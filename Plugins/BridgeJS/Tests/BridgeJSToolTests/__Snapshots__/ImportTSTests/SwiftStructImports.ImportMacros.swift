#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_translate")
fileprivate func bjs_translate(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32
#else
fileprivate func bjs_translate(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$translate(_ point: Point, _ dx: Int, _ dy: Int) throws(JSException) -> Point {
    let pointObjectId = point.bridgeJSLowerParameter()
    let dxValue = dx.bridgeJSLowerParameter()
    let dyValue = dy.bridgeJSLowerParameter()
    let ret = bjs_translate(pointObjectId, dxValue, dyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Point.bridgeJSLiftReturn(ret)
}