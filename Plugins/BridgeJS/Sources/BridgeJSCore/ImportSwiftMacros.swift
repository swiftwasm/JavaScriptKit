import SwiftSyntax
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Collects macro-annotated Swift declarations and produces ImportedModuleSkeleton.
public final class ImportSwiftMacros {
    let progress: ProgressReporting
    let moduleName: String
    private var sourceFiles: [(sourceFile: SourceFileSyntax, inputFilePath: String)] = []

    public init(progress: ProgressReporting, moduleName: String) {
        self.progress = progress
        self.moduleName = moduleName
    }

    /// Processes a Swift source file to find declarations marked with @JSFunction/@JSGetter/@JSSetter/@JSClass
    ///
    /// - Parameters:
    ///   - sourceFile: The parsed Swift source file to process
    ///   - inputFilePath: The file path for error reporting
    public func addSourceFile(_ sourceFile: SourceFileSyntax, _ inputFilePath: String) {
        sourceFiles.append((sourceFile, inputFilePath))
    }

    /// Finalizes the import process and generates the bridge code plus skeleton.
    public func finalize() throws -> (outputSwift: String?, outputSkeleton: ImportedModuleSkeleton) {
        var perSourceErrors: [(inputFilePath: String, errors: [DiagnosticError])] = []
        var importedFiles: [ImportedFileSkeleton] = []

        for (sourceFile, inputFilePath) in sourceFiles {
            progress.print("Processing \(inputFilePath)")
            let collector = APICollector(
                inputFilePath: inputFilePath,
                knownJSClassNames: Self.collectJSClassNames(from: sourceFile)
            )
            collector.walk(sourceFile)
            if !collector.errors.isEmpty {
                perSourceErrors.append((inputFilePath: inputFilePath, errors: collector.errors))
            }
            importedFiles.append(
                ImportedFileSkeleton(
                    functions: collector.importedFunctions,
                    types: collector.importedTypes
                )
            )
        }

        if !perSourceErrors.isEmpty {
            let allErrors = perSourceErrors.flatMap { inputFilePath, errors in
                errors.map { $0.formattedDescription(fileName: inputFilePath) }
            }
            throw BridgeJSCoreError(allErrors.joined(separator: "\n"))
        }

        let moduleSkeleton = ImportedModuleSkeleton(children: importedFiles)

        var importer = ImportTS(progress: progress, moduleName: moduleName)
        for skeleton in importedFiles {
            importer.addSkeleton(skeleton)
        }
        let outputSwift = try importer.finalize()
        return (outputSwift: outputSwift, outputSkeleton: moduleSkeleton)
    }

    private static func collectJSClassNames(from sourceFile: SourceFileSyntax) -> Set<String> {
        let collector = JSImportTypeNameCollector(viewMode: .sourceAccurate)
        collector.walk(sourceFile)
        return collector.typeNames
    }

    private final class JSImportTypeNameCollector: SyntaxAnyVisitor {
        var typeNames: Set<String> = []

        private func visitTypeDecl(_ attributes: AttributeListSyntax?, _ name: String) -> SyntaxVisitorContinueKind {
            if APICollector.AttributeChecker.hasJSClassAttribute(attributes) {
                typeNames.insert(name)
            }
            return .visitChildren
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            visitTypeDecl(node.attributes, node.name.text)
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            visitTypeDecl(node.attributes, node.name.text)
        }
    }

