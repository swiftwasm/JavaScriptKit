import SwiftExtract
import SwiftSyntax
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

// MARK: - Import lowering

/// Lowers extracted `@JSFunction/@JSGetter/@JSSetter/@JSClass` declarations
/// into per-file imported skeletons.
final class ImportLowering {
    let context: LoweringContext
    private(set) var errors: [(file: String, diagnostic: DiagnosticError)] = []
    private(set) var importOrigins: [JSImportFrom] = []
    private(set) var importedModulePathNodes: [String: Syntax] = [:]
    private(set) var importedModulePathFiles: [String: String] = [:]

    init(context: LoweringContext) {
        self.context = context
    }

    func diagnose(node: some SyntaxProtocol, file: String, message: String, hint: String? = nil) {
        errors.append((file: file, diagnostic: DiagnosticError(node: node, message: message, hint: hint)))
    }

    private func bridgeType(
        for type: SwiftType,
        anchor: some SyntaxProtocol,
        file: String
    ) -> BridgeType? {
        var lookupErrors: [DiagnosticError] = []
        let result = context.bridgeType(for: type, anchor: anchor, errors: &lookupErrors)
        errors.append(contentsOf: lookupErrors.map { (file: file, diagnostic: $0) })
        return result
    }

    // MARK: Entry point

    func lower(
        analysis: AnalysisResult,
        orderedTypes: [ExtractedNominalType],
        filePaths: [String]
    ) -> [ImportedFileSkeleton] {
        var importedFiles: [ImportedFileSkeleton] = []

        for filePath in filePaths {
            var functions: [ImportedFunctionSkeleton] = []
            for function in analysis.extractedGlobalFuncs where function.sourceFilePath == filePath {
                guard let node = function.swiftDecl.as(FunctionDeclSyntax.self) else { continue }
                if let jsFunction = node.attributes.firstAttribute(named: "JSFunction") {
                    if let imported = parseFunction(function, node: node, attribute: jsFunction, file: filePath) {
                        functions.append(imported)
                    }
                } else if node.attributes.hasAttribute(name: "JSSetter") {
                    diagnose(
                        node: node,
                        file: filePath,
                        message: "@JSSetter is not supported at top-level. Use it only in @JSClass types."
                    )
                }
            }

            var globalGetters: [ImportedGetterSkeleton] = []
            for variable in analysis.extractedGlobalVariables
            where variable.sourceFilePath == filePath && variable.apiKind == .getter {
                guard let node = variable.swiftDecl.as(VariableDeclSyntax.self),
                    let jsGetter = node.attributes.firstAttribute(named: "JSGetter")
                else { continue }
                if let getter = parseGetter(variable, node: node, attribute: jsGetter, file: filePath) {
                    globalGetters.append(getter)
                }
            }

            var types: [ImportedTypeSkeleton] = []
            for type in orderedTypes
            where type.sourceFilePath == filePath && type.swiftNominal.syntax.attributes.hasAttribute(name: "JSClass") {
                types.append(lowerImportedType(type, file: filePath))
            }

            let importedFile = ImportedFileSkeleton(
                functions: functions,
                types: types,
                globalGetters: globalGetters
            )
            if !importedFile.isEmpty {
                importedFiles.append(importedFile)
            }
        }

        return importedFiles
    }

    // MARK: Imported types

