@_expose(wasm, "bjs_makeBench")
@_cdecl("bjs_makeBench")
public func _bjs_makeBench() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeBench()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Workshop_Bench_init")
@_cdecl("bjs_Workshop_Bench_init")
public func _bjs_Workshop_Bench_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Workshop.Bench()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Workshop_Bench_deinit")
@_cdecl("bjs_Workshop_Bench_deinit")
public func _bjs_Workshop_Bench_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Workshop.Bench>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Workshop.Bench: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Workshop_Bench_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Workshop_Bench_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Workshop_Bench_wrap")
fileprivate func _bjs_Workshop_Bench_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Workshop_Bench_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Workshop_Bench_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Workshop_Bench_wrap_extern(pointer)
}