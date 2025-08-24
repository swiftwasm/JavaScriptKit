// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_checkInt")
@_cdecl("bjs_checkInt")
public func _bjs_checkInt() -> Int32 {
    #if arch(wasm32)
    let ret = checkInt()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkFloat")
@_cdecl("bjs_checkFloat")
public func _bjs_checkFloat() -> Float32 {
    #if arch(wasm32)
    let ret = checkFloat()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkDouble")
@_cdecl("bjs_checkDouble")
public func _bjs_checkDouble() -> Float64 {
    #if arch(wasm32)
    let ret = checkDouble()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkBool")
@_cdecl("bjs_checkBool")
public func _bjs_checkBool() -> Int32 {
    #if arch(wasm32)
    let ret = checkBool()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}