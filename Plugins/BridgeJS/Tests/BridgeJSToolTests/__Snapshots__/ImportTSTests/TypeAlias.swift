#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkSimple")
fileprivate func bjs_checkSimple(_ a: Float64) -> Void
#else
fileprivate func bjs_checkSimple(_ a: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkSimple(_ a: Double) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    bjs_checkSimple(aValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}