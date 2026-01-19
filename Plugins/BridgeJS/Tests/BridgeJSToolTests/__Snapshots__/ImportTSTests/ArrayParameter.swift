#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArray")
fileprivate func bjs_checkArray(_ a: Int32) -> Void
#else
fileprivate func bjs_checkArray(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkArray(_ a: JSObject) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    bjs_checkArray(aValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArrayWithLength")
fileprivate func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkArrayWithLength(_ a: JSObject, _ b: Double) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    let bValue = b.bridgeJSLowerParameter()
    bjs_checkArrayWithLength(aValue, bValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArray")
fileprivate func bjs_checkArray(_ a: Int32) -> Void
#else
fileprivate func bjs_checkArray(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkArray(_ a: JSObject) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    bjs_checkArray(aValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}