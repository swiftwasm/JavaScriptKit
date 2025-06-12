// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

@_extern(wasm, module: "bjs", name: "make_jsstring")
private func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32

@_extern(wasm, module: "bjs", name: "init_memory_with_result")
private func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)

@_extern(wasm, module: "bjs", name: "free_jsobject")
private func _free_jsobject(_ ptr: Int32) -> Void

func jsRoundTripVoid() -> Void {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripVoid")
    func bjs_jsRoundTripVoid() -> Void
    bjs_jsRoundTripVoid()
}

func jsRoundTripNumber(_ v: Double) -> Double {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumber")
    func bjs_jsRoundTripNumber(_ v: Float64) -> Float64
    let ret = bjs_jsRoundTripNumber(v)
    return Double(ret)
}

func jsRoundTripBool(_ v: Bool) -> Bool {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripBool")
    func bjs_jsRoundTripBool(_ v: Int32) -> Int32
    let ret = bjs_jsRoundTripBool(Int32(v ? 1 : 0))
    return ret == 1
}

func jsRoundTripString(_ v: String) -> String {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripString")
    func bjs_jsRoundTripString(_ v: Int32) -> Int32
    var v = v
    let vId = v.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_jsRoundTripString(vId)
    return String(unsafeUninitializedCapacity: Int(ret)) { b in
        _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
        return Int(ret)
    }
}