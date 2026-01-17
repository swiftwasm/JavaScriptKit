import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum JSMacroMessage: String, DiagnosticMessage {
    case unsupportedDeclaration = "@JSFunction can only be applied to functions or initializers."
    case unsupportedVariable = "@JSGetter can only be applied to single-variable declarations."
    case unsupportedSetterDeclaration = "@JSSetter can only be applied to functions."
    case invalidSetterName =
        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo')."
    case setterRequiresParameter = "@JSSetter function must have at least one parameter."

    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "JavaScriptKitMacros", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}

enum JSMacroHelper {
    static func enclosingTypeName(from context: some MacroExpansionContext) -> String? {
        for syntax in context.lexicalContext {
            if let decl = syntax.as(ClassDeclSyntax.self) {
                return decl.name.text
            }
            if let decl = syntax.as(StructDeclSyntax.self) {
                return decl.name.text
            }
            if let decl = syntax.as(EnumDeclSyntax.self) {
                return decl.name.text
            }
            if let decl = syntax.as(ActorDeclSyntax.self) {
                return decl.name.text
            }
        }
        return nil
    }

    static func isStatic(_ modifiers: DeclModifierListSyntax?) -> Bool {
        guard let modifiers else { return false }
        return modifiers.contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }
    }

    static func isVoidReturn(_ returnType: TypeSyntax?) -> Bool {
        guard let returnType else { return true }
        if let identifier = returnType.as(IdentifierTypeSyntax.self), identifier.name.text == "Void" {
            return true
        }
        if let tuple = returnType.as(TupleTypeSyntax.self), tuple.elements.isEmpty {
            return true
        }
        return false
    }

    static func glueName(baseName: String, enclosingTypeName: String?) -> String {
        if let enclosingTypeName {
            return "_$\(enclosingTypeName)_\(baseName)"
        }
        return "_$\(baseName)"
    }

    static func glueName(baseName: String, enclosingTypeName: String?, operation: String) -> String {
        if let enclosingTypeName {
            return "_$\(enclosingTypeName)_\(baseName)_\(operation)"
        }
        return "_$\(baseName)_\(operation)"
    }

    static func parameterNames(_ parameters: FunctionParameterListSyntax) -> [String] {
        parameters.compactMap { param in
            let nameToken = param.secondName ?? param.firstName
            let nameText = nameToken.text
            return nameText == "_" ? nil : nameText
        }
    }

    static func tryAwaitPrefix(isAsync: Bool, isThrows: Bool) -> String {
        switch (isAsync, isThrows) {
        case (true, true):
            return "try await "
        case (true, false):
            return "await "
        case (false, true):
            return "try "
        case (false, false):
            return ""
        }
    }

    /// Strips backticks from an identifier name.
    /// Swift identifiers with keywords are escaped with backticks (e.g., `` `prefix` ``),
    /// but function names should not include backticks.
    static func stripBackticks(_ name: String) -> String {
        if name.hasPrefix("`") && name.hasSuffix("`") && name.count > 2 {
            return String(name.dropFirst().dropLast())
        }
        return name
    }
}
