import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
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
        guard let outputSwift = renderSwiftGlue() else {
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
            let exportedClass = ExportedClass(
                name: name,
                swiftCallName: swiftCallName,
                constructor: nil,
                methods: [],
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

            if currentEnum.cases.contains(where: { !$0.associatedValues.isEmpty }) {
                for c in currentEnum.cases {
                    for associatedValue in c.associatedValues {
                        switch associatedValue.type {
                        case .string, .int, .float, .double, .bool:
                            break
                        default:
                            diagnose(
                                node: node,
                                message: "Unsupported associated value type: \(associatedValue.type.swiftType)",
                                hint:
                                    "Only primitive types (String, Int, Float, Double, Bool) are supported in associated-value enums"
                            )
                        }
                    }
                }
            }

            let swiftCallName = ExportSwift.computeSwiftCallName(for: node, itemName: enumName)
            let exportedEnum = ExportedEnum(
                name: enumName,
                swiftCallName: swiftCallName,
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
        guard let identifier = type.as(IdentifierTypeSyntax.self) else {
            return nil
        }

        guard let typeDecl = typeDeclResolver.lookupType(for: identifier) else {
            return nil
        }
        if let enumDecl = typeDecl.as(EnumDeclSyntax.self) {
            let enumName = enumDecl.name.text
            if let existingEnum = exportedEnums.first(where: { $0.name == enumName }) {
                switch existingEnum.enumType {
                case .simple:
                    return .caseEnum(existingEnum.swiftCallName)
                case .rawValue:
                    let rawType = SwiftEnumRawType.from(existingEnum.rawType!)!
                    return .rawValueEnum(existingEnum.swiftCallName, rawType)
                case .associatedValue:
                    return .associatedValueEnum(existingEnum.swiftCallName)
                case .namespace:
                    return .namespaceEnum(existingEnum.swiftCallName)
                }
            }
            let swiftCallName = ExportSwift.computeSwiftCallName(for: enumDecl, itemName: enumDecl.name.text)
            let rawTypeString = enumDecl.inheritanceClause?.inheritedTypes.first { inheritedType in
                let typeName = inheritedType.type.trimmedDescription
                return Constants.supportedRawTypes.contains(typeName)
            }?.type.trimmedDescription

            if let rawTypeString = rawTypeString,
                let rawType = SwiftEnumRawType.from(rawTypeString)
            {
                return .rawValueEnum(swiftCallName, rawType)
            } else {
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
        return .swiftHeapObject(typeDecl.name.text)
    }

    static let prelude: DeclSyntax = """
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) import JavaScriptKit
        """

    func renderSwiftGlue() -> String? {
        var decls: [DeclSyntax] = []
        guard exportedFunctions.count > 0 || exportedClasses.count > 0 || exportedEnums.count > 0 else {
            return nil
        }
        decls.append(Self.prelude)

        for enumDef in exportedEnums where enumDef.enumType == .simple {
            decls.append(renderCaseEnumHelpers(enumDef))
        }

        for enumDef in exportedEnums where enumDef.enumType == .associatedValue {
            decls.append(renderAssociatedValueEnumHelpers(enumDef))
        }

        for function in exportedFunctions {
            decls.append(renderSingleExportedFunction(function: function))
        }
        for klass in exportedClasses {
            decls.append(contentsOf: renderSingleExportedClass(klass: klass))
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
                init?(bridgeJSRawValue: Int32) {
                    \(raw: initSwitch)
                }

                var bridgeJSRawValue: Int32 {
                    \(raw: valueSwitch)
                }
            }
            """
    }

    class ExportedThunkBuilder {
        var body: [CodeBlockItemSyntax] = []
        var abiParameterForwardings: [LabeledExprSyntax] = []
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

        func liftParameter(param: Parameter) {
            switch param.type {
            case .bool:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name) == 1")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .int:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.type.swiftType)(\(raw: param.name))")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .float:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .f32))
            case .double:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .f64))
            case .string:
                let bytesLabel = "\(param.name)Bytes"
                let lengthLabel = "\(param.name)Len"
                let prepare: CodeBlockItemSyntax = """
                    let \(raw: param.name) = String(unsafeUninitializedCapacity: Int(\(raw: lengthLabel))) { b in
                        _swift_js_init_memory(\(raw: bytesLabel), b.baseAddress.unsafelyUnwrapped)
                        return Int(\(raw: lengthLabel))
                    }
                    """
                append(prepare)
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((bytesLabel, .i32))
                abiParameterSignatures.append((lengthLabel, .i32))
            case .caseEnum(let enumName):
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: enumName)(bridgeJSRawValue: \(raw: param.name))!")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .rawValueEnum(let enumName, let rawType):
                if rawType == .string {
                    let bytesLabel = "\(param.name)Bytes"
                    let lengthLabel = "\(param.name)Len"
                    let prepare: CodeBlockItemSyntax = """
                        let \(raw: param.name) = String(unsafeUninitializedCapacity: Int(\(raw: lengthLabel))) { b in
                            _swift_js_init_memory(\(raw: bytesLabel), b.baseAddress.unsafelyUnwrapped)
                            return Int(\(raw: lengthLabel))
                        }
                        """
                    append(prepare)
                    abiParameterForwardings.append(
                        LabeledExprSyntax(
                            label: param.label,
                            expression: ExprSyntax("\(raw: enumName)(rawValue: \(raw: param.name))!")
                        )
                    )
                    abiParameterSignatures.append((bytesLabel, .i32))
                    abiParameterSignatures.append((lengthLabel, .i32))
                } else {
                    let conversionExpr: String
                    switch rawType {
                    case .bool:
                        conversionExpr = "\(enumName)(rawValue: \(param.name) != 0)!"
                    case .uint, .uint32, .uint64:
                        if rawType == .uint64 {
                            conversionExpr =
                                "\(enumName)(rawValue: \(rawType.rawValue)(bitPattern: Int64(\(param.name))))!"
                        } else {
                            conversionExpr = "\(enumName)(rawValue: \(rawType.rawValue)(bitPattern: \(param.name)))!"
                        }
                    default:
                        conversionExpr = "\(enumName)(rawValue: \(rawType.rawValue)(\(param.name)))!"
                    }

                    abiParameterForwardings.append(
                        LabeledExprSyntax(
                            label: param.label,
                            expression: ExprSyntax(stringLiteral: conversionExpr)
                        )
                    )
                    if let wasmType = rawType.wasmCoreType {
                        abiParameterSignatures.append((param.name, wasmType))
                    }
                }
            case .associatedValueEnum(let enumName):
                let enumBaseName = enumName.components(separatedBy: ".").last ?? enumName
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax(
                            "\(raw: enumBaseName).dispatchConstruct(\(raw: param.name)CaseId, \(raw: param.name)ParamsId, \(raw: param.name)ParamsLen)"
                        )
                    )
                )
                abiParameterSignatures.append(("\(param.name)CaseId", .i32))
                abiParameterSignatures.append(("\(param.name)ParamsId", .i32))
                abiParameterSignatures.append(("\(param.name)ParamsLen", .i32))
            case .namespaceEnum:
                break
            case .jsObject(nil):
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("JSObject(id: UInt32(bitPattern: \(raw: param.name)))")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .jsObject(let name):
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: name)(takingThis: UInt32(bitPattern: \(raw: param.name)))")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .swiftHeapObject:
                let objectExpr: ExprSyntax =
                    "Unmanaged<\(raw: param.type.swiftType)>.fromOpaque(\(raw: param.name)).takeUnretainedValue()"
                abiParameterForwardings.append(
                    LabeledExprSyntax(label: param.label, expression: objectExpr)
                )
                abiParameterSignatures.append((param.name, .pointer))
            case .void:
                break
            }
        }

        private func renderCallStatement(callee: ExprSyntax, returnType: BridgeType) -> CodeBlockItemSyntax {
            var callExpr: ExprSyntax =
                "\(raw: callee)(\(raw: abiParameterForwardings.map { $0.description }.joined(separator: ", ")))"
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

            let retMutability: String
            if returnType == .string {
                retMutability = "var"
            } else {
                retMutability = "let"
            }
            if returnType == .void {
                return CodeBlockItemSyntax(item: .init(ExpressionStmtSyntax(expression: callExpr)))
            } else {
                return CodeBlockItemSyntax(item: .init(DeclSyntax("\(raw: retMutability) ret = \(raw: callExpr)")))
            }
        }

        func call(name: String, returnType: BridgeType) {
            let item = renderCallStatement(callee: "\(raw: name)", returnType: returnType)
            append(item)
        }

        func callMethod(klassName: String, methodName: String, returnType: BridgeType) {
            let _selfParam = self.abiParameterForwardings.removeFirst()
            let item = renderCallStatement(
                callee: "\(raw: _selfParam).\(raw: methodName)",
                returnType: returnType
            )
            append(item)
        }

        func lowerReturnValue(returnType: BridgeType) {
            if effects.isAsync {
                // Async functions always return a Promise, which is a JSObject
                _lowerReturnValue(returnType: .jsObject(nil))
            } else {
                _lowerReturnValue(returnType: returnType)
            }
        }

        private func _lowerReturnValue(returnType: BridgeType) {
            switch returnType {
            case .void:
                abiReturnType = nil
            case .bool:
                abiReturnType = .i32
            case .int:
                abiReturnType = .i32
            case .float:
                abiReturnType = .f32
            case .double:
                abiReturnType = .f64
            case .string:
                abiReturnType = nil
            case .jsObject:
                abiReturnType = .i32
            case .swiftHeapObject:
                // UnsafeMutableRawPointer is returned as an i32 pointer
                abiReturnType = .pointer
            case .caseEnum:
                abiReturnType = .i32
            case .rawValueEnum(_, let rawType):
                abiReturnType = rawType == .string ? nil : rawType.wasmCoreType
            case .associatedValueEnum:
                abiReturnType = nil
            case .namespaceEnum:
                abiReturnType = nil
            }

            if effects.isAsync {
                // The return value of async function (T of `(...) async -> T`) is
                // handled by the JSPromise.async, so we don't need to do anything here.
                return
            }

            switch returnType {
            case .void: break
            case .int, .float, .double:
                append("return \(raw: abiReturnType!.swiftType)(ret)")
            case .bool:
                append("return Int32(ret ? 1 : 0)")
            case .string:
                append(
                    """
                    return ret.withUTF8 { ptr in
                        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
                    }
                    """
                )
            case .caseEnum:
                abiReturnType = .i32
                append("return ret.bridgeJSRawValue")
            case .rawValueEnum(_, let rawType):
                if rawType == .string {
                    append(
                        """
                        var rawValue = ret.rawValue
                        return rawValue.withUTF8 { ptr in
                            _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
                        }
                        """
                    )
                } else {
                    switch rawType {
                    case .bool:
                        append("return Int32(ret.rawValue ? 1 : 0)")
                    case .int, .int32, .uint, .uint32:
                        append("return Int32(ret.rawValue)")
                    case .int64, .uint64:
                        append("return Int64(ret.rawValue)")
                    case .float:
                        append("return Float32(ret.rawValue)")
                    case .double:
                        append("return Float64(ret.rawValue)")
                    default:
                        append("return Int32(ret.rawValue)")
                    }
                }
            case .associatedValueEnum:
                append("ret.bridgeJSReturn()")
            case .namespaceEnum: break
            case .jsObject(nil):
                append(
                    """
                    return _swift_js_retain(Int32(bitPattern: ret.id))
                    """
                )
            case .jsObject(_?):
                append(
                    """
                    return _swift_js_retain(Int32(bitPattern: ret.this.id))
                    """
                )
            case .swiftHeapObject:
                // Perform a manual retain on the object, which will be balanced by a
                // release called via FinalizationRegistry
                append(
                    """
                    return Unmanaged.passRetained(ret).toOpaque()
                    """
                )
            }
        }

        func render(abiName: String) -> DeclSyntax {
            let body: CodeBlockItemListSyntax
            if effects.isAsync {
                body = """
                        let ret = JSPromise.async {
                            \(CodeBlockItemListSyntax(self.body))
                        }.jsObject
                        return _swift_js_retain(Int32(bitPattern: ret.id))
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

    func renderSingleExportedFunction(function: ExportedFunction) -> DeclSyntax {
        let builder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            builder.liftParameter(param: param)
        }
        builder.call(name: function.name, returnType: function.returnType)
        builder.lowerReturnValue(returnType: function.returnType)
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
    func renderSingleExportedClass(klass: ExportedClass) -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        if let constructor = klass.constructor {
            let builder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                builder.liftParameter(param: param)
            }
            builder.call(name: klass.swiftCallName, returnType: BridgeType.swiftHeapObject(klass.name))
            builder.lowerReturnValue(returnType: BridgeType.swiftHeapObject(klass.name))
            decls.append(builder.render(abiName: constructor.abiName))
        }
        for method in klass.methods {
            let builder = ExportedThunkBuilder(effects: method.effects)
            builder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: BridgeType.swiftHeapObject(klass.swiftCallName))
            )
            for param in method.parameters {
                builder.liftParameter(param: param)
            }
            builder.callMethod(
                klassName: klass.swiftCallName,
                methodName: method.name,
                returnType: method.returnType
            )
            builder.lowerReturnValue(returnType: method.returnType)
            decls.append(builder.render(abiName: method.abiName))
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
    /// extension Greeter: ConvertibleToJSValue {
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

        return """
            extension \(raw: klass.swiftCallName): ConvertibleToJSValue {
                var jsValue: JSValue {
                    @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: externFunctionName)")
                    func \(raw: wrapFunctionName)(_: UnsafeMutableRawPointer) -> Int32
                    return .object(JSObject(id: UInt32(bitPattern: \(raw: wrapFunctionName)(Unmanaged.passRetained(self).toOpaque()))))
                }
            }
            """
    }

    // MARK: - Variable ABI Associated Value Enum Generation

    static func renderVariableABIAssociatedValueEnum(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        var returnCases: [String] = []

        for (i, c) in enumDef.cases.enumerated() {
            let caseName = c.name
            let caseIndex = i

            if c.associatedValues.isEmpty {
                returnCases.append(
                    """
                    case .\(caseName):
                        _swift_js_return_tag(Int32(\(caseIndex)))
                    """
                )
            } else {
                let returnCase = generateReturnCase(
                    caseName: caseName,
                    caseIndex: caseIndex,
                    associatedValues: c.associatedValues
                )
                returnCases.append(returnCase)
            }
        }

        let returnSwitch = (["switch self {"] + returnCases + ["}"]).joined(separator: "\n        ")

        let enumBaseName = typeName.components(separatedBy: ".").last ?? typeName
        return """
            import Foundation

            extension \(raw: typeName) {
                func bridgeJSReturn() {
                    @_extern(wasm, module: "bjs", name: "swift_js_return_tag")
                    func _swift_js_return_tag(_: Int32)
                    @_extern(wasm, module: "bjs", name: "swift_js_return_string")
                    func _swift_js_return_string(_: UnsafePointer<UInt8>?, _: Int32)
                    @_extern(wasm, module: "bjs", name: "swift_js_return_int")
                    func _swift_js_return_int(_: Int32)
                    @_extern(wasm, module: "bjs", name: "swift_js_return_f32")
                    func _swift_js_return_f32(_: Float32)
                    @_extern(wasm, module: "bjs", name: "swift_js_return_f64")
                    func _swift_js_return_f64(_: Float64)
                    \(raw: returnSwitch)
                }
            }

            extension \(raw: enumBaseName) {
                \(raw: generateCaseSpecificConstructors(enumDef: enumDef).joined(separator: "\n\n                "))
                
                static func dispatchConstruct(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> \(raw: typeName) {
                    let paramsString = String(unsafeUninitializedCapacity: Int(paramsLen)) { buf in
                        _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
                        return Int(paramsLen)
                    }
                    return dispatchConstructFromJson(caseId, paramsString)
                }
                
                static func dispatchConstructFromJson(_ caseId: Int32, _ paramsJson: String) -> \(raw: typeName) {
                    switch caseId {
                    \(raw: generateStructuredDispatchCases(enumDef: enumDef).joined(separator: "\n                    "))
                    default: fatalError("Unknown \(raw: enumBaseName) case ID: \\(caseId)")
                    }
                }
            }
            """
    }

    static func generateCaseSpecificConstructors(enumDef: ExportedEnum) -> [String] {
        var constructors: [String] = []
        let enumBaseName = enumDef.swiftCallName.components(separatedBy: ".").last ?? enumDef.swiftCallName

        for (i, c) in enumDef.cases.enumerated() {
            let caseName = c.name

            if c.associatedValues.isEmpty {
                constructors.append(
                    """
                    static func constructFrom\(enumBaseName)_\(i)() -> \(enumDef.swiftCallName) { 
                        return .\(caseName) 
                    }
                    """
                )
            } else {
                var params: [String] = []
                var args: [String] = []

                for (j, av) in c.associatedValues.enumerated() {
                    let paramName = av.label ?? "param\(j)"

                    switch av.type {
                    case .string:
                        params.append("\(paramName): String")
                        args.append("\(paramName)")
                    case .int:
                        params.append("\(paramName): Int32")
                        args.append("Int(\(paramName))")
                    case .bool:
                        params.append("\(paramName): Int32")
                        args.append("(\(paramName) != 0)")
                    case .float:
                        params.append("\(paramName): Float32")
                        args.append("\(paramName)")
                    case .double:
                        params.append("\(paramName): Float64")
                        args.append("\(paramName)")
                    default:
                        params.append("\(paramName): Int32")
                        args.append("\(paramName)")
                    }
                }

                let paramList = params.joined(separator: ", ")
                let argList = args.joined(separator: ", ")

                constructors.append(
                    """
                    static func constructFrom\(enumBaseName)_\(i)(\(paramList)) -> \(enumDef.swiftCallName) { 
                        return .\(caseName)(\(argList)) 
                    }
                    """
                )
            }
        }

        return constructors
    }

    static func generateDispatchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        let enumBaseName = enumDef.swiftCallName.components(separatedBy: ".").last ?? enumDef.swiftCallName

        for (i, c) in enumDef.cases.enumerated() {
            if c.associatedValues.isEmpty {
                cases.append("case \(i): return constructFrom\(enumBaseName)_\(i)()")
            } else {
                // For cases with parameters, we'll extract them from the pointer
                var paramExtractions: [String] = []
                var paramPasses: [String] = []
                var offset = 0

                for (j, av) in c.associatedValues.enumerated() {
                    let paramName = av.label ?? "param\(j)"

                    switch av.type {
                    case .string:
                        paramExtractions.append(
                            "let \(paramName)_ptr = params.load(fromByteOffset: \(offset), as: UnsafePointer<UInt8>.self)"
                        )
                        paramExtractions.append(
                            "let \(paramName)_len = params.load(fromByteOffset: \(offset + 8), as: Int32.self)"
                        )
                        paramPasses.append("\(paramName)_ptr: \(paramName)_ptr")
                        paramPasses.append("\(paramName)_len: \(paramName)_len")
                        offset += 16  // 8 bytes for pointer + 4 bytes for length + padding
                    case .int:
                        paramExtractions.append(
                            "let \(paramName) = params.load(fromByteOffset: \(offset), as: Int32.self)"
                        )
                        paramPasses.append("\(paramName): \(paramName)")
                        offset += 4
                    case .bool:
                        paramExtractions.append(
                            "let \(paramName) = params.load(fromByteOffset: \(offset), as: Int32.self)"
                        )
                        paramPasses.append("\(paramName): \(paramName)")
                        offset += 4
                    case .float:
                        paramExtractions.append(
                            "let \(paramName) = params.load(fromByteOffset: \(offset), as: Float32.self)"
                        )
                        paramPasses.append("\(paramName): \(paramName)")
                        offset += 4
                    case .double:
                        paramExtractions.append(
                            "let \(paramName) = params.load(fromByteOffset: \(offset), as: Float64.self)"
                        )
                        paramPasses.append("\(paramName): \(paramName)")
                        offset += 8
                    default:
                        paramExtractions.append(
                            "let \(paramName) = params.load(fromByteOffset: \(offset), as: Int32.self)"
                        )
                        paramPasses.append("\(paramName): \(paramName)")
                        offset += 4
                    }
                }

                let extractionCode = paramExtractions.joined(separator: "; ")
                let paramList = paramPasses.joined(separator: ", ")

                cases.append("case \(i): \(extractionCode); return constructFrom\(enumBaseName)_\(i)(\(paramList))")
            }
        }

        return cases
    }

    static func generateReturnCase(caseName: String, caseIndex: Int, associatedValues: [AssociatedValue]) -> String {
        var returnStatements: [String] = []
        returnStatements.append("_swift_js_return_tag(Int32(\(caseIndex)))")

        for (i, av) in associatedValues.enumerated() {
            let paramName = av.label ?? "param\(i)"

            switch av.type {
            case .string:
                returnStatements.append(
                    """
                    var mutable\(paramName.capitalized) = \(paramName)
                    mutable\(paramName.capitalized).withUTF8 { ptr in
                        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
                    }
                    """
                )
            case .int:
                returnStatements.append("_swift_js_return_int(Int32(\(paramName)))")
            case .bool:
                returnStatements.append("_swift_js_return_int(\(paramName) ? 1 : 0)")
            case .float:
                returnStatements.append("_swift_js_return_f32(\(paramName))")
            case .double:
                returnStatements.append("_swift_js_return_f64(\(paramName))")
            default:
                returnStatements.append("_swift_js_return_int(0)")
            }
        }

        let returnCode = returnStatements.joined(separator: "\n            ")
        return """
            case .\(caseName)(let \(associatedValues.enumerated().map { av in av.1.label ?? "param\(av.0)" }.joined(separator: ", let "))):
                \(returnCode)
            """
    }

    static func generateStructuredDispatchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        let enumBaseName = enumDef.swiftCallName.components(separatedBy: ".").last ?? enumDef.swiftCallName

        for (i, c) in enumDef.cases.enumerated() {
            if c.associatedValues.isEmpty {
                cases.append("case \(i): return constructFrom\(enumBaseName)_\(i)()")
            } else {
                // Parse JSON parameters and call constructor
                var paramExtractions: [String] = []
                var paramPasses: [String] = []

                for (j, av) in c.associatedValues.enumerated() {
                    let paramName = av.label ?? "param\(j)"

                    switch av.type {
                    case .string:
                        paramExtractions.append("let \(paramName) = params[\"\(paramName)\"] as! String")
                        paramPasses.append("\(paramName): \(paramName)")
                    case .int:
                        paramExtractions.append("let \(paramName) = params[\"\(paramName)\"] as! Int32")
                        paramPasses.append("\(paramName): \(paramName)")
                    case .bool:
                        paramExtractions.append("let \(paramName) = Int32(params[\"\(paramName)\"] as! Bool ? 1 : 0)")
                        paramPasses.append("\(paramName): \(paramName)")
                    case .float:
                        paramExtractions.append("let \(paramName) = params[\"\(paramName)\"] as! Float32")
                        paramPasses.append("\(paramName): \(paramName)")
                    case .double:
                        paramExtractions.append("let \(paramName) = params[\"\(paramName)\"] as! Float64")
                        paramPasses.append("\(paramName): \(paramName)")
                    default:
                        paramExtractions.append("let \(paramName) = params[\"\(paramName)\"] as! Int32")
                        paramPasses.append("\(paramName): \(paramName)")
                    }
                }

                let extractionCode = paramExtractions.joined(separator: "; ")
                let paramList = paramPasses.joined(separator: ", ")

                cases.append(
                    """
                    case \(i): 
                        guard let data = paramsJson.data(using: .utf8),
                              let params = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            fatalError("Failed to parse parameters JSON")
                        }
                        \(extractionCode)
                        return constructFrom\(enumBaseName)_\(i)(\(paramList))
                    """
                )
            }
        }

        return cases
    }

    static func generateConstructorCall(
        enumType: String,
        caseName: String,
        associatedValues: [AssociatedValue]
    ) -> String {
        var params: [String] = []

        // For simplicity, we'll handle the most common case: single parameter using (a, b) as needed
        if associatedValues.count == 1 {
            let av = associatedValues[0]
            let paramName = av.label ?? "param0"

            switch av.type {
            case .string:
                params.append("\(paramName)_ptr: UnsafePointer<UInt8>(bitPattern: UInt(a)).unsafelyUnwrapped")
                params.append("\(paramName)_len: b")
            case .int:
                params.append("\(paramName): a")
            case .bool:
                params.append("\(paramName): (a != 0)")
            case .float:
                params.append("\(paramName): Float32(bitPattern: UInt32(a))")
            case .double:
                params.append("\(paramName): Double(bitPattern: UInt64(a) | (UInt64(b) << 32))")
            default:
                params.append("\(paramName): a")
            }
        } else {
            // For multiple parameters, this is more complex - for now, use fatalError
            return "fatalError(\"Multiple parameter cases not yet implemented for \\\(caseName)\")"
        }

        return "\(enumType).create\(caseName)(\(params.joined(separator: ", ")))"
    }

    static func renderCaseSpecificConstructor(
        enumType: String,
        caseIndex: Int,
        caseName: String,
        associatedValues: [AssociatedValue]
    ) -> (constructorFunc: String, returnCase: String) {

        // Generate case-specific constructor function with native WASM parameters
        var constructorParams: [String] = []
        var constructorArgs: [String] = []
        var returnStatements: [String] = []

        for (i, av) in associatedValues.enumerated() {
            let paramName = av.label ?? "param\(i)"
            let labelPrefix = av.label.map { "\($0): " } ?? ""

            switch av.type {
            case .string:
                constructorParams.append("\(paramName)_ptr: UnsafePointer<UInt8>")
                constructorParams.append("\(paramName)_len: Int32")
                constructorArgs.append(
                    "\(labelPrefix)String(unsafeUninitializedCapacity: Int(\(paramName)_len)) { buf in _swift_js_init_memory(Int32(bitPattern: \(paramName)_ptr), buf.baseAddress.unsafelyUnwrapped); return Int(\(paramName)_len) }"
                )
                returnStatements.append(
                    """
                    var mutable\(paramName.capitalized) = \(paramName)
                    mutable\(paramName.capitalized).withUTF8 { ptr in
                        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
                    }
                    """
                )
            case .int:
                constructorParams.append("\(paramName): Int32")
                constructorArgs.append("\(labelPrefix)Int(\(paramName))")
                returnStatements.append("_swift_js_return_int(Int32(\(paramName)))")
            case .bool:
                constructorParams.append("\(paramName): Int32")
                constructorArgs.append("\(labelPrefix)(\(paramName) != 0)")
                returnStatements.append("_swift_js_return_int(\(paramName) ? 1 : 0)")
            case .float:
                constructorParams.append("\(paramName): Float32")
                constructorArgs.append("\(labelPrefix)\(paramName)")
                returnStatements.append("_swift_js_return_f32(\(paramName))")
            case .double:
                constructorParams.append("\(paramName): Float64")
                constructorArgs.append("\(labelPrefix)\(paramName)")
                returnStatements.append("_swift_js_return_f64(\(paramName))")
            default:
                constructorParams.append("\(paramName): Int32")
                constructorArgs.append("\(labelPrefix)/* unsupported type */")
                returnStatements.append("// Unsupported type for \(paramName)")
            }
        }

        // Generate the case-specific constructor function
        let constructorFunc = """
            static func create\(caseName.capitalized)(\(constructorParams.joined(separator: ", "))) -> \(enumType) {
                return .\(caseName)(\(constructorArgs.joined(separator: ", ")))
            }
            """

        let returnCase = """
            case .\(caseName)(\(associatedValues.enumerated().map { i, av in "let \(av.label ?? "param\(i)")" }.joined(separator: ", "))):
                _swift_js_return_tag(Int32(\(caseIndex)))
                \(returnStatements.joined(separator: "\n                "))
            """

        return (constructorFunc, returnCase)
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
}

func renderAssociatedValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
    // Use Variable ABI approach for all associated value enums
    return ExportSwift.renderVariableABIAssociatedValueEnum(enumDef)
}
