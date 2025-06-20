// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_jsstring")
func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32
#else
func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "init_memory_with_result")
func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    fatalError("Only available on WebAssembly")
}
#endif

func checkNumber() -> Double {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkNumber")
    func bjs_checkNumber() -> Float64
    #else
    func bjs_checkNumber() -> Float64 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_checkNumber()
    return Double(ret)
}

func checkBoolean() -> Bool {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkBoolean")
    func bjs_checkBoolean() -> Int32
    #else
    func bjs_checkBoolean() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_checkBoolean()
    return ret == 1
}