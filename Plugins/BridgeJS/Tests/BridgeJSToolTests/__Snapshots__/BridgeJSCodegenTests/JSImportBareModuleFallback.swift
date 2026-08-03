#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_dashedProperty_get")
fileprivate func bjs_dashedProperty_get_extern() -> Int32
#else
fileprivate func bjs_dashedProperty_get_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_dashedProperty_get() -> Int32 {
    return bjs_dashedProperty_get_extern()
}

func _$dashedProperty_get() throws(JSException) -> String {
    let ret = bjs_dashedProperty_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_kebabCaseFunction")
fileprivate func bjs_kebabCaseFunction_extern() -> Int32
#else
fileprivate func bjs_kebabCaseFunction_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_kebabCaseFunction() -> Int32 {
    return bjs_kebabCaseFunction_extern()
}

func _$kebabCaseFunction() throws(JSException) -> Int {
    let ret = bjs_kebabCaseFunction()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_joinPaths")
fileprivate func bjs_joinPaths_extern(_ lhsBytes: Int32, _ lhsLength: Int32, _ rhsBytes: Int32, _ rhsLength: Int32) -> Int32
#else
fileprivate func bjs_joinPaths_extern(_ lhsBytes: Int32, _ lhsLength: Int32, _ rhsBytes: Int32, _ rhsLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_joinPaths(_ lhsBytes: Int32, _ lhsLength: Int32, _ rhsBytes: Int32, _ rhsLength: Int32) -> Int32 {
    return bjs_joinPaths_extern(lhsBytes, lhsLength, rhsBytes, rhsLength)
}

func _$joinPaths(_ lhs: String, _ rhs: String) throws(JSException) -> String {
    let ret0 = lhs.bridgeJSWithLoweredParameter { (lhsBytes, lhsLength) in
        let ret1 = rhs.bridgeJSWithLoweredParameter { (rhsBytes, rhsLength) in
            let ret = bjs_joinPaths(lhsBytes, lhsLength, rhsBytes, rhsLength)
            return ret
        }
        return ret1
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}