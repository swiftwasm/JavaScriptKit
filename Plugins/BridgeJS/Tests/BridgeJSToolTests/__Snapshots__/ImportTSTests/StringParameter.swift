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

func checkString(_ a: String) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkString")
    func bjs_checkString(_ a: Int32) -> Void
    #else
    func bjs_checkString(_ a: Int32) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var a = a
    let aId = a.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_checkString(aId)
}

func checkStringWithLength(_ a: String, _ b: Double) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkStringWithLength")
    func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void
    #else
    func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var a = a
    let aId = a.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_checkStringWithLength(aId, b)
}