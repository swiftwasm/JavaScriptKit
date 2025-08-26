import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Exports Swift functions and classes to JavaScript
///
/// This class processes Swift source files to find declarations marked with `@JS`
/// and generates:
/// 1. Swift glue code to call the Swift functions from JavaScript
/// 2. Skeleton files that define the structure of the exported APIs
///
/// The generated skeletons will be used by ``BridgeJSLink`` to generate
/// JavaScript glue code and TypeScript definitions.
public class ExportSwift {
    let progress: ProgressReporting
    let moduleName: String

    private var exportedFunctions: [ExportedFunction] = []
    private var exportedClasses: [ExportedClass] = []
    private var exportedEnums: [ExportedEnum] = []
    private var typeDeclResolver: TypeDeclResolver = TypeDeclResolver()

    public init(progress: ProgressReporting, moduleName: String) {
        self.progress = progress
        self.moduleName = moduleName
    }

    /// Processes a Swift source file to find declarations marked with @JS
    ///
    /// - Parameters:
    ///   - sourceFile: The parsed Swift source file to process
    ///   - inputFilePath: The file path for error reporting
    public func addSourceFile(_ sourceFile: SourceFileSyntax, _ inputFilePath: String) throws {
        progress.print("Processing \(inputFilePath)")
        typeDeclResolver.addSourceFile(sourceFile)

        let errors = try parseSingleFile(sourceFile)
        if errors.count > 0 {
            throw BridgeJSCoreError(
                errors.map { $0.formattedDescription(fileName: inputFilePath) }
                    .joined(separator: "\n")
            )
        }
    }

    /// Finalizes the export process and generates the bridge code
    ///
    /// - Returns: A tuple containing the generated Swift code and a skeleton
    /// describing the exported APIs
    public func finalize() throws -> (outputSwift: String, outputSkeleton: ExportedSkeleton)? {
        guard let outputSwift = try renderSwiftGlue() else {
            return nil
        }
        return (
            outputSwift: outputSwift,
            outputSkeleton: ExportedSkeleton(
                moduleName: moduleName,
                functions: exportedFunctions,
                classes: exportedClasses,
                enums: exportedEnums
            )
        )
    }

    fileprivate final class APICollector: SyntaxAnyVisitor {
        var exportedFunctions: [ExportedFunction] = []
        /// The names of the exported classes, in the order they were written in the source file
        var exportedClassNames: [String] = []
        var exportedClassByName: [String: ExportedClass] = [:]
        /// The names of the exported enums, in the order they were written in the source file
        var exportedEnumNames: [String] = []
        var exportedEnumByName: [String: ExportedEnum] = [:]
        var errors: [DiagnosticError] = []

        /// Creates a unique key for a class by combining name and namespace
        private func classKey(name: String, namespace: [String]?) -> String {
            if let namespace = namespace, !namespace.isEmpty {
                return "\(namespace.joined(separator: ".")).\(name)"
            } else {
                return name
            }
        }

        /// Temporary storage for enum data during visitor traversal since EnumCaseDeclSyntax lacks parent context
        struct CurrentEnum {
            var name: String?
            var cases: [EnumCase] = []
            var rawType: String?
        }
        var currentEnum = CurrentEnum()

        enum State {
            case topLevel
            case classBody(name: String, key: String)
            case enumBody(name: String)
        }

        struct StateStack {
            private var states: [State]
            var current: State {
                return states.last!
            }

            init(_ initialState: State) {
                self.states = [initialState]
            }
            mutating func push(state: State) {
                states.append(state)
            }

            mutating func pop() {
                _ = states.removeLast()
            }
        }

        var stateStack: StateStack = StateStack(.topLevel)
        var state: State {
            return stateStack.current
        }
        let parent: ExportSwift

        init(parent: ExportSwift) {
            self.parent = parent
            super.init(viewMode: .sourceAccurate)
        }

        private func diagnose(node: some SyntaxProtocol, message: String, hint: String? = nil) {
            errors.append(DiagnosticError(node: node, message: message, hint: hint))
        }

        private func diagnoseUnsupportedType(node: some SyntaxProtocol, type: String) {
            diagnose(
                node: node,
                message: "Unsupported type: \(type)",
                hint: "Only primitive types and types defined in the same module are allowed"
            )
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            switch state {
            case .topLevel:
                if let exportedFunction = visitFunction(
                    node: node
                ) {
                    exportedFunctions.append(exportedFunction)
                }
                return .skipChildren
            case .classBody(_, let classKey):
                if let exportedFunction = visitFunction(
                    node: node
                ) {
                    exportedClassByName[classKey]?.methods.append(exportedFunction)
                }
                return .skipChildren
            case .enumBody:
                diagnose(node: node, message: "Functions are not supported inside enums")
                return .skipChildren
            }
        }

        private func visitFunction(node: FunctionDeclSyntax) -> ExportedFunction? {
            guard let jsAttribute = node.attributes.firstJSAttribute else {
                return nil
            }

            let name = node.name.text
            let namespace = extractNamespace(from: jsAttribute)

            if namespace != nil, case .classBody = state {
                diagnose(
                    node: jsAttribute,
                    message: "Namespace is only needed in top-level declaration",
                    hint: "Remove the namespace from @JS attribute or move this function to top-level"
                )
            }

            var parameters: [Parameter] = []
            for param in node.signature.parameterClause.parameters {
                guard let type = self.parent.lookupType(for: param.type) else {
                    diagnoseUnsupportedType(node: param.type, type: param.type.trimmedDescription)
                    continue
                }
                let name = param.secondName?.text ?? param.firstName.text
                let label = param.firstName.text
                parameters.append(Parameter(label: label, name: name, type: type))
            }
            let returnType: BridgeType
            if let returnClause = node.signature.returnClause {
                guard let type = self.parent.lookupType(for: returnClause.type) else {
                    diagnoseUnsupportedType(node: returnClause.type, type: returnClause.type.trimmedDescription)
                    return nil
                }
                returnType = type
            } else {
                returnType = .void
            }

            let abiName: String
            switch state {
            case .topLevel:
                abiName = "bjs_\(name)"
            case .classBody(let className, _):
                abiName = "bjs_\(className)_\(name)"
            case .enumBody:
                abiName = ""
                diagnose(
                    node: node,
                    message: "Functions are not supported inside enums"
                )
            }

            guard let effects = collectEffects(signature: node.signature) else {
                return nil
            }

            return ExportedFunction(
                name: name,
                abiName: abiName,
                parameters: parameters,
                returnType: returnType,
                effects: effects,
                namespace: namespace
            )
        }

        private func collectEffects(signature: FunctionSignatureSyntax) -> Effects? {
            let isAsync = signature.effectSpecifiers?.asyncSpecifier != nil
            var isThrows = false
            if let throwsClause: ThrowsClauseSyntax = signature.effectSpecifiers?.throwsClause {
                // Limit the thrown type to JSException for now
                guard let thrownType = throwsClause.type else {
                    diagnose(
                        node: throwsClause,
                        message: "Thrown type is not specified, only JSException is supported for now"
                    )
                    return nil
                }
                guard thrownType.trimmedDescription == "JSException" else {
                    diagnose(
                        node: throwsClause,
                        message: "Only JSException is supported for thrown type, got \(thrownType.trimmedDescription)"
                    )
                    return nil
                }
                isThrows = true
            }
            return Effects(isAsync: isAsync, isThrows: isThrows)
        }

        private func extractNamespace(
            from jsAttribute: AttributeSyntax
        ) -> [String]? {
            guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self) else {
                return nil
            }

            guard let namespaceArg = arguments.first(where: { $0.label?.text == "namespace" }),
                let stringLiteral = namespaceArg.expression.as(StringLiteralExprSyntax.self),
                let namespaceString = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
            else {
                return nil
            }

            return namespaceString.split(separator: ".").map(String.init)
        }

