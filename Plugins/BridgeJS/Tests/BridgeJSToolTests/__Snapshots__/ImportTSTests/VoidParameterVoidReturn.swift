// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_check")
func bjs_check() -> Void
#else
func bjs_check() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func check() throws(JSException) -> Void {
    bjs_check()
    if let error = _swift_js_take_exception() {
        throw error
    }
}