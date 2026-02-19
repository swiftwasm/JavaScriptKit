@_expose(wasm, "bjs_PrivateAPI_privateFunction")
@_cdecl("bjs_PrivateAPI_privateFunction")
public func _bjs_PrivateAPI_privateFunction() -> Void {
    #if arch(wasm32)
    let ret = privateFunction()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PrivateClass_init")
@_cdecl("bjs_PrivateClass_init")
public func _bjs_PrivateClass_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PrivateClass()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PrivateClass_greet")
@_cdecl("bjs_PrivateClass_greet")
public func _bjs_PrivateClass_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PrivateClass.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PrivateClass_deinit")
@_cdecl("bjs_PrivateClass_deinit")
public func _bjs_PrivateClass_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PrivateClass>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PrivateClass: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PrivateClass_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_PrivateClass_wrap")
fileprivate func _bjs_PrivateClass_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PrivateClass_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PrivateClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PrivateClass_wrap_extern(pointer)
}