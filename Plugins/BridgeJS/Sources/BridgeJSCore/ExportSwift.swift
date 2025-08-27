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

            let effectiveNamespace: [String]?
            if computedNamespace != nil && attributeNamespace != nil {
                effectiveNamespace = computedNamespace
            } else {
                effectiveNamespace = computedNamespace ?? attributeNamespace
            }

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

    func renderSwiftGlue() -> String? {
        var decls: [DeclSyntax] = []
        guard exportedFunctions.count > 0 || exportedClasses.count > 0 || exportedEnums.count > 0 else {
            return nil
        }
        decls.append(Self.prelude)

        if exportedEnums.contains(where: { $0.enumType == .associatedValue }) {
            decls.append(renderAssociatedValueBinaryHelpers())
        }

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

    func renderAssociatedValueBinaryHelpers() -> DeclSyntax {
        return """
            fileprivate enum _BJSParamType: UInt8 {
                case string = 1
                case int32 = 2
                case bool = 3
                case float32 = 4
                case float64 = 5
            }

            fileprivate struct _BJSBinaryReader {
                let raw: UnsafeRawBufferPointer
                var offset: Int = 0

                @inline(__always)
                mutating func readUInt8() -> UInt8 {
                    let b = raw[offset]
                    offset += 1
                    return b
                }

                @inline(__always)
                mutating func readUInt32() -> UInt32 {
                    var v = UInt32(0)
                    withUnsafeMutableBytes(of: &v) { dst in
                        dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
                    }
                    offset += 4
                    return UInt32(littleEndian: v)
                }

                @inline(__always)
                mutating func readInt32() -> Int32 {
                    var v = Int32(0)
                    withUnsafeMutableBytes(of: &v) { dst in
                        dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
                    }
                    offset += 4
                    return Int32(littleEndian: v)
                }

                @inline(__always)
                mutating func readFloat32() -> Float32 {
                    var bits = UInt32(0)
                    withUnsafeMutableBytes(of: &bits) { dst in
                        dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 4)]))
                    }
                    offset += 4
                    return Float32(bitPattern: UInt32(littleEndian: bits))
                }

                @inline(__always)
                mutating func readFloat64() -> Float64 {
                    var bits = UInt64(0)
                    withUnsafeMutableBytes(of: &bits) { dst in
                        dst.copyBytes(from: UnsafeRawBufferPointer(rebasing: raw[offset..<(offset + 8)]))
                    }
                    offset += 8
                    return Float64(bitPattern: UInt64(littleEndian: bits))
                }

                @inline(__always)
                mutating func readString() -> String {
                    let len = Int(readUInt32())
                    let s = String(decoding: UnsafeBufferPointer(
                        start: raw.baseAddress!.advanced(by: offset).assumingMemoryBound(to: UInt8.self),
                        count: len
                    ), as: UTF8.self)
                    offset += len
                    return s
                }

                @inline(__always)
                mutating func expectTag(_ expected: _BJSParamType) {
                    let rawTag = readUInt8()
                    guard let got = _BJSParamType(rawValue: rawTag), got == expected else {
                        preconditionFailure("BridgeJS: mismatched enum param tag. Expected \\(expected) got \\(String(describing: _BJSParamType(rawValue: rawTag)))")
                    }
                }

                @inline(__always)
                mutating func readParamCount(expected: Int) {
                    let count = Int(readUInt32())
                    precondition(count == expected, "BridgeJS: mismatched enum param count. Expected \\(expected) got \\(count)")
                }
            }

            @_extern(wasm, module: "bjs", name: "swift_js_init_memory")
            func _swift_js_init_memory(_: Int32, _: UnsafeMutablePointer<UInt8>)

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
            @_extern(wasm, module: "bjs", name: "swift_js_return_bool")
            func _swift_js_return_bool(_: Int32)
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
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax(
                            "\(raw: enumName).bridgeJSLiftParameter(\(raw: param.name)CaseId, \(raw: param.name)ParamsId, \(raw: param.name)ParamsLen)"
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
                // UnsafeMutableRawPointer is returned as an i32 pointer
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax(
                            "Unmanaged<\(raw: param.type.swiftType)>.fromOpaque(\(raw: param.name)).takeUnretainedValue()"
                        )
                    )
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
                append("ret.bridgeJSLowerReturn()")
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
            case .associatedValueEnum: break
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

    func renderAssociatedValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        return """
            private extension \(raw: typeName) {
                static func bridgeJSLiftParameter(_ caseId: Int32, _ paramsId: Int32, _ paramsLen: Int32) -> \(raw: typeName) {
                    let params: [UInt8] = .init(unsafeUninitializedCapacity: Int(paramsLen)) { buf, initializedCount in
                        _swift_js_init_memory(paramsId, buf.baseAddress.unsafelyUnwrapped)
                        initializedCount = Int(paramsLen)
                    }
                    return params.withUnsafeBytes { raw in
                        var reader = _BJSBinaryReader(raw: raw)
                        switch caseId {
                        \(raw: generateBinaryLiftSwitchCases(enumDef: enumDef).joined(separator: "\n                        "))
                        default: fatalError("Unknown \(raw: typeName) case ID: \\(caseId)")
                        }
                    }
                }

                func bridgeJSLowerReturn() {
                    switch self {
                    \(raw: generateReturnSwitchCases(enumDef: enumDef).joined(separator: "\n                    "))
                    }
                }
            }
            """
    }

    func generateBinaryLiftSwitchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                cases.append("case \(caseIndex): return .\(enumCase.name)")
            } else {
                var lines: [String] = []
                lines.append("case \(caseIndex):")
                lines.append("reader.readParamCount(expected: \(enumCase.associatedValues.count))")
                var argList: [String] = []

                for (paramIndex, associatedValue) in enumCase.associatedValues.enumerated() {
                    let paramName = associatedValue.label ?? "param\(paramIndex)"
                    argList.append(paramName)

                    switch associatedValue.type {
                    case .string:
                        lines.append("reader.expectTag(.string)")
                        lines.append("let \(paramName) = reader.readString()")
                    case .int:
                        lines.append("reader.expectTag(.int32)")
                        lines.append("let \(paramName) = Int(reader.readInt32())")
                    case .bool:
                        lines.append("reader.expectTag(.bool)")
                        lines.append("let \(paramName) = Int32(reader.readUInt8()) != 0")
                    case .float:
                        lines.append("reader.expectTag(.float32)")
                        lines.append("let \(paramName) = reader.readFloat32()")
                    case .double:
                        lines.append("reader.expectTag(.float64)")
                        lines.append("let \(paramName) = reader.readFloat64()")
                    default:
                        lines.append("reader.expectTag(.int32)")
                        lines.append("let \(paramName) = reader.readInt32()")
                    }
                }

                lines.append("return .\(enumCase.name)(\(argList.joined(separator: ", ")))")
                cases.append(lines.joined(separator: "\n                        "))
            }
        }
        return cases
    }

    func generateReturnSwitchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                cases.append("""
                    case .\(enumCase.name):
                        _swift_js_return_tag(Int32(\(caseIndex)))
                    """)
            } else {
                var bodyLines: [String] = []
                bodyLines.append("_swift_js_return_tag(Int32(\(caseIndex)))")
                for (i, av) in enumCase.associatedValues.enumerated() {
                    let paramName = av.label ?? "param\(i)"
                    switch av.type {
                    case .string:
                        bodyLines.append("""
                            var __bjs_\(paramName) = \(paramName)
                            __bjs_\(paramName).withUTF8 { ptr in
                                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
                            }
                            """)
                    case .int:
                        bodyLines.append("_swift_js_return_int(Int32(\(paramName)))")
                    case .bool:
                        bodyLines.append("_swift_js_return_bool(\(paramName) ? 1 : 0)")
                    case .float:
                        bodyLines.append("_swift_js_return_f32(\(paramName))")
                    case .double:
                        bodyLines.append("_swift_js_return_f64(\(paramName))")
                    default:
                        bodyLines.append("preconditionFailure(\"BridgeJS: unsupported associated value type in generated code\")")
                    }
                }
                let pattern = enumCase.associatedValues.enumerated().map { i, av in "let \(av.label ?? "param\(i)")" }.joined(separator: ", ")
                cases.append("""
                    case .\(enumCase.name)(\(pattern)):
                        \(bodyLines.joined(separator: "\n                        "))
                    """)
            }
        }
        return cases
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
