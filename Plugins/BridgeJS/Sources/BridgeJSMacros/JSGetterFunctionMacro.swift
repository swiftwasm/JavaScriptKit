import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSGetterFunctionMacro {}

extension JSGetterFunctionMacro: BodyMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else { return [] }
        let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context)
        let isInstanceMember = enclosingTypeName != nil && !JSMacroHelper.isStatic(functionDecl.modifiers)
        if enclosingTypeName != nil {
            JSMacroHelper.diagnoseMissingJSClass(node: node, for: "JSGetterFunction", in: context)
        }
        JSMacroHelper.diagnoseThrowsRequiresJSException(
            signature: functionDecl.signature,
            on: Syntax(functionDecl),
            in: context,
            message: .jsGetterFunctionRequiresThrows,
            noteMessage: JSMacroText.jsGetterFunctionExceptionPropagation
        )
        let getterName = JSMacroHelper.glueName(
            baseName: JSMacroHelper.stripBackticks(functionDecl.name.text),
            enclosingTypeName: enclosingTypeName,
            operation: "get"
        )
        let argument = isInstanceMember ? JSMacroHelper.selfArgument(in: context) : ""
        return [CodeBlockItemSyntax(stringLiteral: "return try \(getterName)(\(argument))")]
    }
}