        private func extractEnumStyle(
            from jsAttribute: AttributeSyntax
        ) -> EnumEmitStyle? {
            guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
                let styleArg = arguments.first(where: { $0.label?.text == "enumStyle" })
            else {
                return nil
            }
            let text = styleArg.expression.trimmedDescription
            if text.contains("tsEnum") {
                return .tsEnum
            }
            if text.contains("const") {
                return .const
            }
            return nil
        }

        override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else { return .skipChildren }
            guard case .classBody(let className, _) = state else {
                if case .enumBody(_) = state {
                    diagnose(node: node, message: "Initializers are not supported inside enums")
                } else {
                    diagnose(node: node, message: "@JS init must be inside a @JS class")
                }
                return .skipChildren
            }

            if let jsAttribute = node.attributes.firstJSAttribute,
                extractNamespace(from: jsAttribute) != nil
            {
                diagnose(
                    node: jsAttribute,
                    message: "Namespace is not supported for initializer declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }

            var parameters: [Parameter] = []
            for param in node.signature.parameterClause.parameters {
                guard let type = self.parent.lookupType(for: param.type) else {
                    diagnoseUnsupportedType(node: param.type, type: param.type.trimmedDescription)
                    continue
                }
                let name = param.secondName?.text ?? param.firstName.text
                let label = param.firstName.text
                parameters.append(Parameter(label: label, name: name, type: type))
            }

            guard let effects = collectEffects(signature: node.signature) else {
                return .skipChildren
            }

            let constructor = ExportedConstructor(
                abiName: "bjs_\(className)_init",
                parameters: parameters,
                effects: effects
            )
            if case .classBody(_, let classKey) = state {
                exportedClassByName[classKey]?.constructor = constructor
            }
            return .skipChildren
        }

        override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else { return .skipChildren }
            guard case .classBody(_, let classKey) = state else {
                diagnose(node: node, message: "@JS var must be inside a @JS class")
                return .skipChildren
            }

            if let jsAttribute = node.attributes.firstJSAttribute,
                extractNamespace(from: jsAttribute) != nil
            {
                diagnose(
                    node: jsAttribute,
                    message: "Namespace is not supported for property declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }

            // Process each binding (variable declaration)
            for binding in node.bindings {
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    diagnose(node: binding.pattern, message: "Complex patterns not supported for @JS properties")
                    continue
                }

                let propertyName = pattern.identifier.text

                guard let typeAnnotation = binding.typeAnnotation else {
                    diagnose(node: binding, message: "@JS property must have explicit type annotation")
                    continue
                }

                guard let propertyType = self.parent.lookupType(for: typeAnnotation.type) else {
                    diagnoseUnsupportedType(node: typeAnnotation.type, type: typeAnnotation.type.trimmedDescription)
                    continue
                }

                // Check if property is readonly
                let isLet = node.bindingSpecifier.tokenKind == .keyword(.let)
                let isGetterOnly = node.bindings.contains(where: {
                    switch $0.accessorBlock?.accessors {
                    case .accessors(let accessors):
                        // Has accessors - check if it only has a getter (no setter, willSet, or didSet)
                        return !accessors.contains(where: { accessor in
                            let tokenKind = accessor.accessorSpecifier.tokenKind
                            return tokenKind == .keyword(.set) || tokenKind == .keyword(.willSet)
                                || tokenKind == .keyword(.didSet)
                        })
                    case .getter:
                        // Has only a getter block
                        return true
                    case nil:
                        // No accessor block - this is a stored property, not readonly
                        return false
                    }
                })
                let isReadonly = isLet || isGetterOnly

                let exportedProperty = ExportedProperty(
                    name: propertyName,
                    type: propertyType,
                    isReadonly: isReadonly
                )

                exportedClassByName[classKey]?.properties.append(exportedProperty)
            }

            return .skipChildren
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            let name = node.name.text

            guard let jsAttribute = node.attributes.firstJSAttribute else {
                return .skipChildren
            }

            let attributeNamespace = extractNamespace(from: jsAttribute)
            let computedNamespace = computeNamespace(for: node)

            if computedNamespace != nil && attributeNamespace != nil {
                diagnose(
                    node: jsAttribute,
                    message: "Nested classes cannot specify their own namespace",
                    hint: "Remove the namespace from @JS attribute - nested classes inherit namespace from parent"
                )
                return .skipChildren
            }

            let effectiveNamespace = computedNamespace ?? attributeNamespace

            let swiftCallName = ExportSwift.computeSwiftCallName(for: node, itemName: name)
            let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
                for: node,
                message: "Class visibility must be at least internal"
            )
            let exportedClass = ExportedClass(
                name: name,
                swiftCallName: swiftCallName,
                explicitAccessControl: explicitAccessControl,
                constructor: nil,
                methods: [],
                properties: [],
                namespace: effectiveNamespace
            )
            let uniqueKey = classKey(name: name, namespace: effectiveNamespace)

            stateStack.push(state: .classBody(name: name, key: uniqueKey))
            exportedClassByName[uniqueKey] = exportedClass
            exportedClassNames.append(uniqueKey)
            return .visitChildren
        }

