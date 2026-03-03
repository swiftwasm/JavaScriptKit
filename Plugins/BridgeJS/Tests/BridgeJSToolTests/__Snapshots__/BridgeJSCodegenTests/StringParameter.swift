@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    checkString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripString")
@_cdecl("bjs_roundtripString")
public func _bjs_roundtripString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkString")
fileprivate func bjs_checkString_extern(_ aBytes: Int32, _ aLength: Int32) -> Void
#else
fileprivate func bjs_checkString_extern(_ aBytes: Int32, _ aLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_checkString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    return bjs_checkString_extern(aBytes, aLength)
}

func _$checkString(_ a: String) throws(JSException) -> Void {
    _swift_js_with_borrowed_utf8(a) { aBytes, aLength in
        bjs_checkString(aBytes, aLength)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkStringWithLength")
fileprivate func bjs_checkStringWithLength_extern(_ aBytes: Int32, _ aLength: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkStringWithLength_extern(_ aBytes: Int32, _ aLength: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_checkStringWithLength(_ aBytes: Int32, _ aLength: Int32, _ b: Float64) -> Void {
    return bjs_checkStringWithLength_extern(aBytes, aLength, b)
}

func _$checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void {
    let bValue = b.bridgeJSLowerParameter()
    _swift_js_with_borrowed_utf8(a) { aBytes, aLength in
        bjs_checkStringWithLength(aBytes, aLength, bValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}