    private func lowerImportedType(_ type: ExtractedNominalType, file: String) -> ImportedTypeSkeleton {
        let nominal = type.swiftNominal
        let node = nominal.syntax
        let attribute = node.attributes.firstAttribute(named: "JSClass")

        let extractedJSName = attribute.flatMap { extractJSName(from: $0, file: file) }
        let from = attribute.flatMap { extractJSImportFrom(from: $0, file: file) }
        validateDefaultExportUsage(extractedJSName, from: from, node: node, file: file, inClassBody: false)
        let modifiers = node.asProtocol((any WithModifiersSyntax).self)?.modifiers ?? DeclModifierListSyntax([])
        let accessLevel = Self.bridgeAccessLevel(from: modifiers)

        var constructor: ImportedConstructorSkeleton?
        for initializer in type.initializers {
            guard let initNode = initializer.swiftDecl.as(InitializerDeclSyntax.self),
                initNode.attributes.hasAttribute(name: "JSFunction")
            else { continue }
            if constructor != nil {
                diagnose(
                    node: initNode,
                    file: file,
                    message: "Only one @JSFunction initializer is supported in @JSClass types."
                )
                continue
            }
            constructor = parseConstructor(initializer, node: initNode, file: file, parentAccessLevel: accessLevel)
        }

        var methods: [ImportedFunctionSkeleton] = []
        var staticMethods: [ImportedFunctionSkeleton] = []
        var setters: [ImportedSetterSkeleton] = []
        for method in type.methods {
            guard let methodNode = method.swiftDecl.as(FunctionDeclSyntax.self) else { continue }
            let isStaticMember = methodNode.modifiers.containsStaticOrClass
            if let jsFunction = methodNode.attributes.firstAttribute(named: "JSFunction") {
                if let imported = parseFunction(
                    method,
                    node: methodNode,
                    attribute: jsFunction,
                    file: file,
                    inClassBody: true
                ) {
                    if isStaticMember {
                        staticMethods.append(imported)
                    } else {
                        methods.append(imported)
                    }
                }
            } else if let jsSetter = methodNode.attributes.firstAttribute(named: "JSSetter") {
                if isStaticMember {
                    diagnose(
                        node: methodNode,
                        file: file,
                        message:
                            "@JSSetter is not supported for static members. Use it only for instance members in @JSClass types."
                    )
                } else if let setter = parseSetter(method, node: methodNode, attribute: jsSetter, file: file) {
                    setters.append(setter)
                }
            }
        }

        var getters: [ImportedGetterSkeleton] = []
        for variable in type.variables where variable.apiKind == .getter {
            guard let varNode = variable.swiftDecl.as(VariableDeclSyntax.self),
                let jsGetter = varNode.attributes.firstAttribute(named: "JSGetter")
            else { continue }
            if varNode.modifiers.containsStaticOrClass {
                diagnose(
                    node: varNode,
                    file: file,
                    message:
                        "@JSGetter is not supported for static members. Use it only for instance members in @JSClass types."
                )
            } else if let getter = parseGetter(
                variable,
                node: varNode,
                attribute: jsGetter,
                file: file,
                inClassBody: true
            ) {
                getters.append(getter)
            }
        }

        return ImportedTypeSkeleton(
            name: nominal.name,
            jsName: extractedJSName?.memberName,
            from: from,
            constructor: constructor,
            methods: methods,
            staticMethods: staticMethods,
            getters: getters,
            setters: setters,
            documentation: nil,
            accessLevel: accessLevel
        )
    }

    // MARK: Functions