        override func visitPost(_ node: ClassDeclSyntax) {
            // Make sure we pop the state stack only if we're in a class body state (meaning we successfully pushed)
            if case .classBody(_, _) = stateStack.current {
                stateStack.pop()
            }
        }

        override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else {
                return .skipChildren
            }

            guard let jsAttribute = node.attributes.firstJSAttribute else {
                return .skipChildren
            }

            let name = node.name.text

            let rawType: String? = node.inheritanceClause?.inheritedTypes.first { inheritedType in
                let typeName = inheritedType.type.trimmedDescription
                return Constants.supportedRawTypes.contains(typeName)
            }?.type.trimmedDescription

            let attributeNamespace = extractNamespace(from: jsAttribute)
            let computedNamespace = computeNamespace(for: node)

            if computedNamespace != nil && attributeNamespace != nil {
                diagnose(
                    node: jsAttribute,
                    message: "Nested enums cannot specify their own namespace",
                    hint: "Remove the namespace from @JS attribute - nested enums inherit namespace from parent"
                )
                return .skipChildren
            }

            currentEnum.name = name
            currentEnum.cases = []
            currentEnum.rawType = rawType

            stateStack.push(state: .enumBody(name: name))

            return .visitChildren
        }

        override func visitPost(_ node: EnumDeclSyntax) {
            guard let jsAttribute = node.attributes.firstJSAttribute,
                let enumName = currentEnum.name
            else {
                // Only pop if we have a valid enum that was processed
                if case .enumBody(_) = stateStack.current {
                    stateStack.pop()
                }
                return
            }

            let attributeNamespace = extractNamespace(from: jsAttribute)
            let computedNamespace = computeNamespace(for: node)

            let effectiveNamespace: [String]?
            if computedNamespace == nil && attributeNamespace != nil {
                effectiveNamespace = attributeNamespace
            } else {
                effectiveNamespace = computedNamespace
            }

            let emitStyle = extractEnumStyle(from: jsAttribute) ?? .const
            if case .tsEnum = emitStyle,
                let raw = currentEnum.rawType,
                let rawEnum = SwiftEnumRawType.from(raw), rawEnum == .bool
            {
                diagnose(
                    node: jsAttribute,
                    message: "TypeScript enum style is not supported for Bool raw-value enums",
                    hint: "Use enumStyle: .const or change the raw type to String or a numeric type"
                )
            }

            let swiftCallName = ExportSwift.computeSwiftCallName(for: node, itemName: enumName)
            let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
                for: node,
                message: "Enum visibility must be at least internal"
            )
            let exportedEnum = ExportedEnum(
                name: enumName,
                swiftCallName: swiftCallName,
                explicitAccessControl: explicitAccessControl,
                cases: currentEnum.cases,
                rawType: currentEnum.rawType,
                namespace: effectiveNamespace,
                emitStyle: emitStyle
            )
            exportedEnumByName[enumName] = exportedEnum
            exportedEnumNames.append(enumName)

            currentEnum = CurrentEnum()
            stateStack.pop()
        }

        override func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
            for element in node.elements {
                let caseName = element.name.text
                let rawValue: String?
                var associatedValues: [AssociatedValue] = []

                if currentEnum.rawType != nil {
                    if let stringLiteral = element.rawValue?.value.as(StringLiteralExprSyntax.self) {
                        rawValue = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
                    } else if let boolLiteral = element.rawValue?.value.as(BooleanLiteralExprSyntax.self) {
                        rawValue = boolLiteral.literal.text
                    } else if let intLiteral = element.rawValue?.value.as(IntegerLiteralExprSyntax.self) {
                        rawValue = intLiteral.literal.text
                    } else if let floatLiteral = element.rawValue?.value.as(FloatLiteralExprSyntax.self) {
                        rawValue = floatLiteral.literal.text
                    } else {
                        rawValue = nil
                    }
                } else {
                    rawValue = nil
                }
                if let parameterClause = element.parameterClause {
                    for param in parameterClause.parameters {
                        guard let bridgeType = parent.lookupType(for: param.type) else {
                            diagnose(
                                node: param.type,
                                message: "Unsupported associated value type: \(param.type.trimmedDescription)",
                                hint: "Only primitive types and types defined in the same module are allowed"
                            )
                            continue
                        }

                        let label = param.firstName?.text
                        associatedValues.append(AssociatedValue(label: label, type: bridgeType))
                    }
                }
                let enumCase = EnumCase(
                    name: caseName,
                    rawValue: rawValue,
                    associatedValues: associatedValues
                )

                currentEnum.cases.append(enumCase)
            }

            return .visitChildren
        }

        /// Computes namespace by walking up the AST hierarchy to find parent namespace enums
        /// If parent enum is a namespace enum (no cases) then it will be used as part of namespace for given node
        ///
        ///
        /// Method allows for explicit namespace for top level enum, it will be used as base namespace and will concat enum name
        private func computeNamespace(for node: some SyntaxProtocol) -> [String]? {
            var namespace: [String] = []
            var currentNode: Syntax? = node.parent

            while let parent = currentNode {
                if let enumDecl = parent.as(EnumDeclSyntax.self),
                    enumDecl.attributes.hasJSAttribute()
                {
                    let isNamespaceEnum = !enumDecl.memberBlock.members.contains { member in
                        member.decl.is(EnumCaseDeclSyntax.self)
                    }
                    if isNamespaceEnum {
                        namespace.insert(enumDecl.name.text, at: 0)

                        if let jsAttribute = enumDecl.attributes.firstJSAttribute,
                            let explicitNamespace = extractNamespace(from: jsAttribute)
                        {
                            namespace = explicitNamespace + namespace
                            break
                        }
                    }
                }
                currentNode = parent.parent
            }

            return namespace.isEmpty ? nil : namespace
        }

        /// Requires the node to have at least internal access control.
        private func computeExplicitAtLeastInternalAccessControl(
            for node: some WithModifiersSyntax,
            message: String
        ) -> String? {
            guard let accessControl = node.explicitAccessControl else {
                return nil
            }
            guard accessControl.isAtLeastInternal else {
                diagnose(
                    node: accessControl,
                    message: message,
                    hint: "Use `internal`, `package` or `public` access control"
                )
                return nil
            }
            return accessControl.name.text
        }
    }

    func parseSingleFile(_ sourceFile: SourceFileSyntax) throws -> [DiagnosticError] {
        let collector = APICollector(parent: self)
        collector.walk(sourceFile)
        exportedFunctions.append(contentsOf: collector.exportedFunctions)
        exportedClasses.append(
            contentsOf: collector.exportedClassNames.map {
                collector.exportedClassByName[$0]!
            }
        )
        exportedEnums.append(
            contentsOf: collector.exportedEnumNames.map {
                collector.exportedEnumByName[$0]!
            }
        )
        return collector.errors
    }

    /// Computes the full Swift call name by walking up the AST hierarchy to find all parent enums
    /// This generates the qualified name needed for Swift code generation (e.g., "Networking.API.HTTPServer")
    private static func computeSwiftCallName(for node: some SyntaxProtocol, itemName: String) -> String {
        var swiftPath: [String] = []
        var currentNode: Syntax? = node.parent

        while let parent = currentNode {
            if let enumDecl = parent.as(EnumDeclSyntax.self),
                enumDecl.attributes.hasJSAttribute()
            {
                swiftPath.insert(enumDecl.name.text, at: 0)
            }
            currentNode = parent.parent
        }

        if swiftPath.isEmpty {
            return itemName
        } else {
            return swiftPath.joined(separator: ".") + "." + itemName
        }
    }

    func lookupType(for type: TypeSyntax) -> BridgeType? {
        if let primitive = BridgeType(swiftType: type.trimmedDescription) {
            return primitive
        }

        guard let typeDecl = typeDeclResolver.resolve(type) else {
            return nil
        }

        if let enumDecl = typeDecl.as(EnumDeclSyntax.self) {
            let swiftCallName = ExportSwift.computeSwiftCallName(for: enumDecl, itemName: enumDecl.name.text)
            let rawTypeString = enumDecl.inheritanceClause?.inheritedTypes.first { inheritedType in
                let typeName = inheritedType.type.trimmedDescription
                return Constants.supportedRawTypes.contains(typeName)
            }?.type.trimmedDescription

            if let rawTypeString, let rawType = SwiftEnumRawType.from(rawTypeString) {
                return .rawValueEnum(swiftCallName, rawType)
            } else {
                let hasAnyCases = enumDecl.memberBlock.members.contains { member in
                    member.decl.is(EnumCaseDeclSyntax.self)
                }
                if !hasAnyCases {
                    return .namespaceEnum(swiftCallName)
                }
                let hasAssociatedValues =
                    enumDecl.memberBlock.members.contains { member in
                        guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { return false }
                        return caseDecl.elements.contains { element in
                            if let params = element.parameterClause?.parameters {
                                return !params.isEmpty
                            }
                            return false
                        }
                    }
                if hasAssociatedValues {
                    return .associatedValueEnum(swiftCallName)
                } else {
                    return .caseEnum(swiftCallName)
                }
            }
        }

        guard typeDecl.is(ClassDeclSyntax.self) || typeDecl.is(ActorDeclSyntax.self) else {
            return nil
        }
        let swiftCallName = ExportSwift.computeSwiftCallName(for: typeDecl, itemName: typeDecl.name.text)
        return .swiftHeapObject(swiftCallName)
    }

    static let prelude: DeclSyntax = """
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) import JavaScriptKit
        """

    func renderSwiftGlue() throws -> String? {
        var decls: [DeclSyntax] = []
        guard exportedFunctions.count > 0 || exportedClasses.count > 0 || exportedEnums.count > 0 else {
            return nil
        }
        decls.append(Self.prelude)

        for enumDef in exportedEnums {
            if enumDef.enumType == .simple {
                decls.append(renderCaseEnumHelpers(enumDef))
            } else {
                decls.append("extension \(raw: enumDef.swiftCallName): _BridgedSwiftEnumNoPayload {}")
            }
        }

        for function in exportedFunctions {
            decls.append(try renderSingleExportedFunction(function: function))
        }
        for klass in exportedClasses {
            decls.append(contentsOf: try renderSingleExportedClass(klass: klass))
        }
        let format = BasicFormat()
        return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
    }

    func renderCaseEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        var initCases: [String] = []
        var valueCases: [String] = []
        for (index, c) in enumDef.cases.enumerated() {
            initCases.append("case \(index): self = .\(c.name)")
            valueCases.append("case .\(c.name): return \(index)")
        }
        let initSwitch = (["switch bridgeJSRawValue {"] + initCases + ["default: return nil", "}"]).joined(
            separator: "\n"
        )
        let valueSwitch = (["switch self {"] + valueCases + ["}"]).joined(separator: "\n")

        return """
            extension \(raw: typeName) {
                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
                    return bridgeJSRawValue
                }
                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> \(raw: typeName) {
                    return \(raw: typeName)(bridgeJSRawValue: value)!
                }
                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> \(raw: typeName) {
                    return \(raw: typeName)(bridgeJSRawValue: value)!
                }
                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
                    return bridgeJSRawValue
                }

                private init?(bridgeJSRawValue: Int32) {
                    \(raw: initSwitch)
                }

                private var bridgeJSRawValue: Int32 {
                    \(raw: valueSwitch)
                }
            }
            """
    }

    class ExportedThunkBuilder {
        var body: [CodeBlockItemSyntax] = []
        var liftedParameterExprs: [ExprSyntax] = []
        var parameters: [Parameter] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?
        let effects: Effects

        init(effects: Effects) {
            self.effects = effects
        }

        private func append(_ item: CodeBlockItemSyntax) {
            var item = item
            // Add a newline for items after the first one
            if !self.body.isEmpty {
                item = item.with(\.leadingTrivia, .newline)
            }
            self.body.append(item)
        }

        func liftParameter(param: Parameter) throws {
            parameters.append(param)
            let liftingInfo = try param.type.liftParameterInfo()
            let argumentsToLift: [String]
            if liftingInfo.parameters.count == 1 {
                argumentsToLift = [param.name]
            } else {
                argumentsToLift = liftingInfo.parameters.map { (name, _) in param.name + name.capitalizedFirstLetter }
            }
            liftedParameterExprs.append(
                ExprSyntax(
                    "\(raw: param.type.swiftType).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                )
            )
            for (name, type) in zip(argumentsToLift, liftingInfo.parameters.map { $0.type }) {
                abiParameterSignatures.append((name, type))
            }
        }

        private func removeFirstLiftedParameter() -> (parameter: Parameter, expr: ExprSyntax) {
            let parameter = parameters.removeFirst()
            let expr = liftedParameterExprs.removeFirst()
            return (parameter, expr)
        }

        private func renderCallStatement(callee: ExprSyntax, returnType: BridgeType) -> CodeBlockItemSyntax {
            let labeledParams = zip(parameters, liftedParameterExprs).map { param, expr in
                LabeledExprSyntax(label: param.label, expression: expr)
            }
            var callExpr: ExprSyntax =
                "\(raw: callee)(\(raw: labeledParams.map { $0.description }.joined(separator: ", ")))"
            if effects.isAsync {
                callExpr = ExprSyntax(
                    AwaitExprSyntax(awaitKeyword: .keyword(.await).with(\.trailingTrivia, .space), expression: callExpr)
                )
            }
            if effects.isThrows {
                callExpr = ExprSyntax(
                    TryExprSyntax(
                        tryKeyword: .keyword(.try).with(\.trailingTrivia, .space),
                        expression: callExpr
                    )
                )
            }

            if effects.isAsync, returnType != .void {
                return CodeBlockItemSyntax(item: .init(StmtSyntax("return \(raw: callExpr).jsValue")))
            }

            if returnType == .void {
                return CodeBlockItemSyntax(item: .init(ExpressionStmtSyntax(expression: callExpr)))
            } else {
                return CodeBlockItemSyntax(item: .init(DeclSyntax("let ret = \(raw: callExpr)")))
            }
        }

        func call(name: String, returnType: BridgeType) {
            let item = renderCallStatement(callee: "\(raw: name)", returnType: returnType)
            append(item)
        }

        func callMethod(klassName: String, methodName: String, returnType: BridgeType) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            let item = renderCallStatement(
                callee: "\(raw: selfExpr).\(raw: methodName)",
                returnType: returnType
            )
            append(item)
        }

        func callPropertyGetter(klassName: String, propertyName: String, returnType: BridgeType) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            if returnType == .void {
                append("\(raw: selfExpr).\(raw: propertyName)")
            } else {
                append("let ret = \(raw: selfExpr).\(raw: propertyName)")
            }
        }

        func callPropertySetter(klassName: String, propertyName: String) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            let (_, newValueExpr) = removeFirstLiftedParameter()
            append("\(raw: selfExpr).\(raw: propertyName) = \(raw: newValueExpr)")
        }

        func lowerReturnValue(returnType: BridgeType) throws {
            if effects.isAsync {
                // Async functions always return a Promise, which is a JSObject
                try _lowerReturnValue(returnType: .jsObject(nil))
            } else {
                try _lowerReturnValue(returnType: returnType)
            }
        }

        private func _lowerReturnValue(returnType: BridgeType) throws {
            let loweringInfo = try returnType.loweringReturnInfo()
            abiReturnType = loweringInfo.returnType
            if returnType == .void {
                return
            }
            if effects.isAsync {
                // The return value of async function (T of `(...) async -> T`) is
                // handled by the JSPromise.async, so we don't need to do anything here.
                return
            }

            append("return ret.bridgeJSLowerReturn()")
        }

        func render(abiName: String) -> DeclSyntax {
            let body: CodeBlockItemListSyntax
            if effects.isAsync {
                body = """
                        let ret = JSPromise.async {
                            \(CodeBlockItemListSyntax(self.body))
                        }.jsObject
                        return ret.bridgeJSLowerReturn()
                    """
            } else if effects.isThrows {
                body = """
                    do {
                        \(CodeBlockItemListSyntax(self.body))
                    } catch let error {
                        if let error = error.thrownValue.object {
                            withExtendedLifetime(error) {
                                _swift_js_throw(Int32(bitPattern: $0.id))
                            }
                        } else {
                            let jsError = JSError(message: String(describing: error))
                            withExtendedLifetime(jsError.jsObject) {
                                _swift_js_throw(Int32(bitPattern: $0.id))
                            }
                        }
                        \(raw: returnPlaceholderStmt())
                    }
                    """
            } else {
                body = CodeBlockItemListSyntax(self.body)
            }
            return """
                @_expose(wasm, "\(raw: abiName)")
                @_cdecl("\(raw: abiName)")
                public func _\(raw: abiName)(\(raw: parameterSignature())) -> \(raw: returnSignature()) {
                    #if arch(wasm32)
                \(body)
                    #else
                    fatalError("Only available on WebAssembly")
                    #endif
                }
                """
        }

        private func returnPlaceholderStmt() -> String {
            switch abiReturnType {
            case .i32: return "return 0"
            case .i64: return "return 0"
            case .f32: return "return 0.0"
            case .f64: return "return 0.0"
            case .pointer: return "return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped"
            case .none: return "return"
            }
        }

        func parameterSignature() -> String {
            var nameAndType: [(name: String, abiType: String)] = []
            for (name, type) in abiParameterSignatures {
                nameAndType.append((name, type.swiftType))
            }
            return nameAndType.map { "\($0.name): \($0.abiType)" }.joined(separator: ", ")
        }

        func returnSignature() -> String {
            return abiReturnType?.swiftType ?? "Void"
        }
    }

    func renderSingleExportedFunction(function: ExportedFunction) throws -> DeclSyntax {
        let builder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try builder.liftParameter(param: param)
        }
        builder.call(name: function.name, returnType: function.returnType)
        try builder.lowerReturnValue(returnType: function.returnType)
        return builder.render(abiName: function.abiName)
    }

    /// # Example
    ///
    /// Given the following Swift code:
    ///
    /// ```swift
    /// @JS class Greeter {
    ///     var name: String
    ///
    ///     @JS init(name: String) {
    ///         self.name = name
    ///     }
    ///
    ///     @JS func greet() -> String {
    ///         return "Hello, \(name)!"
    ///     }
    /// }
    /// ```
    ///
    /// The following Swift glue code will be generated:
    ///
    /// ```swift
    /// @_expose(wasm, "bjs_Greeter_init")
    /// @_cdecl("bjs_Greeter_init")
    /// public func _bjs_Greeter_init(nameBytes: Int32, nameLen: Int32) -> UnsafeMutableRawPointer {
    ///     let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
    ///         _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
    ///         return Int(nameLen)
    ///     }
    ///     let ret = Greeter(name: name)
    ///     return Unmanaged.passRetained(ret).toOpaque()
    /// }
    ///
    /// @_expose(wasm, "bjs_Greeter_greet")
    /// @_cdecl("bjs_Greeter_greet")
    /// public func _bjs_Greeter_greet(pointer: UnsafeMutableRawPointer) -> Void {
    ///     let _self = Unmanaged<Greeter>.fromOpaque(pointer).takeUnretainedValue()
    ///     var ret = _self.greet()
    ///     return ret.withUTF8 { ptr in
    ///         _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    ///     }
    /// }
    /// @_expose(wasm, "bjs_Greeter_deinit")
    /// @_cdecl("bjs_Greeter_deinit")
    /// public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    ///     Unmanaged<Greeter>.fromOpaque(pointer).release()
    /// }
    /// ```
    func renderSingleExportedClass(klass: ExportedClass) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        if let constructor = klass.constructor {
            let builder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                try builder.liftParameter(param: param)
            }
            builder.call(name: klass.swiftCallName, returnType: BridgeType.swiftHeapObject(klass.name))
            try builder.lowerReturnValue(returnType: BridgeType.swiftHeapObject(klass.name))
            decls.append(builder.render(abiName: constructor.abiName))
        }
        for method in klass.methods {
            let builder = ExportedThunkBuilder(effects: method.effects)
            try builder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: BridgeType.swiftHeapObject(klass.swiftCallName))
            )
            for param in method.parameters {
                try builder.liftParameter(param: param)
            }
            builder.callMethod(
                klassName: klass.swiftCallName,
                methodName: method.name,
                returnType: method.returnType
            )
            try builder.lowerReturnValue(returnType: method.returnType)
            decls.append(builder.render(abiName: method.abiName))
        }

        // Generate property getters and setters
        for property in klass.properties {
            // Generate getter
            let getterBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
            try getterBuilder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(klass.name))
            )
            getterBuilder.callPropertyGetter(
                klassName: klass.name,
                propertyName: property.name,
                returnType: property.type
            )
            try getterBuilder.lowerReturnValue(returnType: property.type)
            decls.append(getterBuilder.render(abiName: property.getterAbiName(className: klass.name)))

            // Generate setter if property is not readonly
            if !property.isReadonly {
                let setterBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                try setterBuilder.liftParameter(
                    param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(klass.name))
                )
                try setterBuilder.liftParameter(
                    param: Parameter(label: "value", name: "value", type: property.type)
                )
                setterBuilder.callPropertySetter(
                    klassName: klass.name,
                    propertyName: property.name
                )
                try setterBuilder.lowerReturnValue(returnType: .void)
                decls.append(setterBuilder.render(abiName: property.setterAbiName(className: klass.name)))
            }
        }

        do {
            decls.append(
                """
                @_expose(wasm, "bjs_\(raw: klass.name)_deinit")
                @_cdecl("bjs_\(raw: klass.name)_deinit")
                public func _bjs_\(raw: klass.name)_deinit(pointer: UnsafeMutableRawPointer) {
                    Unmanaged<\(raw: klass.swiftCallName)>.fromOpaque(pointer).release()
                }
                """
            )
        }

        // Generate ConvertibleToJSValue extension
        decls.append(renderConvertibleToJSValueExtension(klass: klass))

        return decls
    }

    /// Generates a ConvertibleToJSValue extension for the exported class
    ///
    /// # Example
    ///
    /// For a class named `Greeter`, this generates:
    ///
    /// ```swift
    /// extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    ///     var jsValue: JSValue {
    ///         @_extern(wasm, module: "MyModule", name: "bjs_Greeter_wrap")
    ///         func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
    ///         return JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque())))
    ///     }
    /// }
    /// ```
    func renderConvertibleToJSValueExtension(klass: ExportedClass) -> DeclSyntax {
        let wrapFunctionName = "_bjs_\(klass.name)_wrap"
        let externFunctionName = "bjs_\(klass.name)_wrap"

        // If the class has an explicit access control, we need to add it to the extension declaration.
        let accessControl = klass.explicitAccessControl.map { "\($0) " } ?? ""
        return """
            extension \(raw: klass.swiftCallName): ConvertibleToJSValue, _BridgedSwiftHeapObject {
                \(raw: accessControl)var jsValue: JSValue {
                    #if arch(wasm32)
                    @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: externFunctionName)")
                    func \(raw: wrapFunctionName)(_: UnsafeMutableRawPointer) -> Int32
                    #else
                    func \(raw: wrapFunctionName)(_: UnsafeMutableRawPointer) -> Int32 {
                        fatalError("Only available on WebAssembly")
                    }
                    #endif
                    return .object(JSObject(id: UInt32(bitPattern: \(raw: wrapFunctionName)(Unmanaged.passRetained(self).toOpaque()))))
                }
            }
            """
    }
}

