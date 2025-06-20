// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "return_string")
private func _return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
@_extern(wasm, module: "bjs", name: "init_memory")
private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)

@_extern(wasm, module: "bjs", name: "swift_js_retain")
private func _swift_js_retain(_ ptr: Int32) -> Int32
@_extern(wasm, module: "bjs", name: "swift_js_throw")
private func _swift_js_throw(_ id: Int32)
#endif

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