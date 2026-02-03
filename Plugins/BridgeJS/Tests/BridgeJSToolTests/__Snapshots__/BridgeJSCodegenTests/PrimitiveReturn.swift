@_expose(wasm, "bjs_checkInt")
@_cdecl("bjs_checkInt")
public func _bjs_checkInt() -> Int32 {
    #if arch(wasm32)
    let ret = checkInt()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkUInt")
@_cdecl("bjs_checkUInt")
public func _bjs_checkUInt() -> Int32 {
    #if arch(wasm32)
    let ret = checkUInt()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkFloat")
@_cdecl("bjs_checkFloat")
public func _bjs_checkFloat() -> Float32 {
    #if arch(wasm32)
    let ret = checkFloat()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkDouble")
@_cdecl("bjs_checkDouble")
public func _bjs_checkDouble() -> Float64 {
    #if arch(wasm32)
    let ret = checkDouble()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkBool")
@_cdecl("bjs_checkBool")
public func _bjs_checkBool() -> Int32 {
    #if arch(wasm32)
    let ret = checkBool()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkNumber")
fileprivate func bjs_checkNumber() -> Float64
#else
fileprivate func bjs_checkNumber() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkNumber() throws(JSException) -> Double {
    let ret = bjs_checkNumber()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkBoolean")
fileprivate func bjs_checkBoolean() -> Int32
#else
fileprivate func bjs_checkBoolean() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$checkBoolean() throws(JSException) -> Bool {
    let ret = bjs_checkBoolean()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}