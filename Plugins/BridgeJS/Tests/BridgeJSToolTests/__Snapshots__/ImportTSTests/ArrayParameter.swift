// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func checkArray(_ a: JSObject) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkArray")
    func bjs_checkArray(_ a: Int32) throws -> Void
    #else
    func bjs_checkArray(_ a: Int32) throws -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_checkArray(Int32(bitPattern: a.id))
}

func checkArrayWithLength(_ a: JSObject, _ b: Double) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkArrayWithLength")
    func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) throws -> Void
    #else
    func bjs_checkArrayWithLength(_ a: Int32, _ b: Float64) throws -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_checkArrayWithLength(Int32(bitPattern: a.id), b)
}

func checkArray(_ a: JSObject) -> Void {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_checkArray")
    func bjs_checkArray(_ a: Int32) throws -> Void
    #else
    func bjs_checkArray(_ a: Int32) throws -> Void {
        fatalError("Only available on WebAssembly")
    }
    #endif
    bjs_checkArray(Int32(bitPattern: a.id))
}