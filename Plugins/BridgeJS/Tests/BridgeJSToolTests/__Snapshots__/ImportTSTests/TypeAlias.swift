// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func checkSimple(_ a: Double) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkSimple")
    func bjs_checkSimple(_ a: Float64) throws -> Void
    #else
    func bjs_checkSimple(_ a: Float64) throws -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_checkSimple(a)
}