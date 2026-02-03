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

extension JSGetterMacro: PeerMacro {
    /// Emits a diagnostic when @JSGetter is applied to a declaration that is not a variable (e.g. a function).
    /// AccessorMacro may not be invoked for non-property declarations. For variables with multiple
    /// bindings, the compiler emits its own diagnostic; we only diagnose non-variable decls here.
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(VariableDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(declaration), message: JSMacroMessage.unsupportedVariable))
            return []
        }
        return []
    }
}
