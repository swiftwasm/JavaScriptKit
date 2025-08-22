// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

extension APIResult {
    init?(bridgeJSTag: Int32, a: Int32, b: Int32) {
        switch bridgeJSTag {
        case 0:
            let s = String(unsafeUninitializedCapacity: Int(b)) { buf in
                _swift_js_init_memory(a, buf.baseAddress.unsafelyUnwrapped)
                return Int(b)
            }
            self = .success(s)
        case 1:
            self = .failure(Int(a))
        case 2:
            self = .flag((a != 0))
        case 3:
            self = .rate(Float(bitPattern: UInt32(bitPattern: a)))
        case 4:
            let bits = UInt64(UInt32(bitPattern: a)) | (UInt64(UInt32(bitPattern: b)) << 32)
            self = .precise(Double(bitPattern: bits))
        case 5:
            self = .info
        default:
            return nil
        }
    }

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
        switch self {
        case .success(let value):
            _swift_js_return_tag(Int32(0))
            var ret = value
            ret.withUTF8 { ptr in
                _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let value):
            _swift_js_return_tag(Int32(1))
            _swift_js_return_int(Int32(value))
        case .flag(let value):
            _swift_js_return_tag(Int32(2))
            _swift_js_return_int(value ? 1 : 0)
        case .rate(let value):
            _swift_js_return_tag(Int32(3))
            _swift_js_return_f32(value)
        case .precise(let value):
            _swift_js_return_tag(Int32(4))
            _swift_js_return_f64(value)
        case .info:
            _swift_js_return_tag(Int32(5))
        }
    }
}

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(resultTag: Int32, resultA: Int32, resultB: Int32) -> Void {
    #if arch(wasm32)
    handle(result: APIResult(bridgeJSTag: resultTag, a: resultA, b: resultB)!)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getResult")
@_cdecl("bjs_getResult")
public func _bjs_getResult() -> Void {
    #if arch(wasm32)
    let ret = getResult()
    ret.bridgeJSReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}