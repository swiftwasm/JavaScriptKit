@_expose(wasm, "bjs_ClassA_linkedB_get")
@_cdecl("bjs_ClassA_linkedB_get")
public func _bjs_ClassA_linkedB_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ClassA.bridgeJSLiftParameter(_self).linkedB
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassA_linkedB_set")
@_cdecl("bjs_ClassA_linkedB_set")
public func _bjs_ClassA_linkedB_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valuePointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    ClassA.bridgeJSLiftParameter(_self).linkedB = Optional<ClassB>.bridgeJSLiftParameter(valueIsSome, valuePointer)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassA_deinit")
@_cdecl("bjs_ClassA_deinit")
public func _bjs_ClassA_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ClassA>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ClassA: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClassA_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ClassA_wrap")
fileprivate func _bjs_ClassA_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClassA_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ClassB_init")
@_cdecl("bjs_ClassB_init")
public func _bjs_ClassB_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ClassB()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClassB_deinit")
@_cdecl("bjs_ClassB_deinit")
public func _bjs_ClassB_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ClassB>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ClassB: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClassB_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ClassB_wrap")
fileprivate func _bjs_ClassB_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClassB_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif