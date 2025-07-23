// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func checkString(_ a: String) throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkString")
    func bjs_checkString(_ a: Int32) -> Void
    #else
    func bjs_checkString(_ a: Int32) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var a = a
    let aId = a.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_checkString(aId)
}

func checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkStringWithLength")
    func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void
    #else
    func bjs_checkStringWithLength(_ a: Int32, _ b: Float64) -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    var a = a
    let aId = a.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    bjs_checkStringWithLength(aId, b)
}