@_expose(wasm, "bjs_CachedModel_init")
@_cdecl("bjs_CachedModel_init")
public func _bjs_CachedModel_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = CachedModel(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_CachedModel_name_get")
@_cdecl("bjs_CachedModel_name_get")
public func _bjs_CachedModel_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = CachedModel.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_CachedModel_name_set")
@_cdecl("bjs_CachedModel_name_set")
public func _bjs_CachedModel_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    CachedModel.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_CachedModel_deinit")
@_cdecl("bjs_CachedModel_deinit")
public func _bjs_CachedModel_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<CachedModel>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension CachedModel: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_CachedModel_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_CachedModel_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_CachedModel_wrap")
fileprivate func _bjs_CachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_CachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_CachedModel_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_CachedModel_wrap_extern(pointer)
}

@_expose(wasm, "bjs_UncachedModel_init")
@_cdecl("bjs_UncachedModel_init")
public func _bjs_UncachedModel_init(_ value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = UncachedModel(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UncachedModel_value_get")
@_cdecl("bjs_UncachedModel_value_get")
public func _bjs_UncachedModel_value_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = UncachedModel.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UncachedModel_value_set")
@_cdecl("bjs_UncachedModel_value_set")
public func _bjs_UncachedModel_value_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    UncachedModel.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UncachedModel_deinit")
@_cdecl("bjs_UncachedModel_deinit")
public func _bjs_UncachedModel_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<UncachedModel>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension UncachedModel: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_UncachedModel_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_UncachedModel_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_UncachedModel_wrap")
fileprivate func _bjs_UncachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_UncachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_UncachedModel_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_UncachedModel_wrap_extern(pointer)
}

@_expose(wasm, "bjs_ExplicitlyUncachedModel_init")
@_cdecl("bjs_ExplicitlyUncachedModel_init")
public func _bjs_ExplicitlyUncachedModel_init(_ count: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ExplicitlyUncachedModel(count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExplicitlyUncachedModel_count_get")
@_cdecl("bjs_ExplicitlyUncachedModel_count_get")
public func _bjs_ExplicitlyUncachedModel_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ExplicitlyUncachedModel.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExplicitlyUncachedModel_count_set")
@_cdecl("bjs_ExplicitlyUncachedModel_count_set")
public func _bjs_ExplicitlyUncachedModel_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ExplicitlyUncachedModel.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExplicitlyUncachedModel_deinit")
@_cdecl("bjs_ExplicitlyUncachedModel_deinit")
public func _bjs_ExplicitlyUncachedModel_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ExplicitlyUncachedModel>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ExplicitlyUncachedModel: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ExplicitlyUncachedModel_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_ExplicitlyUncachedModel_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ExplicitlyUncachedModel_wrap")
fileprivate func _bjs_ExplicitlyUncachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ExplicitlyUncachedModel_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_ExplicitlyUncachedModel_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_ExplicitlyUncachedModel_wrap_extern(pointer)
}