import SwiftSyntax

/// Resolves type declarations from Swift syntax nodes
class TypeDeclResolver {
    typealias TypeDecl = NamedDeclSyntax & DeclGroupSyntax & DeclSyntaxProtocol
    /// A representation of a qualified name of a type declaration
    ///
    /// `Outer.Inner` type declaration is represented as ["Outer", "Inner"]
    typealias QualifiedName = [String]
    private var typeDeclByQualifiedName: [QualifiedName: TypeDecl] = [:]
    private var typeAliasByQualifiedName: [QualifiedName: TypeAliasDeclSyntax] = [:]

    enum Error: Swift.Error {
        case typeNotFound(QualifiedName)
    }

    private class TypeDeclCollector: SyntaxVisitor {
        let resolver: TypeDeclResolver
        var scope: [TypeDecl] = []
        var rootTypeDecls: [TypeDecl] = []

        init(resolver: TypeDeclResolver) {
            self.resolver = resolver
            super.init(viewMode: .all)
        }

        func visitNominalDecl(_ node: TypeDecl) -> SyntaxVisitorContinueKind {
            let name = node.name.text
            let qualifiedName = scope.map(\.name.text) + [name]
            resolver.typeDeclByQualifiedName[qualifiedName] = node
            scope.append(node)
            return .visitChildren
        }

        func visitPostNominalDecl() {
            let type = scope.removeLast()
            if scope.isEmpty {
                rootTypeDecls.append(type)
            }
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            return visitNominalDecl(node)
        }
        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            return visitNominalDecl(node)
        }
        override func visitPost(_ node: ClassDeclSyntax) {
            visitPostNominalDecl()
        }
        override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
            return visitNominalDecl(node)
        }
        override func visitPost(_ node: ActorDeclSyntax) {
            visitPostNominalDecl()
        }
        override func visitPost(_ node: StructDeclSyntax) {
            visitPostNominalDecl()
        }
        override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
            return visitNominalDecl(node)
        }
        override func visitPost(_ node: EnumDeclSyntax) {
            visitPostNominalDecl()
        }
        
        override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
            let name = node.name.text
            let qualifiedName = scope.map(\.name.text) + [name]
            resolver.typeAliasByQualifiedName[qualifiedName] = node
            return .skipChildren
        }
    }

    /// Collects type declarations from a parsed Swift source file
    func addSourceFile(_ sourceFile: SourceFileSyntax) {
        let collector = TypeDeclCollector(resolver: self)
        collector.walk(sourceFile)
    }

    /// Builds the type name scope for a given type usage
    private func buildScope(type: IdentifierTypeSyntax) -> QualifiedName {
        var innerToOuter: [String] = []
        var context: SyntaxProtocol = type
        while let parent = context.parent {
            if let parent = parent.asProtocol(NamedDeclSyntax.self), parent.isProtocol(DeclGroupSyntax.self) {
                innerToOuter.append(parent.name.text)
            }
            context = parent
        }
        return innerToOuter.reversed()
    }

    /// Looks up a qualified name of a type declaration by its unqualified type usage
    /// Returns the qualified name hierarchy of the type declaration
    /// If the type declaration is not found, returns the unqualified name
    private func tryQualify(type: IdentifierTypeSyntax) -> QualifiedName {
        let name = type.name.text
        let scope = buildScope(type: type)
        /// Search for the type declaration from the innermost scope to the outermost scope
        for i in (0...scope.count).reversed() {
            let qualifiedName = Array(scope[0..<i] + [name])
            if typeDeclByQualifiedName[qualifiedName] != nil {
                return qualifiedName
            }
        }
        return [name]
    }

    /// Looks up a type declaration by its unqualified type usage
    func lookupType(for type: IdentifierTypeSyntax) -> TypeDecl? {
        let qualifiedName = tryQualify(type: type)
        return typeDeclByQualifiedName[qualifiedName]
    }

    /// Looks up a type declaration by its fully qualified name
    func lookupType(fullyQualified: QualifiedName) -> TypeDecl? {
        return typeDeclByQualifiedName[fullyQualified]
    }

    /// Resolves a type usage node to the corresponding nominal type declaration collected in this resolver.
    ///
    /// Supported inputs:
    /// - IdentifierTypeSyntax (e.g. `Method`) — resolved relative to the lexical scope, preferring the innermost enclosing type.
    /// - MemberTypeSyntax (e.g. `Networking.API.Method`) — resolved by recursively building the fully qualified name.
    ///
    /// Resolution strategy:
    /// 1. If the node is IdentifierTypeSyntax, call `lookupType(for:)` which attempts scope-aware qualification via `tryQualify`.
    /// 2. Otherwise, attempt to build a fully qualified name with `qualifiedComponents(from:)` and look it up with `lookupType(fullyQualified:)`.
    ///
    /// - Parameter type: The SwiftSyntax node representing a type appearance in source code.
    /// - Returns: The nominal declaration (enum/class/actor/struct) if found, otherwise nil.
    func resolve(_ type: TypeSyntax) -> TypeDecl? {
        if let id = type.as(IdentifierTypeSyntax.self) {
            return lookupType(for: id)
        }
        if let components = qualifiedComponents(from: type) {
            return lookupType(fullyQualified: components)
        }
        return nil
    }
    
    /// Resolves a type usage node to a type alias declaration
    ///
    /// - Parameter type: The SwiftSyntax node representing a type appearance in source code.
    /// - Returns: The type alias declaration if found, otherwise nil.
    func resolveTypeAlias(_ type: TypeSyntax) -> TypeAliasDeclSyntax? {
        if let id = type.as(IdentifierTypeSyntax.self) {
            let qualifiedName = tryQualify(type: id)
            return typeAliasByQualifiedName[qualifiedName]
        }
        if let components = qualifiedComponents(from: type) {
            return typeAliasByQualifiedName[components]
        }
        return nil
    }

    private func qualifiedComponents(from type: TypeSyntax) -> QualifiedName? {
        if let m = type.as(MemberTypeSyntax.self) {
            guard let base = qualifiedComponents(from: TypeSyntax(m.baseType)) else { return nil }
            return base + [m.name.text]
        } else if let id = type.as(IdentifierTypeSyntax.self) {
            return [id.name.text]
        } else {
            return nil
        }
    }
}
