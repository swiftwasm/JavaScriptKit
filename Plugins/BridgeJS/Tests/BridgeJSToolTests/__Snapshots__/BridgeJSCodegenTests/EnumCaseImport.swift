extension Signal: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Signal {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Signal {
        return Signal(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .start
        case 1:
            self = .stop
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .start:
            return 0
        case .stop:
            return 1
        }
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_SignalControls_roundTrip_static")
fileprivate func bjs_SignalControls_roundTrip_static_extern(_ signal: Int32) -> Int32
#else
fileprivate func bjs_SignalControls_roundTrip_static_extern(_ signal: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SignalControls_roundTrip_static(_ signal: Int32) -> Int32 {
    return bjs_SignalControls_roundTrip_static_extern(signal)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_SignalControls_send")
fileprivate func bjs_SignalControls_send_extern(_ self: Int32, _ signal: Int32) -> Void
#else
fileprivate func bjs_SignalControls_send_extern(_ self: Int32, _ signal: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SignalControls_send(_ self: Int32, _ signal: Int32) -> Void {
    return bjs_SignalControls_send_extern(self, signal)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_SignalControls_current")
fileprivate func bjs_SignalControls_current_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_SignalControls_current_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SignalControls_current(_ self: Int32) -> Int32 {
    return bjs_SignalControls_current_extern(self)
}

func _$SignalControls_roundTrip(_ signal: Signal) throws(JSException) -> Signal {
    let signalValue = signal.bridgeJSLowerParameter()
    let ret = bjs_SignalControls_roundTrip_static(signalValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Signal.bridgeJSLiftReturn(ret)
}

func _$SignalControls_send(_ self: JSObject, _ signal: Signal) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let signalValue = signal.bridgeJSLowerParameter()
    bjs_SignalControls_send(selfValue, signalValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$SignalControls_current(_ self: JSObject) throws(JSException) -> Signal {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_SignalControls_current(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Signal.bridgeJSLiftReturn(ret)
}