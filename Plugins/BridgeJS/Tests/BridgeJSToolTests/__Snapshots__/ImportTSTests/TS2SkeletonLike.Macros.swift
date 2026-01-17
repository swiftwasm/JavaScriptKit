// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

import JavaScriptKit

@JSFunction func createTS2Skeleton() throws (JSException) -> TypeScriptProcessor

@JSClass struct TypeScriptProcessor: _JSBridgedClass {
    @JSFunction func convert(_ ts: String) throws (JSException) -> String
    @JSFunction func validate(_ ts: String) throws (JSException) -> Bool
    @JSGetter var version: String
}

@JSFunction func createCodeGenerator(_ format: String) throws (JSException) -> CodeGenerator

@JSClass struct CodeGenerator: _JSBridgedClass {
    @JSFunction func generate(_ input: JSObject) throws (JSException) -> String
    @JSGetter var outputFormat: String
}