    private func parseFunction(
        _ function: ExtractedFunc,
        node: FunctionDeclSyntax,
        attribute jsFunction: AttributeSyntax,
        file: String,
        inClassBody: Bool = false
    ) -> ImportedFunctionSkeleton? {
        guard
            let effects = validateEffects(
                node.signature.effectSpecifiers,
                node: node,
                file: file,
                attributeName: "JSFunction"
            )
        else {
            return nil
        }

        guard
            let genericParameterNames = parseGenericParameterNames(
                genericParameterClause: node.genericParameterClause,
                genericWhereClause: node.genericWhereClause,
                node: Syntax(node),
                file: file
            )
        else {
            return nil
        }

        let baseName = SwiftToSkeleton.normalizeIdentifier(node.name.text)
        let extractedJSName = extractJSName(from: jsFunction, file: file)
        let from = extractJSImportFrom(from: jsFunction, file: file)
        validateDefaultExportUsage(extractedJSName, from: from, node: node, file: file, inClassBody: inClassBody)
        let jsName = extractedJSName?.memberName

        guard
            let parameters = parseParameters(
                semantic: function.functionSignature.parameters,
                syntax: node.signature.parameterClause,
                genericParameterNames: genericParameterNames,
                file: file
            )
        else { return nil }

        let returnType: BridgeType
        if let returnTypeSyntax = node.signature.returnClause?.type {
            if diagnoseGenericMisuse(
                in: returnTypeSyntax,
                genericParameterNames: genericParameterNames,
                file: file
            ) {
                return nil
            }
            guard
                let resolved = bridgeType(
                    for: function.functionSignature.result.type,
                    anchor: returnTypeSyntax,
                    file: file
                )
            else {
                return nil
            }
            returnType = resolved
        } else {
            returnType = .void
        }

        if !genericParameterNames.isEmpty {
            if effects.isAsync {
                diagnose(
                    node: node,
                    file: file,
                    message: "Generic @JSFunction declarations cannot be 'async' yet."
                )
                return nil
            }
            for genericName in genericParameterNames {
                let usedInParameter = parameters.contains { $0.type.referencedGenericName == genericName }
                let usedInReturn = returnType.referencedGenericName == genericName
                if !usedInParameter && !usedInReturn {
                    diagnose(
                        node: node,
                        file: file,
                        message:
                            "The generic parameter '\(genericName)' must be used in a parameter or return type of a generic @JSFunction declaration."
                    )
                    return nil
                }
            }
        }

        let accessLevel = Self.bridgeAccessLevel(from: node.modifiers)
        return ImportedFunctionSkeleton(
            name: baseName,
            jsName: jsName,
            from: from,
            parameters: parameters,
            returnType: returnType,
            effects: effects,
            documentation: nil,
            accessLevel: accessLevel,
            genericParameters: genericParameterNames.isEmpty ? nil : genericParameterNames
        )
    }

    private func parseConstructor(
        _ initializer: ExtractedFunc,
        node: InitializerDeclSyntax,
        file: String,
        parentAccessLevel: BridgeJSAccessLevel
    ) -> ImportedConstructorSkeleton? {
        guard
            let effects = validateEffects(
                node.signature.effectSpecifiers,
                node: node,
                file: file,
                attributeName: "JSFunction"
            )
        else {
            return nil
        }
        guard
            let genericParameterNames = parseGenericParameterNames(
                genericParameterClause: node.genericParameterClause,
                genericWhereClause: node.genericWhereClause,
                node: Syntax(node),
                file: file
            )
        else {
            return nil
        }
        if !genericParameterNames.isEmpty && effects.isAsync {
            diagnose(
                node: node,
                file: file,
                message: "Generic @JSFunction declarations cannot be 'async' yet."
            )
            return nil
        }
        guard
            let parameters = parseParameters(
                semantic: initializer.functionSignature.parameters,
                syntax: node.signature.parameterClause,
                genericParameterNames: genericParameterNames,
                file: file
            )
        else { return nil }
        for genericName in genericParameterNames
        where !parameters.contains(where: { $0.type.referencedGenericName == genericName }) {
            diagnose(
                node: node,
                file: file,
                message:
                    "The generic parameter '\(genericName)' must be used in a parameter of a generic @JSFunction initializer."
            )
            return nil
        }
        // Initializers without an explicit modifier inherit access from the
        // enclosing `@JSClass`.
        let accessLevel = Self.bridgeAccessLevel(from: node.modifiers, default: parentAccessLevel)
        return ImportedConstructorSkeleton(
            parameters: parameters,
            accessLevel: accessLevel,
            genericParameters: genericParameterNames.isEmpty ? nil : genericParameterNames
        )
    }

    // MARK: Getters and setters

