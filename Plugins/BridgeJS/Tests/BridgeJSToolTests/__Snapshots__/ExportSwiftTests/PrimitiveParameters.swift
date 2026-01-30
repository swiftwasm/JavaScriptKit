@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check(_ a: Int32, _ b: Int32, _ c: Float32, _ d: Float64, _ e: Int32) -> Void {
    #if arch(wasm32)
    check(a: Int.bridgeJSLiftParameter(a), b: UInt.bridgeJSLiftParameter(b), c: Float.bridgeJSLiftParameter(c), d: Double.bridgeJSLiftParameter(d), e: Bool.bridgeJSLiftParameter(e))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}