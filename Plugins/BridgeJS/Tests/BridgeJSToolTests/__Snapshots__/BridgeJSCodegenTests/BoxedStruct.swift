@_expose(wasm, "bjs_LargePayload_largeContents_get")
@_cdecl("bjs_LargePayload_largeContents_get")
public func _bjs_LargePayload_largeContents_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: LargePayload.self).pointee.largeContents
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_LargePayload_copy")
@_cdecl("bjs_LargePayload_copy")
public func _bjs_LargePayload_copy(_ pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    return LargePayload.bridgeJSCopyBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_LargePayload_deinit")
@_cdecl("bjs_LargePayload_deinit")
public func _bjs_LargePayload_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    LargePayload.bridgeJSReleaseBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension LargePayload: _BridgedSwiftBoxedValueStruct {}

@_expose(wasm, "bjs_Hi_init")
@_cdecl("bjs_Hi_init")
public func _bjs_Hi_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Hi(largeContents: [Int].bridgeJSStackPop())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Hi_largeContents_get")
@_cdecl("bjs_Hi_largeContents_get")
public func _bjs_Hi_largeContents_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: Hi.self).pointee.largeContents
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Hi_summarize")
@_cdecl("bjs_Hi_summarize")
public func _bjs_Hi_summarize(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: Hi.self).pointee.summarize()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Hi_appendingZero")
@_cdecl("bjs_Hi_appendingZero")
public func _bjs_Hi_appendingZero(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: Hi.self).pointee.appendingZero()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Hi_copy")
@_cdecl("bjs_Hi_copy")
public func _bjs_Hi_copy(_ pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    return Hi.bridgeJSCopyBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Hi_deinit")
@_cdecl("bjs_Hi_deinit")
public func _bjs_Hi_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Hi.bridgeJSReleaseBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Hi: _BridgedSwiftBoxedValueStruct {}

@_expose(wasm, "bjs_Container_payload_get")
@_cdecl("bjs_Container_payload_get")
public func _bjs_Container_payload_get(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: Container.self).pointee.payload
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_copy")
@_cdecl("bjs_Container_copy")
public func _bjs_Container_copy(_ pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    return Container.bridgeJSCopyBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_deinit")
@_cdecl("bjs_Container_deinit")
public func _bjs_Container_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Container.bridgeJSReleaseBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Container: _BridgedSwiftBoxedValueStruct {}

@_expose(wasm, "bjs_MutableBox_counter_get")
@_cdecl("bjs_MutableBox_counter_get")
public func _bjs_MutableBox_counter_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: MutableBox.self).pointee.counter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MutableBox_counter_set")
@_cdecl("bjs_MutableBox_counter_set")
public func _bjs_MutableBox_counter_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    _self.assumingMemoryBound(to: MutableBox.self).pointee.counter = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MutableBox_label_get")
@_cdecl("bjs_MutableBox_label_get")
public func _bjs_MutableBox_label_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = _self.assumingMemoryBound(to: MutableBox.self).pointee.label
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MutableBox_copy")
@_cdecl("bjs_MutableBox_copy")
public func _bjs_MutableBox_copy(_ pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    return MutableBox.bridgeJSCopyBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MutableBox_deinit")
@_cdecl("bjs_MutableBox_deinit")
public func _bjs_MutableBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MutableBox.bridgeJSReleaseBox(pointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension MutableBox: _BridgedSwiftBoxedValueStruct {}

extension ValueWithBoxedField: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ValueWithBoxedField {
        let label = String.bridgeJSStackPop()
        let payload = Hi.bridgeJSStackPop()
        return ValueWithBoxedField(payload: payload, label: label)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.payload.bridgeJSStackPush()
        self.label.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ValueWithBoxedField(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ValueWithBoxedField()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ValueWithBoxedField")
fileprivate func _bjs_struct_lower_ValueWithBoxedField_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ValueWithBoxedField_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ValueWithBoxedField(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ValueWithBoxedField_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ValueWithBoxedField")
fileprivate func _bjs_struct_lift_ValueWithBoxedField_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ValueWithBoxedField_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ValueWithBoxedField() -> Int32 {
    return _bjs_struct_lift_ValueWithBoxedField_extern()
}

@_expose(wasm, "bjs_roundtripBoxed")
@_cdecl("bjs_roundtripBoxed")
public func _bjs_roundtripBoxed(_ p: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundtripBoxed(_: p.assumingMemoryBound(to: LargePayload.self).pointee)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_mayMakeHi")
@_cdecl("bjs_mayMakeHi")
public func _bjs_mayMakeHi(_ flag: Int32) -> Void {
    #if arch(wasm32)
    let ret = mayMakeHi(_: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_consumeBoxedArray")
@_cdecl("bjs_consumeBoxedArray")
public func _bjs_consumeBoxedArray() -> Void {
    #if arch(wasm32)
    let ret = consumeBoxedArray(_: [Hi].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_consumeBoxedDictionary")
@_cdecl("bjs_consumeBoxedDictionary")
public func _bjs_consumeBoxedDictionary() -> Void {
    #if arch(wasm32)
    let ret = consumeBoxedDictionary(_: [String: Hi].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_optionalBoxedArray")
@_cdecl("bjs_optionalBoxedArray")
public func _bjs_optionalBoxedArray(_ flag: Int32) -> Void {
    #if arch(wasm32)
    let ret = optionalBoxedArray(_: Bool.bridgeJSLiftParameter(flag))
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayOfOptionalBoxed")
@_cdecl("bjs_arrayOfOptionalBoxed")
public func _bjs_arrayOfOptionalBoxed(_ flag: Int32) -> Void {
    #if arch(wasm32)
    let ret = arrayOfOptionalBoxed(_: Bool.bridgeJSLiftParameter(flag))
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}