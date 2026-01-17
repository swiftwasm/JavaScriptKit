import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSSetterMacro {}

extension JSSetterMacro: BodyMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else {
            context.diagnose(
                Diagnostic(node: Syntax(declaration), message: JSMacroMessage.unsupportedSetterDeclaration)
            )
            return []
        }

        let functionName = functionDecl.name.text

        // Extract property name from setter function name (e.g., "setFoo" -> "foo")
        // Strip backticks if present (e.g., "set`prefix`" -> "prefix")
        let rawFunctionName = JSMacroHelper.stripBackticks(functionName)
        guard rawFunctionName.hasPrefix("set"), rawFunctionName.count > 3 else {
            context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.invalidSetterName))
            return []
        }

        let propertyName = String(rawFunctionName.dropFirst(3))
        guard !propertyName.isEmpty else {
            context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.invalidSetterName))
            return []
        }

        // Convert first character to lowercase (e.g., "Foo" -> "foo")
        let baseName = propertyName.prefix(1).lowercased() + propertyName.dropFirst()

        let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context)
        let isStatic = JSMacroHelper.isStatic(functionDecl.modifiers)
        let isInstanceMember = enclosingTypeName != nil && !isStatic

        let glueName = JSMacroHelper.glueName(
            baseName: baseName,
            enclosingTypeName: enclosingTypeName,
            operation: "set"
        )

        var arguments: [String] = []
        if isInstanceMember {
            arguments.append("self.jsObject")
        }

        // Get the parameter name(s) - setters typically have one parameter
        let parameters = functionDecl.signature.parameterClause.parameters
        guard let firstParam = parameters.first else {
            context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.setterRequiresParameter))
            return []
        }

        let paramName = firstParam.secondName ?? firstParam.firstName
        arguments.append(paramName.text)

        let argsJoined = arguments.joined(separator: ", ")
        let call = "\(glueName)(\(argsJoined))"

        // Setters should throw JSException, so always use try
        return [CodeBlockItemSyntax(stringLiteral: "try \(call)")]
    }
}
