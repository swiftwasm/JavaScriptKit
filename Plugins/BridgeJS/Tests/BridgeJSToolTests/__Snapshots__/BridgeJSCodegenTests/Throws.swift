@_expose(wasm, "bjs_throwsSomething")
@_cdecl("bjs_throwsSomething")
public func _bjs_throwsSomething() -> Void {
    #if arch(wasm32)
    do {
        try throwsSomething()
    } catch let error {
        error.bridgeJSLowerThrow()
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}