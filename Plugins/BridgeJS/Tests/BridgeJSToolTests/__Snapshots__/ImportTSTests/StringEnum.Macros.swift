// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(Experimental) @_spi(BridgeJS) import JavaScriptKit

enum FeatureFlag: String {
    case foo = "foo"
    case bar = "bar"
}
extension FeatureFlag: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}

@JSFunction func takesFeatureFlag(_ flag: FeatureFlag) throws (JSException) -> Void

@JSFunction func returnsFeatureFlag() throws (JSException) -> FeatureFlag
