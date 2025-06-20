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

func asyncReturnVoid() -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncReturnVoid")
    func bjs_asyncReturnVoid() -> Int32
    #else
    func bjs_asyncReturnVoid() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncReturnVoid()
    return JSPromise(takingThis: ret)
}

func asyncRoundTripInt(_ v: Double) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripInt")
    func bjs_asyncRoundTripInt(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripInt(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripInt(v)
    return JSPromise(takingThis: ret)
}

func asyncRoundTripString(_ v: String) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripString")
    func bjs_asyncRoundTripString(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripString(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var v = v
    let vId = v.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_asyncRoundTripString(vId)
    return JSPromise(takingThis: ret)
}

func asyncRoundTripBool(_ v: Bool) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripBool")
    func bjs_asyncRoundTripBool(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripBool(Int32(v ? 1 : 0))
    return JSPromise(takingThis: ret)
}

func asyncRoundTripFloat(_ v: Double) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripFloat")
    func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripFloat(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripFloat(v)
    return JSPromise(takingThis: ret)
}

func asyncRoundTripDouble(_ v: Double) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripDouble")
    func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32
    #else
    func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripDouble(v)
    return JSPromise(takingThis: ret)
}

func asyncRoundTripJSObject(_ v: JSObject) -> JSPromise {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_asyncRoundTripJSObject")
    func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32
    #else
    func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_asyncRoundTripJSObject(Int32(bitPattern: v.id))
    return JSPromise(takingThis: ret)
}