// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func checkNumber() throws(JSException) -> Double {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkNumber")
    func bjs_checkNumber() -> Float64
    #else
    func bjs_checkNumber() -> Float64 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_checkNumber()
    return Double(ret)
}

func checkBoolean() throws(JSException) -> Bool {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkBoolean")
    func bjs_checkBoolean() -> Int32
    #else
    func bjs_checkBoolean() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_checkBoolean()
    return ret == 1
}