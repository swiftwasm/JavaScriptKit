// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func asyncReturnVoid() throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncReturnVoid")
    func bjs_asyncReturnVoid() -> Int32
    #else
    func bjs_asyncReturnVoid() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncReturnVoid()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripInt(_ v: Double) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripInt")
    func bjs_asyncRoundTripInt(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripInt(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripInt(v)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripString(_ v: String) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripString")
    func bjs_asyncRoundTripString(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripString(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var v = v
    let vId = v.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_asyncRoundTripString(vId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripBool(_ v: Bool) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripBool")
    func bjs_asyncRoundTripBool(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripBool(Int32(v ? 1 : 0))
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripFloat(_ v: Double) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripFloat")
    func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripFloat(v)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripDouble(_ v: Double) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripDouble")
    func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripDouble(v)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}

func asyncRoundTripJSObject(_ v: JSObject) throws(JSException) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripJSObject")
    func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripJSObject(Int32(bitPattern: v.id))
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise(takingThis: ret)
}