    fileprivate final class APICollector: SyntaxAnyVisitor {
        var importedFunctions: [ImportedFunctionSkeleton] = []
        var importedTypes: [ImportedTypeSkeleton] = []
        var errors: [DiagnosticError] = []

        private let inputFilePath: String
        private var jsClassNames: Set<String>

        // MARK: - State Management

        enum State {
            case topLevel
            case jsClassBody(name: String)
        }

        private var stateStack: [State] = [.topLevel]
        var state: State {
            return stateStack.last!
        }

        // Current type being collected (when in jsClassBody state)
        private struct CurrentType {
            let name: String
            var constructor: ImportedConstructorSkeleton?
            var methods: [ImportedFunctionSkeleton]
            var getters: [ImportedGetterSkeleton]
            var setters: [ImportedSetterSkeleton]
        }
        private var currentType: CurrentType?

        // MARK: - Attribute Checking

        /// Helper struct for checking and extracting attributes
        fileprivate struct AttributeChecker {
            static func hasJSFunctionAttribute(_ attributes: AttributeListSyntax?) -> Bool {
                hasAttribute(attributes, name: "JSFunction")
            }

            static func hasJSGetterAttribute(_ attributes: AttributeListSyntax?) -> Bool {
                hasAttribute(attributes, name: "JSGetter")
            }

            static func hasJSSetterAttribute(_ attributes: AttributeListSyntax?) -> Bool {
                hasAttribute(attributes, name: "JSSetter")
            }

            static func firstJSSetterAttribute(_ attributes: AttributeListSyntax?) -> AttributeSyntax? {
                attributes?.first { attribute in
                    attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JSSetter"
                }?.as(AttributeSyntax.self)
            }

            static func hasJSClassAttribute(_ attributes: AttributeListSyntax?) -> Bool {
                hasAttribute(attributes, name: "JSClass")
            }

            static func hasAttribute(_ attributes: AttributeListSyntax?, name: String) -> Bool {
                guard let attributes else { return false }
                return attributes.contains { attribute in
                    guard let syntax = attribute.as(AttributeSyntax.self) else { return false }
                    return syntax.attributeName.trimmedDescription == name
                }
            }


            /// Extracts the jsName argument value from a @JSSetter attribute, if present.
            static func extractJSName(from attribute: AttributeSyntax) -> String? {
                guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {
                    return nil
                }
                for argument in arguments {
                    if argument.label?.text == "jsName",
                       let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
                       let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
                    {
                        return segment.content.text
                    }
                }
                return nil
            }
        }

        // MARK: - Validation Helpers

        /// Common validation result for setter functions
        private struct SetterValidationResult {
            let effects: Effects
            let jsName: String?
            let firstParam: FunctionParameterSyntax
            let valueType: BridgeType
        }

        /// Validates effects (throws required, async not supported)
        private func validateEffects(
            _ effects: FunctionEffectSpecifiersSyntax?,
            node: some SyntaxProtocol,
            attributeName: String
        ) -> Effects? {
            guard let effects = parseEffects(effects) else {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "@\(attributeName) declarations must be throws.",
                        hint: "Declare the function as 'throws (JSException)'."
                    )
                )
                return nil
            }
            if effects.isAsync {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "@\(attributeName) declarations do not support async yet."
                    )
                )
                return nil
            }
            return effects
        }

        /// Validates a setter function and extracts common information
        private func validateSetter(
            _ node: FunctionDeclSyntax,
            jsSetter: AttributeSyntax,
            enclosingTypeName: String?
        ) -> SetterValidationResult? {
            guard let effects = validateEffects(node.signature.effectSpecifiers, node: node, attributeName: "JSSetter") else {
                return nil
            }

            let jsName = AttributeChecker.extractJSName(from: jsSetter)
            let parameters = node.signature.parameterClause.parameters

            guard let firstParam = parameters.first else {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "@JSSetter function must have at least one parameter."
                    )
                )
                return nil
            }

            if firstParam.type.is(MissingTypeSyntax.self) {
                errors.append(
                    DiagnosticError(
                        node: firstParam,
                        message: "All @JSSetter parameters must have explicit types."
                    )
                )
                return nil
            }

            return SetterValidationResult(
                effects: effects,
                jsName: jsName,
                firstParam: firstParam,
                valueType: parseType(firstParam.type, enclosingTypeName: enclosingTypeName)
            )
        }

        // MARK: - Property Name Resolution

        /// Helper for resolving property names from setter function names and jsName attributes
        private struct PropertyNameResolver {
            /// Resolves property name and function base name from a setter function and optional jsName
            /// - Returns: (propertyName, functionBaseName) where propertyName preserves case for getter matching,
            ///   and functionBaseName has lowercase first char for ABI generation
            static func resolve(
                functionName: String,
                jsName: String?,
                normalizeIdentifier: (String) -> String
            ) -> (propertyName: String, functionBaseName: String)? {
                if let jsName = jsName {
                    let propertyName = normalizeIdentifier(jsName)
                    let functionBaseName = propertyName.prefix(1).lowercased() + propertyName.dropFirst()
                    return (propertyName: propertyName, functionBaseName: functionBaseName)
                }

                let rawFunctionName = functionName.hasPrefix("`") && functionName.hasSuffix("`") && functionName.count > 2
                    ? String(functionName.dropFirst().dropLast())
                    : functionName

                guard rawFunctionName.hasPrefix("set"), rawFunctionName.count > 3 else {
                    return nil
                }

                let derivedPropertyName = String(rawFunctionName.dropFirst(3))
                let normalized = normalizeIdentifier(derivedPropertyName)
                let propertyName = normalized.prefix(1).lowercased() + normalized.dropFirst()
                return (propertyName: propertyName, functionBaseName: propertyName)
            }
        }

        init(inputFilePath: String, knownJSClassNames: Set<String>) {
            self.inputFilePath = inputFilePath
            self.jsClassNames = knownJSClassNames
            super.init(viewMode: .sourceAccurate)
        }

        private func enterJSClass(_ typeName: String) {
            stateStack.append(.jsClassBody(name: typeName))
            currentType = CurrentType(name: typeName, constructor: nil, methods: [], getters: [], setters: [])
        }

        private func exitJSClass() {
            if case .jsClassBody(let typeName) = state, let type = currentType, type.name == typeName {
                importedTypes.append(
                    ImportedTypeSkeleton(
                        name: type.name,
                        constructor: type.constructor,
                        methods: type.methods,
                        getters: type.getters,
                        setters: type.setters,
                        documentation: nil
                    )
                )
                currentType = nil
            }
            stateStack.removeLast()
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            if AttributeChecker.hasJSClassAttribute(node.attributes) {
                enterJSClass(node.name.text)
            }
            return .visitChildren
        }

        override func visitPost(_ node: StructDeclSyntax) {
            if AttributeChecker.hasJSClassAttribute(node.attributes) {
                exitJSClass()
            }
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            if AttributeChecker.hasJSClassAttribute(node.attributes) {
                enterJSClass(node.name.text)
            }
            return .visitChildren
        }

        override func visitPost(_ node: ClassDeclSyntax) {
            if AttributeChecker.hasJSClassAttribute(node.attributes) {
                exitJSClass()
            }
        }

        // MARK: - Visitor Methods

        override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
            let typeName = node.extendedType.trimmedDescription
            collectStaticMembers(in: node.memberBlock.members, typeName: typeName)
            return .skipChildren
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            switch state {
            case .topLevel:
                return handleTopLevelFunction(node)

            case .jsClassBody(let typeName):
                guard var type = currentType, type.name == typeName else {
                    return .skipChildren
                }
                let isStaticMember = isStatic(node.modifiers)
                let handled = handleClassFunction(node, typeName: typeName, isStaticMember: isStaticMember, type: &type)
                if handled {
                    currentType = type
                }
                return .skipChildren
            }
        }

        private func handleTopLevelFunction(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            if AttributeChecker.hasJSFunctionAttribute(node.attributes),
               let function = parseFunction(node, enclosingTypeName: nil, isStaticMember: true) {
                importedFunctions.append(function)
                return .skipChildren
            }
            // Top-level setters are not supported
            if AttributeChecker.hasJSSetterAttribute(node.attributes) {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "@JSSetter is not supported at top-level. Use it only in @JSClass types."
                    )
                )
                return .skipChildren
            }
            return .visitChildren
        }

        private func handleClassFunction(
            _ node: FunctionDeclSyntax,
            typeName: String,
            isStaticMember: Bool,
            type: inout CurrentType
        ) -> Bool {
            if AttributeChecker.hasJSFunctionAttribute(node.attributes) {
                if isStaticMember {
                    parseFunction(node, enclosingTypeName: typeName, isStaticMember: true).map { importedFunctions.append($0) }
                } else {
                    parseFunction(node, enclosingTypeName: typeName, isStaticMember: false).map { type.methods.append($0) }
                }
                return true
            }

            if AttributeChecker.hasJSSetterAttribute(node.attributes) {
                if isStaticMember {
                    errors.append(
                        DiagnosticError(
                            node: node,
                            message: "@JSSetter is not supported for static members. Use it only for instance members in @JSClass types."
                        )
                    )
                } else if let jsSetter = AttributeChecker.firstJSSetterAttribute(node.attributes),
                          let setter = parseSetterSkeleton(jsSetter, node, enclosingTypeName: typeName) {
                    type.setters.append(setter)
                }
                return true
            }

            return false
        }

        override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
            guard AttributeChecker.hasJSGetterAttribute(node.attributes) else {
                return .visitChildren
            }

            switch state {
            case .topLevel:
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "@JSGetter is not supported at top-level. Use it only in @JSClass types."
                    )
                )
                return .skipChildren

            case .jsClassBody(let typeName):
                guard var type = currentType, type.name == typeName else {
                    return .skipChildren
                }
                if isStatic(node.modifiers) {
                    errors.append(
                        DiagnosticError(
                            node: node,
                            message: "@JSGetter is not supported for static members. Use it only for instance members in @JSClass types."
                        )
                    )
                } else if let getter = parseGetterSkeleton(node, enclosingTypeName: typeName) {
                    type.getters.append(getter)
                    currentType = type
                }
                return .skipChildren
            }
        }

        override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
            guard AttributeChecker.hasJSFunctionAttribute(node.attributes) else {
                return .visitChildren
            }

            switch state {
            case .topLevel:
                return .visitChildren

            case .jsClassBody(let typeName):
                guard var type = currentType, type.name == typeName else {
                    return .skipChildren
                }
                if type.constructor != nil {
                    errors.append(
                        DiagnosticError(
                            node: node,
                            message: "Only one @JSFunction initializer is supported in @JSClass types."
                        )
                    )
                    return .skipChildren
                }
                if let parsed = parseConstructor(node, typeName: typeName) {
                    type.constructor = parsed
                    currentType = type
                }
                return .skipChildren
            }
        }


        // MARK: - Member Collection

        private func collectStaticMembers(in members: MemberBlockItemListSyntax, typeName: String) {
            for member in members {
                if let function = member.decl.as(FunctionDeclSyntax.self) {
                    if AttributeChecker.hasJSFunctionAttribute(function.attributes),
                       let parsed = parseFunction(function, enclosingTypeName: typeName, isStaticMember: true) {
                        importedFunctions.append(parsed)
                    } else if AttributeChecker.hasJSSetterAttribute(function.attributes) {
                        errors.append(
                            DiagnosticError(
                                node: function,
                                message: "@JSSetter is not supported for static members. Use it only for instance members in @JSClass types."
                            )
                        )
                    }
                } else if let variable = member.decl.as(VariableDeclSyntax.self),
                          AttributeChecker.hasJSGetterAttribute(variable.attributes) {
                    errors.append(
                        DiagnosticError(
                            node: variable,
                            message: "@JSGetter is not supported for static members. Use it only for instance members in @JSClass types."
                        )
                    )
                }
            }
        }

        // MARK: - Parsing Methods

        private func parseConstructor(
            _ initializer: InitializerDeclSyntax,
            typeName: String
        ) -> ImportedConstructorSkeleton? {
            guard validateEffects(initializer.signature.effectSpecifiers, node: initializer, attributeName: "JSFunction") != nil else {
                return nil
            }
            return ImportedConstructorSkeleton(
                parameters: parseParameters(
                    from: initializer.signature.parameterClause,
                    enclosingTypeName: typeName
                )
            )
        }

        private func parseFunction(
            _ node: FunctionDeclSyntax,
            enclosingTypeName: String?,
            isStaticMember: Bool
        ) -> ImportedFunctionSkeleton? {
            guard validateEffects(node.signature.effectSpecifiers, node: node, attributeName: "JSFunction") != nil else {
                return nil
            }

            let baseName = normalizeIdentifier(node.name.text)
            let name: String
            if isStaticMember, let enclosingTypeName {
                name = "\(enclosingTypeName)_\(baseName)"
            } else {
                name = baseName
            }

            let parameters = parseParameters(
                from: node.signature.parameterClause,
                enclosingTypeName: enclosingTypeName
            )
            let returnType: BridgeType
            if let returnTypeSyntax = node.signature.returnClause?.type {
                returnType = parseType(returnTypeSyntax, enclosingTypeName: enclosingTypeName)
            } else {
                returnType = .void
            }
            return ImportedFunctionSkeleton(
                name: name,
                parameters: parameters,
                returnType: returnType,
                documentation: nil
            )
        }


        /// Extracts property info from a VariableDeclSyntax (binding, identifier, type)
        private func extractPropertyInfo(
            _ node: VariableDeclSyntax,
            errorMessage: String = "@JSGetter must declare a single stored property with an explicit type."
        ) -> (identifier: IdentifierPatternSyntax, type: TypeSyntax)? {
            guard let binding = node.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
                  let typeAnnotation = binding.typeAnnotation else {
                errors.append(DiagnosticError(node: node, message: errorMessage))
                return nil
            }
            return (identifier, typeAnnotation.type)
        }

        private func parseGetterSkeleton(
            _ node: VariableDeclSyntax,
            enclosingTypeName: String?
        ) -> ImportedGetterSkeleton? {
            guard let (identifier, type) = extractPropertyInfo(node) else {
                return nil
            }
            let propertyType = parseType(type, enclosingTypeName: enclosingTypeName)
            let propertyName = normalizeIdentifier(identifier.identifier.text)
            return ImportedGetterSkeleton(
                name: propertyName,
                type: propertyType,
                documentation: nil,
                functionName: nil
            )
        }

        /// Parses a setter as part of a type's property system (for instance setters)
        private func parseSetterSkeleton(
            _ jsSetter: AttributeSyntax,
            _ node: FunctionDeclSyntax,
            enclosingTypeName: String?
        ) -> ImportedSetterSkeleton? {
            guard let validation = validateSetter(node, jsSetter: jsSetter, enclosingTypeName: enclosingTypeName) else {
                return nil
            }

            let functionName = node.name.text
            guard let (propertyName, functionBaseName) = PropertyNameResolver.resolve(
                functionName: functionName,
                jsName: validation.jsName,
                normalizeIdentifier: normalizeIdentifier
            ) else {
                return nil
            }

            return ImportedSetterSkeleton(
                name: propertyName,
                type: validation.valueType,
                documentation: nil,
                functionName: "\(functionBaseName)_set"
            )
        }


        // MARK: - Type and Parameter Parsing

        private func parseParameters(
            from clause: FunctionParameterClauseSyntax,
            enclosingTypeName: String?
        ) -> [Parameter] {
            clause.parameters.compactMap { param in
                let type = param.type
                if type.is(MissingTypeSyntax.self) {
                    errors.append(
                        DiagnosticError(
                            node: param,
                            message: "All @JSFunction parameters must have explicit types."
                        )
                    )
                    return nil
                }
                let nameToken = param.secondName ?? param.firstName
                let name = normalizeIdentifier(nameToken.text)
                let labelToken = param.secondName == nil ? nil : param.firstName
                let label = labelToken?.text == "_" ? nil : labelToken?.text
                let bridgeType = parseType(type, enclosingTypeName: enclosingTypeName)
                return Parameter(label: label, name: name, type: bridgeType)
            }
        }


        private func parseType(_ type: TypeSyntax, enclosingTypeName: String?) -> BridgeType {
            guard let identifier = type.as(IdentifierTypeSyntax.self) else {
                errors.append(
                    DiagnosticError(
                        node: type,
                        message: "Unsupported @JS type '\(type.trimmedDescription)'."
                    )
                )
                return .void
            }

            let name = normalizeIdentifier(identifier.name.text)
            if name == "Self", let enclosingTypeName {
                return .jsObject(enclosingTypeName)
            }
            return BridgeType(swiftType: name) ?? .jsObject(name)
        }

        // MARK: - Helper Methods

        private func parseEffects(_ effects: FunctionEffectSpecifiersSyntax?) -> Effects? {
            let isThrows = effects?.throwsClause != nil
            let isAsync = effects?.asyncSpecifier != nil
            guard isThrows else {
                return nil
            }
            return Effects(isAsync: isAsync, isThrows: isThrows)
        }

        private func isStatic(_ modifiers: DeclModifierListSyntax?) -> Bool {
            guard let modifiers else { return false }
            return modifiers.contains { modifier in
                modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
            }
        }

        private func normalizeIdentifier(_ name: String) -> String {
            guard name.hasPrefix("`"), name.hasSuffix("`"), name.count >= 2 else {
                return name
            }
            return String(name.dropFirst().dropLast())
        }
    }
}
