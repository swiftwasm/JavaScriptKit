@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check() -> Void {
    #if arch(wasm32)
    check()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_check")
fileprivate func bjs_check_extern() -> Void
#else
fileprivate func bjs_check_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_check() -> Void {
    return bjs_check_extern()
}

func _$check() throws(JSException) -> Void {
    bjs_check()
    if let error = _swift_js_take_exception() {
        throw error
    }
}