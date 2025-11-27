// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkString")
fileprivate func bjs_checkString(_ a: Int32) -> Void
#else
fileprivate func bjs_checkString(_ a: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func checkString(_ a: String) throws(JSException) -> Void {
    bjs_checkString(a.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkStringWithLength")
fileprivate func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void
#else
fileprivate func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void {
    bjs_checkStringWithLength(a.bridgeJSLowerParameter(), b.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}