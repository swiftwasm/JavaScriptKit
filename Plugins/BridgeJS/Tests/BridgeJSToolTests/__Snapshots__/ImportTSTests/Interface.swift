// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_jsstring")
func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32
#else
func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "init_memory_with_result")
func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    fatalError("Only available on WebAssembly")
}
#endif

func returnAnimatable() -> Animatable {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
    func bjs_returnAnimatable() -> Int32
    #else
    func bjs_returnAnimatable() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_returnAnimatable()
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

    func animate(_ keyframes: JSObject, _ options: JSObject) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Animatable_animate")
        func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
        #else
        func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_Animatable_animate(Int32(bitPattern: self.this.id), Int32(bitPattern: keyframes.id), Int32(bitPattern: options.id))
        return JSObject(id: UInt32(bitPattern: ret))
    }

    func getAnimations(_ options: JSObject) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Animatable_getAnimations")
        func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
        #else
        func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_Animatable_getAnimations(Int32(bitPattern: self.this.id), Int32(bitPattern: options.id))
        return JSObject(id: UInt32(bitPattern: ret))
    }

}