// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkNumber")
fileprivate func bjs_checkNumber() -> Float64
#else
fileprivate func bjs_checkNumber() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func checkNumber() throws(JSException) -> Double {
    let ret = bjs_checkNumber()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_checkBoolean")
fileprivate func bjs_checkBoolean() -> Int32
#else
fileprivate func bjs_checkBoolean() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func checkBoolean() throws(JSException) -> Bool {
    let ret = bjs_checkBoolean()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}