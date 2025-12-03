import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum JSImportFunctionMacro {}

extension JSImportFunctionMacro: BodyMacro {
  package static func expansion(
    of node: AttributeSyntax,
    providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax] {
    return [
        "fatalError(\"Not implemented\")"
    ]
  }
}

enum JSImportVariableMacro {}

extension JSImportVariableMacro: AccessorMacro {
  package static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
) throws -> [AccessorDeclSyntax] {
    return [
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            effectSpecifiers: AccessorEffectSpecifiersSyntax(
                asyncSpecifier: nil,
                throwsClause: nil
            ),
            body: CodeBlockSyntax {
                "fatalError(\"Not implemented\")"
            }
        )
    ]
  }
}

extension JSImportFunctionMacro: AccessorMacro {
  package static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
) throws -> [AccessorDeclSyntax] {
    return [
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            effectSpecifiers: AccessorEffectSpecifiersSyntax(
                asyncSpecifier: nil,
                throwsClause: nil
            ),
            body: CodeBlockSyntax {
                "fatalError(\"Not implemented\")"
            }
        )
    ]
  }
}

extension JSImportFunctionMacro: PeerMacro {
  package static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
) throws -> [DeclSyntax] {
    let functionDecl: DeclSyntax = """
        func \(raw: context.makeUniqueName("jsImportFunction"))() -> UInt32 {
          fatalError("Not implemented")
        }
    """
    return [functionDecl]
  }
}
