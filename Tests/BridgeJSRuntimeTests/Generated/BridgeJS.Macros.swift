// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@JSFunction func jsRoundTripVoid() throws(JSException) -> Void

@JSFunction func jsRoundTripNumber(_ v: Double) throws(JSException) -> Double

@JSFunction func jsRoundTripBool(_ v: Bool) throws(JSException) -> Bool

@JSFunction func jsRoundTripString(_ v: String) throws(JSException) -> String

@JSFunction func jsRoundTripJSValue(_ v: JSValue) throws(JSException) -> JSValue

@JSFunction func jsThrowOrVoid(_ shouldThrow: Bool) throws(JSException) -> Void

@JSFunction func jsThrowOrNumber(_ shouldThrow: Bool) throws(JSException) -> Double

@JSFunction func jsThrowOrBool(_ shouldThrow: Bool) throws(JSException) -> Bool

@JSFunction func jsThrowOrString(_ shouldThrow: Bool) throws(JSException) -> String

enum FeatureFlag: String {
    case foo = "foo"
    case bar = "bar"
}
extension FeatureFlag: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}

@JSFunction func jsRoundTripFeatureFlag(_ flag: FeatureFlag) throws(JSException) -> FeatureFlag

@JSClass struct JsGreeter {
    @JSGetter var name: String
    @JSSetter func setName(_ value: String) throws(JSException)
    @JSGetter var `prefix`: String
    @JSFunction init(_ name: String, _ `prefix`: String) throws(JSException)
    @JSFunction func greet() throws(JSException) -> String
    @JSFunction func changeName(_ name: String) throws(JSException) -> Void
}

@JSFunction func runAsyncWorks() throws(JSException) -> JSPromise

@JSFunction(jsName: "$jsWeirdFunction") func _jsWeirdFunction() throws(JSException) -> Double

@JSClass(jsName: "$WeirdClass") struct _WeirdClass {
    @JSFunction init() throws(JSException)
    @JSFunction(jsName: "method-with-dashes") func method_with_dashes() throws(JSException) -> String
}

@JSClass struct StaticBox {
    @JSFunction init(_ value: Double) throws(JSException)
    @JSFunction func value() throws(JSException) -> Double
    @JSFunction static func create(_ value: Double) throws(JSException) -> StaticBox
    @JSFunction static func value() throws(JSException) -> Double
    @JSFunction static func makeDefault() throws(JSException) -> StaticBox
    @JSFunction(jsName: "with-dashes") static func with_dashes() throws(JSException) -> StaticBox
}

@JSFunction(from: .global) func parseInt(_ string: String) throws(JSException) -> Double

@JSClass(from: .global) struct Animal {
    @JSGetter var name: String
    @JSSetter func setName(_ value: String) throws(JSException)
    @JSGetter var age: Double
    @JSSetter func setAge(_ value: Double) throws(JSException)
    @JSGetter var isCat: Bool
    @JSSetter func setIsCat(_ value: Bool) throws(JSException)
    @JSFunction init(_ name: String, _ age: Double, _ isCat: Bool) throws(JSException)
    @JSFunction func bark() throws(JSException) -> String
    @JSFunction func getIsCat() throws(JSException) -> Bool
}

@JSGetter(from: .global) var globalObject1: JSValue
