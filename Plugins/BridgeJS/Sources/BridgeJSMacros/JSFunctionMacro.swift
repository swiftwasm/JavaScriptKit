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
            let isTopLevel = enclosingTypeName == nil
            let isInstanceMember = !isTopLevel && !isStatic
            if !isTopLevel {
                JSMacroHelper.diagnoseMissingJSClass(node: node, for: "JSFunction", in: context)
            }

            JSMacroHelper.diagnoseThrowsRequiresJSException(
                signature: functionDecl.signature,
                on: Syntax(functionDecl),
                in: context
            )

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
            let prefix = JSMacroHelper.tryAwaitPrefix(isAsync: isAsync, isThrows: true)

            let isVoid = JSMacroHelper.isVoidReturn(functionDecl.signature.returnClause?.type)
            let line = isVoid ? "\(prefix)\(call)" : "return \(prefix)\(call)"
            return [CodeBlockItemSyntax(stringLiteral: line)]
        }

        if let initializerDecl = declaration.as(InitializerDeclSyntax.self) {
            guard let enclosingTypeName = JSMacroHelper.enclosingTypeName(from: context) else {
                context.diagnose(
                    Diagnostic(
                        node: Syntax(declaration),
                        message: JSMacroMessage.unsupportedDeclaration,
                        notes: [
                            Note(
                                node: Syntax(declaration),
                                message: JSMacroNoteMessage(
                                    message: "Move this initializer inside a JS wrapper type annotated with @JSClass."
                                )
                            )
                        ]
                    )
                )
                return [CodeBlockItemSyntax(stringLiteral: "fatalError(\"@JSFunction init must be inside a type\")")]
            }

            JSMacroHelper.diagnoseMissingJSClass(node: node, for: "JSFunction", in: context)
            JSMacroHelper.diagnoseThrowsRequiresJSException(
                signature: initializerDecl.signature,
                on: Syntax(initializerDecl),
                in: context
            )

            let glueName = JSMacroHelper.glueName(baseName: "init", enclosingTypeName: enclosingTypeName)
            let parameters = initializerDecl.signature.parameterClause.parameters
            let arguments = JSMacroHelper.parameterNames(parameters)
            let call = "\(glueName)(\(arguments.joined(separator: ", ")))"

            let effects = initializerDecl.signature.effectSpecifiers
            let isAsync = effects?.asyncSpecifier != nil
            let prefix = JSMacroHelper.tryAwaitPrefix(isAsync: isAsync, isThrows: true)

            return [
                CodeBlockItemSyntax(stringLiteral: "let jsObject = \(prefix)\(call)"),
                CodeBlockItemSyntax(stringLiteral: "self.init(unsafelyWrapping: jsObject)"),
            ]
        }

        context.diagnose(
            Diagnostic(
                node: Syntax(declaration),
                message: JSMacroMessage.unsupportedDeclaration,
                notes: [
                    Note(
                        node: Syntax(declaration),
                        message: JSMacroNoteMessage(
                            message: "Apply @JSFunction to a function or initializer on your @JSClass wrapper type."
                        )
                    )
                ]
            )
        )
        return []
    }
}

extension JSFunctionMacro: PeerMacro {
    /// Emits a diagnostic when @JSFunction is applied to a declaration that is not a function or initializer.
    /// BodyMacro is only invoked for declarations with optional code blocks (e.g. functions, initializers),
    /// so for vars and other decls we need PeerMacro to run and diagnose.
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if declaration.is(FunctionDeclSyntax.self) { return [] }
        if declaration.is(InitializerDeclSyntax.self) { return [] }
        context.diagnose(
            Diagnostic(
                node: Syntax(declaration),
                message: JSMacroMessage.unsupportedDeclaration,
                notes: [
                    Note(
                        node: Syntax(declaration),
                        message: JSMacroNoteMessage(
                            message:
                                "Place @JSFunction on a function or initializer; use @JSGetter/@JSSetter for properties."
                        )
                    )
                ]
            )
        )
        return []
    }
}
