import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum JSMacroMessage: String, DiagnosticMessage {
    case unsupportedDeclaration = "@JSFunction can only be applied to functions or initializers."
    case unsupportedJSClassDeclaration = "@JSClass can only be applied to structs."
    case unsupportedVariable = "@JSGetter can only be applied to single-variable declarations."
    case unsupportedSetterDeclaration = "@JSSetter can only be applied to functions."
    case invalidSetterName =
        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo')."
    case setterRequiresParameter = "@JSSetter function must have at least one parameter."
    case setterRequiresThrows = "@JSSetter function must declare throws(JSException)."
    case jsFunctionRequiresThrows = "@JSFunction throws must be declared as throws(JSException)."
    case requiresJSClass = "JavaScript members must be declared inside a @JSClass struct."
    case jsClassRequiresAtLeastInternal =
        "@JSClass does not support private/fileprivate access level. Use internal, package, or public."
    case jsClassMemberRequiresAtLeastInternal =
        "@JSClass requires jsObject and init(unsafelyWrapping:) to be at least internal."

    var message: String { rawValue }
    var diagnosticID: MessageID { MessageID(domain: "JavaScriptKitMacros", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
}

struct JSMacroNoteMessage: NoteMessage {
    let message: String
    var noteID: MessageID { MessageID(domain: "JavaScriptKitMacros", id: message) }
}

struct JSMacroFixItMessage: FixItMessage {
    let message: String
    var fixItID: MessageID { MessageID(domain: "JavaScriptKitMacros", id: message) }
}

enum JSMacroText {
    static let jsExceptionPropagation = "@JSFunction must propagate JavaScript errors as JSException."
    static let jsSetterExceptionPropagation = "@JSSetter must propagate JavaScript errors as JSException."
}

enum JSMacroHelper {
    static func enclosingTypeName(from context: some MacroExpansionContext) -> String? {
        enclosingTypeSyntax(from: context).flatMap(typeName(of:))
    }

    static func enclosingTypeSyntax(from context: some MacroExpansionContext) -> Syntax? {
        for syntax in context.lexicalContext {
            if syntax.is(ClassDeclSyntax.self) || syntax.is(StructDeclSyntax.self)
                || syntax.is(EnumDeclSyntax.self) || syntax.is(ActorDeclSyntax.self)
            {
                return Syntax(syntax)
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

    static func capitalizingFirstLetter(_ value: String) -> String {
        guard let first = value.first else { return value }
        return first.uppercased() + value.dropFirst()
    }

    static func hasJSClassAttribute(_ typeSyntax: Syntax) -> Bool {
        guard let attributes = attributes(of: typeSyntax) else { return false }
        for attribute in attributes.compactMap({ $0.as(AttributeSyntax.self) }) {
            let name = attribute.attributeName.trimmedDescription
            if name == "JSClass" || name == "@JSClass" {
                return true
            }
        }
        return false
    }

    static func typeName(of syntax: Syntax) -> String? {
        switch syntax.as(SyntaxEnum.self) {
        case .structDecl(let decl): return decl.name.text
        case .classDecl(let decl): return decl.name.text
        case .enumDecl(let decl): return decl.name.text
        case .actorDecl(let decl): return decl.name.text
        default: return nil
        }
    }

    private static func attributes(of syntax: Syntax) -> AttributeListSyntax? {
        switch syntax.as(SyntaxEnum.self) {
        case .structDecl(let decl): return decl.attributes
        case .classDecl(let decl): return decl.attributes
        case .enumDecl(let decl): return decl.attributes
        case .actorDecl(let decl): return decl.attributes
        default: return nil
        }
    }

    static func diagnoseThrowsRequiresJSException(
        signature: FunctionSignatureSyntax,
        on node: Syntax,
        in context: some MacroExpansionContext,
        additionalNotes: [Note] = []
    ) {
        let throwsClause = signature.effectSpecifiers?.throwsClause
        let throwsTypeName = throwsClause?.type?.as(IdentifierTypeSyntax.self)?.name.text
        let isJSException = throwsTypeName == "JSException"
        let isAllowedGenericError =
            throwsClause != nil
            && (throwsTypeName == nil || throwsTypeName == "Error" || throwsTypeName == "Swift.Error")
        guard !isJSException else { return }
        guard !isAllowedGenericError else { return }

        let newThrowsClause = jsExceptionThrowsClause(from: throwsClause)

        let fixIt: FixIt
        if let throwsClause = signature.effectSpecifiers?.throwsClause {
            fixIt = FixIt(
                message: JSMacroFixItMessage(message: "Declare throws(JSException)"),
                changes: [.replace(oldNode: Syntax(throwsClause), newNode: Syntax(newThrowsClause))]
            )
        } else {
            let adjustedParameterClause = signature.parameterClause.with(\.rightParen.trailingTrivia, .spaces(0))
            let newEffects = FunctionEffectSpecifiersSyntax(
                asyncSpecifier: signature.effectSpecifiers?.asyncSpecifier,
                throwsClause: newThrowsClause
            )
            let newSignature =
                signature
                .with(\.parameterClause, adjustedParameterClause)
                .with(\.effectSpecifiers, newEffects)
            fixIt = FixIt(
                message: JSMacroFixItMessage(message: "Declare throws(JSException)"),
                changes: [.replace(oldNode: Syntax(signature), newNode: Syntax(newSignature))]
            )
        }

        var notes: [Note] = [
            jsExceptionPropagationNote(on: node)
        ]
        notes.append(contentsOf: additionalNotes)

        context.diagnose(
            Diagnostic(
                node: node,
                message: JSMacroMessage.jsFunctionRequiresThrows,
                notes: notes,
                fixIts: [fixIt]
            )
        )
    }

    static func diagnoseMissingJSClass(
        node: some SyntaxProtocol,
        for macroName: String,
        in context: some MacroExpansionContext
    ) {
        guard let typeSyntax = enclosingTypeSyntax(from: context) else { return }
        guard !hasJSClassAttribute(typeSyntax) else { return }
        context.diagnose(Diagnostic(node: node, message: JSMacroMessage.requiresJSClass))
    }

    static func setterPropertyBase(from parameter: FunctionParameterSyntax?) -> String? {
        guard let parameter else { return nil }
        let candidateNames = [
            parameter.secondName,
            parameter.firstName.tokenKind == .wildcard ? nil : parameter.firstName,
        ].compactMap { $0?.text }.filter { $0 != "_" }
        if let explicitName = candidateNames.first(where: { name in name != "value" && name != "newValue" }) {
            return explicitName
        }
        if let identifierType = parameter.type.as(IdentifierTypeSyntax.self) {
            let typeName = identifierType.name.text
            guard let first = typeName.first else { return nil }
            return first.lowercased() + typeName.dropFirst()
        }
        return candidateNames.first
    }

    static func suggestedSetterName(rawFunctionName: String, firstParameter: FunctionParameterSyntax?) -> String? {
        guard let base = setterPropertyBase(from: firstParameter) else { return nil }
        return "set" + capitalizingFirstLetter(base)
    }

    /// Build a typed throws(JSException) clause preserving trivia when possible.
    static func jsExceptionThrowsClause(from throwsClause: ThrowsClauseSyntax?) -> ThrowsClauseSyntax {
        let throwsSpecifier = (throwsClause?.throwsSpecifier ?? .keyword(.throws, leadingTrivia: .space))
            .with(\.trailingTrivia, .spaces(0))
            .with(\.leadingTrivia, throwsClause?.throwsSpecifier.leadingTrivia ?? .space)
        let leftParen = throwsClause?.leftParen ?? .leftParenToken()
        let rightParen = (throwsClause?.rightParen ?? .rightParenToken())
            .with(\.trailingTrivia, throwsClause?.rightParen?.trailingTrivia ?? .space)

        return ThrowsClauseSyntax(
            throwsSpecifier: throwsSpecifier,
            leftParen: leftParen,
            type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("JSException"))),
            rightParen: rightParen
        )
    }

    static func jsExceptionPropagationNote(
        on node: Syntax,
        message: String = JSMacroText.jsExceptionPropagation
    ) -> Note {
        Note(
            node: node,
            message: JSMacroNoteMessage(
                message: message
            )
        )
    }
}
