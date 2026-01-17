@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString() -> Void {
    #if arch(wasm32)
    let ret = checkString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}