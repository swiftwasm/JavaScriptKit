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

func checkString() -> String {
    @_extern(wasm, module: "Check", name: "bjs_checkString")
    func bjs_checkString() -> Int32
    let ret = bjs_checkString()
    return String(unsafeUninitializedCapacity: Int(ret)) { b in
        _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
        return Int(ret)
    }
}