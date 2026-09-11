@_expose(wasm, "bjs_createPropertyHolder")
@_cdecl("bjs_createPropertyHolder")
public func _bjs_createPropertyHolder(_ intValue: Int32, _ floatValue: Float32, _ doubleValue: Float64, _ boolValue: Int32, _ stringValueBytes: Int32, _ stringValueLength: Int32, _ jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let jsObject = JSObject.bridgeJSLiftParameter(jsObject)
    let stringValue = String.bridgeJSLiftParameter(stringValueBytes, stringValueLength)
    let boolValue = Bool.bridgeJSLiftParameter(boolValue)
    let doubleValue = Double.bridgeJSLiftParameter(doubleValue)
    let floatValue = Float.bridgeJSLiftParameter(floatValue)
    let intValue = Int.bridgeJSLiftParameter(intValue)
    let ret = createPropertyHolder(intValue: intValue, floatValue: floatValue, doubleValue: doubleValue, boolValue: boolValue, stringValue: stringValue, jsObject: jsObject)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testPropertyHolder")
@_cdecl("bjs_testPropertyHolder")
public func _bjs_testPropertyHolder(_ holder: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let holder = PropertyHolder.bridgeJSLiftParameter(holder)
    let ret = testPropertyHolder(holder: holder)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_init")
@_cdecl("bjs_PropertyHolder_init")
public func _bjs_PropertyHolder_init(_ intValue: Int32, _ floatValue: Float32, _ doubleValue: Float64, _ boolValue: Int32, _ stringValueBytes: Int32, _ stringValueLength: Int32, _ jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let jsObject = JSObject.bridgeJSLiftParameter(jsObject)
    let stringValue = String.bridgeJSLiftParameter(stringValueBytes, stringValueLength)
    let boolValue = Bool.bridgeJSLiftParameter(boolValue)
    let doubleValue = Double.bridgeJSLiftParameter(doubleValue)
    let floatValue = Float.bridgeJSLiftParameter(floatValue)
    let intValue = Int.bridgeJSLiftParameter(intValue)
    let ret = PropertyHolder(intValue: intValue, floatValue: floatValue, doubleValue: doubleValue, boolValue: boolValue, stringValue: stringValue, jsObject: jsObject)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_getAllValues")
@_cdecl("bjs_PropertyHolder_getAllValues")
public func _bjs_PropertyHolder_getAllValues(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.getAllValues()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_get")
@_cdecl("bjs_PropertyHolder_intValue_get")
public func _bjs_PropertyHolder_intValue_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.intValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_set")
@_cdecl("bjs_PropertyHolder_intValue_set")
public func _bjs_PropertyHolder_intValue_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let value = Int.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.intValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_get")
@_cdecl("bjs_PropertyHolder_floatValue_get")
public func _bjs_PropertyHolder_floatValue_get(_ _self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.floatValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_set")
@_cdecl("bjs_PropertyHolder_floatValue_set")
public func _bjs_PropertyHolder_floatValue_set(_ _self: UnsafeMutableRawPointer, _ value: Float32) -> Void {
    #if arch(wasm32)
    let value = Float.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.floatValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_get")
@_cdecl("bjs_PropertyHolder_doubleValue_get")
public func _bjs_PropertyHolder_doubleValue_get(_ _self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.doubleValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_set")
@_cdecl("bjs_PropertyHolder_doubleValue_set")
public func _bjs_PropertyHolder_doubleValue_set(_ _self: UnsafeMutableRawPointer, _ value: Float64) -> Void {
    #if arch(wasm32)
    let value = Double.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.doubleValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_get")
@_cdecl("bjs_PropertyHolder_boolValue_get")
public func _bjs_PropertyHolder_boolValue_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.boolValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_set")
@_cdecl("bjs_PropertyHolder_boolValue_set")
public func _bjs_PropertyHolder_boolValue_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let value = Bool.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.boolValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_get")
@_cdecl("bjs_PropertyHolder_stringValue_get")
public func _bjs_PropertyHolder_stringValue_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.stringValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_set")
@_cdecl("bjs_PropertyHolder_stringValue_set")
public func _bjs_PropertyHolder_stringValue_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let value = String.bridgeJSLiftParameter(valueBytes, valueLength)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.stringValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyInt_get")
@_cdecl("bjs_PropertyHolder_readonlyInt_get")
public func _bjs_PropertyHolder_readonlyInt_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.readonlyInt
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyFloat_get")
@_cdecl("bjs_PropertyHolder_readonlyFloat_get")
public func _bjs_PropertyHolder_readonlyFloat_get(_ _self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.readonlyFloat
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyDouble_get")
@_cdecl("bjs_PropertyHolder_readonlyDouble_get")
public func _bjs_PropertyHolder_readonlyDouble_get(_ _self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.readonlyDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyBool_get")
@_cdecl("bjs_PropertyHolder_readonlyBool_get")
public func _bjs_PropertyHolder_readonlyBool_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.readonlyBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyString_get")
@_cdecl("bjs_PropertyHolder_readonlyString_get")
public func _bjs_PropertyHolder_readonlyString_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.readonlyString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_get")
@_cdecl("bjs_PropertyHolder_jsObject_get")
public func _bjs_PropertyHolder_jsObject_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_set")
@_cdecl("bjs_PropertyHolder_jsObject_set")
public func _bjs_PropertyHolder_jsObject_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let value = JSObject.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.jsObject = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_get")
@_cdecl("bjs_PropertyHolder_sibling_get")
public func _bjs_PropertyHolder_sibling_get(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.sibling
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_set")
@_cdecl("bjs_PropertyHolder_sibling_set")
public func _bjs_PropertyHolder_sibling_set(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let value = PropertyHolder.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.sibling = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_get")
@_cdecl("bjs_PropertyHolder_lazyValue_get")
public func _bjs_PropertyHolder_lazyValue_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.lazyValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_set")
@_cdecl("bjs_PropertyHolder_lazyValue_set")
public func _bjs_PropertyHolder_lazyValue_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let value = String.bridgeJSLiftParameter(valueBytes, valueLength)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.lazyValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadonly_get")
@_cdecl("bjs_PropertyHolder_computedReadonly_get")
public func _bjs_PropertyHolder_computedReadonly_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.computedReadonly
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_get")
@_cdecl("bjs_PropertyHolder_computedReadWrite_get")
public func _bjs_PropertyHolder_computedReadWrite_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.computedReadWrite
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_set")
@_cdecl("bjs_PropertyHolder_computedReadWrite_set")
public func _bjs_PropertyHolder_computedReadWrite_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let value = String.bridgeJSLiftParameter(valueBytes, valueLength)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.computedReadWrite = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_get")
@_cdecl("bjs_PropertyHolder_observedProperty_get")
public func _bjs_PropertyHolder_observedProperty_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    let ret = _self.observedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_set")
@_cdecl("bjs_PropertyHolder_observedProperty_set")
public func _bjs_PropertyHolder_observedProperty_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let value = Int.bridgeJSLiftParameter(value)
    let _self = PropertyHolder.bridgeJSLiftParameter(_self)
    _self.observedProperty = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_deinit")
@_cdecl("bjs_PropertyHolder_deinit")
public func _bjs_PropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PropertyHolder_wrap")
fileprivate func _bjs_PropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PropertyHolder_wrap_extern(pointer)
}