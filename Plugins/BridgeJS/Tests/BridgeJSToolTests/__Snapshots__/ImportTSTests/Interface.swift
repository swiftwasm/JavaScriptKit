// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func returnAnimatable() throws(JSException) -> Animatable {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
    func bjs_returnAnimatable() -> Int32
    #else
    func bjs_returnAnimatable() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_returnAnimatable()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Animatable(takingThis: ret)
}

struct Animatable {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    func animate(_ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Animatable_animate")
        func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
        #else
        func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_Animatable_animate(Int32(bitPattern: self.this.id), Int32(bitPattern: keyframes.id), Int32(bitPattern: options.id))
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject(id: UInt32(bitPattern: ret))
    }

    func getAnimations(_ options: JSObject) throws(JSException) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Animatable_getAnimations")
        func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
        #else
        func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_Animatable_getAnimations(Int32(bitPattern: self.this.id), Int32(bitPattern: options.id))
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject(id: UInt32(bitPattern: ret))
    }

}