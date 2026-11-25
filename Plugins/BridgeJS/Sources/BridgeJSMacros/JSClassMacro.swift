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
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { return members }

        if let accessLevel = accessLevel(from: structDecl.modifiers),
            accessLevel == .private || accessLevel == .fileprivate
        {
            context.diagnose(
                Diagnostic(
                    node: Syntax(structDecl),
                    message: JSMacroMessage.jsClassRequiresAtLeastInternal
                )
            )
            return []
        }

        let memberAccessModifier = synthesizedMemberAccessModifier(for: declaration).map { "\($0) " } ?? ""

        let existingMembers = declaration.memberBlock.members
        let hasUnsafelyWrappingInit = existingMembers.contains { member in
            guard let initializer = member.decl.as(InitializerDeclSyntax.self) else { return false }
            let parameters = initializer.signature.parameterClause.parameters
            guard let firstParam = parameters.first else { return false }
            let externalName = firstParam.firstName.text
            let internalName = firstParam.secondName?.text
            return externalName == "unsafelyWrapping" && internalName == "jsObject"
        }

        if JSMacroHelper.isNoncopyable(structDecl) {
            members.append(DeclSyntax("\(raw: memberAccessModifier)let jsRef: JSUniqueRef"))
            members.append(
                DeclSyntax(
                    """
                    \(raw: memberAccessModifier)init(unsafelyAdopting jsRef: consuming JSUniqueRef) {
                        self.jsRef = jsRef
                    }
                    """
                )
            )
            if !hasUnsafelyWrappingInit {
                members.append(
                    DeclSyntax(
                        """
                        \(raw: memberAccessModifier)init(unsafelyWrapping jsObject: consuming JSObject) {
                            self.init(unsafelyAdopting: JSUniqueRef(taking: consume jsObject))
                        }
                        """
                    )
                )
            }
            members.append(DeclSyntax("\(raw: memberAccessModifier)var jsID: Int32 { jsRef.jsID }"))
            members.append(
                DeclSyntax("\(raw: memberAccessModifier)consuming func takeJSRef() -> JSUniqueRef { jsRef }")
            )
            return members
        }

        let hasJSObjectProperty = existingMembers.contains { member in
            guard let variable = member.decl.as(VariableDeclSyntax.self) else { return false }
            return variable.bindings.contains { binding in
                binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "jsObject"
            }
        }

        if !hasJSObjectProperty {
            members.append(DeclSyntax("\(raw: memberAccessModifier)let jsObject: JSObject"))
        }

        if !hasUnsafelyWrappingInit {
            members.append(
                DeclSyntax(
                    """
                    \(raw: memberAccessModifier)init(unsafelyWrapping jsObject: JSObject) {
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
        if let accessLevel = accessLevel(from: structDecl.modifiers),
            accessLevel == .private || accessLevel == .fileprivate
        {
            return []
        }

        // Do not add extension if the struct already conforms to _JSBridgedClass
        if let clause = structDecl.inheritanceClause,
            clause.inheritedTypes.contains(where: { $0.type.trimmed.description == "_JSBridgedClass" })
        {
            return []
        }

        let wanted = JSMacroHelper.isNoncopyable(structDecl) ? "_JSUniqueBridgedClass" : "_JSBridgedClass"
        let conformances = protocols.map { $0.trimmed.description }.filter {
            $0 == wanted || $0.hasSuffix(".\(wanted)")
        }
        guard !conformances.isEmpty else { return [] }
        return [
            try ExtensionDeclSyntax("extension \(type.trimmed): \(raw: conformances.joined(separator: ", ")) {}")
        ]
    }

    private static func synthesizedMemberAccessModifier(for declaration: some DeclGroupSyntax) -> String? {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { return nil }
        switch accessLevel(from: structDecl.modifiers) {
        case .public: return "public"
        case .package: return "package"
        case .internal: return "internal"
        case .fileprivate, .private, .none: return nil
        }
    }

    private enum AccessLevel {
        case `public`
        case package
        case `internal`
        case `fileprivate`
        case `private`
    }

    private static func accessLevel(from modifiers: DeclModifierListSyntax?) -> AccessLevel? {
        guard let modifiers else { return nil }
        for modifier in modifiers {
            switch modifier.name.tokenKind {
            case .keyword(.public): return .public
            case .keyword(.package): return .package
            case .keyword(.internal): return .internal
            case .keyword(.fileprivate): return .fileprivate
            case .keyword(.private): return .private
            default: continue
            }
        }
        return nil
    }
}
