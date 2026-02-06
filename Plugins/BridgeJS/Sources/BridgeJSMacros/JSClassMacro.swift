import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum JSClassMacro {}

extension JSClassMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(StructDeclSyntax.self) else {
            var fixIts: [FixIt] = []
            let note = Note(
                node: Syntax(declaration),
                message: JSMacroNoteMessage(
                    message: "Use @JSClass on a struct wrapper to synthesize jsObject and JS bridging members."
                )
            )

            if let classDecl = declaration.as(ClassDeclSyntax.self) {
                let structKeyword = classDecl.classKeyword.with(\.tokenKind, .keyword(.struct))
                fixIts.append(
                    FixIt(
                        message: JSMacroFixItMessage(message: "Change 'class' to 'struct'"),
                        changes: [
                            .replace(
                                oldNode: Syntax(classDecl.classKeyword),
                                newNode: Syntax(structKeyword)
                            )
                        ]
                    )
                )
            }
            context.diagnose(
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.unsupportedJSClassDeclaration,
                    notes: [note],
                    fixIts: fixIts
                )
            )
            return []
        }

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

extension JSClassMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { return [] }
        guard !protocols.isEmpty else { return [] }

        // Do not add extension if the struct already conforms to _JSBridgedClass
        if let clause = structDecl.inheritanceClause,
            clause.inheritedTypes.contains(where: { $0.type.trimmed.description == "_JSBridgedClass" })
        {
            return []
        }

        let conformanceList = protocols.map { $0.trimmed.description }.joined(separator: ", ")
        return [
            try ExtensionDeclSyntax("extension \(type.trimmed): \(raw: conformanceList) {}")
        ]
    }
}
