#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkString")
fileprivate func bjs_checkString(_ a: Int32) -> Void
#else
fileprivate func bjs_checkString(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkString(_ a: String) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    bjs_checkString(aValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkStringWithLength")
fileprivate func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    let bValue = b.bridgeJSLowerParameter()
    bjs_checkStringWithLength(aValue, bValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}