fileprivate enum Constants {
    static let supportedRawTypes = SwiftEnumRawType.allCases.map { $0.rawValue }
}

extension AttributeListSyntax {
    fileprivate func hasJSAttribute() -> Bool {
        firstJSAttribute != nil
    }

    fileprivate var firstJSAttribute: AttributeSyntax? {
        first(where: {
            $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JS"
        })?.as(AttributeSyntax.self)
    }
}

extension BridgeType {
    init?(swiftType: String) {
        switch swiftType {
        case "Int":
            self = .int
        case "Float":
            self = .float
        case "Double":
            self = .double
        case "String":
            self = .string
        case "Bool":
            self = .bool
        case "Void":
            self = .void
        case "JSObject":
            self = .jsObject(nil)
        default:
            return nil
        }
    }
}

extension WasmCoreType {
    var swiftType: String {
        switch self {
        case .i32: return "Int32"
        case .i64: return "Int64"
        case .f32: return "Float32"
        case .f64: return "Float64"
        case .pointer: return "UnsafeMutableRawPointer"
        }
    }
}

extension BridgeType {
    var swiftType: String {
        switch self {
        case .bool: return "Bool"
        case .int: return "Int"
        case .float: return "Float"
        case .double: return "Double"
        case .string: return "String"
        case .jsObject(nil): return "JSObject"
        case .jsObject(let name?): return name
        case .swiftHeapObject(let name): return name
        case .void: return "Void"
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .namespaceEnum(let name): return name
        }
    }

