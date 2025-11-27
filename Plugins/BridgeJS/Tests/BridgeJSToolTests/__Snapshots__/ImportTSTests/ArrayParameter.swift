// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArray")
func bjs_checkArray(_ a: Int32) -> Void
#else
func bjs_checkArray(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func checkArray(_ a: JSObject) throws(JSException) -> Void {
    bjs_checkArray(a.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArrayWithLength")
func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void
#else
func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func checkArrayWithLength(_ a: JSObject, _ b: Double) throws(JSException) -> Void {
    bjs_checkArrayWithLength(a.bridgeJSLowerParameter(), b.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkArray")
func bjs_checkArray(_ a: Int32) -> Void
#else
func bjs_checkArray(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func checkArray(_ a: JSObject) throws(JSException) -> Void {
    bjs_checkArray(a.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}