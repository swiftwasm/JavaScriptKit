// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
fileprivate func bjs_returnAnimatable() -> Int32
#else
fileprivate func bjs_returnAnimatable() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func returnAnimatable() throws(JSException) -> Animatable {
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

struct Animatable: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    func animate(_ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
        let selfValue = self.bridgeJSLowerParameter()
        let keyframesValue = keyframes.bridgeJSLowerParameter()
        let optionsValue = options.bridgeJSLowerParameter()
        let ret = bjs_Animatable_animate(selfValue, keyframesValue, optionsValue)
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

    func getAnimations(_ options: JSObject) throws(JSException) -> JSObject {
        let selfValue = self.bridgeJSLowerParameter()
        let optionsValue = options.bridgeJSLowerParameter()
        let ret = bjs_Animatable_getAnimations(selfValue, optionsValue)
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

}