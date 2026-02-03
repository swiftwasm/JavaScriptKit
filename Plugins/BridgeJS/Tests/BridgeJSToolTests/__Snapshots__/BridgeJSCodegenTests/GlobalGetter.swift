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