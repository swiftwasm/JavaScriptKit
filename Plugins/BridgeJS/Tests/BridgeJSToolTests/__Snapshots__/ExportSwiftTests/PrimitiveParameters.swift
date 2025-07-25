// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check(a: Int32, b: Float32, c: Float64, d: Int32) -> Void {
    #if arch(wasm32)
    check(a: Int(a), b: b, c: c, d: d == 1)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}