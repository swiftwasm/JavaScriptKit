import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct BridgeJSMacrosPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        JSFunctionMacro.self,
        JSGetterMacro.self,
        JSGetterFunctionMacro.self,
        JSSetterMacro.self,
        JSClassMacro.self,
    ]
}
