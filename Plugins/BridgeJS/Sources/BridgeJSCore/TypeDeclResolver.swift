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
        var scope: [String] = []

        init(resolver: TypeDeclResolver) {
            self.resolver = resolver
            super.init(viewMode: .all)
        }

        func visitNominalDecl(_ node: TypeDecl) -> SyntaxVisitorContinueKind {
            let name = node.name.text
            let qualifiedName = scope + [name]
            resolver.typeDeclByQualifiedName[qualifiedName] = node
            scope.append(name)
            return .visitChildren
        }

        func visitPostNominalDecl() {
            scope.removeLast()
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
        override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
            return visitNominalDecl(node)
        }
        override func visitPost(_ node: ProtocolDeclSyntax) {
            visitPostNominalDecl()
        }

        override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
            let name = node.name.text
            let qualifiedName = scope + [name]
            resolver.typeAliasByQualifiedName[qualifiedName] = node
            return .skipChildren
        }

        override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
            guard let components = node.memberScopeComponents else {
                return .skipChildren
            }
            scope.append(contentsOf: components)
            return .visitChildren
        }
        override func visitPost(_ node: ExtensionDeclSyntax) {
            scope.removeLast(node.memberScopeComponents?.count ?? 0)
        }
    }

    /// Collects type declarations from a parsed Swift source file
    func addSourceFile(_ sourceFile: SourceFileSyntax) {
        let collector = TypeDeclCollector(resolver: self)
        collector.walk(sourceFile)
    }

    /// Builds the type name scope for a given type usage
    private func buildScope(type: TypeSyntax) -> QualifiedName {
        var innerToOuter: [String] = []
        var context: SyntaxProtocol = type
        while let parent = context.parent {
            if let parent = parent.asProtocol(NamedDeclSyntax.self), parent.isProtocol(DeclGroupSyntax.self) {
                innerToOuter.append(parent.name.text)
            } else if let extensionDecl = parent.as(ExtensionDeclSyntax.self),
                let components = extensionDecl.memberScopeComponents
            {
                innerToOuter.append(contentsOf: components.reversed())
            }
            context = parent
        }
        return innerToOuter.reversed()
    }

    /// Looks up a qualified name of a type declaration relative to its lexical scope
    /// Returns the qualified name hierarchy of the type declaration
    /// If the type declaration is not found, returns the original qualified name
    private func tryQualify(type: TypeSyntax) -> QualifiedName? {
        guard let components = type.qualifiedComponents else {
            return nil
        }
        let scope = buildScope(type: type)
        /// Search for the type declaration from the innermost scope to the outermost scope
        for i in (0...scope.count).reversed() {
            let qualifiedName = Array(scope.prefix(i)) + components
            if typeDeclByQualifiedName[qualifiedName] != nil || typeAliasByQualifiedName[qualifiedName] != nil {
                return qualifiedName
            }
        }
        return components
    }

    /// Looks up a type declaration by its unqualified type usage
    func lookupType(for type: IdentifierTypeSyntax) -> TypeDecl? {
        guard let qualifiedName = tryQualify(type: TypeSyntax(type)) else {
            return nil
        }
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
    /// - MemberTypeSyntax (e.g. `Networking.API.Method`) — resolved relative to the lexical scope before falling back to the fully qualified name.
    ///
    /// Resolution strategy:
    /// Build the qualified name with `qualifiedComponents`, then attempt scope-aware qualification via `tryQualify`.
    ///
    /// - Parameter type: The SwiftSyntax node representing a type appearance in source code.
    /// - Returns: The nominal declaration (enum/class/actor/struct) if found, otherwise nil.
    func resolve(_ type: TypeSyntax) -> TypeDecl? {
        if let qualifiedName = tryQualify(type: type) {
            return lookupType(fullyQualified: qualifiedName)
        }
        return nil
    }

    func resolveExtensionTarget(_ type: TypeSyntax) -> TypeDecl? {
        guard let qualifiedName = type.qualifiedComponents else {
            return nil
        }
        return lookupType(fullyQualified: qualifiedName)
    }

    /// Resolves a type usage node to a type alias declaration
    ///
    /// - Parameter type: The SwiftSyntax node representing a type appearance in source code.
    /// - Returns: The type alias declaration if found, otherwise nil.
    func resolveTypeAlias(_ type: TypeSyntax) -> TypeAliasDeclSyntax? {
        if let qualifiedName = tryQualify(type: type) {
            return typeAliasByQualifiedName[qualifiedName]
        }
        return nil
    }

}

extension TypeSyntax {
    var qualifiedComponents: TypeDeclResolver.QualifiedName? {
        if let m = self.as(MemberTypeSyntax.self) {
            guard let base = TypeSyntax(m.baseType).qualifiedComponents else { return nil }
            return base + [m.name.text]
        } else if let id = self.as(IdentifierTypeSyntax.self) {
            return [id.name.text]
        } else {
            return nil
        }
    }
}

extension ExtensionDeclSyntax {
    var memberScopeComponents: TypeDeclResolver.QualifiedName? {
        extendedType.qualifiedComponents
    }
}
