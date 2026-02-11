@_expose(wasm, "bjs_mirrorDictionary")
@_cdecl("bjs_mirrorDictionary")
public func _bjs_mirrorDictionary() -> Void {
    #if arch(wasm32)
    let ret = mirrorDictionary(_: [String: Int].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_optionalDictionary")
@_cdecl("bjs_optionalDictionary")
public func _bjs_optionalDictionary() -> Void {
    #if arch(wasm32)
    let ret = optionalDictionary(_: Optional<[String: String]>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_nestedDictionary")
@_cdecl("bjs_nestedDictionary")
public func _bjs_nestedDictionary() -> Void {
    #if arch(wasm32)
    let ret = nestedDictionary(_: [String: [Int]].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_boxDictionary")
@_cdecl("bjs_boxDictionary")
public func _bjs_boxDictionary() -> Void {
    #if arch(wasm32)
    let ret = boxDictionary(_: [String: Box].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_optionalBoxDictionary")
@_cdecl("bjs_optionalBoxDictionary")
public func _bjs_optionalBoxDictionary() -> Void {
    #if arch(wasm32)
    let ret = optionalBoxDictionary(_: [String: Optional<Box>].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Box_deinit")
@_cdecl("bjs_Box_deinit")
public func _bjs_Box_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Box>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Box: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Box_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Box_wrap")
fileprivate func _bjs_Box_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Box_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_importMirrorDictionary")
fileprivate func bjs_importMirrorDictionary() -> Void
#else
fileprivate func bjs_importMirrorDictionary() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$importMirrorDictionary(_ values: [String: Double]) throws(JSException) -> [String: Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_importMirrorDictionary()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Double].bridgeJSLiftReturn()
}