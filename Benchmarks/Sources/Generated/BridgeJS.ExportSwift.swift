// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_run")
@_cdecl("bjs_run")
public func _bjs_run() -> Void {
    #if arch(wasm32)
    run()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}