#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_console_get")
fileprivate func bjs_console_get_extern() -> Int32
#else
fileprivate func bjs_console_get_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_console_get() -> Int32 {
    return bjs_console_get_extern()
}

func _$console_get() throws(JSException) -> JSConsole {
    let ret = bjs_console_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSConsole.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_parseInt")
fileprivate func bjs_parseInt_extern(_ stringBytes: Int32, _ stringLength: Int32) -> Float64
#else
fileprivate func bjs_parseInt_extern(_ stringBytes: Int32, _ stringLength: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_parseInt(_ stringBytes: Int32, _ stringLength: Int32) -> Float64 {
    return bjs_parseInt_extern(stringBytes, stringLength)
}

func _$parseInt(_ string: String) throws(JSException) -> Double {
    let ret0 = string.bridgeJSWithLoweredParameter { (stringBytes, stringLength) in
        let ret = bjs_parseInt(stringBytes, stringLength)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSConsole_log")
fileprivate func bjs_JSConsole_log_extern(_ self: Int32, _ messageBytes: Int32, _ messageLength: Int32) -> Void
#else
fileprivate func bjs_JSConsole_log_extern(_ self: Int32, _ messageBytes: Int32, _ messageLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSConsole_log(_ self: Int32, _ messageBytes: Int32, _ messageLength: Int32) -> Void {
    return bjs_JSConsole_log_extern(self, messageBytes, messageLength)
}

func _$JSConsole_log(_ self: JSObject, _ message: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    message.bridgeJSWithLoweredParameter { (messageBytes, messageLength) in
        bjs_JSConsole_log(selfValue, messageBytes, messageLength)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WebSocket_init")
fileprivate func bjs_WebSocket_init_extern(_ urlBytes: Int32, _ urlLength: Int32) -> Int32
#else
fileprivate func bjs_WebSocket_init_extern(_ urlBytes: Int32, _ urlLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WebSocket_init(_ urlBytes: Int32, _ urlLength: Int32) -> Int32 {
    return bjs_WebSocket_init_extern(urlBytes, urlLength)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WebSocket_close")
fileprivate func bjs_WebSocket_close_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WebSocket_close_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WebSocket_close(_ self: Int32) -> Void {
    return bjs_WebSocket_close_extern(self)
}

func _$WebSocket_init(_ url: String) throws(JSException) -> JSObject {
    let ret0 = url.bridgeJSWithLoweredParameter { (urlBytes, urlLength) in
        let ret = bjs_WebSocket_init(urlBytes, urlLength)
        return ret
    }
    let ret = ret0
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