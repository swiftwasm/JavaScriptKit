// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

import JavaScriptKit

@JSFunction func jsRoundTripVoid() throws (JSException) -> Void

@JSFunction func jsRoundTripNumber(_ v: Double) throws (JSException) -> Double

@JSFunction func jsRoundTripBool(_ v: Bool) throws (JSException) -> Bool

@JSFunction func jsRoundTripString(_ v: String) throws (JSException) -> String

@JSFunction func jsThrowOrVoid(_ shouldThrow: Bool) throws (JSException) -> Void

@JSFunction func jsThrowOrNumber(_ shouldThrow: Bool) throws (JSException) -> Double

@JSFunction func jsThrowOrBool(_ shouldThrow: Bool) throws (JSException) -> Bool

@JSFunction func jsThrowOrString(_ shouldThrow: Bool) throws (JSException) -> String

@JSClass struct JsGreeter: _JSBridgedClass {
    @JSGetter var name: String
    @JSSetter func setName(_ value: String) throws (JSException)
    @JSGetter var `prefix`: String
    @JSFunction init(_ name: String, _ `prefix`: String) throws (JSException)
    @JSFunction func greet() throws (JSException) -> String
    @JSFunction func changeName(_ name: String) throws (JSException) -> Void
}

@JSFunction func runAsyncWorks() throws (JSException) -> JSPromise
