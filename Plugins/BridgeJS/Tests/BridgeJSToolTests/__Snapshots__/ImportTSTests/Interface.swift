// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

@_extern(wasm, module: "bjs", name: "make_jsstring")
private func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32

@_extern(wasm, module: "bjs", name: "init_memory_with_result")
private func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)

@_extern(wasm, module: "bjs", name: "free_jsobject")
private func _free_jsobject(_ ptr: Int32) -> Void

func returnAnimatable() -> Animatable {
    @_extern(wasm, module: "Check", name: "bjs_returnAnimatable")
    func bjs_returnAnimatable() -> Int32
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
        @_extern(wasm, module: "Check", name: "bjs_Animatable_animate")
        func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
        let ret = bjs_Animatable_animate(Int32(bitPattern: self.this.id), Int32(bitPattern: keyframes.id), Int32(bitPattern: options.id))
        return JSObject(id: UInt32(bitPattern: ret))
    }

    func getAnimations(_ options: JSObject) -> JSObject {
        @_extern(wasm, module: "Check", name: "bjs_Animatable_getAnimations")
        func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
        let ret = bjs_Animatable_getAnimations(Int32(bitPattern: self.this.id), Int32(bitPattern: options.id))
        return JSObject(id: UInt32(bitPattern: ret))
    }

}