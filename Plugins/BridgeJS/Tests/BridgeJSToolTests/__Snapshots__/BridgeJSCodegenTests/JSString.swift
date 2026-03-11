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

@_expose(wasm, "bjs_checkOptionalJSString")
@_cdecl("bjs_checkOptionalJSString")
public func _bjs_checkOptionalJSString(_ a: Int32) -> Void {
    #if arch(wasm32)
    checkOptionalJSString(a: Optional<JSString>.bridgeJSLiftParameter(a))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getOptionalJSString")
@_cdecl("bjs_getOptionalJSString")
public func _bjs_getOptionalJSString() -> Int32 {
    #if arch(wasm32)
    let ret = getOptionalJSString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSString")
@_cdecl("bjs_roundTripOptionalJSString")
public func _bjs_roundTripOptionalJSString(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripOptionalJSString(_: Optional<JSString>.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_checkUndefinedOrJSString")
@_cdecl("bjs_checkUndefinedOrJSString")
public func _bjs_checkUndefinedOrJSString(_ a: Int32) -> Void {
    #if arch(wasm32)
    checkUndefinedOrJSString(a: JSUndefinedOr<JSString>.bridgeJSLiftParameter(a))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getUndefinedOrJSString")
@_cdecl("bjs_getUndefinedOrJSString")
public func _bjs_getUndefinedOrJSString() -> Int32 {
    #if arch(wasm32)
    let ret = getUndefinedOrJSString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUndefinedOrJSString")
@_cdecl("bjs_roundTripUndefinedOrJSString")
public func _bjs_roundTripUndefinedOrJSString(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripUndefinedOrJSString(_: JSUndefinedOr<JSString>.bridgeJSLiftParameter(value))
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

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsCheckOptionalJSString")
fileprivate func bjs_jsCheckOptionalJSString_extern(_ a: Int32) -> Void
#else
fileprivate func bjs_jsCheckOptionalJSString_extern(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsCheckOptionalJSString(_ a: Int32) -> Void {
    return bjs_jsCheckOptionalJSString_extern(a)
}

func _$jsCheckOptionalJSString(_ a: Optional<JSString>) throws(JSException) -> Void {
    a.bridgeJSWithLoweredParameter { aValue in
        bjs_jsCheckOptionalJSString(aValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsGetOptionalJSString")
fileprivate func bjs_jsGetOptionalJSString_extern() -> Int32
#else
fileprivate func bjs_jsGetOptionalJSString_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsGetOptionalJSString() -> Int32 {
    return bjs_jsGetOptionalJSString_extern()
}

func _$jsGetOptionalJSString() throws(JSException) -> Optional<JSString> {
    let ret = bjs_jsGetOptionalJSString()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<JSString>.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsCheckUndefinedOrJSString")
fileprivate func bjs_jsCheckUndefinedOrJSString_extern(_ a: Int32) -> Void
#else
fileprivate func bjs_jsCheckUndefinedOrJSString_extern(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsCheckUndefinedOrJSString(_ a: Int32) -> Void {
    return bjs_jsCheckUndefinedOrJSString_extern(a)
}

func _$jsCheckUndefinedOrJSString(_ a: JSUndefinedOr<JSString>) throws(JSException) -> Void {
    a.bridgeJSWithLoweredParameter { aValue in
        bjs_jsCheckUndefinedOrJSString(aValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_jsGetUndefinedOrJSString")
fileprivate func bjs_jsGetUndefinedOrJSString_extern() -> Int32
#else
fileprivate func bjs_jsGetUndefinedOrJSString_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsGetUndefinedOrJSString() -> Int32 {
    return bjs_jsGetUndefinedOrJSString_extern()
}

func _$jsGetUndefinedOrJSString() throws(JSException) -> JSUndefinedOr<JSString> {
    let ret = bjs_jsGetUndefinedOrJSString()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<JSString>.bridgeJSLiftReturn(ret)
}