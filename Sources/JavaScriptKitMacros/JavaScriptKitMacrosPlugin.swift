import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct JavaScriptKitMacrosPlugin: CompilerPlugin {
  var providingMacros: [Macro.Type] = [
    JSImportFunctionMacro.self,
    JSImportVariableMacro.self,
  ]
}
