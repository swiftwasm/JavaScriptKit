// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(Experimental) import JavaScriptKit

@JSClass struct Greeter: _JSBridgedClass {
    @JSGetter var name: String
    @JSSetter func setName(_ value: String) throws (JSException)
    @JSGetter var age: Double
    @JSFunction init(_ name: String) throws (JSException)
    @JSFunction func greet() throws (JSException) -> String
    @JSFunction func changeName(_ name: String) throws (JSException) -> Void
}
