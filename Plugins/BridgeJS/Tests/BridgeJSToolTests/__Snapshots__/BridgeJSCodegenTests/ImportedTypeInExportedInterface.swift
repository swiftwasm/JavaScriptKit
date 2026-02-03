@_expose(wasm, "bjs_makeFoo")
@_cdecl("bjs_makeFoo")
public func _bjs_makeFoo() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try makeFoo()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Foo_init")
fileprivate func bjs_Foo_init() -> Int32
#else
fileprivate func bjs_Foo_init() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Foo_init() throws(JSException) -> JSObject {
    let ret = bjs_Foo_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}