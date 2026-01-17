@_expose(wasm, "bjs_throwsSomething")
@_cdecl("bjs_throwsSomething")
public func _bjs_throwsSomething() -> Void {
    #if arch(wasm32)
    do {
        try throwsSomething()
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
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}