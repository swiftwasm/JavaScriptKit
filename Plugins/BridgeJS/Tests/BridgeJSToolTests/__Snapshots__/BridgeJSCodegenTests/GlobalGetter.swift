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
@_extern(wasm, module: "TestModule", name: "bjs_JSConsole_log")
fileprivate func bjs_JSConsole_log_extern(_ self: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void
#else
fileprivate func bjs_JSConsole_log_extern(_ self: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSConsole_log(_ self: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    return bjs_JSConsole_log_extern(self, messageWord0, messageWord1, messageWord2)
}

func _$JSConsole_log(_ self: JSObject, _ message: String) throws(JSException) -> Void {
    message.bridgeJSWithLoweredParameter { (messageWord0, messageWord1, messageWord2) in
        let selfValue = self.bridgeJSLowerParameter()
        bjs_JSConsole_log(selfValue, messageWord0, messageWord1, messageWord2)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}