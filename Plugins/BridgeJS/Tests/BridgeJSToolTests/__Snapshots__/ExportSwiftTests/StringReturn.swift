// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "return_string")
private func _return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
@_extern(wasm, module: "bjs", name: "init_memory")
private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)

@_extern(wasm, module: "bjs", name: "swift_js_retain")
private func _swift_js_retain(_ ptr: Int32) -> Int32
@_extern(wasm, module: "bjs", name: "swift_js_throw")
private func _swift_js_throw(_ id: Int32)
#endif

@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString() -> Void {
    #if arch(wasm32)
    var ret = checkString()
    return ret.withUTF8 { ptr in
        _return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}