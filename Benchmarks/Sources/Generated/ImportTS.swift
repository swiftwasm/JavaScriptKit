// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(JSObject_id) import JavaScriptKit

@_extern(wasm, module: "bjs", name: "make_jsstring")
private func _make_jsstring(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32

@_extern(wasm, module: "bjs", name: "init_memory_with_result")
private func _init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)

@_extern(wasm, module: "bjs", name: "free_jsobject")
private func _free_jsobject(_ ptr: Int32) -> Void

func benchmarkHelperNoop() -> Void {
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoop")
    func bjs_benchmarkHelperNoop() -> Void
    bjs_benchmarkHelperNoop()
}

func benchmarkHelperNoopWithNumber(_ n: Double) -> Void {
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkHelperNoopWithNumber")
    func bjs_benchmarkHelperNoopWithNumber(_ n: Float64) -> Void
    bjs_benchmarkHelperNoopWithNumber(n)
}

func benchmarkRunner(_ name: String, _ body: JSObject) -> Void {
    @_extern(wasm, module: "Benchmarks", name: "bjs_benchmarkRunner")
    func bjs_benchmarkRunner(_ name: Int32, _ body: Int32) -> Void
    var name = name
    let nameId = name.withUTF8 { b in
        _make_jsstring(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_benchmarkRunner(nameId, Int32(bitPattern: body.id))
}