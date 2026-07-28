#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_roundtrip")
fileprivate func bjs_roundtrip_extern() -> Void
#else
fileprivate func bjs_roundtrip_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_roundtrip() -> Void {
    return bjs_roundtrip_extern()
}

func _$roundtrip(_ items: [Int]) throws(JSException) -> [Int] {
    let _ = items.bridgeJSLowerParameter()
    bjs_roundtrip()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_logStrings")
fileprivate func bjs_logStrings_extern() -> Void
#else
fileprivate func bjs_logStrings_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_logStrings() -> Void {
    return bjs_logStrings_extern()
}

func _$logStrings(_ items: [String]) throws(JSException) -> Void {
    let _ = items.bridgeJSLowerParameter()
    bjs_logStrings()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_optionalArrayThenArray")
fileprivate func bjs_optionalArrayThenArray_extern(_ a: Int32) -> Int32
#else
fileprivate func bjs_optionalArrayThenArray_extern(_ a: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_optionalArrayThenArray(_ a: Int32) -> Int32 {
    return bjs_optionalArrayThenArray_extern(a)
}

func _$optionalArrayThenArray(_ a: Optional<[Int]>, _ b: [Int]) throws(JSException) -> Int {
    let _ = b.bridgeJSLowerParameter()
    let aIsSome = a.bridgeJSLowerParameter()
    let ret = bjs_optionalArrayThenArray(aIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_borrowedStringAroundStackParams")
fileprivate func bjs_borrowedStringAroundStackParams_extern(_ sBytes: Int32, _ sLength: Int32, _ a: Int32) -> Int32
#else
fileprivate func bjs_borrowedStringAroundStackParams_extern(_ sBytes: Int32, _ sLength: Int32, _ a: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_borrowedStringAroundStackParams(_ sBytes: Int32, _ sLength: Int32, _ a: Int32) -> Int32 {
    return bjs_borrowedStringAroundStackParams_extern(sBytes, sLength, a)
}

func _$borrowedStringAroundStackParams(_ s: String, _ a: Optional<[Int]>, _ b: [Int]) throws(JSException) -> Int {
    let ret0 = s.bridgeJSWithLoweredParameter { (sBytes, sLength) in
        let _ = b.bridgeJSLowerParameter()
        let aIsSome = a.bridgeJSLowerParameter()
        let ret = bjs_borrowedStringAroundStackParams(sBytes, sLength, aIsSome)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}