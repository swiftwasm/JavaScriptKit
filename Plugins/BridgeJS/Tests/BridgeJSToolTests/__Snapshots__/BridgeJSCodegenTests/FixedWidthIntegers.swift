@_expose(wasm, "bjs_roundTripInt8")
@_cdecl("bjs_roundTripInt8")
public func _bjs_roundTripInt8(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt8(_: Int8.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUInt8")
@_cdecl("bjs_roundTripUInt8")
public func _bjs_roundTripUInt8(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripUInt8(_: UInt8.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt16")
@_cdecl("bjs_roundTripInt16")
public func _bjs_roundTripInt16(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt16(_: Int16.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUInt16")
@_cdecl("bjs_roundTripUInt16")
public func _bjs_roundTripUInt16(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripUInt16(_: UInt16.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt32")
@_cdecl("bjs_roundTripInt32")
public func _bjs_roundTripInt32(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt32(_: Int32.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUInt32")
@_cdecl("bjs_roundTripUInt32")
public func _bjs_roundTripUInt32(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripUInt32(_: UInt32.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt64")
@_cdecl("bjs_roundTripInt64")
public func _bjs_roundTripInt64(_ v: Int64) -> Int64 {
    #if arch(wasm32)
    let ret = roundTripInt64(_: Int64.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUInt64")
@_cdecl("bjs_roundTripUInt64")
public func _bjs_roundTripUInt64(_ v: Int64) -> Int64 {
    #if arch(wasm32)
    let ret = roundTripUInt64(_: UInt64.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripInt8")
fileprivate func bjs_roundTripInt8_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripInt8_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripInt8(_ v: Int32) -> Int32 {
    return bjs_roundTripInt8_extern(v)
}

func _$roundTripInt8(_ v: Int8) throws(JSException) -> Int8 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripInt8(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int8.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripUInt8")
fileprivate func bjs_roundTripUInt8_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripUInt8_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripUInt8(_ v: Int32) -> Int32 {
    return bjs_roundTripUInt8_extern(v)
}

func _$roundTripUInt8(_ v: UInt8) throws(JSException) -> UInt8 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripUInt8(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UInt8.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripInt16")
fileprivate func bjs_roundTripInt16_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripInt16_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripInt16(_ v: Int32) -> Int32 {
    return bjs_roundTripInt16_extern(v)
}

func _$roundTripInt16(_ v: Int16) throws(JSException) -> Int16 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripInt16(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int16.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripUInt16")
fileprivate func bjs_roundTripUInt16_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripUInt16_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripUInt16(_ v: Int32) -> Int32 {
    return bjs_roundTripUInt16_extern(v)
}

func _$roundTripUInt16(_ v: UInt16) throws(JSException) -> UInt16 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripUInt16(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UInt16.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripInt32")
fileprivate func bjs_roundTripInt32_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripInt32_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripInt32(_ v: Int32) -> Int32 {
    return bjs_roundTripInt32_extern(v)
}

func _$roundTripInt32(_ v: Int32) throws(JSException) -> Int32 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripInt32(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int32.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripUInt32")
fileprivate func bjs_roundTripUInt32_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_roundTripUInt32_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripUInt32(_ v: Int32) -> Int32 {
    return bjs_roundTripUInt32_extern(v)
}

func _$roundTripUInt32(_ v: UInt32) throws(JSException) -> UInt32 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripUInt32(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UInt32.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripInt64")
fileprivate func bjs_roundTripInt64_extern(_ v: Int64) -> Int64
#else
fileprivate func bjs_roundTripInt64_extern(_ v: Int64) -> Int64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripInt64(_ v: Int64) -> Int64 {
    return bjs_roundTripInt64_extern(v)
}

func _$roundTripInt64(_ v: Int64) throws(JSException) -> Int64 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripInt64(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int64.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundTripUInt64")
fileprivate func bjs_roundTripUInt64_extern(_ v: Int64) -> Int64
#else
fileprivate func bjs_roundTripUInt64_extern(_ v: Int64) -> Int64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundTripUInt64(_ v: Int64) -> Int64 {
    return bjs_roundTripUInt64_extern(v)
}

func _$roundTripUInt64(_ v: UInt64) throws(JSException) -> UInt64 {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_roundTripUInt64(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UInt64.bridgeJSLiftReturn(ret)
}