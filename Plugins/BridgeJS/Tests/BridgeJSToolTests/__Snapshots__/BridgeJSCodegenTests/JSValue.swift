@_expose(wasm, "bjs_roundTripJSValue")
@_cdecl("bjs_roundTripJSValue")
public func _bjs_roundTripJSValue(_ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripJSValue(_: JSValue.bridgeJSLiftParameter(valueKind, valuePayload1, valuePayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSValue")
@_cdecl("bjs_roundTripOptionalJSValue")
public func _bjs_roundTripOptionalJSValue(_ valueIsSome: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSValue(_: Optional<JSValue>.bridgeJSLiftParameter(valueIsSome, valueKind, valuePayload1, valuePayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSValueArray")
@_cdecl("bjs_roundTripJSValueArray")
public func _bjs_roundTripJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripJSValueArray(_: [JSValue].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSValueArray")
@_cdecl("bjs_roundTripOptionalJSValueArray")
public func _bjs_roundTripOptionalJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSValueArray(_: Optional<[JSValue]>.bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_init")
@_cdecl("bjs_JSValueHolder_init")
public func _bjs_JSValueHolder_init(_ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64, _ optionalValueIsSome: Int32, _ optionalValueKind: Int32, _ optionalValuePayload1: Int32, _ optionalValuePayload2: Float64) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = JSValueHolder(value: JSValue.bridgeJSLiftParameter(valueKind, valuePayload1, valuePayload2), optionalValue: Optional<JSValue>.bridgeJSLiftParameter(optionalValueIsSome, optionalValueKind, optionalValuePayload1, optionalValuePayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_update")
@_cdecl("bjs_JSValueHolder_update")
public func _bjs_JSValueHolder_update(_ _self: UnsafeMutableRawPointer, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64, _ optionalValueIsSome: Int32, _ optionalValueKind: Int32, _ optionalValuePayload1: Int32, _ optionalValuePayload2: Float64) -> Void {
    #if arch(wasm32)
    JSValueHolder.bridgeJSLiftParameter(_self).update(value: JSValue.bridgeJSLiftParameter(valueKind, valuePayload1, valuePayload2), optionalValue: Optional<JSValue>.bridgeJSLiftParameter(optionalValueIsSome, optionalValueKind, optionalValuePayload1, optionalValuePayload2))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_echo")
@_cdecl("bjs_JSValueHolder_echo")
public func _bjs_JSValueHolder_echo(_ _self: UnsafeMutableRawPointer, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = JSValueHolder.bridgeJSLiftParameter(_self).echo(value: JSValue.bridgeJSLiftParameter(valueKind, valuePayload1, valuePayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_echoOptional")
@_cdecl("bjs_JSValueHolder_echoOptional")
public func _bjs_JSValueHolder_echoOptional(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = JSValueHolder.bridgeJSLiftParameter(_self).echoOptional(_: Optional<JSValue>.bridgeJSLiftParameter(valueIsSome, valueKind, valuePayload1, valuePayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_value_get")
@_cdecl("bjs_JSValueHolder_value_get")
public func _bjs_JSValueHolder_value_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = JSValueHolder.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_value_set")
@_cdecl("bjs_JSValueHolder_value_set")
public func _bjs_JSValueHolder_value_set(_ _self: UnsafeMutableRawPointer, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    JSValueHolder.bridgeJSLiftParameter(_self).value = JSValue.bridgeJSLiftParameter(valueKind, valuePayload1, valuePayload2)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_optionalValue_get")
@_cdecl("bjs_JSValueHolder_optionalValue_get")
public func _bjs_JSValueHolder_optionalValue_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = JSValueHolder.bridgeJSLiftParameter(_self).optionalValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_optionalValue_set")
@_cdecl("bjs_JSValueHolder_optionalValue_set")
public func _bjs_JSValueHolder_optionalValue_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    #if arch(wasm32)
    JSValueHolder.bridgeJSLiftParameter(_self).optionalValue = Optional<JSValue>.bridgeJSLiftParameter(valueIsSome, valueKind, valuePayload1, valuePayload2)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_JSValueHolder_deinit")
@_cdecl("bjs_JSValueHolder_deinit")
public func _bjs_JSValueHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<JSValueHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension JSValueHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_JSValueHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_JSValueHolder_wrap")
fileprivate func _bjs_JSValueHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_JSValueHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsEchoJSValue")
fileprivate func bjs_jsEchoJSValue(_ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void
#else
fileprivate func bjs_jsEchoJSValue(_ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsEchoJSValue(_ value: JSValue) throws(JSException) -> JSValue {
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    bjs_jsEchoJSValue(valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSValue.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsEchoJSValueArray")
fileprivate func bjs_jsEchoJSValueArray() -> Void
#else
fileprivate func bjs_jsEchoJSValueArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsEchoJSValueArray(_ values: [JSValue]) throws(JSException) -> [JSValue] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsEchoJSValueArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [JSValue].bridgeJSLiftReturn()
}