@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check(_ a: Int32, _ b: Int32, _ c: Float32, _ d: Float64, _ e: Int32) -> Void {
    #if arch(wasm32)
    check(a: Int.bridgeJSLiftParameter(a), b: UInt.bridgeJSLiftParameter(b), c: Float.bridgeJSLiftParameter(c), d: Double.bridgeJSLiftParameter(d), e: Bool.bridgeJSLiftParameter(e))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_check")
fileprivate func bjs_check_extern(_ a: Float64, _ b: Int32) -> Void
#else
fileprivate func bjs_check_extern(_ a: Float64, _ b: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_check(_ a: Float64, _ b: Int32) -> Void {
    return bjs_check_extern(a, b)
}

func _$check(_ a: Double, _ b: Bool) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    let bValue = b.bridgeJSLowerParameter()
    bjs_check(aValue, bValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}