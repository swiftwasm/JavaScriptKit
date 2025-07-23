// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func benchmarkHelperNoop() -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoop")
    func bjs_benchmarkHelperNoop() -> Void
    #else
    func bjs_benchmarkHelperNoop() -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_benchmarkHelperNoop()
}

func benchmarkHelperNoopWithNumber(_ n: Double) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoopWithNumber")
    func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void
    #else
    func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_benchmarkHelperNoopWithNumber(n)
}

func benchmarkRunner(_ name: String, _ body: JSObject) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkRunner")
    func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void
    #else
    func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var name = name
    let nameId = name.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_benchmarkRunner(nameId, Int32(bitPattern: body.id))
}