@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    checkString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripString")
@_cdecl("bjs_roundtripString")
public func _bjs_roundtripString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}