    private func parseGetter(
        _ variable: ExtractedFunc,
        node: VariableDeclSyntax,
        attribute jsGetter: AttributeSyntax,
        file: String,
        inClassBody: Bool = false
    ) -> ImportedGetterSkeleton? {
        guard let binding = node.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
            let typeAnnotation = binding.typeAnnotation
        else {
            diagnose(
                node: node,
                file: file,
                message: "@JSGetter must declare a single stored property with an explicit type."
            )
            return nil
        }
        guard
            let propertyType = bridgeType(
                for: variable.functionSignature.result.type,
                anchor: typeAnnotation.type,
                file: file
            )
        else {
            return nil
        }
        let propertyName = SwiftToSkeleton.normalizeIdentifier(identifier.identifier.text)
        let extractedJSName = extractJSName(from: jsGetter, file: file)
        let from = extractJSImportFrom(from: jsGetter, file: file)
        validateDefaultExportUsage(extractedJSName, from: from, node: node, file: file, inClassBody: inClassBody)
        let accessLevel = Self.bridgeAccessLevel(from: node.modifiers)
        return ImportedGetterSkeleton(
            name: propertyName,
            jsName: extractedJSName?.memberName,
            from: from,
            type: propertyType,
            documentation: nil,
            functionName: nil,
            accessLevel: accessLevel
        )
    }

    private func parseSetter(
        _ method: ExtractedFunc,
        node: FunctionDeclSyntax,
        attribute jsSetter: AttributeSyntax,
        file: String
    ) -> ImportedSetterSkeleton? {
        guard
            let effects = validateEffects(
                node.signature.effectSpecifiers,
                node: node,
                file: file,
                attributeName: "JSSetter"
            )
        else {
            return nil
        }
        _ = effects

        let extractedJSName = extractJSName(from: jsSetter, file: file)
        validateDefaultExportUsage(
            extractedJSName,
            from: nil,
            node: node,
            file: file,
            inClassBody: true,
            isSetter: true
        )
        let jsName = extractedJSName?.memberName

        guard let firstParamSyntax = node.signature.parameterClause.parameters.first else {
            diagnose(
                node: node,
                file: file,
                message: "@JSSetter function must have at least one parameter."
            )
            return nil
        }

        if firstParamSyntax.type.is(MissingTypeSyntax.self) {
            diagnose(
                node: firstParamSyntax,
                file: file,
                message: "All @JSSetter parameters must have explicit types."
            )
            return nil
        }

        guard let firstParamSemantic = method.functionSignature.parameters.first,
            let valueType = bridgeType(for: firstParamSemantic.type, anchor: firstParamSyntax.type, file: file)
        else {
            return nil
        }

        let functionName = node.name.text
        guard let (propertyName, functionBaseName) = Self.resolveSetterPropertyName(functionName: functionName)
        else {
            return nil
        }

        let accessLevel = Self.bridgeAccessLevel(from: node.modifiers)
        return ImportedSetterSkeleton(
            name: propertyName,
            jsName: jsName,
            type: valueType,
            documentation: nil,
            functionName: "\(functionBaseName)_set",
            accessLevel: accessLevel
        )
    }

    /// Resolves property name and function base name from a setter function.
    private static func resolveSetterPropertyName(
        functionName: String
    ) -> (propertyName: String, functionBaseName: String)? {
        let rawFunctionName =
            functionName.hasPrefix("`") && functionName.hasSuffix("`") && functionName.count > 2
            ? String(functionName.dropFirst().dropLast())
            : functionName

        guard rawFunctionName.hasPrefix("set"), rawFunctionName.count > 3 else {
            return nil
        }

        let derivedPropertyName = String(rawFunctionName.dropFirst(3))
        let normalized = SwiftToSkeleton.normalizeIdentifier(derivedPropertyName)
        let propertyName = normalized.prefix(1).lowercased() + normalized.dropFirst()
        return (propertyName: propertyName, functionBaseName: propertyName)
    }

    // MARK: Parameters

    private func parseParameters(
        semantic: [SwiftParameter],
        syntax: FunctionParameterClauseSyntax,
        genericParameterNames: [String],
        file: String
    ) -> [Parameter]? {
        var parameters: [Parameter] = []
        for (index, syntaxParam) in syntax.parameters.enumerated() {
            guard index < semantic.count else { break }
            if syntaxParam.type.is(MissingTypeSyntax.self) {
                diagnose(
                    node: syntaxParam,
                    file: file,
                    message: "All @JSFunction parameters must have explicit types."
                )
                continue
            }
            if diagnoseGenericMisuse(
                in: syntaxParam.type,
                genericParameterNames: genericParameterNames,
                file: file
            ) {
                return nil
            }
            guard let bridgeType = bridgeType(for: semantic[index].type, anchor: syntaxParam.type, file: file) else {
                continue
            }
            let nameToken = syntaxParam.secondName ?? syntaxParam.firstName
            let name = SwiftToSkeleton.normalizeIdentifier(nameToken.text)
            let labelToken = syntaxParam.secondName == nil ? nil : syntaxParam.firstName
            let label = labelToken?.text == "_" ? nil : labelToken?.text
            parameters.append(Parameter(label: label, name: name, type: bridgeType))
        }
        return parameters
    }

