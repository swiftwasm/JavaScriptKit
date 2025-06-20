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

@_expose(wasm, "bjs_checkInt")
@_cdecl("bjs_checkInt")
public func _bjs_checkInt() -> Int32 {
    #if arch(wasm32)
    let ret = checkInt()
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkFloat")
@_cdecl("bjs_checkFloat")
public func _bjs_checkFloat() -> Float32 {
    #if arch(wasm32)
    let ret = checkFloat()
    return Float32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkDouble")
@_cdecl("bjs_checkDouble")
public func _bjs_checkDouble() -> Float64 {
    #if arch(wasm32)
    let ret = checkDouble()
    return Float64(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkBool")
@_cdecl("bjs_checkBool")
public func _bjs_checkBool() -> Int32 {
    #if arch(wasm32)
    let ret = checkBool()
    return Int32(ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}