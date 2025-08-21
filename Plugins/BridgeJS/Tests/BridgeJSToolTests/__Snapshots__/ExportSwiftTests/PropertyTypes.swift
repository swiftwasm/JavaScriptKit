// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_createPropertyHolder")
@_cdecl("bjs_createPropertyHolder")
public func _bjs_createPropertyHolder(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLen: Int32, jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let stringValue = String(unsafeUninitializedCapacity: Int(stringValueLen)) { b in
        _swift_js_init_memory(stringValueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(stringValueLen)
    }
    let ret = createPropertyHolder(intValue: Int(intValue), floatValue: floatValue, doubleValue: doubleValue, boolValue: boolValue == 1, stringValue: stringValue, jsObject: JSObject(id: UInt32(bitPattern: jsObject)))
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testPropertyHolder")
@_cdecl("bjs_testPropertyHolder")
public func _bjs_testPropertyHolder(holder: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = testPropertyHolder(holder: Unmanaged<PropertyHolder>.fromOpaque(holder).takeUnretainedValue())
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_init")
@_cdecl("bjs_PropertyHolder_init")
public func _bjs_PropertyHolder_init(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLen: Int32, jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let stringValue = String(unsafeUninitializedCapacity: Int(stringValueLen)) { b in
        _swift_js_init_memory(stringValueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(stringValueLen)
    }
    let ret = PropertyHolder(intValue: Int(intValue), floatValue: floatValue, doubleValue: doubleValue, boolValue: boolValue == 1, stringValue: stringValue, jsObject: JSObject(id: UInt32(bitPattern: jsObject)))
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_getAllValues")
@_cdecl("bjs_PropertyHolder_getAllValues")
public func _bjs_PropertyHolder_getAllValues(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().getAllValues()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_get")
@_cdecl("bjs_PropertyHolder_intValue_get")
public func _bjs_PropertyHolder_intValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().intValue
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_set")
@_cdecl("bjs_PropertyHolder_intValue_set")
public func _bjs_PropertyHolder_intValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().intValue = Int(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_get")
@_cdecl("bjs_PropertyHolder_floatValue_get")
public func _bjs_PropertyHolder_floatValue_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().floatValue
    return Float32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_set")
@_cdecl("bjs_PropertyHolder_floatValue_set")
public func _bjs_PropertyHolder_floatValue_set(_self: UnsafeMutableRawPointer, value: Float32) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().floatValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_get")
@_cdecl("bjs_PropertyHolder_doubleValue_get")
public func _bjs_PropertyHolder_doubleValue_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().doubleValue
    return Float64(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_set")
@_cdecl("bjs_PropertyHolder_doubleValue_set")
public func _bjs_PropertyHolder_doubleValue_set(_self: UnsafeMutableRawPointer, value: Float64) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().doubleValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_get")
@_cdecl("bjs_PropertyHolder_boolValue_get")
public func _bjs_PropertyHolder_boolValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().boolValue
    return Int32(ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_set")
@_cdecl("bjs_PropertyHolder_boolValue_set")
public func _bjs_PropertyHolder_boolValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().boolValue = value == 1
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_get")
@_cdecl("bjs_PropertyHolder_stringValue_get")
public func _bjs_PropertyHolder_stringValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().stringValue
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_set")
@_cdecl("bjs_PropertyHolder_stringValue_set")
public func _bjs_PropertyHolder_stringValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLen: Int32) -> Void {
    #if arch(wasm32)
    let value = String(unsafeUninitializedCapacity: Int(valueLen)) { b in
        _swift_js_init_memory(valueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(valueLen)
    }
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().stringValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyInt_get")
@_cdecl("bjs_PropertyHolder_readonlyInt_get")
public func _bjs_PropertyHolder_readonlyInt_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().readonlyInt
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyFloat_get")
@_cdecl("bjs_PropertyHolder_readonlyFloat_get")
public func _bjs_PropertyHolder_readonlyFloat_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().readonlyFloat
    return Float32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyDouble_get")
@_cdecl("bjs_PropertyHolder_readonlyDouble_get")
public func _bjs_PropertyHolder_readonlyDouble_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().readonlyDouble
    return Float64(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyBool_get")
@_cdecl("bjs_PropertyHolder_readonlyBool_get")
public func _bjs_PropertyHolder_readonlyBool_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().readonlyBool
    return Int32(ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyString_get")
@_cdecl("bjs_PropertyHolder_readonlyString_get")
public func _bjs_PropertyHolder_readonlyString_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().readonlyString
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_get")
@_cdecl("bjs_PropertyHolder_jsObject_get")
public func _bjs_PropertyHolder_jsObject_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_set")
@_cdecl("bjs_PropertyHolder_jsObject_set")
public func _bjs_PropertyHolder_jsObject_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().jsObject = JSObject(id: UInt32(bitPattern: value))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_get")
@_cdecl("bjs_PropertyHolder_sibling_get")
public func _bjs_PropertyHolder_sibling_get(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().sibling
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_set")
@_cdecl("bjs_PropertyHolder_sibling_set")
public func _bjs_PropertyHolder_sibling_set(_self: UnsafeMutableRawPointer, value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().sibling = Unmanaged<PropertyHolder>.fromOpaque(value).takeUnretainedValue()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_get")
@_cdecl("bjs_PropertyHolder_lazyValue_get")
public func _bjs_PropertyHolder_lazyValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().lazyValue
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_set")
@_cdecl("bjs_PropertyHolder_lazyValue_set")
public func _bjs_PropertyHolder_lazyValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLen: Int32) -> Void {
    #if arch(wasm32)
    let value = String(unsafeUninitializedCapacity: Int(valueLen)) { b in
        _swift_js_init_memory(valueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(valueLen)
    }
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().lazyValue = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadonly_get")
@_cdecl("bjs_PropertyHolder_computedReadonly_get")
public func _bjs_PropertyHolder_computedReadonly_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().computedReadonly
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_get")
@_cdecl("bjs_PropertyHolder_computedReadWrite_get")
public func _bjs_PropertyHolder_computedReadWrite_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().computedReadWrite
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_set")
@_cdecl("bjs_PropertyHolder_computedReadWrite_set")
public func _bjs_PropertyHolder_computedReadWrite_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLen: Int32) -> Void {
    #if arch(wasm32)
    let value = String(unsafeUninitializedCapacity: Int(valueLen)) { b in
        _swift_js_init_memory(valueBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(valueLen)
    }
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().computedReadWrite = value
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_get")
@_cdecl("bjs_PropertyHolder_observedProperty_get")
public func _bjs_PropertyHolder_observedProperty_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().observedProperty
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_set")
@_cdecl("bjs_PropertyHolder_observedProperty_set")
public func _bjs_PropertyHolder_observedProperty_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(_self).takeUnretainedValue().observedProperty = Int(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_deinit")
@_cdecl("bjs_PropertyHolder_deinit")
public func _bjs_PropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PropertyHolder>.fromOpaque(pointer).release()
}

extension PropertyHolder: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "TestModule", name: "bjs_PropertyHolder_wrap")
        func _bjs_PropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}