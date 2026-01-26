#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_takesFeatureFlag")
fileprivate func bjs_takesFeatureFlag(_ flag: Int32) -> Void
#else
fileprivate func bjs_takesFeatureFlag(_ flag: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$takesFeatureFlag(_ flag: FeatureFlag) throws(JSException) -> Void {
    let flagValue = flag.bridgeJSLowerParameter()
    bjs_takesFeatureFlag(flagValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_returnsFeatureFlag")
fileprivate func bjs_returnsFeatureFlag() -> Int32
#else
fileprivate func bjs_returnsFeatureFlag() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$returnsFeatureFlag() throws(JSException) -> FeatureFlag {
    let ret = bjs_returnsFeatureFlag()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return FeatureFlag.bridgeJSLiftReturn(ret)
}