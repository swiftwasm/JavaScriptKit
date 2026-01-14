// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoop")
fileprivate func bjs_benchmarkHelperNoop() -> Void
#else
fileprivate func bjs_benchmarkHelperNoop() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func benchmarkHelperNoop() throws(JSException) -> Void {
    bjs_benchmarkHelperNoop()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoopWithNumber")
fileprivate func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void
#else
fileprivate func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func benchmarkHelperNoopWithNumber(_ n: Double) throws(JSException) -> Void {
    let nValue = n.bridgeJSLowerParameter()
    bjs_benchmarkHelperNoopWithNumber(nValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkRunner")
fileprivate func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void
#else
fileprivate func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func benchmarkRunner(_ name: String, _ body: JSObject) throws(JSException) -> Void {
    let nameValue = name.bridgeJSLowerParameter()
    let bodyValue = body.bridgeJSLowerParameter()
    bjs_benchmarkRunner(nameValue, bodyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}