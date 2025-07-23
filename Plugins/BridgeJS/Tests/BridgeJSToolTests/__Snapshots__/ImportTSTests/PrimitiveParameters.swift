// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func check(_ a: Double, _ b: Bool) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_check")
    func bjs_check(_ a: Float64, _ b: Int32) -> Void
    #else
    func bjs_check(_ a: Float64, _ b: Int32) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_check(a, Int32(b ? 1 : 0))
}