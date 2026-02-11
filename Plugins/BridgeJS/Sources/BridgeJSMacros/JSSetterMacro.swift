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
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.unsupportedSetterDeclaration,
                    notes: [
                        Note(
                            node: Syntax(declaration),
                            message: JSMacroNoteMessage(
                                message: "@JSSetter can only be used on methods that set a JavaScript property."
                            )
                        )
                    ]
                )
            )
            return []
        }

        let functionName = functionDecl.name.text
        let parameters = functionDecl.signature.parameterClause.parameters
        let suggestedSetterName = JSMacroHelper.suggestedSetterName(
            rawFunctionName: JSMacroHelper.stripBackticks(functionName),
            firstParameter: parameters.first
        )
        let renameFixIts: [FixIt]
        if let name = suggestedSetterName {
            let replacement = functionDecl.name.with(\.tokenKind, .identifier(name))
                .with(\.leadingTrivia, functionDecl.name.leadingTrivia)
                .with(\.trailingTrivia, functionDecl.name.trailingTrivia)
            renameFixIts = [
                FixIt(
                    message: JSMacroFixItMessage(message: "Rename setter to '\(name)'"),
                    changes: [.replace(oldNode: Syntax(functionDecl.name), newNode: Syntax(replacement))]
                )
            ]
        } else {
            renameFixIts = []
        }
        let addParameterFixIts: [FixIt] = {
            let placeholderParameter = FunctionParameterSyntax(
                firstName: .wildcardToken(trailingTrivia: .space),
                secondName: .identifier("value"),
                colon: .colonToken(trailingTrivia: .space),
                type: IdentifierTypeSyntax(name: TokenSyntax(.identifier("<#Type#>"), presence: .present))
            )
            let newClause = FunctionParameterClauseSyntax(
                leftParen: .leftParenToken(),
                parameters: FunctionParameterListSyntax([placeholderParameter]),
                rightParen: .rightParenToken(trailingTrivia: .space)
            )
            return [
                FixIt(
                    message: JSMacroFixItMessage(message: "Add a value parameter to the setter"),
                    changes: [
                        .replace(
                            oldNode: Syntax(functionDecl.signature.parameterClause),
                            newNode: Syntax(newClause)
                        )
                    ]
                )
            ]
        }()

        // Extract property name from setter function name (e.g., "setFoo" -> "foo")
        // Strip backticks if present (e.g., "set`prefix`" -> "prefix")
        let rawFunctionName = JSMacroHelper.stripBackticks(functionName)
        guard rawFunctionName.hasPrefix("set"), rawFunctionName.count > 3 else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.invalidSetterName,
                    notes: [
                        Note(
                            node: Syntax(functionDecl.name),
                            message: JSMacroNoteMessage(
                                message: "Setter names must start with 'set' followed by the property name."
                            )
                        )
                    ],
                    fixIts: renameFixIts
                )
            )
            return [
                CodeBlockItemSyntax(
                    stringLiteral:
                        "fatalError(\"@JSSetter function name must start with 'set' followed by a property name\")"
                )
            ]
        }

        let propertyName = String(rawFunctionName.dropFirst(3))
        guard !propertyName.isEmpty else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.invalidSetterName,
                    notes: [
                        Note(
                            node: Syntax(functionDecl.name),
                            message: JSMacroNoteMessage(
                                message: "Setter names must include the property after 'set'."
                            )
                        )
                    ],
                    fixIts: renameFixIts
                )
            )
            return [
                CodeBlockItemSyntax(
                    stringLiteral:
                        "fatalError(\"@JSSetter function name must start with 'set' followed by a property name\")"
                )
            ]
        }

        // Convert first character to lowercase (e.g., "Foo" -> "foo")
        let baseName = propertyName.prefix(1).lowercased() + propertyName.dropFirst()

        let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context)
        let isStatic = JSMacroHelper.isStatic(functionDecl.modifiers)
        let isTopLevel = enclosingTypeName == nil
        let isInstanceMember = !isTopLevel && !isStatic
        if !isTopLevel {
            JSMacroHelper.diagnoseMissingJSClass(node: node, for: "JSSetter", in: context)
        }

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
        guard let firstParam = parameters.first else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.setterRequiresParameter,
                    notes: [
                        Note(
                            node: Syntax(declaration),
                            message: JSMacroNoteMessage(
                                message: "@JSSetter needs a parameter for the value being assigned."
                            )
                        )
                    ],
                    fixIts: addParameterFixIts
                )
            )
            return [
                CodeBlockItemSyntax(
                    stringLiteral: "fatalError(\"@JSSetter function must have at least one parameter\")"
                )
            ]
        }

        let paramName = firstParam.secondName ?? firstParam.firstName
        arguments.append(paramName.text)

        // Ensure throws(JSException) is declared to match the generated body.
        let existingThrowsClause = functionDecl.signature.effectSpecifiers?.throwsClause
        let existingThrowsType = existingThrowsClause?.type
            .flatMap { $0.as(IdentifierTypeSyntax.self)?.name.text }
        let hasTypedJSException = existingThrowsType == "JSException"
        let isAllowedGenericError =
            existingThrowsClause != nil
            && (existingThrowsType == nil || existingThrowsType == "Error" || existingThrowsType == "Swift.Error")

        if !hasTypedJSException && !isAllowedGenericError {
            let throwsClause = JSMacroHelper.jsExceptionThrowsClause(
                from: existingThrowsClause
            )
            let newEffects =
                (functionDecl.signature.effectSpecifiers
                ?? FunctionEffectSpecifiersSyntax(asyncSpecifier: nil, throwsClause: nil))
                .with(\.throwsClause, throwsClause)
            let newSignature = functionDecl.signature.with(\.effectSpecifiers, newEffects)
            let fixIt = FixIt(
                message: JSMacroFixItMessage(message: "Declare throws(JSException)"),
                changes: [.replace(oldNode: Syntax(functionDecl.signature), newNode: Syntax(newSignature))]
            )
            let notes: [Note] = [
                JSMacroHelper.jsExceptionPropagationNote(
                    on: Syntax(functionDecl),
                    message: JSMacroText.jsSetterExceptionPropagation
                )
            ]
            context.diagnose(
                Diagnostic(
                    node: Syntax(functionDecl),
                    message: JSMacroMessage.setterRequiresThrows,
                    notes: notes,
                    fixIts: [fixIt]
                )
            )
        }

        let argsJoined = arguments.joined(separator: ", ")
        let call = "\(glueName)(\(argsJoined))"

        // Setters should throw JSException, so always use try
        return [CodeBlockItemSyntax(stringLiteral: "try \(call)")]
    }
}

extension JSSetterMacro: PeerMacro {
    /// Emits a diagnostic when @JSSetter is applied to a declaration that is not a function.
    /// BodyMacro is only invoked for declarations with optional code blocks (e.g. functions).
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.is(FunctionDeclSyntax.self) else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(declaration),
                    message: JSMacroMessage.unsupportedSetterDeclaration,
                    notes: [
                        Note(
                            node: Syntax(declaration),
                            message: JSMacroNoteMessage(
                                message: "@JSSetter should be attached to a method that writes a JavaScript property."
                            )
                        )
                    ]
                )
            )
            return []
        }
        return []
    }
}
