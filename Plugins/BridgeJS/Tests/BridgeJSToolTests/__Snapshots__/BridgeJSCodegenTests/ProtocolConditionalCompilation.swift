extension Logger where Self: _BridgedSwiftProtocolWrapper {
    func log(_ message: String) -> Void {
        message.bridgeJSWithLoweredParameter { (messageWord0, messageWord1, messageWord2) in
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_Logger_log(jsObjectValue, messageWord0, messageWord1, messageWord2)
        }
    }

    func trace(_ message: String) -> Void {
        message.bridgeJSWithLoweredParameter { (messageWord0, messageWord1, messageWord2) in
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_Logger_trace(jsObjectValue, messageWord0, messageWord1, messageWord2)
        }
    }

    func flush() -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        bjs_Logger_flush(jsObjectValue)
    }

    var verbosity: Int {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_Logger_verbosity_get(jsObjectValue)
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            let newValueValue = newValue.bridgeJSLowerParameter()
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_Logger_verbosity_set(jsObjectValue, newValueValue)
        }
    }
}

struct AnyLogger: Logger, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyLogger(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Logger_log")
fileprivate func bjs_Logger_log_extern(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void
#else
fileprivate func bjs_Logger_log_extern(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Logger_log(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    return bjs_Logger_log_extern(jsObject, messageWord0, messageWord1, messageWord2)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Logger_trace")
fileprivate func bjs_Logger_trace_extern(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void
#else
fileprivate func bjs_Logger_trace_extern(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Logger_trace(_ jsObject: Int32, _ messageWord0: Int32, _ messageWord1: Int32, _ messageWord2: Int32) -> Void {
    return bjs_Logger_trace_extern(jsObject, messageWord0, messageWord1, messageWord2)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Logger_flush")
fileprivate func bjs_Logger_flush_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_Logger_flush_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Logger_flush(_ jsObject: Int32) -> Void {
    return bjs_Logger_flush_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Logger_verbosity_get")
fileprivate func bjs_Logger_verbosity_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_Logger_verbosity_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Logger_verbosity_get(_ jsObject: Int32) -> Int32 {
    return bjs_Logger_verbosity_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Logger_verbosity_set")
fileprivate func bjs_Logger_verbosity_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Logger_verbosity_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Logger_verbosity_set(_ jsObject: Int32, _ newValue: Int32) -> Void {
    return bjs_Logger_verbosity_set_extern(jsObject, newValue)
}