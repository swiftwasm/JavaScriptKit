#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkString")
fileprivate func bjs_checkString() -> Int32
#else
fileprivate func bjs_checkString() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkString() throws(JSException) -> String {
    let ret = bjs_checkString()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}