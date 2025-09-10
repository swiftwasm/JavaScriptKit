// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(aBytes: Int32, aLength: Int32) -> Void {
    #if arch(wasm32)
    checkString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripString")
@_cdecl("bjs_roundtripString")
public func _bjs_roundtripString(aBytes: Int32, aLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripString(a: String.bridgeJSLiftParameter(aBytes, aLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}