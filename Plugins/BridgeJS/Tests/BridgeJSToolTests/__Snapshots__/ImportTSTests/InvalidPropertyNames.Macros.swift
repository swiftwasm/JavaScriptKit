// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(Experimental) import JavaScriptKit

@JSFunction func createArrayBuffer() throws (JSException) -> ArrayBufferLike

@JSClass struct ArrayBufferLike: _JSBridgedClass {
    @JSGetter var byteLength: Double
    @JSFunction func slice(_ begin: Double, _ end: Double) throws (JSException) -> ArrayBufferLike
}

@JSFunction func createWeirdObject() throws (JSException) -> WeirdNaming

@JSClass struct WeirdNaming: _JSBridgedClass {
    @JSGetter var normalProperty: String
    @JSSetter func setNormalProperty(_ value: String) throws (JSException)
    @JSGetter var `for`: String
    @JSSetter func setFor(_ value: String) throws (JSException)
    @JSGetter var `Any`: String
    @JSSetter(jsName: "Any") func setAny(_ value: String) throws (JSException)
    @JSFunction func `as`() throws (JSException) -> Void
}
