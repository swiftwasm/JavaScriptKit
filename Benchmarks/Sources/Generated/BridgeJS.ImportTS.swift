// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func benchmarkHelperNoop() throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoop")
    func bjs_benchmarkHelperNoop() -> Void
    #else
    func bjs_benchmarkHelperNoop() -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_benchmarkHelperNoop()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func benchmarkHelperNoopWithNumber(_ n: Double) throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoopWithNumber")
    func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void
    #else
    func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_benchmarkHelperNoopWithNumber(n)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func benchmarkRunner(_ name: String, _ body: JSObject) throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkRunner")
    func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void
    #else
    func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_benchmarkRunner(name.bridgeJSLowerParameter(), body.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
}