@_expose(wasm, "bjs_checkJSString")
@_cdecl("bjs_checkJSString")
public func _bjs_checkJSString(_ a: Int32) -> Void {
    #if arch(wasm32)
    checkJSString(a: JSString.bridgeJSLiftParameter(a))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getJSString")
@_cdecl("bjs_getJSString")
public func _bjs_getJSString() -> Int32 {
    #if arch(wasm32)
    let ret = getJSString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSString")
@_cdecl("bjs_roundTripJSString")
public func _bjs_roundTripJSString(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSString(_: JSString.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsCheckJSString")
fileprivate func bjs_jsCheckJSString_extern(_ a: Int32) -> Void
#else
fileprivate func bjs_jsCheckJSString_extern(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsCheckJSString(_ a: Int32) -> Void {
    return bjs_jsCheckJSString_extern(a)
}

func _$jsCheckJSString(_ a: JSString) throws(JSException) -> Void {
    a.bridgeJSWithLoweredParameter { aValue in
        bjs_jsCheckJSString(aValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsGetJSString")
fileprivate func bjs_jsGetJSString_extern() -> Int32
#else
fileprivate func bjs_jsGetJSString_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsGetJSString() -> Int32 {
    return bjs_jsGetJSString_extern()
}

func _$jsGetJSString() throws(JSException) -> JSString {
    let ret = bjs_jsGetJSString()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSString.bridgeJSLiftReturn(ret)
}