    /// Generic parameters may only appear bare or wrapped exactly once as
    /// `T?`, `[T]` or `[String: T]`. Any other type spelling that mentions a
    /// generic parameter is rejected; returns the offending name.
    private static func genericMisuseName(
        in type: TypeSyntax,
        genericParameterNames: [String]
    ) -> String? {
        guard !genericParameterNames.isEmpty else { return nil }

        func bareGenericName(_ inner: TypeSyntax) -> String? {
            guard let identifier = inner.as(IdentifierTypeSyntax.self),
                identifier.genericArgumentClause == nil,
                genericParameterNames.contains(identifier.name.text)
            else {
                return nil
            }
            return identifier.name.text
        }

        if bareGenericName(type) != nil {
            return nil
        }
        if let arrayType = type.as(ArrayTypeSyntax.self), bareGenericName(arrayType.element) != nil {
            return nil
        }
        if let optionalType = type.as(OptionalTypeSyntax.self), bareGenericName(optionalType.wrappedType) != nil {
            return nil
        }
        if let dictType = type.as(DictionaryTypeSyntax.self),
            let keyIdentifier = dictType.key.as(IdentifierTypeSyntax.self),
            keyIdentifier.genericArgumentClause == nil,
            keyIdentifier.name.text == "String",
            bareGenericName(dictType.value) != nil
        {
            return nil
        }
        for token in type.tokens(viewMode: .sourceAccurate) {
            if case .identifier(let text) = token.tokenKind, genericParameterNames.contains(text) {
                return text
            }
        }
        return nil
    }

    private func diagnoseGenericMisuse(
        in type: TypeSyntax,
        genericParameterNames: [String],
        file: String
    ) -> Bool {
        guard let misusedName = Self.genericMisuseName(in: type, genericParameterNames: genericParameterNames) else {
            return false
        }
        diagnose(
            node: type,
            file: file,
            message:
                "Generic parameter '\(misusedName)' may only be used as a bare type; wrapping it beyond 'T?', '[T]' and '[String: T]' is not supported."
        )
        return true
    }

    // MARK: Generic parameter clauses

    /// Validates and collects the generic parameter names of an imported
    /// `@JSFunction` declaration (function, method or initializer).
    ///
    /// Returns `nil` when a diagnostic was emitted; an empty array when the
    /// declaration is not generic.
    private func parseGenericParameterNames(
        genericParameterClause: GenericParameterClauseSyntax?,
        genericWhereClause: GenericWhereClauseSyntax?,
        node: Syntax,
        file: String
    ) -> [String]? {
        var genericParameterNames: [String] = []
        if let genericParameterClause {
            for genericParam in genericParameterClause.parameters {
                let paramName = genericParam.name.text
                let constraintText = genericParam.inheritedType?.trimmedDescription
                guard Self.isBridgeableGenericConstraint(constraintText) else {
                    diagnose(
                        node: genericParam,
                        file: file,
                        message:
                            "Generic parameter '\(paramName)' must be constrained to 'BridgedSwiftGenericBridgeable' to be used with @JSFunction."
                    )
                    return nil
                }
                genericParameterNames.append(paramName)
            }
        }
        if genericWhereClause != nil {
            diagnose(
                node: node,
                file: file,
                message: "'where' clauses are not supported on @JSFunction declarations."
            )
            return nil
        }
        return genericParameterNames
    }

    private static func isBridgeableGenericConstraint(_ constraint: String?) -> Bool {
        constraint == "BridgedSwiftGenericBridgeable"
            || constraint == "JavaScriptKit.BridgedSwiftGenericBridgeable"
    }

