#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_jsRoundTripNumber")
fileprivate func bjs_jsRoundTripNumber(_ v: Float64) -> Float64
#else
fileprivate func bjs_jsRoundTripNumber(_ v: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripNumber(_ v: Double) throws(JSException) -> Double {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_jsRoundTripNumber(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_JsGreeter_init")
fileprivate func bjs_JsGreeter_init(_ name: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_init(_ name: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_JsGreeter_greet")
fileprivate func bjs_JsGreeter_greet(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_greet(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$JsGreeter_init(_ name: String) throws(JSException) -> JSObject {
    let nameValue = name.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_init(nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$JsGreeter_greet(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_greet(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}