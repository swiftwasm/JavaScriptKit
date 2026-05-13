@_expose(wasm, "bjs_processBytes")
@_cdecl("bjs_processBytes")
public func _bjs_processBytes(_ data: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processBytes(_: JSUint8Array.bridgeJSLiftParameter(data))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processFloats")
@_cdecl("bjs_processFloats")
public func _bjs_processFloats(_ data: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processFloats(_: JSFloat32Array.bridgeJSLiftParameter(data))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processGenericDoubles")
@_cdecl("bjs_processGenericDoubles")
public func _bjs_processGenericDoubles(_ data: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processGenericDoubles(_: JSFloat64Array.bridgeJSLiftParameter(data))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processGenericInts")
@_cdecl("bjs_processGenericInts")
public func _bjs_processGenericInts(_ data: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processGenericInts(_: JSInt32Array.bridgeJSLiftParameter(data))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}