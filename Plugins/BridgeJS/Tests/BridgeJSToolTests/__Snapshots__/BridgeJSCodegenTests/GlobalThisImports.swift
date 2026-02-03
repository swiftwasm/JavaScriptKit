#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_console_get")
fileprivate func bjs_console_get() -> Int32
#else
fileprivate func bjs_console_get() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$console_get() throws(JSException) -> JSConsole {
    let ret = bjs_console_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSConsole.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_parseInt")
fileprivate func bjs_parseInt(_ string: Int32) -> Float64
#else
fileprivate func bjs_parseInt(_ string: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$parseInt(_ string: String) throws(JSException) -> Double {
    let stringValue = string.bridgeJSLowerParameter()
    let ret = bjs_parseInt(stringValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSConsole_log")
fileprivate func bjs_JSConsole_log(_ self: Int32, _ message: Int32) -> Void
#else
fileprivate func bjs_JSConsole_log(_ self: Int32, _ message: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$JSConsole_log(_ self: JSObject, _ message: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let messageValue = message.bridgeJSLowerParameter()
    bjs_JSConsole_log(selfValue, messageValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WebSocket_init")
fileprivate func bjs_WebSocket_init(_ url: Int32) -> Int32
#else
fileprivate func bjs_WebSocket_init(_ url: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WebSocket_close")
fileprivate func bjs_WebSocket_close(_ self: Int32) -> Void
#else
fileprivate func bjs_WebSocket_close(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$WebSocket_init(_ url: String) throws(JSException) -> JSObject {
    let urlValue = url.bridgeJSLowerParameter()
    let ret = bjs_WebSocket_init(urlValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$WebSocket_close(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WebSocket_close(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}