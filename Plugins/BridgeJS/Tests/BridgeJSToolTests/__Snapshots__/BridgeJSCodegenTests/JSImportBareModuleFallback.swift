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
fileprivate func bjs_joinPaths_extern(_ lhsWord0: Int32, _ lhsWord1: Int32, _ lhsWord2: Int32, _ rhsWord0: Int32, _ rhsWord1: Int32, _ rhsWord2: Int32) -> Int32
#else
fileprivate func bjs_joinPaths_extern(_ lhsWord0: Int32, _ lhsWord1: Int32, _ lhsWord2: Int32, _ rhsWord0: Int32, _ rhsWord1: Int32, _ rhsWord2: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_joinPaths(_ lhsWord0: Int32, _ lhsWord1: Int32, _ lhsWord2: Int32, _ rhsWord0: Int32, _ rhsWord1: Int32, _ rhsWord2: Int32) -> Int32 {
    return bjs_joinPaths_extern(lhsWord0, lhsWord1, lhsWord2, rhsWord0, rhsWord1, rhsWord2)
}

func _$joinPaths(_ lhs: String, _ rhs: String) throws(JSException) -> String {
    let ret0 = lhs.bridgeJSWithLoweredParameter { (lhsWord0, lhsWord1, lhsWord2) in
        let ret1 = rhs.bridgeJSWithLoweredParameter { (rhsWord0, rhsWord1, rhsWord2) in
            let ret = bjs_joinPaths(lhsWord0, lhsWord1, lhsWord2, rhsWord0, rhsWord1, rhsWord2)
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