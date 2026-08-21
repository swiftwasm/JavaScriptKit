import SwiftExtract
import SwiftSyntax
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

// MARK: - Export lowering

/// Lowers extracted `@JS` declarations into the exported skeleton.
final class ExportLowering {
    let context: LoweringContext
    private(set) var errors: [(file: String, diagnostic: DiagnosticError)] = []

    init(context: LoweringContext) {
        self.context = context
    }

    private func diagnose(node: some SyntaxProtocol, file: String, message: String, hint: String? = nil) {
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

    private func resolveTypeSyntax(
        _ syntax: TypeSyntax,
        file: String
    ) -> BridgeType? {
        guard let swiftType = try? context.analyzer.resolveType(syntax) else {
            var lookupErrors: [DiagnosticError] = []
            _ = context.unsupported(name: syntax.trimmedDescription, anchor: syntax, errors: &lookupErrors)
            errors.append(contentsOf: lookupErrors.map { (file: file, diagnostic: $0) })
            return nil
        }
        return bridgeType(for: swiftType, anchor: syntax, file: file)
    }

    private func diagnoseNestedOptional(node: some SyntaxProtocol, file: String, type: String) {
        diagnose(
            node: node,
            file: file,
            message: "Nested optional types are not supported: \(type)",
            hint: "Use a single optional like String? instead of String?? or Optional<Optional<T>>"
        )
    }

    // MARK: Contexts

    /// Where an exported member lives; drives namespace inheritance, static
    /// context, and ABI names — the equivalent of the old walker's state.
    private enum MemberContext {
        case topLevel
        case classBody(ExportedClass)
        case structBody(ExportedStruct)
        case enumBody(ExportedEnum)
    }

    // MARK: Global declarations

    func lowerGlobalFunction(_ function: ExtractedFunc, into skeleton: inout ExportedSkeleton) {
        guard let node = function.swiftDecl.as(FunctionDeclSyntax.self) else { return }
        let file = function.sourceFilePath ?? ""
        if node.modifiers.containsStaticOrClass {
            diagnose(node: node, file: file, message: "Top-level functions cannot be static")
            return
        }
        if let exported = lowerFunction(function, node: node, file: file, in: .topLevel) {
            skeleton.functions.append(exported)
        }
    }

    func diagnoseGlobalExportedVariable(_ variable: ExtractedFunc) {
        guard variable.apiKind == .getter else { return }
        diagnose(
            node: variable.swiftDecl,
            file: variable.sourceFilePath ?? "",
            message: "@JS var must be inside a @JS class or enum"
        )
    }

    // MARK: Types

    func lower(_ type: ExtractedNominalType, into skeleton: inout ExportedSkeleton) {
        let nominal = type.swiftNominal
        let attributes = nominal.syntax.attributes
        let file = nominal.sourceFilePath

        // `@JSClass` types belong to the imported skeleton.
        guard !attributes.hasAttribute(name: "JSClass") else { return }

        guard let jsAttribute = attributes.firstJSAttribute else {
            // Members reached this type through an extension of a type that
            // isn't `@JS` — the old collector diagnosed the extension itself.
            for member in type.methods + type.initializers + type.variables
            where member.declAttributeList?.hasJSFamilyAttribute() == true {
                diagnose(
                    node: member.swiftDecl,
                    file: member.sourceFilePath ?? file,
                    message: "Unsupported type '\(nominal.name)'.",
                    hint: "You can only extend `@JS` annotated types defined in the same module"
                )
            }
            return
        }

        if let aliasTarget = SwiftToSkeleton.extractAliasTarget(from: jsAttribute) {
            recordAlias(type: type, jsAttribute: jsAttribute, aliasTarget: aliasTarget, into: &skeleton)
            return
        }

        switch nominal.kind {
        case .class, .actor:
            lowerClass(type, jsAttribute: jsAttribute, into: &skeleton)
        case .struct:
            lowerStruct(type, jsAttribute: jsAttribute, into: &skeleton)
        case .enum:
            lowerEnum(type, jsAttribute: jsAttribute, into: &skeleton)
        case .protocol:
            lowerProtocol(type, jsAttribute: jsAttribute, into: &skeleton)
        }
    }

    // MARK: Namespace helpers

    private struct NamespaceResolution {
        let namespace: [String]?
        let isValid: Bool
    }

    private func resolveNamespace(
        from jsAttribute: AttributeSyntax,
        for nominal: SwiftNominalTypeDeclaration,
        file: String,
        declarationType: String
    ) -> NamespaceResolution {
        let attributeNamespace = SwiftToSkeleton.extractNamespace(from: jsAttribute)
        let computedNamespace = context.namespaceFromEnclosingNamespaceEnums(of: nominal.parent)

        if computedNamespace != nil && attributeNamespace != nil {
            diagnose(
                node: jsAttribute,
                file: file,
                message: "Nested \(declarationType)s cannot specify their own namespace",
                hint:
                    "Remove the namespace from @JS attribute - nested \(declarationType)s inherit namespace from parent"
            )
            return NamespaceResolution(namespace: nil, isValid: false)
        }

        return NamespaceResolution(namespace: computedNamespace ?? attributeNamespace, isValid: true)
    }

    private func effectiveNamespace(
        resolvedNamespace: [String]?,
        parentTypeNamespace: [String]?
    ) -> [String]? {
        let combined = (parentTypeNamespace ?? []) + (resolvedNamespace ?? [])
        return combined.isEmpty ? nil : combined
    }

    /// Requires the node to have at least internal access control.
    private func explicitAtLeastInternalAccessControl(
        for node: some WithModifiersSyntax,
        file: String,
        message: String
    ) -> String? {
        guard let accessControl = node.explicitAccessControl else {
            return nil
        }
        guard accessControl.isAtLeastInternal else {
            diagnose(
                node: accessControl,
                file: file,
                message: message,
                hint: "Use `internal`, `package` or `public` access control"
            )
            return nil
        }
        return accessControl.name.text
    }

    private func diagnoseUnsupportedJSName(from jsAttribute: AttributeSyntax, file: String) {
        guard SwiftToSkeleton.extractJSNameArgument(from: jsAttribute) != nil else { return }
        diagnose(
            node: jsAttribute,
            file: file,
            message: "A separate name for JavaScript is not supported here"
        )
    }

    private func extractValidatedJSName(from jsAttribute: AttributeSyntax, file: String) -> String? {
        guard let jsName = SwiftToSkeleton.extractJSNameArgument(from: jsAttribute) else { return nil }
        guard SwiftToSkeleton.isValidJSIdentifier(jsName) else {
            diagnose(
                node: jsAttribute,
                file: file,
                message: "`\(jsName)` is not a valid JavaScript identifier"
            )
            return nil
        }
        return jsName
    }

    // MARK: Class

    private func lowerClass(
        _ type: ExtractedNominalType,
        jsAttribute: AttributeSyntax,
        into skeleton: inout ExportedSkeleton
    ) {
        let nominal = type.swiftNominal
        let file = nominal.sourceFilePath
        let node = nominal.syntax

        diagnoseUnsupportedJSName(from: jsAttribute, file: file)

        let namespaceResult = resolveNamespace(from: jsAttribute, for: nominal, file: file, declarationType: "class")
        guard namespaceResult.isValid else { return }
        let namespace = effectiveNamespace(
            resolvedNamespace: namespaceResult.namespace,
            parentTypeNamespace: context.namespaceFromEnclosingTypes(of: nominal.parent)
        )
        let swiftCallName = context.swiftCallName(for: nominal)
        let explicitAccessControl = explicitAtLeastInternalAccessControl(
            for: node,
            file: file,
            message: "Class visibility must be at least internal"
        )
        let identityMode = SwiftToSkeleton.extractIdentityMode(from: jsAttribute)
        let isFinal =
            node.modifiers.contains { $0.name.tokenKind == .keyword(.final) } ? true : nil

        var klass = ExportedClass(
            name: nominal.name,
            swiftCallName: swiftCallName,
            explicitAccessControl: explicitAccessControl,
            constructor: nil,
            methods: [],
            properties: [],
            namespace: namespace,
            identityMode: identityMode,
            documentation: SwiftToSkeleton.extractDocumentation(from: node),
            isFinal: isFinal
        )

        let memberContext = MemberContext.classBody(klass)

        for initializer in type.initializers {
            guard let initNode = initializer.swiftDecl.as(InitializerDeclSyntax.self),
                let initJSAttribute = initNode.attributes.firstJSAttribute
            else { continue }
            let initFile = initializer.sourceFilePath ?? file
            diagnoseUnsupportedJSName(from: initJSAttribute, file: initFile)
            if SwiftToSkeleton.extractNamespace(from: initJSAttribute) != nil {
                diagnose(
                    node: initJSAttribute,
                    file: initFile,
                    message: "Namespace is not supported for initializer declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }
            let parameters = lowerParameters(
                semantic: initializer.functionSignature.parameters,
                syntax: initNode.signature.parameterClause,
                file: initFile,
                allowDefaults: true
            )
            guard let effects = collectEffects(signature: initNode.signature, file: initFile) else {
                continue
            }
            klass.constructor = ExportedConstructor(
                abiName: "bjs_\(klass.abiName)_init",
                parameters: parameters,
                effects: effects,
                documentation: SwiftToSkeleton.extractDocumentation(from: initNode)
            )
        }

        for method in type.methods {
            guard let methodNode = method.swiftDecl.as(FunctionDeclSyntax.self),
                methodNode.attributes.firstJSAttribute != nil
            else { continue }
            if let exported = lowerFunction(
                method,
                node: methodNode,
                file: method.sourceFilePath ?? file,
                in: memberContext
            ) {
                klass.methods.append(exported)
            }
        }

        for property in lowerAnnotatedProperties(of: type, in: memberContext, typeFile: file) {
            klass.properties.append(property)
        }

        skeleton.classes.append(klass)
    }

    // MARK: Struct

    private func lowerStruct(
        _ type: ExtractedNominalType,
        jsAttribute: AttributeSyntax,
        into skeleton: inout ExportedSkeleton
    ) {
        let nominal = type.swiftNominal
        let file = nominal.sourceFilePath
        let node = nominal.syntax

        diagnoseUnsupportedJSName(from: jsAttribute, file: file)

        let namespaceResult = resolveNamespace(from: jsAttribute, for: nominal, file: file, declarationType: "struct")
        guard namespaceResult.isValid else { return }
        let namespace = effectiveNamespace(
            resolvedNamespace: namespaceResult.namespace,
            parentTypeNamespace: context.namespaceFromEnclosingTypes(of: nominal.parent)
        )
        let swiftCallName = context.swiftCallName(for: nominal)
        let explicitAccessControl = explicitAtLeastInternalAccessControl(
            for: node,
            file: file,
            message: "Struct visibility must be at least internal"
        )

        var properties: [ExportedProperty] = []
        // Instance stored fields come from the struct's direct body, are
        // implicitly readonly, and don't require `@JS`.
        for member in node.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }
            // `@JS` vars are handled below (with an error unless static).
            if varDecl.attributes.hasJSAttribute() { continue }
            if varDecl.modifiers.containsStaticOrClass { continue }

            for binding in varDecl.bindings {
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    continue
                }
                guard let typeAnnotation = binding.typeAnnotation else {
                    diagnose(node: binding, file: file, message: "Struct field must have explicit type annotation")
                    continue
                }
                guard let fieldType = resolveTypeSyntax(typeAnnotation.type, file: file) else {
                    continue
                }
                properties.append(
                    ExportedProperty(
                        name: pattern.identifier.text,
                        type: fieldType,
                        isReadonly: true,
                        isStatic: false,
                        namespace: namespace,
                        staticContext: nil,
                        documentation: SwiftToSkeleton.extractDocumentation(from: varDecl)
                    )
                )
            }
        }

        var exportedStruct = ExportedStruct(
            name: nominal.name,
            swiftCallName: swiftCallName,
            explicitAccessControl: explicitAccessControl,
            properties: properties,
            constructor: nil,
            methods: [],
            namespace: namespace,
            documentation: SwiftToSkeleton.extractDocumentation(from: node)
        )

        let memberContext = MemberContext.structBody(exportedStruct)

        for initializer in type.initializers {
            guard let initNode = initializer.swiftDecl.as(InitializerDeclSyntax.self),
                let initJSAttribute = initNode.attributes.firstJSAttribute
            else { continue }
            let initFile = initializer.sourceFilePath ?? file
            diagnoseUnsupportedJSName(from: initJSAttribute, file: initFile)
            if SwiftToSkeleton.extractNamespace(from: initJSAttribute) != nil {
                diagnose(
                    node: initJSAttribute,
                    file: initFile,
                    message: "Namespace is not supported for initializer declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }
            let parameters = lowerParameters(
                semantic: initializer.functionSignature.parameters,
                syntax: initNode.signature.parameterClause,
                file: initFile,
                allowDefaults: true
            )
            guard let effects = collectEffects(signature: initNode.signature, file: initFile) else {
                continue
            }
            exportedStruct.constructor = ExportedConstructor(
                abiName: "bjs_\(exportedStruct.abiName)_init",
                parameters: parameters,
                effects: effects,
                documentation: SwiftToSkeleton.extractDocumentation(from: initNode)
            )
        }

        for method in type.methods {
            guard let methodNode = method.swiftDecl.as(FunctionDeclSyntax.self),
                methodNode.attributes.firstJSAttribute != nil
            else { continue }
            if let exported = lowerFunction(
                method,
                node: methodNode,
                file: method.sourceFilePath ?? file,
                in: memberContext
            ) {
                exportedStruct.methods.append(exported)
            }
        }

        for property in lowerAnnotatedProperties(of: type, in: memberContext, typeFile: file) {
            exportedStruct.properties.append(property)
        }

        validateStructInitOrder(node: node, exportedStruct: exportedStruct, file: file)
        skeleton.structs.append(exportedStruct)
    }

    private func validateStructInitOrder(
        node: some DeclGroupSyntax,
        exportedStruct: ExportedStruct,
        file: String
    ) {
        guard let constructor = exportedStruct.constructor else {
            // No explicit @JS init — synthesized memberwise init is assumed,
            // which always matches declaration order.
            return
        }

        let instanceProps = exportedStruct.properties.filter { !$0.isStatic }
        let expectedLabels = instanceProps.map(\.name)
        let actualLabels = constructor.parameters.compactMap(\.label)

        guard expectedLabels != actualLabels else { return }

        // Find the @JS init node so we can point the diagnostic at it.
        let initNode: (any SyntaxProtocol) =
            node.memberBlock.members
            .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
            .first(where: { $0.attributes.hasJSAttribute() })
            ?? node

        let expectedOrder = expectedLabels.joined(separator: ", ")
        let actualOrder = actualLabels.joined(separator: ", ")

        diagnose(
            node: initNode,
            file: file,
            message:
                "@JS struct initializer parameters must match stored properties in declaration order. Expected (\(expectedOrder)), got (\(actualOrder))",
            hint:
                "Reorder the initializer parameters to match the property declaration order, or remove the @JS init to use the synthesized memberwise initializer"
        )
    }

    // MARK: Enum

    private func lowerEnum(
        _ type: ExtractedNominalType,
        jsAttribute: AttributeSyntax,
        into skeleton: inout ExportedSkeleton
    ) {
        let nominal = type.swiftNominal
        let file = nominal.sourceFilePath
        guard let node = nominal.syntax.as(EnumDeclSyntax.self) else { return }

        diagnoseUnsupportedJSName(from: jsAttribute, file: file)

        let rawTypeString = node.inheritanceClause?.inheritedTypes.first { inheritedType in
            SwiftEnumRawType.supportedTypeNames.contains(inheritedType.type.trimmedDescription)
        }?.type.trimmedDescription

        let namespaceResult = resolveNamespace(from: jsAttribute, for: nominal, file: file, declarationType: "enum")
        guard namespaceResult.isValid else { return }
        let namespace = effectiveNamespace(
            resolvedNamespace: namespaceResult.namespace,
            parentTypeNamespace: context.namespaceFromEnclosingTypes(of: nominal.parent)
        )
        let emitStyle = SwiftToSkeleton.extractEnumStyle(from: jsAttribute) ?? .const
        let swiftCallName = context.swiftCallName(for: nominal)
        let explicitAccessControl = explicitAtLeastInternalAccessControl(
            for: node,
            file: file,
            message: "Enum visibility must be at least internal"
        )

        let tsFullPath: String
        if let namespace, !namespace.isEmpty {
            tsFullPath = namespace.joined(separator: ".") + "." + nominal.name
        } else {
            tsFullPath = nominal.name
        }

        var exportedEnum = ExportedEnum(
            name: nominal.name,
            swiftCallName: swiftCallName,
            tsFullPath: tsFullPath,
            explicitAccessControl: explicitAccessControl,
            cases: [],
            rawType: SwiftEnumRawType(rawTypeString),
            namespace: namespace,
            emitStyle: emitStyle,
            staticMethods: [],
            staticProperties: [],
            documentation: SwiftToSkeleton.extractDocumentation(from: node)
        )

        for enumCase in type.cases {
            guard let caseDecl = enumCase.swiftDecl.as(EnumCaseDeclSyntax.self) else { continue }
            let element = caseDecl.elements.first {
                SwiftToSkeleton.normalizeIdentifier($0.name.text) == enumCase.name
            }
            let rawValue: String?
            if exportedEnum.rawType != nil {
                rawValue = Self.rawValueText(of: element)
            } else {
                rawValue = nil
            }
            var associatedValues: [AssociatedValue] = []
            for (index, parameter) in enumCase.parameters.enumerated() {
                let anchor: Syntax
                if let parameterSyntax = element?.parameterClause?.parameters.dropFirst(index).first {
                    anchor = Syntax(parameterSyntax.type)
                } else {
                    anchor = Syntax(caseDecl)
                }
                guard let valueType = bridgeType(for: parameter.type, anchor: anchor, file: file) else {
                    continue
                }
                associatedValues.append(AssociatedValue(label: parameter.name, type: valueType))
            }
            exportedEnum.cases.append(
                EnumCase(
                    name: enumCase.name,
                    rawValue: rawValue,
                    associatedValues: associatedValues
                )
            )
        }

        let memberContext = MemberContext.enumBody(exportedEnum)

        for initializer in type.initializers
        where initializer.swiftDecl.asProtocol((any WithAttributesSyntax).self)?.attributes.hasJSAttribute() == true {
            diagnose(
                node: initializer.swiftDecl,
                file: initializer.sourceFilePath ?? file,
                message: "Initializers are not supported inside enums"
            )
        }

        for method in type.methods {
            guard let methodNode = method.swiftDecl.as(FunctionDeclSyntax.self),
                methodNode.attributes.firstJSAttribute != nil
            else { continue }
            if let exported = lowerFunction(
                method,
                node: methodNode,
                file: method.sourceFilePath ?? file,
                in: memberContext
            ) {
                exportedEnum.staticMethods.append(exported)
            }
        }

        for property in lowerAnnotatedProperties(of: type, in: memberContext, typeFile: file) {
            exportedEnum.staticProperties.append(property)
        }

        // Post-processing checks that the old walker performed in visitPost.
        if case .tsEnum = emitStyle {
            if exportedEnum.rawType == .bool {
                diagnose(
                    node: jsAttribute,
                    file: file,
                    message: "TypeScript enum style is not supported for Bool raw-value enums",
                    hint: "Use enumStyle: .const or change the raw type to String or a numeric type"
                )
            }
            if !exportedEnum.staticMethods.isEmpty {
                diagnose(
                    node: jsAttribute,
                    file: file,
                    message: "TypeScript enum style does not support static functions",
                    hint: "Use enumStyle: .const to generate a const object that supports static functions"
                )
            }
        }

        if exportedEnum.cases.contains(where: { !$0.associatedValues.isEmpty }) {
            if case .tsEnum = emitStyle {
                diagnose(
                    node: jsAttribute,
                    file: file,
                    message: "TypeScript enum style is not supported for associated value enums",
                    hint: "Use enumStyle: .const in order to map associated-value enums"
                )
            }
            for enumCase in exportedEnum.cases {
                for associatedValue in enumCase.associatedValues {
                    if !associatedValue.type.isSupportedAsAssociatedValue() {
                        diagnose(
                            node: node,
                            file: file,
                            message: "Unsupported associated value type: \(associatedValue.type.swiftType)",
                            hint:
                                "Only primitive types, enums, structs, classes, JSObject, arrays, and their optionals are supported in associated-value enums"
                        )
                    }
                }
            }
        }

        skeleton.enums.append(exportedEnum)
    }

    private static func rawValueText(of element: EnumCaseElementSyntax?) -> String? {
        guard let element else { return nil }
        if let stringLiteral = element.rawValue?.value.as(StringLiteralExprSyntax.self) {
            return stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
        }
        if let boolLiteral = element.rawValue?.value.as(BooleanLiteralExprSyntax.self) {
            return boolLiteral.literal.text
        }
        var numericExpr = element.rawValue?.value
        var isNegative = false
        if let prefixExpr = numericExpr?.as(PrefixOperatorExprSyntax.self),
            prefixExpr.operator.text == "-"
        {
            numericExpr = prefixExpr.expression
            isNegative = true
        }
        if let intLiteral = numericExpr?.as(IntegerLiteralExprSyntax.self) {
            return isNegative ? "-\(intLiteral.literal.text)" : intLiteral.literal.text
        }
        if let floatLiteral = numericExpr?.as(FloatLiteralExprSyntax.self) {
            return isNegative ? "-\(floatLiteral.literal.text)" : floatLiteral.literal.text
        }
        return nil
    }

    // MARK: Protocol

    private func lowerProtocol(
        _ type: ExtractedNominalType,
        jsAttribute: AttributeSyntax,
        into skeleton: inout ExportedSkeleton
    ) {
        let nominal = type.swiftNominal
        let file = nominal.sourceFilePath
        let node = nominal.syntax

        diagnoseUnsupportedJSName(from: jsAttribute, file: file)

        let namespaceResult = resolveNamespace(
            from: jsAttribute,
            for: nominal,
            file: file,
            declarationType: "protocol"
        )
        guard namespaceResult.isValid else { return }
        let namespace = effectiveNamespace(
            resolvedNamespace: namespaceResult.namespace,
            parentTypeNamespace: context.namespaceFromEnclosingTypes(of: nominal.parent)
        )
        _ = explicitAtLeastInternalAccessControl(
            for: node,
            file: file,
            message: "Protocol visibility must be at least internal"
        )

        var methods: [ExportedFunction] = []
        for method in type.methods {
            guard let methodNode = method.swiftDecl.as(FunctionDeclSyntax.self) else { continue }
            if let methodJSAttribute = methodNode.attributes.firstJSAttribute {
                diagnoseUnsupportedJSName(from: methodJSAttribute, file: file)
            }

            let parameters = lowerParameters(
                semantic: method.functionSignature.parameters,
                syntax: methodNode.signature.parameterClause,
                file: file,
                allowDefaults: false
            )
            guard
                let returnType = lowerReturnType(
                    semantic: method.functionSignature.result.type,
                    syntax: methodNode.signature.returnClause,
                    file: file
                )
            else { continue }
            guard let effects = collectEffects(signature: methodNode.signature, file: file) else {
                continue
            }
            methods.append(
                ExportedFunction(
                    name: methodNode.name.text,
                    abiName: ABINameGenerator.generateABIName(
                        baseName: methodNode.name.text,
                        namespace: namespace,
                        className: nominal.name
                    ),
                    parameters: parameters,
                    returnType: returnType,
                    effects: effects,
                    namespace: namespace,
                    staticContext: nil,
                    documentation: SwiftToSkeleton.extractDocumentation(from: methodNode)
                )
            )
        }

        var properties: [ExportedProtocolProperty] = []
        var seenPropertyDecls = Set<SyntaxIdentifier>()
        for variable in type.variables {
            guard let varDecl = variable.swiftDecl.as(VariableDeclSyntax.self),
                seenPropertyDecls.insert(varDecl.id).inserted
            else { continue }
            if let varJSAttribute = varDecl.attributes.firstJSAttribute {
                diagnoseUnsupportedJSName(from: varJSAttribute, file: file)
            }
            for binding in varDecl.bindings {
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    diagnose(
                        node: binding.pattern,
                        file: file,
                        message: "Complex patterns not supported for protocol properties"
                    )
                    continue
                }
                guard let typeAnnotation = binding.typeAnnotation else {
                    diagnose(node: binding, file: file, message: "Protocol property must have explicit type annotation")
                    continue
                }
                guard let propertyType = resolveTypeSyntax(typeAnnotation.type, file: file) else {
                    continue
                }
                guard let accessorBlock = binding.accessorBlock else {
                    diagnose(
                        node: binding,
                        file: file,
                        message: "Protocol property must specify { get } or { get set }",
                        hint: "Add { get } for readonly or { get set } for readwrite property"
                    )
                    continue
                }
                properties.append(
                    ExportedProtocolProperty(
                        name: pattern.identifier.text,
                        type: propertyType,
                        isReadonly: Self.hasOnlyGetter(accessorBlock),
                        documentation: SwiftToSkeleton.extractDocumentation(from: varDecl)
                    )
                )
            }
        }

        skeleton.protocols.append(
            ExportedProtocol(
                name: nominal.name,
                methods: methods,
                properties: properties,
                namespace: namespace,
                documentation: SwiftToSkeleton.extractDocumentation(from: node)
            )
        )
    }

    static func hasOnlyGetter(_ accessorBlock: AccessorBlockSyntax?) -> Bool {
        switch accessorBlock?.accessors {
        case .accessors(let accessors):
            return !accessors.contains(where: { accessor in
                let tokenKind = accessor.accessorSpecifier.tokenKind
                return tokenKind == .keyword(.set) || tokenKind == .keyword(.willSet)
                    || tokenKind == .keyword(.didSet)
            })
        case .getter:
            return true
        case nil:
            return false
        }
    }

    // MARK: Alias

    private func recordAlias(
        type: ExtractedNominalType,
        jsAttribute: AttributeSyntax,
        aliasTarget: TypeSyntax,
        into skeleton: inout ExportedSkeleton
    ) {
        let nominal = type.swiftNominal
        let file = nominal.sourceFilePath
        let swiftCallName = context.swiftCallName(for: nominal)
        if SwiftToSkeleton.extractNamespace(from: jsAttribute) != nil {
            diagnose(
                node: nominal.syntax,
                file: file,
                message: "`namespace` is not supported on `@JS(as:)` types",
                hint: "Remove the `namespace:` argument; an alias adopts its target's representation"
            )
            return
        }
        var lookupErrors: [DiagnosticError] = []
        guard
            let aliasBridgeType = context.aliasType(
                target: aliasTarget,
                swiftCallName: swiftCallName,
                anchor: aliasTarget,
                errors: &lookupErrors
            ),
            case .alias(_, let underlying) = aliasBridgeType
        else {
            errors.append(contentsOf: lookupErrors.map { (file: file, diagnostic: $0) })
            return
        }
        guard underlying.aliasConformanceProtocols != nil else {
            diagnose(
                node: aliasTarget,
                file: file,
                message: "Representation \(underlying.swiftType) is not supported"
            )
            return
        }
        skeleton.aliases.append(
            ExportedAlias(swiftCallName: swiftCallName, underlying: underlying)
        )
    }

    // MARK: Functions

    private func lowerFunction(
        _ function: ExtractedFunc,
        node: FunctionDeclSyntax,
        file: String,
        in memberContext: MemberContext
    ) -> ExportedFunction? {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return nil
        }

        if let genericClause = node.genericParameterClause, let firstGenericParam = genericClause.parameters.first {
            diagnose(
                node: firstGenericParam,
                file: file,
                message:
                    "Generic parameters on exported @JS functions are not supported yet. Generic functions are currently only supported on imported @JSFunction declarations."
            )
            return nil
        }

        let isStatic = node.modifiers.containsStaticOrClass
        let name = node.name.text
        let jsName = extractValidatedJSName(from: jsAttribute, file: file)

        let attributeNamespace = SwiftToSkeleton.extractNamespace(from: jsAttribute)
        let computedNamespace: [String]?
        switch memberContext {
        case .topLevel:
            computedNamespace = nil
        case .classBody, .structBody, .enumBody:
            computedNamespace = context.namespaceFromEnclosingNamespaceEnums(of: function.enclosingNominal)
        }

        let finalNamespace: [String]?
        if let computed = computedNamespace, !computed.isEmpty {
            finalNamespace = computed
        } else {
            finalNamespace = attributeNamespace
        }

        if attributeNamespace != nil, case .classBody = memberContext {
            diagnose(
                node: jsAttribute,
                file: file,
                message: "Namespace is only needed in top-level declaration",
                hint: "Remove the namespace from @JS attribute or move this function to top-level"
            )
        }

        if attributeNamespace != nil, case .enumBody = memberContext {
            diagnose(
                node: jsAttribute,
                file: file,
                message: "Namespace is not supported for enum static functions",
                hint: "Remove the namespace from @JS attribute - enum functions inherit namespace from enum"
            )
        }

        let parameters = lowerParameters(
            semantic: function.functionSignature.parameters,
            syntax: node.signature.parameterClause,
            file: file,
            allowDefaults: true
        )
        guard
            let returnType = lowerReturnType(
                semantic: function.functionSignature.result.type,
                syntax: node.signature.returnClause,
                file: file
            )
        else { return nil }

        let staticContext: StaticContext?
        let classNameForABI: String?

        switch memberContext {
        case .topLevel:
            staticContext = nil
            classNameForABI = nil
        case .classBody(let klass):
            staticContext = isStatic ? .className(klass.abiName) : nil
            classNameForABI = klass.abiName
        case .structBody(let exportedStruct):
            staticContext = isStatic ? .structName(exportedStruct.abiName) : nil
            classNameForABI = exportedStruct.abiName
        case .enumBody(let exportedEnum):
            if !isStatic {
                diagnose(node: node, file: file, message: "Only static functions are supported in enums")
                return nil
            }
            let isNamespaceEnum = exportedEnum.cases.isEmpty
            staticContext =
                isNamespaceEnum
                ? .namespaceEnum(exportedEnum.swiftCallName)
                : .enumName(exportedEnum.name)
            classNameForABI = nil
        }

        let abiName = ABINameGenerator.generateABIName(
            baseName: jsName ?? name,
            namespace: finalNamespace,
            staticContext: isStatic ? staticContext : nil,
            className: classNameForABI
        )

        guard let effects = collectEffects(signature: node.signature, file: file, isStatic: isStatic) else {
            return nil
        }

        return ExportedFunction(
            name: name,
            jsName: jsName,
            abiName: abiName,
            parameters: parameters,
            returnType: returnType,
            effects: effects,
            namespace: finalNamespace,
            staticContext: staticContext,
            documentation: SwiftToSkeleton.extractDocumentation(from: node)
        )
    }