    // MARK: Effects

    /// Validates effects (throws required, async only supported for @JSFunction)
    private func validateEffects(
        _ effects: FunctionEffectSpecifiersSyntax?,
        node: some SyntaxProtocol,
        file: String,
        attributeName: String
    ) -> Effects? {
        let isThrows = effects?.throwsClause != nil
        let isAsync = effects?.asyncSpecifier != nil
        guard isThrows else {
            diagnose(
                node: node,
                file: file,
                message: "@\(attributeName) declarations must be throws.",
                hint: "Declare the function as 'throws(JSException)'."
            )
            return nil
        }
        if isAsync && attributeName != "JSFunction" {
            diagnose(
                node: node,
                file: file,
                message: "@\(attributeName) declarations do not support async yet."
            )
            return nil
        }
        return Effects(isAsync: isAsync, isThrows: isThrows)
    }

    // MARK: jsName / from arguments

    /// The result of reading a `jsName:` argument.
    struct ExtractedJSName {
        /// The JavaScript member name to look up.
        ///
        /// `.default` normalizes to `"default"`: in ECMAScript a module's default
        /// export *is* its `default` named export, so no separate representation
        /// is needed downstream.
        let memberName: String
        /// True when the source spelled `.default` rather than a string literal.
        let isDefaultExportSpelling: Bool
    }

    /// Extracts the `jsName` argument value from an attribute, if present.
    private func extractJSName(from attribute: AttributeSyntax, file: String) -> ExtractedJSName? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
            let argument = arguments.first(where: { $0.label?.text == "jsName" })
        else {
            return nil
        }

        if let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
            let value = stringLiteral.representedLiteralValue
        {
            return ExtractedJSName(memberName: value, isDefaultExportSpelling: false)
        }

        // An explicit `jsName: nil` means the same as omitting the argument.
        if argument.expression.is(NilLiteralExprSyntax.self) {
            return nil
        }

        // Accept the explicit `.name("...")` spelling of a plain member name.
        if let call = argument.expression.as(FunctionCallExprSyntax.self),
            call.calledExpression.trimmedDescription.split(separator: ".").last == "name"
        {
            guard call.arguments.count == 1,
                let literal = call.arguments.first?.expression.as(StringLiteralExprSyntax.self),
                let value = literal.representedLiteralValue
            else {
                diagnose(
                    node: call.arguments.first?.expression ?? argument.expression,
                    file: file,
                    message: "jsName must be a string literal or '.default'."
                )
                return nil
            }
            return ExtractedJSName(memberName: value, isDefaultExportSpelling: false)
        }

        // Accept `.default`, `JSName.default`, and the backticked spellings.
        let description = argument.expression.trimmedDescription
        let caseName = description.split(separator: ".").last.map(String.init) ?? description
        if caseName == "default" || caseName == "`default`" {
            return ExtractedJSName(memberName: "default", isDefaultExportSpelling: true)
        }

