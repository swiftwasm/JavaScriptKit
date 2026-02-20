@_expose(wasm, "bjs_plainFunction")
@_cdecl("bjs_plainFunction")
public func _bjs_plainFunction() -> Void {
    #if arch(wasm32)
    let ret = plainFunction()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyModule_Utils_namespacedFunction")
@_cdecl("bjs_MyModule_Utils_namespacedFunction")
public func _bjs_MyModule_Utils_namespacedFunction() -> Void {
    #if arch(wasm32)
    let ret = namespacedFunction()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Greeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_wrap")
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Greeter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Converter_init")
@_cdecl("bjs_Converter_init")
public func _bjs_Converter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Converter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_toString")
@_cdecl("bjs_Converter_toString")
public func _bjs_Converter_toString(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = Converter.bridgeJSLiftParameter(_self).toString(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_deinit")
@_cdecl("bjs_Converter_deinit")
public func _bjs_Converter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Converter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Converter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Converter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Converter_wrap")
fileprivate func _bjs_Converter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Converter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Converter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Converter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_UUID_uuidString")
@_cdecl("bjs_UUID_uuidString")
public func _bjs_UUID_uuidString(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = UUID.bridgeJSLiftParameter(_self).uuidString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UUID_deinit")
@_cdecl("bjs_UUID_deinit")
public func _bjs_UUID_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<UUID>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension UUID: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_UUID_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_UUID_wrap")
fileprivate func _bjs_UUID_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_UUID_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_UUID_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_UUID_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Container_init")
@_cdecl("bjs_Container_init")
public func _bjs_Container_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Container()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_getItems")
@_cdecl("bjs_Container_getItems")
public func _bjs_Container_getItems(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Container.bridgeJSLiftParameter(_self).getItems()
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_addItem")
@_cdecl("bjs_Container_addItem")
public func _bjs_Container_addItem(_ _self: UnsafeMutableRawPointer, _ item: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Container.bridgeJSLiftParameter(_self).addItem(_: Greeter.bridgeJSLiftParameter(item))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_deinit")
@_cdecl("bjs_Container_deinit")
public func _bjs_Container_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Container>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Container: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Container_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Container_wrap")
fileprivate func _bjs_Container_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Container_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Container_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Container_wrap_extern(pointer)
}