    // MARK: Properties (@JS var)

    private func lowerAnnotatedProperties(
        of type: ExtractedNominalType,
        in memberContext: MemberContext,
        typeFile: String
    ) -> [ExportedProperty] {
        var properties: [ExportedProperty] = []
        var seenDecls = Set<SyntaxIdentifier>()

        for variable in type.variables {
            guard let varDecl = variable.swiftDecl.as(VariableDeclSyntax.self),
                let jsAttribute = varDecl.attributes.firstJSAttribute,
                seenDecls.insert(varDecl.id).inserted
            else { continue }
            let file = variable.sourceFilePath ?? typeFile

            let isStatic = varDecl.modifiers.containsStaticOrClass

            if SwiftToSkeleton.extractNamespace(from: jsAttribute) != nil {
                diagnose(
                    node: jsAttribute,
                    file: file,
                    message: "Namespace parameter within @JS attribute is not supported for property declarations",
                    hint:
                        "Remove the namespace from @JS attribute. If you need dedicated namespace, consider using a nested enum or class instead."
                )
            }

            let computedNamespace = context.namespaceFromEnclosingNamespaceEnums(of: variable.enclosingNominal)
            let finalNamespace: [String]?
            if let computed = computedNamespace, !computed.isEmpty {
                finalNamespace = computed
            } else {
                finalNamespace = nil
            }

            let staticContext: StaticContext?
            switch memberContext {
            case .classBody(let klass):
                staticContext = isStatic ? .className(klass.abiName) : nil
            case .enumBody(let exportedEnum):
                if !isStatic {
                    diagnose(node: varDecl, file: file, message: "Only static properties are supported in enums")
                    continue
                }
                let isNamespaceEnum = exportedEnum.cases.isEmpty
                staticContext =
                    isNamespaceEnum
                    ? .namespaceEnum(exportedEnum.swiftCallName)
                    : .enumName(exportedEnum.swiftCallName)
            case .structBody(let exportedStruct):
                if !isStatic {
                    diagnose(
                        node: varDecl,
                        file: file,
                        message: "@JS var must be static in structs (instance fields don't need @JS)"
                    )
                    continue
                }
                staticContext = .structName(exportedStruct.abiName)
            case .topLevel:
                diagnose(node: varDecl, file: file, message: "@JS var must be inside a @JS class or enum")
                continue
            }

            let jsName = extractValidatedJSName(from: jsAttribute, file: file)
            if jsName != nil, varDecl.bindings.count > 1 {
                diagnose(
                    node: jsAttribute,
                    file: file,
                    message: "Name targets declaration with multiple bindings",
                    hint: "Declare each property with a different JS name separately"
                )
            }

            for binding in varDecl.bindings {
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    diagnose(
                        node: binding.pattern,
                        file: file,
                        message: "Complex patterns not supported for @JS properties"
                    )
                    continue
                }
                guard let typeAnnotation = binding.typeAnnotation else {
                    diagnose(node: binding, file: file, message: "@JS property must have explicit type annotation")
                    continue
                }
                guard let propertyType = resolveTypeSyntax(typeAnnotation.type, file: file) else {
                    continue
                }

                let isLet = varDecl.bindingSpecifier.tokenKind == .keyword(.let)
                let isGetterOnly = varDecl.bindings.contains(where: { Self.hasOnlyGetter($0.accessorBlock) })

                properties.append(
                    ExportedProperty(
                        name: pattern.identifier.text,
                        jsName: jsName,
                        type: propertyType,
                        isReadonly: isLet || isGetterOnly,
                        isStatic: isStatic,
                        namespace: finalNamespace,
                        staticContext: staticContext,
                        documentation: SwiftToSkeleton.extractDocumentation(from: varDecl)
                    )
                )
            }
        }