    struct LiftingIntrinsicInfo: Sendable {
        let parameters: [(name: String, type: WasmCoreType)]

        static let bool = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let int = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let float = LiftingIntrinsicInfo(parameters: [("value", .f32)])
        static let double = LiftingIntrinsicInfo(parameters: [("value", .f64)])
        static let string = LiftingIntrinsicInfo(parameters: [("bytes", .i32), ("length", .i32)])
        static let jsObject = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let swiftHeapObject = LiftingIntrinsicInfo(parameters: [("value", .pointer)])
        static let void = LiftingIntrinsicInfo(parameters: [])
        static let caseEnum = LiftingIntrinsicInfo(parameters: [("value", .i32)])
    }

    func liftParameterInfo() throws -> LiftingIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .void: return .void
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .bool: return .bool
            case .int: return .int
            case .float: return .float
            case .double: return .double
            case .string: return .string
            case .int32: return .int
            case .int64: return .int
            case .uint: return .int
            case .uint32: return .int
            case .uint64: return .int
            }
        case .associatedValueEnum:
            throw BridgeJSCoreError("Associated value enums are not supported to pass as parameters")
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
        }
    }

    struct LoweringIntrinsicInfo: Sendable {
        let returnType: WasmCoreType?

        static let bool = LoweringIntrinsicInfo(returnType: .i32)
        static let int = LoweringIntrinsicInfo(returnType: .i32)
        static let float = LoweringIntrinsicInfo(returnType: .f32)
        static let double = LoweringIntrinsicInfo(returnType: .f64)
        static let string = LoweringIntrinsicInfo(returnType: nil)
        static let jsObject = LoweringIntrinsicInfo(returnType: .i32)
        static let swiftHeapObject = LoweringIntrinsicInfo(returnType: .pointer)
        static let void = LoweringIntrinsicInfo(returnType: nil)
        static let caseEnum = LoweringIntrinsicInfo(returnType: .i32)
        static let rawValueEnum = LoweringIntrinsicInfo(returnType: .i32)
    }

    func loweringReturnInfo() throws -> LoweringIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .void: return .void
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .bool: return .bool
            case .int: return .int
            case .float: return .float
            case .double: return .double
            case .string: return .string
            case .int32: return .int
            case .int64: return .int
            case .uint: return .int
            case .uint32: return .int
            case .uint64: return .int
            }
        case .associatedValueEnum:
            throw BridgeJSCoreError("Associated value enums are not supported to pass as parameters")
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
        }
    }
}

extension DeclModifierSyntax {
    var isAccessControl: Bool {
        switch self.name.tokenKind {
        case .keyword(.private),
            .keyword(.fileprivate),
            .keyword(.internal),
            .keyword(.package),
            .keyword(.public),
            .keyword(.open):
            return true
        default:
            return false
        }
    }

    var isAtLeastInternal: Bool {
        switch self.name.tokenKind {
        case .keyword(.private): false
        case .keyword(.fileprivate): false
        case .keyword(.internal): true
        case .keyword(.package): true
        case .keyword(.public): true
        case .keyword(.open): true
        default: false
        }
    }

    var isAtLeastPackage: Bool {
        switch self.name.tokenKind {
        case .keyword(.private): false
        case .keyword(.fileprivate): false
        case .keyword(.internal): true
        case .keyword(.package): true
        case .keyword(.public): true
        case .keyword(.open): true
        default: false
        }
    }
}

extension WithModifiersSyntax {
    var explicitAccessControl: DeclModifierSyntax? {
        return self.modifiers.first { modifier in
            modifier.isAccessControl
        }
    }
}
