@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    let a = String.bridgeJSLiftParameter(aBytes, aLength)
    checkString(a: a)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripString")
@_cdecl("bjs_roundtripString")
public func _bjs_roundtripString(_ aBytes: Int32, _ aLength: Int32) -> Void {
    #if arch(wasm32)
    let a = String.bridgeJSLiftParameter(aBytes, aLength)
    let ret = roundtripString(a: a)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkString")
fileprivate func bjs_checkString_extern(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32) -> Void
#else
fileprivate func bjs_checkString_extern(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_checkString(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32) -> Void {
    return bjs_checkString_extern(aWord0, aWord1, aWord2)
}

func _$checkString(_ a: String) throws(JSException) -> Void {
    a.bridgeJSWithLoweredParameter { (aWord0, aWord1, aWord2) in
        bjs_checkString(aWord0, aWord1, aWord2)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_checkStringWithLength")
fileprivate func bjs_checkStringWithLength_extern(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkStringWithLength_extern(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_checkStringWithLength(_ aWord0: Int32, _ aWord1: Int32, _ aWord2: Int32, _ b: Float64) -> Void {
    return bjs_checkStringWithLength_extern(aWord0, aWord1, aWord2, b)
}

func _$checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void {
    a.bridgeJSWithLoweredParameter { (aWord0, aWord1, aWord2) in
        let bValue = b.bridgeJSLowerParameter()
        bjs_checkStringWithLength(aWord0, aWord1, aWord2, bValue)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}