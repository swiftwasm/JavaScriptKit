import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder

/// Exports Swift functions and classes to JavaScript
///
/// This class processes Swift source files to find declarations marked with `@JS`
/// and generates:
/// 1. Swift glue code to call the Swift functions from JavaScript
/// 2. Skeleton files that define the structure of the exported APIs
///
/// The generated skeletons will be used by ``BridgeJSLink`` to generate
/// JavaScript glue code and TypeScript definitions.
class ExportSwift {
    let progress: ProgressReporting

    private var exportedFunctions: [ExportedFunction] = []
    private var exportedClasses: [ExportedClass] = []
    private var typeDeclResolver: TypeDeclResolver = TypeDeclResolver()

    init(progress: ProgressReporting) {
        self.progress = progress
    }

    /// Processes a Swift source file to find declarations marked with @JS
    ///
    /// - Parameters:
    ///   - sourceFile: The parsed Swift source file to process
    ///   - inputFilePath: The file path for error reporting
    func addSourceFile(_ sourceFile: SourceFileSyntax, _ inputFilePath: String) throws {
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
    func finalize() throws -> (outputSwift: String, outputSkeleton: ExportedSkeleton)? {
        guard let outputSwift = renderSwiftGlue() else {
            return nil
        }
        return (
            outputSwift: outputSwift,
            outputSkeleton: ExportedSkeleton(functions: exportedFunctions, classes: exportedClasses)
        )
    }

    fileprivate final class APICollector: SyntaxAnyVisitor {
        var exportedFunctions: [ExportedFunction] = []
        /// The names of the exported classes, in the order they were written in the source file
        var exportedClassNames: [String] = []
        var exportedClassByName: [String: ExportedClass] = [:]
        var errors: [DiagnosticError] = []

        enum State {
            case topLevel
            case classBody(name: String)
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
                if let exportedFunction = visitFunction(node: node) {
                    exportedFunctions.append(exportedFunction)
                }
                return .skipChildren
            case .classBody(let name):
                if let exportedFunction = visitFunction(node: node) {
                    exportedClassByName[name]?.methods.append(exportedFunction)
                }
                return .skipChildren
            }
        }

        private func visitFunction(node: FunctionDeclSyntax) -> ExportedFunction? {
            guard let jsAttribute = node.attributes.firstJSAttribute else {
                return nil
            }
            
            let name = node.name.text
            let namespace = extractNamespace(from: jsAttribute)
            
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
            case .classBody(let className):
                abiName = "bjs_\(className)_\(name)"
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
            guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
                  let firstArg = arguments.first?.expression.as(StringLiteralExprSyntax.self),
                  let namespaceString = firstArg.segments.first?.as(StringSegmentSyntax.self)?.content.text else {
                return  nil
            }
            return namespaceString.split(separator: ".").map(String.init)
        }

        override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else { return .skipChildren }
            guard case .classBody(let name) = state else {
                diagnose(node: node, message: "@JS init must be inside a @JS class")
                return .skipChildren
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
                abiName: "bjs_\(name)_init",
                parameters: parameters,
                effects: effects
            )
            exportedClassByName[name]?.constructor = constructor
            return .skipChildren
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            let name = node.name.text
            
            stateStack.push(state: .classBody(name: name))

            guard let jsAttribute = node.attributes.firstJSAttribute else { return .skipChildren }

            let namespace = extractNamespace(from: jsAttribute)
            exportedClassByName[name] = ExportedClass(
                name: name,
                constructor: nil,
                methods: [],
                namespace: namespace
            )
            exportedClassNames.append(name)
            return .visitChildren
        }
        override func visitPost(_ node: ClassDeclSyntax) {
            stateStack.pop()
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
        return collector.errors
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
        guard exportedFunctions.count > 0 || exportedClasses.count > 0 else {
            return nil
        }
        decls.append(Self.prelude)
        for function in exportedFunctions {
            decls.append(renderSingleExportedFunction(function: function))
        }
        for klass in exportedClasses {
            decls.append(contentsOf: renderSingleExportedClass(klass: klass))
        }
        let format = BasicFormat()
        return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
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
                // UnsafeMutableRawPointer is passed as an i32 pointer
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
                callExpr = ExprSyntax(AwaitExprSyntax(awaitKeyword: .keyword(.await), expression: callExpr))
            }
            if effects.isThrows {
                callExpr = ExprSyntax(
                    TryExprSyntax(
                        tryKeyword: .keyword(.try).with(\.trailingTrivia, .space),
                        expression: callExpr
                    )
                )
            }
            let retMutability = returnType == .string ? "var" : "let"
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
            abiReturnType = returnType.abiReturnType

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
            if effects.isThrows {
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
            builder.call(name: klass.name, returnType: .swiftHeapObject(klass.name))
            builder.lowerReturnValue(returnType: .swiftHeapObject(klass.name))
            decls.append(builder.render(abiName: constructor.abiName))
        }
        for method in klass.methods {
            let builder = ExportedThunkBuilder(effects: method.effects)
            builder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(klass.name))
            )
            for param in method.parameters {
                builder.liftParameter(param: param)
            }
            builder.callMethod(
                klassName: klass.name,
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
                    Unmanaged<\(raw: klass.name)>.fromOpaque(pointer).release()
                }
                """
            )
        }

        return decls
    }
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
        }
    }
}
