@_expose(wasm, "bjs_GlobalAPI_globalFunction")
@_cdecl("bjs_GlobalAPI_globalFunction")
public func _bjs_GlobalAPI_globalFunction() -> Void {
    #if arch(wasm32)
    let ret = globalFunction()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalClass_init")
@_cdecl("bjs_GlobalClass_init")
public func _bjs_GlobalClass_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = GlobalClass()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalClass_greet")
@_cdecl("bjs_GlobalClass_greet")
public func _bjs_GlobalClass_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = GlobalClass.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_GlobalClass_deinit")
@_cdecl("bjs_GlobalClass_deinit")
public func _bjs_GlobalClass_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<GlobalClass>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension GlobalClass: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_GlobalClass_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GlobalClass_wrap")
fileprivate func _bjs_GlobalClass_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_GlobalClass_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_GlobalClass_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_GlobalClass_wrap_extern(pointer)
}