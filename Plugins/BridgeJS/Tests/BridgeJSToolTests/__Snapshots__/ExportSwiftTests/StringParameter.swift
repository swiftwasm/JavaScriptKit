// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(aBytes: Int32, aLen: Int32) -> Void {
    #if arch(wasm32)
    checkString(a: String.bridgeJSLiftParameter(aBytes, aLen))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}