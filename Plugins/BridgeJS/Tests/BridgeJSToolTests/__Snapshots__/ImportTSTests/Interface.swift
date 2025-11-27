// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
func bjs_returnAnimatable() -> Int32
#else
func bjs_returnAnimatable() -> Int32 {
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
func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
#else
func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Animatable_getAnimations")
func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
#else
func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

struct Animatable: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    func animate(_ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
        let ret = bjs_Animatable_animate(self.bridgeJSLowerParameter(), keyframes.bridgeJSLowerParameter(), options.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

    func getAnimations(_ options: JSObject) throws(JSException) -> JSObject {
        let ret = bjs_Animatable_getAnimations(self.bridgeJSLowerParameter(), options.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

}