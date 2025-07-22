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

func createTS2Skeleton() -> TS2Skeleton {
    #if arch(wasm32)
    @_extern(wasm, module: "PlayBridgeJS", name: "bjs_createTS2Skeleton")
    func bjs_createTS2Skeleton() -> Int32
    #else
    func bjs_createTS2Skeleton() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_createTS2Skeleton()
    return TS2Skeleton(takingThis: ret)
}

struct TS2Skeleton {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    func convert(_ ts: String) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "PlayBridgeJS", name: "bjs_TS2Skeleton_convert")
        func bjs_TS2Skeleton_convert(_ self: Int32, _ ts: Int32) -> Int32
        #else
        func bjs_TS2Skeleton_convert(_ self: Int32, _ ts: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        var ts = ts
        let tsId = ts.withUTF8 { b in
            _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_TS2Skeleton_convert(Int32(bitPattern: self.this.id), tsId)
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

}