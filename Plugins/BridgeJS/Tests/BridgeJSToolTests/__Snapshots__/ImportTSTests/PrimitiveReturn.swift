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

func checkNumber() -> Double {
    @_extern(wasm, module: "Check", name: "bjs_checkNumber")
    func bjs_checkNumber() -> Float64
    let ret = bjs_checkNumber()
    return Double(ret)
}

func checkBoolean() -> Bool {
    @_extern(wasm, module: "Check", name: "bjs_checkBoolean")
    func bjs_checkBoolean() -> Int32
    let ret = bjs_checkBoolean()
    return ret == 1
}