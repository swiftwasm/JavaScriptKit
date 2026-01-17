import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSGetterMacro {}

extension JSGetterMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let variableDecl = declaration.as(VariableDeclSyntax.self),
            let binding = variableDecl.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
        else {
            context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.unsupportedVariable))
            return []
        }

        let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context)
        let isStatic = JSMacroHelper.isStatic(variableDecl.modifiers)
        let isInstanceMember = enclosingTypeName != nil && !isStatic

        // Strip backticks from property name (e.g., "`prefix`" -> "prefix")
        // Backticks are only needed for Swift identifiers, not function names
        let propertyName = JSMacroHelper.stripBackticks(identifier.identifier.text)
        let getterName = JSMacroHelper.glueName(
            baseName: propertyName,
            enclosingTypeName: enclosingTypeName,
            operation: "get"
        )

        var getterArgs: [String] = []
        if isInstanceMember {
            getterArgs.append("self.jsObject")
        }
        let getterCall: CodeBlockItemSyntax =
            "return try \(raw: getterName)(\(raw: getterArgs.joined(separator: ", ")))"

        let throwsClause = ThrowsClauseSyntax(
            throwsSpecifier: .keyword(.throws),
            leftParen: .leftParenToken(),
            type: IdentifierTypeSyntax(name: .identifier("JSException")),
            rightParen: .rightParenToken()
        )

        return [
            AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                effectSpecifiers: AccessorEffectSpecifiersSyntax(
                    asyncSpecifier: nil,
                    throwsClause: throwsClause
                ),
                body: CodeBlockSyntax {
                    getterCall
                }
            )
        ]
    }
}
