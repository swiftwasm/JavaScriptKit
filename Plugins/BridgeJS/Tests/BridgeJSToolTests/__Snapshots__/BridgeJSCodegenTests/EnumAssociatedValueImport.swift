extension PayloadSignal: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> PayloadSignal {
        switch caseId {
        case 0:
            return .start(String.bridgeJSStackPop())
        case 1:
            return .stop(Int.bridgeJSStackPop())
        case 2:
            return .idle
        default:
            fatalError("Unknown PayloadSignal case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .start(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .stop(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .idle:
            return Int32(2)
        }
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PayloadSignalControls_roundTrip_static")
fileprivate func bjs_PayloadSignalControls_roundTrip_static_extern(_ signal: Int32) -> Int32
#else
fileprivate func bjs_PayloadSignalControls_roundTrip_static_extern(_ signal: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PayloadSignalControls_roundTrip_static(_ signal: Int32) -> Int32 {
    return bjs_PayloadSignalControls_roundTrip_static_extern(signal)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PayloadSignalControls_send")
fileprivate func bjs_PayloadSignalControls_send_extern(_ self: Int32, _ signal: Int32) -> Void
#else
fileprivate func bjs_PayloadSignalControls_send_extern(_ self: Int32, _ signal: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PayloadSignalControls_send(_ self: Int32, _ signal: Int32) -> Void {
    return bjs_PayloadSignalControls_send_extern(self, signal)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PayloadSignalControls_current")
fileprivate func bjs_PayloadSignalControls_current_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_PayloadSignalControls_current_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PayloadSignalControls_current(_ self: Int32) -> Int32 {
    return bjs_PayloadSignalControls_current_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PayloadSignalControls_roundTripOptional")
fileprivate func bjs_PayloadSignalControls_roundTripOptional_extern(_ self: Int32, _ signalIsSome: Int32, _ signalCaseId: Int32) -> Int32
#else
fileprivate func bjs_PayloadSignalControls_roundTripOptional_extern(_ self: Int32, _ signalIsSome: Int32, _ signalCaseId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_PayloadSignalControls_roundTripOptional(_ self: Int32, _ signalIsSome: Int32, _ signalCaseId: Int32) -> Int32 {
    return bjs_PayloadSignalControls_roundTripOptional_extern(self, signalIsSome, signalCaseId)
}

func _$PayloadSignalControls_roundTrip(_ signal: PayloadSignal) throws(JSException) -> PayloadSignal {
    let signalCaseId = signal.bridgeJSLowerParameter()
    let ret = bjs_PayloadSignalControls_roundTrip_static(signalCaseId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return PayloadSignal.bridgeJSLiftReturn(ret)
}

func _$PayloadSignalControls_send(_ self: JSObject, _ signal: PayloadSignal) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let signalCaseId = signal.bridgeJSLowerParameter()
    bjs_PayloadSignalControls_send(selfValue, signalCaseId)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$PayloadSignalControls_current(_ self: JSObject) throws(JSException) -> PayloadSignal {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_PayloadSignalControls_current(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return PayloadSignal.bridgeJSLiftReturn(ret)
}

func _$PayloadSignalControls_roundTripOptional(_ self: JSObject, _ signal: Optional<PayloadSignal>) throws(JSException) -> Optional<PayloadSignal> {
    let selfValue = self.bridgeJSLowerParameter()
    let (signalIsSome, signalCaseId) = signal.bridgeJSLowerParameter()
    let ret = bjs_PayloadSignalControls_roundTripOptional(selfValue, signalIsSome, signalCaseId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<PayloadSignal>.bridgeJSLiftReturn(ret)
}