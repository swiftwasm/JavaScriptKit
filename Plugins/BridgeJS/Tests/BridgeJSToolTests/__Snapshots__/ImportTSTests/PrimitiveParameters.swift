// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_check")
fileprivate func bjs_check(_ a: Float64, _ b: Int32) -> Void
#else
fileprivate func bjs_check(_ a: Float64, _ b: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func check(_ a: Double, _ b: Bool) throws(JSException) -> Void {
    let aValue = a.bridgeJSLowerParameter()
    let bValue = b.bridgeJSLowerParameter()
    bjs_check(aValue, bValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}