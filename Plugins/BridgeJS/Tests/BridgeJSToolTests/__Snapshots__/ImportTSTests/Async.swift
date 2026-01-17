#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncReturnVoid")
fileprivate func bjs_asyncReturnVoid() -> Int32
#else
fileprivate func bjs_asyncReturnVoid() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncReturnVoid() throws(JSException) -> JSPromise {
    let ret = bjs_asyncReturnVoid()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripInt")
fileprivate func bjs_asyncRoundTripInt(_ v: Float64) -> Int32
#else
fileprivate func bjs_asyncRoundTripInt(_ v: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripInt(_ v: Double) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripInt(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripString")
fileprivate func bjs_asyncRoundTripString(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripString(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripString(_ v: String) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripString(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripBool")
fileprivate func bjs_asyncRoundTripBool(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripBool(_ v: Bool) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripBool(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripFloat")
fileprivate func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32
#else
fileprivate func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripFloat(_ v: Double) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripFloat(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripDouble")
fileprivate func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32
#else
fileprivate func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripDouble(_ v: Double) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripDouble(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_asyncRoundTripJSObject")
fileprivate func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$asyncRoundTripJSObject(_ v: JSObject) throws(JSException) -> JSPromise {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripJSObject(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}