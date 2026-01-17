#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_check")
fileprivate func bjs_check() -> Void
#else
fileprivate func bjs_check() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$check() throws(JSException) -> Void {
    bjs_check()
    if let error = _swift_js_take_exception() {
        throw error
    }
}