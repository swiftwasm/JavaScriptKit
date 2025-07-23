// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check() -> Void {
    #if arch(wasm32)
    check()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}