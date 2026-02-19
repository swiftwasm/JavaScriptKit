#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_fetchNumber")
fileprivate func bjs_fetchNumber_extern() -> Int32
#else
fileprivate func bjs_fetchNumber_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_fetchNumber() -> Int32 {
    return bjs_fetchNumber_extern()
}

func _$fetchNumber() throws(JSException) -> Int {
    let ret = bjs_fetchNumber()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}