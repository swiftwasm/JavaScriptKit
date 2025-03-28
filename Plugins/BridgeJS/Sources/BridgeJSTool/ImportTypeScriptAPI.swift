import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder

struct ImportTypeScriptAPI {
    let progress: ProgressReporting
    let moduleName: String
    private var skeletons: [ImportedSkeleton] = []

    init(progress: ProgressReporting, moduleName: String) {
        self.progress = progress
        self.moduleName = moduleName
    }

    mutating func addSkeleton(_ skeleton: ImportedSkeleton) {
        self.skeletons.append(skeleton)
    }

    func finalize() throws -> String {
        var decls: [DeclSyntax] = []
        for skeleton in self.skeletons {
            for function in skeleton.functions {
                try decls.append(contentsOf: renderSwiftThunk(function))
            }
        }

        let format = BasicFormat()
        return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
    }

    class ImportedThunkBuilder {
        var body: [CodeBlockItemSyntax] = []
        var abiParameterForwardings: [LabeledExprSyntax] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?

        func lowerParameter(param: Parameter) throws {
            switch param.type {
            case .bool:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("Int32(\(raw: param.name) == 1)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .int:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
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
                body.append(
                    """
                    let \(raw: param.name) = \(raw: param.name).withUTF8 { b in
                        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
                    }
                    """
                )
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .jsObject:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .swiftHeapObject(_):
                throw BridgeJSToolError("swiftHeapObject is not supported in imported signatures")
            case .void:
                break
            }
        }

        func call(function: ImportedFunction) {
            let call: ExprSyntax = "\(raw: function.name)(\(raw: abiParameterForwardings.map { $0.description }.joined(separator: ", ")))"
            if function.returnType == .void {
                body.append("\(raw: call)")
            } else {
                body.append("let ret = \(raw: call)")
            }
        }

        func liftReturnValue(returnType: BridgeType) throws {
            switch returnType {
            case .bool:
                abiReturnType = .i32
                body.append("return ret == 1")
            case .int:
                abiReturnType = .i32
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .float:
                abiReturnType = .f32
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .double:
                abiReturnType = .f64
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .string:
                abiReturnType = .i32
                body.append("""
                return String(unsafeUninitializedCapacity: Int(ret)) { b in
                    _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                    return Int(ret)
                }
                """)
            case .jsObject:
                body.append("return ret")
            case .swiftHeapObject(_):
                throw BridgeJSToolError("swiftHeapObject is not supported in imported signatures")
            case .void:
                break
            }
        }
    }

    static let prelude: DeclSyntax = """
        @_extern(wasm, module: "bjs", name: "make_jsstring")
        private func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32

        @_extern(wasm, module: "bjs", name: "init_memory_with_result")
        private func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) 
        """

    func renderSwiftThunk(_ function: ImportedFunction) throws -> [DeclSyntax] {
        let name = function.name
        let parameters = function.parameters
        let returnType = function.returnType

        let builder = ImportedThunkBuilder()
        for param in parameters {
            try builder.lowerParameter(param: param)
        }

        builder.call(function: function)

        try builder.liftReturnValue(returnType: returnType)

        let importDecl: DeclSyntax = """
            @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: name)")
            func _bjs_\(raw: name)(\(raw: builder.abiParameterSignatures.map { "\($0.name): \($0.type.swiftType)" }.joined(separator: ", "))) -> \(raw: builder.abiReturnType.map { $0.swiftType } ?? "Void")
            """
        let thunkDecl: DeclSyntax = """
            func \(raw: name)(\(raw: parameters.map { "\($0.name): \($0.type.swiftType)" }.joined(separator: ", "))) -> \(raw: returnType.swiftType) {
            \(CodeBlockItemListSyntax(builder.body))
            }
            """
        return [importDecl, thunkDecl]
    }
}