        return properties
    }

    // MARK: Parameters / return types / effects

    private func lowerParameters(
        semantic: [SwiftParameter],
        syntax: FunctionParameterClauseSyntax,
        file: String,
        allowDefaults: Bool
    ) -> [Parameter] {
        var parameters: [Parameter] = []
        for (index, syntaxParam) in syntax.parameters.enumerated() {
            guard index < semantic.count else { break }
            let semanticParam = semantic[index]

            guard let type = bridgeType(for: semanticParam.type, anchor: syntaxParam.type, file: file) else {
                continue  // Skip unsupported types
            }
            if case .nullable(let wrappedType, _) = type, wrappedType.isOptional {
                diagnoseNestedOptional(node: syntaxParam.type, file: file, type: syntaxParam.type.trimmedDescription)
                continue
            }

            let name = syntaxParam.secondName?.text ?? syntaxParam.firstName.text
            let label = syntaxParam.firstName.text

            let defaultValue: DefaultValue?
            if allowDefaults {
                defaultValue = extractDefaultValue(from: syntaxParam.defaultValue, type: type, file: file)
            } else {
                defaultValue = nil
            }

            parameters.append(Parameter(label: label, name: name, type: type, defaultValue: defaultValue))
        }
        return parameters
    }

    private func lowerReturnType(
        semantic: SwiftType,
        syntax: ReturnClauseSyntax?,
        file: String
    ) -> BridgeType? {
        guard let returnClause = syntax else {
            return .void
        }
        guard let type = bridgeType(for: semantic, anchor: returnClause.type, file: file) else {
            return nil
        }
        if case .nullable(let wrappedType, _) = type, wrappedType.isOptional {
            diagnoseNestedOptional(node: returnClause.type, file: file, type: returnClause.type.trimmedDescription)
            return nil
        }
        return type
    }

    private func collectEffects(
        signature: FunctionSignatureSyntax,
        file: String,
        isStatic: Bool = false
    ) -> Effects? {
        let isAsync = signature.effectSpecifiers?.asyncSpecifier != nil
        var isThrows = false
        if let throwsClause: ThrowsClauseSyntax = signature.effectSpecifiers?.throwsClause {
            // Limit the thrown type to JSException for now
            guard let thrownType = throwsClause.type else {
                diagnose(
                    node: throwsClause,
                    file: file,
                    message: "Thrown type is not specified, only JSException is supported for now"
                )
                return nil
            }
            guard thrownType.trimmedDescription == "JSException" else {
                diagnose(
                    node: throwsClause,
                    file: file,
                    message: "Only JSException is supported for thrown type, got \(thrownType.trimmedDescription)"
                )
                return nil
            }
            isThrows = true
        }
        return Effects(isAsync: isAsync, isThrows: isThrows, isStatic: isStatic)
    }

    // MARK: Default parameter values

    /// Detects whether given expression is supported as default parameter value
    private func isSupportedDefaultValueExpression(_ initClause: InitializerClauseSyntax) -> Bool {
        let expression = initClause.value

        // Function calls are checked later in extractDefaultValue (as constructors are allowed)
        // Array literals are allowed but checked in extractArrayDefaultValue
        if expression.is(DictionaryExprSyntax.self) { return false }
        if expression.is(BinaryOperatorExprSyntax.self) { return false }
        if expression.is(ClosureExprSyntax.self) { return false }

        // Method call chains (e.g., obj.foo())
        if let memberExpression = expression.as(MemberAccessExprSyntax.self),
            memberExpression.base?.is(FunctionCallExprSyntax.self) == true
        {
            return false
        }

        return true
    }

    /// Extract enum case value from member access expression
    private func extractEnumCaseValue(
        from memberExpr: MemberAccessExprSyntax,
        type: BridgeType
    ) -> DefaultValue? {
        let caseName = memberExpr.declName.baseName.text

        let enumName: String?
        switch type {
        case .caseEnum(let name), .rawValueEnum(let name, _), .associatedValueEnum(let name):
            enumName = name
        case .nullable(let wrappedType, _):
            switch wrappedType {
            case .caseEnum(let name), .rawValueEnum(let name, _), .associatedValueEnum(let name):
                enumName = name
            default:
                return nil
            }
        default:
            return nil
        }

        guard let enumName = enumName else { return nil }

        if memberExpr.base == nil {
            return .enumCase(enumName, caseName)
        }

        if let baseExpr = memberExpr.base?.as(DeclReferenceExprSyntax.self) {
            let baseName = baseExpr.baseName.text
            let lastComponent = enumName.split(separator: ".").last.map(String.init) ?? enumName
            if baseName == enumName || baseName == lastComponent {
                return .enumCase(enumName, caseName)
            }
        }

        return nil
    }

    /// Extracts default value from parameter's default value clause
    private func extractDefaultValue(
        from defaultClause: InitializerClauseSyntax?,
        type: BridgeType,
        file: String
    ) -> DefaultValue? {
        guard let defaultClause = defaultClause else {
            return nil
        }

        if !isSupportedDefaultValueExpression(defaultClause) {
            diagnose(
                node: defaultClause,
                file: file,
                message: "Complex default parameter expressions are not supported",
                hint: "Use simple literal values (e.g., \"text\", 42, true, nil) or simple constants"
            )
            return nil
        }

        let expr = defaultClause.value

        if expr.is(NilLiteralExprSyntax.self) {
            guard case .nullable = type else {
                diagnose(
                    node: expr,
                    file: file,
                    message: "nil is only valid for optional parameters",
                    hint: "Make the parameter optional by adding ? to the type"
                )
                return nil
            }
            return .null
        }

        if let memberExpr = expr.as(MemberAccessExprSyntax.self),
            let enumValue = extractEnumCaseValue(from: memberExpr, type: type)
        {
            return enumValue
        }

        if let funcCall = expr.as(FunctionCallExprSyntax.self) {
            return extractConstructorDefaultValue(from: funcCall, type: type, file: file)
        }

        if let arrayExpr = expr.as(ArrayExprSyntax.self) {
            return extractArrayDefaultValue(from: arrayExpr, type: type, file: file)
        }

        if let literalValue = extractLiteralValue(from: expr, type: type) {
            return literalValue
        }

        diagnose(
            node: expr,
            file: file,
            message: "Unsupported default parameter value expression",
            hint: "Use simple literal values like \"text\", 42, true, false, nil, or enum cases like .caseName"
        )
        return nil
    }

    /// Extracts default value from a constructor call expression
    private func extractConstructorDefaultValue(
        from funcCall: FunctionCallExprSyntax,
        type: BridgeType,
        file: String
    ) -> DefaultValue? {
        guard let calledExpr = funcCall.calledExpression.as(DeclReferenceExprSyntax.self) else {
            diagnose(
                node: funcCall,
                file: file,
                message: "Complex constructor expressions are not supported",
                hint: "Use a simple constructor call like ClassName() or ClassName(arg: value)"
            )
            return nil
        }

        let typeName = calledExpr.baseName.text

        let isStructType: Bool
        let expectedTypeName: String?
        switch type {
        case .swiftStruct(let name), .nullable(.swiftStruct(let name), _):
            isStructType = true
            expectedTypeName = name.split(separator: ".").last.map(String.init)
        case .swiftHeapObject(let name), .nullable(.swiftHeapObject(let name), _):
            isStructType = false
            expectedTypeName = name.split(separator: ".").last.map(String.init)
        default:
            diagnose(
                node: funcCall,
                file: file,
                message: "Constructor calls are only supported for class and struct types",
                hint: "Parameter type should be a Swift class or struct"
            )
            return nil
        }

        guard let expectedTypeName = expectedTypeName, typeName == expectedTypeName else {
            diagnose(
                node: funcCall,
                file: file,
                message: "Constructor type name '\(typeName)' doesn't match parameter type",
                hint: "Ensure the constructor matches the parameter type"
            )
            return nil
        }

        if isStructType {
            // For structs, extract field name/value pairs
            var fields: [DefaultValueField] = []
            for argument in funcCall.arguments {
                guard let fieldName = argument.label?.text else {
                    diagnose(
                        node: argument,
                        file: file,
                        message: "Struct initializer arguments must have labels",
                        hint: "Use labeled arguments like MyStruct(x: 1, y: 2)"
                    )
                    return nil
                }
                guard let fieldValue = extractLiteralValue(from: argument.expression) else {
                    diagnose(
                        node: argument.expression,
                        file: file,
                        message: "Struct field value must be a literal",
                        hint: "Use simple literals like \"text\", 42, true, false in struct fields"
                    )
                    return nil
                }
                fields.append(DefaultValueField(name: fieldName, value: fieldValue))
            }
            return .structLiteral(typeName, fields)
        } else {
            if funcCall.arguments.isEmpty {
                return .object(typeName)
            }

            var constructorArgs: [DefaultValue] = []
            for argument in funcCall.arguments {
                guard let argValue = extractLiteralValue(from: argument.expression) else {
                    diagnose(
                        node: argument.expression,
                        file: file,
                        message: "Constructor argument must be a literal value",
                        hint: "Use simple literals like \"text\", 42, true, false in constructor arguments"
                    )
                    return nil
                }
                constructorArgs.append(argValue)
            }
            return .objectWithArguments(typeName, constructorArgs)
        }
    }

    /// Extracts a literal value from an expression with optional type checking
    private func extractLiteralValue(from expr: ExprSyntax, type: BridgeType? = nil) -> DefaultValue? {
        if expr.is(NilLiteralExprSyntax.self) {
            return .null
        }

        if let stringLiteral = expr.as(StringLiteralExprSyntax.self),
            let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
        {
            let value = DefaultValue.string(segment.content.text)
            if let type = type, !type.isCompatibleWith(.string) {
                return nil
            }
            return value
        }

        if let boolLiteral = expr.as(BooleanLiteralExprSyntax.self) {
            let value = DefaultValue.bool(boolLiteral.literal.text == "true")
            if let type = type, !type.isCompatibleWith(.bool) {
                return nil
            }
            return value
        }

        var numericExpr = expr
        var isNegative = false
        if let prefixExpr = expr.as(PrefixOperatorExprSyntax.self),
            prefixExpr.operator.text == "-"
        {
            numericExpr = prefixExpr.expression
            isNegative = true
        }

        if let intLiteral = numericExpr.as(IntegerLiteralExprSyntax.self),
            let intValue = Int(intLiteral.literal.text)
        {
            let value = DefaultValue.int(isNegative ? -intValue : intValue)
            if let type = type, !type.isCompatibleWith(.integer(.int)) {
                return nil
            }
            return value
        }

        if let floatLiteral = numericExpr.as(FloatLiteralExprSyntax.self) {
            if let floatValue = Float(floatLiteral.literal.text) {
                let value = DefaultValue.float(isNegative ? -floatValue : floatValue)
                if type == nil || type?.isCompatibleWith(.float) == true {
                    return value
                }
            }
            if let doubleValue = Double(floatLiteral.literal.text) {
                let value = DefaultValue.double(isNegative ? -doubleValue : doubleValue)
                if type == nil || type?.isCompatibleWith(.double) == true {
                    return value
                }
            }
        }

        return nil
    }

    /// Extracts default value from an array literal expression
    private func extractArrayDefaultValue(
        from arrayExpr: ArrayExprSyntax,
        type: BridgeType,
        file: String
    ) -> DefaultValue? {
        // Verify the type is an array type
        let elementType: BridgeType?
        switch type {
        case .array(let element):
            elementType = element
        case .nullable(.array(let element), _):
            elementType = element
        default:
            diagnose(
                node: arrayExpr,
                file: file,
                message: "Array literal is only valid for array parameters",
                hint: "Parameter type should be an array like [Int] or [String]"
            )
            return nil
        }

        var elements: [DefaultValue] = []
        for element in arrayExpr.elements {
            guard let elementValue = extractLiteralValue(from: element.expression, type: elementType) else {
                diagnose(
                    node: element.expression,
                    file: file,
                    message: "Array element must be a literal value",
                    hint: "Use simple literals like \"text\", 42, true, false in array elements"
                )
                return nil
            }
            elements.append(elementValue)
        }

        return .array(elements)
    }
}

extension ExtractedFunc {
    /// The nominal type containing this member, when it has one.
    var enclosingNominal: SwiftNominalTypeDeclaration? {
        parentType?.asNominalTypeDeclaration
    }
}

extension BridgeType {
    fileprivate func isCompatibleWith(_ expectedType: BridgeType) -> Bool {
        switch (self, expectedType) {
        case let (lhs, rhs) where lhs == rhs:
            return true
        case (.nullable(let wrapped, _), expectedType):
            return wrapped == expectedType
        default:
            return false
        }
    }

    fileprivate func isSupportedAsAssociatedValue(allowNullable: Bool = true) -> Bool {
        switch self {
        case .string, .integer, .float, .double, .bool, .caseEnum, .rawValueEnum,
            .swiftStruct, .swiftHeapObject, .jsObject, .associatedValueEnum, .array:
            return true
        case .alias(_, let underlying):
            return underlying.isSupportedAsAssociatedValue(allowNullable: false)
        case .nullable(let wrapped, _) where allowNullable:
            return wrapped.isSupportedAsAssociatedValue(allowNullable: false)
        default:
            return false
        }
    }
}
