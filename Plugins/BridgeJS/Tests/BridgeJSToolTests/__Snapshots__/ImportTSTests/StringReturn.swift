// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func checkString() -> String {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkString")
    func bjs_checkString() -> Int32
    #else
    func bjs_checkString() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_checkString()
    return String(unsafeUninitializedCapacity: Int(ret)) { b in
        _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
        return Int(ret)
    }
}