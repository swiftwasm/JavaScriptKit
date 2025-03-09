import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
import class Foundation.FileManager

struct ExportSwiftAPI {
    let progress: ProgressReporting

    private var exportedFunctions: [ExportedFunction] = []
    private var exportedClasses: [ExportedClass] = []

    init(progress: ProgressReporting = ProgressReporting()) {
        self.progress = progress
    }

    mutating func addSourceFile(_ sourceFile: SourceFileSyntax, _ inputFilePath: String) throws {
        progress.print("Processing \(inputFilePath)")
        let errors = try parseSingleFile(sourceFile)
        if errors.count > 0 {
            throw BridgeJSToolError(
                errors.map { $0.formattedDescription(fileName: inputFilePath) }
                    .joined(separator: "\n")
            )
        }
    }

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
        var exportedClasses: [String: ExportedClass] = [:]
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

        private func diagnose(node: some SyntaxProtocol, message: String) {
            errors.append(DiagnosticError(node: node, message: message))
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
                    exportedClasses[name]?.methods.append(exportedFunction)
                }
                return .skipChildren
            }
        }

        private func visitFunction(node: FunctionDeclSyntax) -> ExportedFunction? {
            guard node.attributes.hasJSAttribute() else {
                return nil
            }
            let name = node.name.text
            var parameters: [Parameter] = []
            for param in node.signature.parameterClause.parameters {
                guard let type = BridgeType(swiftType: param.type.trimmedDescription) else {
                    diagnose(node: param.type, message: "Unsupported parameter type: \(param.type)")
                    continue
                }
                let name = param.secondName?.text ?? param.firstName.text
                let label = param.firstName.text
                parameters.append(Parameter(label: label, name: name, type: type))
            }
            let returnType: BridgeType
            if let returnClause = node.signature.returnClause {
                guard let type = BridgeType(swiftType: returnClause.type.trimmedDescription) else {
                    diagnose(
                        node: returnClause.type,
                        message: "Unsupported return type: \(returnClause.type)"
                    )
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

            return ExportedFunction(
                name: name,
                abiName: abiName,
                parameters: parameters,
                returnType: returnType
            )
        }

        override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else { return .skipChildren }
            guard case .classBody(let name) = state else {
                diagnose(node: node, message: "@JS init must be inside a @JS class")
                return .skipChildren
            }
            var parameters: [Parameter] = []
            for param in node.signature.parameterClause.parameters {
                guard let type = BridgeType(swiftType: param.type.trimmedDescription) else {
                    diagnose(node: param.type, message: "Unsupported parameter type: \(param.type)")
                    continue
                }
                let name = param.secondName?.text ?? param.firstName.text
                let label = param.firstName.text
                parameters.append(Parameter(label: label, name: name, type: type))
            }

            let constructor = ExportedConstructor(
                abiName: "bjs_\(name)_init",
                parameters: parameters
            )
            exportedClasses[name]?.constructor = constructor
            return .skipChildren
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            guard node.attributes.hasJSAttribute() else { return .skipChildren }
            let name = node.name.text
            exportedClasses[name] = ExportedClass(
                name: name,
                constructor: nil,
                methods: []
            )
            stateStack.push(state: .classBody(name: name))
            return .visitChildren
        }
        override func visitPost(_ node: ClassDeclSyntax) {
            stateStack.pop()
        }
    }

    mutating func parseSingleFile(_ sourceFile: SourceFileSyntax) throws -> [DiagnosticError] {
        let collector = APICollector(viewMode: .all)
        collector.walk(sourceFile)
        exportedFunctions.append(contentsOf: collector.exportedFunctions)
        exportedClasses.append(contentsOf: collector.exportedClasses.values)
        return collector.errors
    }

    static let prelude: DeclSyntax = """
        @_extern(wasm, module: "bjs", name: "return_string")
        private func _return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
        @_extern(wasm, module: "bjs", name: "init_memory")
        private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)
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
                        _init_memory(\(raw: bytesLabel), b.baseAddress.unsafelyUnwrapped)
                        return Int(\(raw: lengthLabel))
                    }
                    """
                body.append(prepare)
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((bytesLabel, .i32))
                abiParameterSignatures.append((lengthLabel, .i32))
            case .jsObject:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
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

        func call(name: String, returnType: BridgeType) {
            let retMutability = returnType == .string ? "var" : "let"
            let callExpr: ExprSyntax =
                "\(raw: name)(\(raw: abiParameterForwardings.map { $0.description }.joined(separator: ", ")))"
            if returnType == .void {
                body.append("\(raw: callExpr)")
            } else {
                body.append(
                    """
                    \(raw: retMutability) ret = \(raw: callExpr)
                    """
                )
            }
        }

        func callMethod(klassName: String, methodName: String, returnType: BridgeType) {
            let _selfParam = self.abiParameterForwardings.removeFirst()
            let retMutability = returnType == .string ? "var" : "let"
            let callExpr: ExprSyntax =
                "\(raw: _selfParam).\(raw: methodName)(\(raw: abiParameterForwardings.map { $0.description }.joined(separator: ", ")))"
            if returnType == .void {
                body.append("\(raw: callExpr)")
            } else {
                body.append(
                    """
                    \(raw: retMutability) ret = \(raw: callExpr)
                    """
                )
            }
        }

        func lowerReturnValue(returnType: BridgeType) {
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
            }

            switch returnType {
            case .void: break
            case .int, .float, .double:
                body.append("return \(raw: abiReturnType!.swiftType)(ret)")
            case .bool:
                body.append("return Int32(ret ? 1 : 0)")
            case .string:
                body.append(
                    """
                    return ret.withUTF8 { ptr in
                        _return_string(ptr.baseAddress, Int32(ptr.count))
                    }
                    """
                )
            case .jsObject:
                body.append(
                    """
                    return ret.id
                    """
                )
            case .swiftHeapObject:
                // Perform a manual retain on the object, which will be balanced by a
                // release called via FinalizationRegistry
                body.append(
                    """
                    return Unmanaged.passRetained(ret).toOpaque()
                    """
                )
            }
        }

        func render(abiName: String) -> DeclSyntax {
            return """
                @_expose(wasm, "\(raw: abiName)")
                @_cdecl("\(raw: abiName)")
                public func _\(raw: abiName)(\(raw: parameterSignature())) -> \(raw: returnSignature()) {
                \(CodeBlockItemListSyntax(body))
                }
                """
        }

        func parameterSignature() -> String {
            abiParameterSignatures.map { "\($0.name): \($0.type.swiftType)" }.joined(
                separator: ", "
            )
        }

        func returnSignature() -> String {
            return abiReturnType?.swiftType ?? "Void"
        }
    }

    func renderSingleExportedFunction(function: ExportedFunction) -> DeclSyntax {
        let builder = ExportedThunkBuilder()
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
    ///         _init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
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
    ///         _return_string(ptr.baseAddress, Int32(ptr.count))
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
            let builder = ExportedThunkBuilder()
            for param in constructor.parameters {
                builder.liftParameter(param: param)
            }
            builder.call(name: klass.name, returnType: .swiftHeapObject(klass.name))
            builder.lowerReturnValue(returnType: .swiftHeapObject(klass.name))
            decls.append(builder.render(abiName: constructor.abiName))
        }
        for method in klass.methods {
            let builder = ExportedThunkBuilder()
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
        return first(where: {
            $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JS"
        }) != nil
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
        case .jsObject: return "JSObject"
        case .swiftHeapObject(let name): return name
        case .void: return "Void"
        }
    }
}
