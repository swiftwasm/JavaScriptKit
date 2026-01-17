import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSClassMacro {}

extension JSClassMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var members: [DeclSyntax] = []

        let existingMembers = declaration.memberBlock.members
        let hasJSObjectProperty = existingMembers.contains { member in
            guard let variable = member.decl.as(VariableDeclSyntax.self) else { return false }
            return variable.bindings.contains { binding in
                binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "jsObject"
            }
        }

        if !hasJSObjectProperty {
            members.append(DeclSyntax("let jsObject: JSObject"))
        }

        let hasUnsafelyWrappingInit = existingMembers.contains { member in
            guard let initializer = member.decl.as(InitializerDeclSyntax.self) else { return false }
            let parameters = initializer.signature.parameterClause.parameters
            guard let firstParam = parameters.first else { return false }
            let externalName = firstParam.firstName.text
            let internalName = firstParam.secondName?.text
            return externalName == "unsafelyWrapping" && internalName == "jsObject"
        }

        if !hasUnsafelyWrappingInit {
            members.append(
                DeclSyntax(
                    """
                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                    """
                )
            )
        }

        return members
    }
}
