// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_createTS2Skeleton")
func bjs_createTS2Skeleton() -> Int32
#else
func bjs_createTS2Skeleton() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func createTS2Skeleton() throws(JSException) -> TS2Skeleton {
    let ret = bjs_createTS2Skeleton()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return TS2Skeleton.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "PlayBridgeJS", name: "bjs_TS2Skeleton_convert")
func bjs_TS2Skeleton_convert(_ self: Int32, _ ts: Int32) -> Int32
#else
func bjs_TS2Skeleton_convert(_ self: Int32, _ ts: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

struct TS2Skeleton: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    func convert(_ ts: String) throws(JSException) -> String {
        let ret = bjs_TS2Skeleton_convert(self.bridgeJSLowerParameter(), ts.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return String.bridgeJSLiftReturn(ret)
    }

}