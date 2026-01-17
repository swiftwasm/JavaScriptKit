#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
fileprivate func bjs_returnAnimatable() -> Int32
#else
fileprivate func bjs_returnAnimatable() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$returnAnimatable() throws(JSException) -> Animatable {
    let ret = bjs_returnAnimatable()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Animatable.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Animatable_animate")
fileprivate func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Animatable_getAnimations")
fileprivate func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Animatable_animate(_ self: JSObject, _ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let keyframesValue = keyframes.bridgeJSLowerParameter()
    let optionsValue = options.bridgeJSLowerParameter()
    let ret = bjs_Animatable_animate(selfValue, keyframesValue, optionsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Animatable_getAnimations(_ self: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let optionsValue = options.bridgeJSLowerParameter()
    let ret = bjs_Animatable_getAnimations(selfValue, optionsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}