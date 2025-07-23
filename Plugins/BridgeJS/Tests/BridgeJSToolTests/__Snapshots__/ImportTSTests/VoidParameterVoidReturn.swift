// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func check() -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_check")
    func bjs_check() -> Void
    #else
    func bjs_check() -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_check()
}