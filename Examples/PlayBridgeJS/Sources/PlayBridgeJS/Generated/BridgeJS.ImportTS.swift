// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func createTS2Skeleton() throws(JSException) -> TS2Skeleton {
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

    func convert(_ ts: String) throws(JSException) -> String {
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
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_TS2Skeleton_convert(Int32(bitPattern: self.this.id), tsId)
        return String(unsafeUninitializedCapacity: Int(ret)) { b in
            _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
            return Int(ret)
        }
    }

}