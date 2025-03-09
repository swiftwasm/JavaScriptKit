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

func checkArray(_ a: JSObject) -> Void {
    @_extern(wasm, module: "Check", name: "bjs_checkArray")
    func bjs_checkArray(_ a: Int32) -> Void
    bjs_checkArray(Int32(bitPattern: a.id))
}

func checkArrayWithLength(_ a: JSObject, _ b: Double) -> Void {
    @_extern(wasm, module: "Check", name: "bjs_checkArrayWithLength")
    func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void
    bjs_checkArrayWithLength(Int32(bitPattern: a.id), b)
}

func checkArray(_ a: JSObject) -> Void {
    @_extern(wasm, module: "Check", name: "bjs_checkArray")
    func bjs_checkArray(_ a: Int32) -> Void
    bjs_checkArray(Int32(bitPattern: a.id))
}