        diagnose(
            node: argument.expression,
            file: file,
            message: "jsName must be a string literal or '.default'."
        )
        return nil
    }

    /// Validates that a `jsName: .default` spelling appears somewhere it can mean something.
    ///
    /// `.default` names the default export of an ECMAScript module, so it only makes
    /// sense on a top-level declaration that has a `from: .module(...)` origin.
    private func validateDefaultExportUsage(
        _ extracted: ExtractedJSName?,
        from: JSImportFrom?,
        node: some SyntaxProtocol,
        file: String,
        inClassBody: Bool,
        isSetter: Bool = false
    ) {
        guard let extracted, extracted.isDefaultExportSpelling else { return }

        if isSetter {
            diagnose(
                node: node,
                file: file,
                message: "'jsName: .default' is not supported on @JSSetter; "
                    + "ECMAScript module bindings are read-only."
            )
            return
        }
        if inClassBody {
            diagnose(
                node: node,
                file: file,
                message: "'jsName: .default' is not supported on a class member; "
                    + "members have no module origin. Did you mean jsName: \"default\"?"
            )
            return
        }
        switch from {
        case .module, .snippet:
            return
        case .global:
            diagnose(
                node: node,
                file: file,
                message: "'jsName: .default' requires 'from: .module(...)' or 'from: .snippet(...)'; "
                    + "globalThis has no default export."
            )
        case nil:
            diagnose(
                node: node,
                file: file,
                message: "'jsName: .default' requires 'from: .module(...)' or 'from: .snippet(...)'."
            )
        }
    }

    private func extractJSImportFrom(from attribute: AttributeSyntax, file: String) -> JSImportFrom? {
        guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
            let argument = arguments.first(where: { $0.label?.text == "from" })
        else {
            return nil
        }

        func record(_ origin: JSImportFrom) -> JSImportFrom {
            importOrigins.append(origin)
            return origin
        }

        if let call = argument.expression.as(FunctionCallExprSyntax.self),
            let caseName = call.calledExpression.trimmedDescription.split(separator: ".").last,
            caseName == "module" || caseName == "snippet"
        {
            let isSnippet = caseName == "snippet"
            guard call.arguments.count == 1,
                let pathExpression = call.arguments.first?.expression,
                let literal = pathExpression.as(StringLiteralExprSyntax.self),
                let path = literal.representedLiteralValue
            else {
                diagnose(
                    node: call.arguments.first?.expression ?? argument.expression,
                    file: file,
                    message: isSnippet
                        ? "JavaScript snippet path must be a string literal."
                        : "JavaScript module specifier must be a string literal."
                )
                return nil
            }
            guard !path.isEmpty else {
                diagnose(
                    node: literal,
                    file: file,
                    message: isSnippet
                        ? "JavaScript snippet path must not be empty."
                        : "JavaScript module specifier must not be empty."
                )
                return nil
            }
            if isSnippet {
                // Full validation of the path happens later, where the file
                // can also be checked for existence.
                if importedModulePathNodes[path] == nil {
                    importedModulePathNodes[path] = Syntax(literal)
                    importedModulePathFiles[path] = file
                }
                return record(.snippet(path))
            }
            guard !path.hasPrefix("/") else {
                diagnose(
                    node: literal,
                    file: file,
                    message: "'\(path)' looks like a file in this target. "
                        + "Use 'from: .snippet(\"\(path)\")' for a JavaScript file you ship with the target, "
                        + "and 'from: .module(...)' for an external module (e.g. 'node:path')."
                )
                return nil
            }
            guard !path.hasPrefix("./"), !path.hasPrefix("../"), path != ".", path != ".." else {
                diagnose(
                    node: literal,
                    file: file,
                    message: "Relative JavaScript module specifiers are not supported: '\(path)'. "
                        + "Use 'from: .snippet(\"/path/to/file.js\")' for a file in this target, "
                        + "or a bare specifier for an external module (e.g. 'node:path')."
                )
                return nil
            }
            return record(.module(path))
        }

        // Accept `.global`, `JSImportFrom.global`, etc.
        let description = argument.expression.trimmedDescription
        let caseName = description.split(separator: ".").last.map(String.init) ?? description
        return caseName == "global" ? record(.global) : nil
    }

    // MARK: Access levels

    /// Maps Swift's declaration modifiers to a `BridgeJSAccessLevel` for
    /// recording on imported skeleton entries. Falls back to `default` when no
    /// access modifier is present (typically `.internal`, but the caller may
    /// override — e.g. an `init` inheriting from its enclosing `@JSClass`).
    /// `private`/`fileprivate` are mapped to the fallback because the macros
    /// already reject those access levels for `@JS*` declarations.
    static func bridgeAccessLevel(
        from modifiers: DeclModifierListSyntax,
        default fallback: BridgeJSAccessLevel = .internal
    ) -> BridgeJSAccessLevel {
        for modifier in modifiers {
            switch modifier.name.tokenKind {
            case .keyword(.public), .keyword(.open):
                return .public
            case .keyword(.package):
                return .package
            case .keyword(.internal):
                return .internal
            default:
                continue
            }
        }
        return fallback
    }
}
