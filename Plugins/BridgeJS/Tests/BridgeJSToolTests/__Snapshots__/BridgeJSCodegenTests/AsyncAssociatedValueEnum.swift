extension AsyncPayloadResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> AsyncPayloadResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .failure(Int.bridgeJSStackPop())
        case 2:
            return .idle
        default:
            fatalError("Unknown AsyncPayloadResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .failure(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .idle:
            return Int32(2)
        }
    }
}

@_expose(wasm, "bjs_asyncRoundTripAssociatedValueEnum")
@_cdecl("bjs_asyncRoundTripAssociatedValueEnum")
public func _bjs_asyncRoundTripAssociatedValueEnum(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let _tmp_value = AsyncPayloadResult.bridgeJSLiftParameter(value)
    return _bjs_makePromise(resolve: Promise_resolve_18AsyncPayloadResultO, reject: Promise_reject) {
        return await asyncRoundTripAssociatedValueEnum(_: _tmp_value)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripOptionalAssociatedValueEnum")
@_cdecl("bjs_asyncRoundTripOptionalAssociatedValueEnum")
public func _bjs_asyncRoundTripOptionalAssociatedValueEnum(_ valueIsSome: Int32, _ valueCaseId: Int32) -> Int32 {
    #if arch(wasm32)
    let _tmp_value = Optional<AsyncPayloadResult>.bridgeJSLiftParameter(valueIsSome, valueCaseId)
    return _bjs_makePromise(resolve: Promise_resolve_Sq18AsyncPayloadResultO, reject: Promise_reject) {
        return await asyncRoundTripOptionalAssociatedValueEnum(_: _tmp_value)
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@JSFunction func Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_reject_TestModule")
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void
#else
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_reject_TestModule(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    return promise_reject_TestModule_extern(promise, valueKind, valuePayload1, valuePayload2)
}

func _$Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    promise_reject_TestModule(promiseValue, valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_18AsyncPayloadResultO(_ promise: JSObject, _ value: AsyncPayloadResult) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_18AsyncPayloadResultO")
fileprivate func promise_resolve_TestModule_18AsyncPayloadResultO_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_18AsyncPayloadResultO_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_18AsyncPayloadResultO(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_18AsyncPayloadResultO_extern(promise, value)
}

func _$Promise_resolve_18AsyncPayloadResultO(_ promise: JSObject, _ value: AsyncPayloadResult) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueCaseId = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_18AsyncPayloadResultO(promiseValue, valueCaseId)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_Sq18AsyncPayloadResultO(_ promise: JSObject, _ value: Optional<AsyncPayloadResult>) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_Sq18AsyncPayloadResultO")
fileprivate func promise_resolve_TestModule_Sq18AsyncPayloadResultO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueCaseId: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_Sq18AsyncPayloadResultO_extern(_ promise: Int32, _ valueIsSome: Int32, _ valueCaseId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_Sq18AsyncPayloadResultO(_ promise: Int32, _ valueIsSome: Int32, _ valueCaseId: Int32) -> Void {
    return promise_resolve_TestModule_Sq18AsyncPayloadResultO_extern(promise, valueIsSome, valueCaseId)
}

func _$Promise_resolve_Sq18AsyncPayloadResultO(_ promise: JSObject, _ value: Optional<AsyncPayloadResult>) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let (valueIsSome, valueCaseId) = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_Sq18AsyncPayloadResultO(promiseValue, valueIsSome, valueCaseId)
    if let error = _swift_js_take_exception() { throw error }
}