#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundtrip")
fileprivate func bjs_roundtrip() -> Void
#else
fileprivate func bjs_roundtrip() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$roundtrip(_ items: [Int]) throws(JSException) -> [Int] {
    let _ = items.bridgeJSLowerParameter()
    bjs_roundtrip()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_logStrings")
fileprivate func bjs_logStrings() -> Void
#else
fileprivate func bjs_logStrings() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$logStrings(_ items: [String]) throws(JSException) -> Void {
    let _ = items.bridgeJSLowerParameter()
    bjs_logStrings()
    if let error = _swift_js_take_exception() {
        throw error
    }
}