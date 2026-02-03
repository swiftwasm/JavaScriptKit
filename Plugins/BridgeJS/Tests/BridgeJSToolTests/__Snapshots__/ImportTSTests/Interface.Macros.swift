// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(Experimental) @_spi(BridgeJS) import JavaScriptKit

@JSFunction func returnAnimatable() throws (JSException) -> Animatable

@JSClass struct Animatable {
    @JSFunction func animate(_ keyframes: JSObject, _ options: JSObject) throws (JSException) -> JSObject
    @JSFunction func getAnimations(_ options: JSObject) throws (JSException) -> JSObject
}
