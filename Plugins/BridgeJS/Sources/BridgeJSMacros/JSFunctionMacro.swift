import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSFunctionMacro {}

extension JSFunctionMacro: BodyMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        if let functionDecl = declaration.as(FunctionDeclSyntax.self) {
            let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context)
            let isStatic = JSMacroHelper.isStatic(functionDecl.modifiers)
            let isInstanceMember = enclosingTypeName != nil && !isStatic

            // Strip backticks from function name (e.g., "`prefix`" -> "prefix")
            // Backticks are only needed for Swift identifiers, not function names
            let name = JSMacroHelper.stripBackticks(functionDecl.name.text)
            let glueName = JSMacroHelper.glueName(baseName: name, enclosingTypeName: enclosingTypeName)

            var arguments: [String] = []
            if isInstanceMember {
                arguments.append("self.jsObject")
            }
            arguments.append(
                contentsOf: JSMacroHelper.parameterNames(functionDecl.signature.parameterClause.parameters)
            )

            let argsJoined = arguments.joined(separator: ", ")
            let call = "\(glueName)(\(argsJoined))"

            let effects = functionDecl.signature.effectSpecifiers
            let isAsync = effects?.asyncSpecifier != nil
            let isThrows = effects?.throwsClause != nil
            let prefix = JSMacroHelper.tryAwaitPrefix(isAsync: isAsync, isThrows: isThrows)

            let isVoid = JSMacroHelper.isVoidReturn(functionDecl.signature.returnClause?.type)
            let line = isVoid ? "\(prefix)\(call)" : "return \(prefix)\(call)"
            return [CodeBlockItemSyntax(stringLiteral: line)]
        }

        if let initializerDecl = declaration.as(InitializerDeclSyntax.self) {
            guard let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context) else {
                context.diagnose(
                    Diagnostic(node: Syntax(declaration), message: JSMacroMessage.unsupportedDeclaration)
                )
                return []
            }

            let glueName = JSMacroHelper.glueName(baseName: "init", enclosingTypeName: enclosingTypeName)
            let parameters = initializerDecl.signature.parameterClause.parameters
            let arguments = JSMacroHelper.parameterNames(parameters)
            let call = "\(glueName)(\(arguments.joined(separator: ", ")))"

            let effects = initializerDecl.signature.effectSpecifiers
            let isAsync = effects?.asyncSpecifier != nil
            let isThrows = effects?.throwsClause != nil
            let prefix = JSMacroHelper.tryAwaitPrefix(isAsync: isAsync, isThrows: isThrows)

            return [
                CodeBlockItemSyntax(stringLiteral: "let jsObject = \(prefix)\(call)"),
                CodeBlockItemSyntax(stringLiteral: "self.init(unsafelyWrapping: jsObject)"),
            ]
        }

        context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.unsupportedDeclaration))
        return []
    }
}
