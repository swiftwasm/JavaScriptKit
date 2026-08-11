#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

import Foundation

final class ImportedJSModuleRegistry {
    /// A JavaScript module that imported declarations are read from.
    ///
    /// A `snippet` reference is a file inside a Swift target, which packaging copies
    /// into the generated output. A `module` reference is a bare specifier resolved by
    /// the JavaScript host (a bundler, an import map, or Node's `node_modules` lookup),
    /// so it has no file and nothing to copy. Because a bare specifier names the same
    /// module no matter which Swift module mentions it — and ECMAScript caches module
    /// instances — it is keyed by specifier alone and shared across targets.
    enum Reference: Hashable {
        case snippet(swiftModuleName: String, path: String)
        case module(specifier: String)
    }

    /// A JavaScript file shipped in a Swift target that packaging must copy into the output.
    struct SnippetFile: Hashable {
        let swiftModuleName: String
        let path: String

        var relativeOutputPath: String {
            "bridge-js-modules/\(swiftModuleName)\(path)"
        }
    }

    private struct Binding {
        let index: Int
        /// Member names looked up on this module, sorted for stable output.
        let members: [String]
        /// Whether every member name is a valid JavaScript identifier, and so can be
        /// reached with a named import instead of a namespace property lookup.
        let usesNamedImports: Bool
    }

    private var bindings: [Reference: Binding] = [:]
    private(set) var references: [Reference] = []

    /// The snippet files packaging must copy, in deterministic order.
    var snippetFiles: [SnippetFile] {
        references.compactMap { reference in
            guard case .snippet(let swiftModuleName, let path) = reference else { return nil }
            return SnippetFile(swiftModuleName: swiftModuleName, path: path)
        }
    }

    func configure(skeletons: [BridgeJSSkeleton]) {
        bindings.removeAll(keepingCapacity: true)
        references = Self.collectReferences(skeletons: skeletons)

        var membersByReference: [Reference: Set<String>] = [:]
        for skeleton in skeletons {
            Self.forEachMemberLookup(skeleton: skeleton) { reference, memberName in
                membersByReference[reference, default: []].insert(memberName)
            }
        }

        for (index, reference) in references.enumerated() {
            let members = (membersByReference[reference] ?? []).sorted()
            // A reference with no member lookups keeps the namespace form: a named import
            // is a hard link-time requirement, so importing a name nothing references
            // would fail the whole module load if the module does not export it.
            bindings[reference] = Binding(
                index: index,
                members: members,
                usesNamedImports: !members.isEmpty && members.allSatisfy(Self.isValidJSIdentifier)
            )
        }
    }

    static func collectReferences(skeletons: [BridgeJSSkeleton]) -> [Reference] {
        var references = Set<Reference>()
        for skeleton in skeletons {
            forEachOrigin(skeleton: skeleton) { reference in
                references.insert(reference)
            }
        }
        return references.sorted(by: isOrderedBefore)
    }

    static func collectSnippetFiles(skeletons: [BridgeJSSkeleton]) -> [SnippetFile] {
        collectReferences(skeletons: skeletons).compactMap { reference in
            guard case .snippet(let swiftModuleName, let path) = reference else { return nil }
            return SnippetFile(swiftModuleName: swiftModuleName, path: path)
        }
    }

    /// Visits every module origin mentioned by the skeleton, whether or not code
    /// generation looks a member up on it.
    ///
    /// This is what decides which modules are imported at all, and for snippets which
    /// files packaging copies. It stays broader than `forEachMemberLookup` so
    /// that a module mentioned only by a wrapper-only `@JSClass` is still imported,
    /// preserving its side effects.
    private static func forEachOrigin(
        skeleton: BridgeJSSkeleton,
        _ body: (Reference) -> Void
    ) {
        func visit(from: JSImportFrom?) {
            guard let reference = Self.reference(swiftModuleName: skeleton.moduleName, from: from) else { return }
            body(reference)
        }
        for file in skeleton.imported?.children ?? [] {
            for function in file.functions { visit(from: function.from) }
            for getter in file.globalGetters { visit(from: getter.from) }
            for type in file.types { visit(from: type.from) }
        }
    }

    /// Visits every module member lookup that code generation will emit.
    ///
    /// The member name taken here must match what the corresponding emitter in
    /// `BridgeJSLink` looks up, and must not include names it never emits: a named
    /// import is a hard link-time requirement, so recording a member that no
    /// generated code references would make the module fail to load whenever the
    /// module does not happen to export that name.
    ///
    /// A class contributes a single binding that serves both its constructor and its
    /// static methods, and only when it has one of those. Instance methods, getters,
    /// and setters contribute nothing because they go through an already-constructed
    /// instance, so a wrapper-only `@JSClass` needs no export from the module at all.
    private static func forEachMemberLookup(
        skeleton: BridgeJSSkeleton,
        _ body: (Reference, String) -> Void
    ) {
        func visit(from: JSImportFrom?, memberName: String) {
            guard let reference = Self.reference(swiftModuleName: skeleton.moduleName, from: from) else { return }
            body(reference, memberName)
        }
        for file in skeleton.imported?.children ?? [] {
            for function in file.functions {
                visit(from: function.from, memberName: function.resolvedJSName)
            }
            for getter in file.globalGetters {
                visit(from: getter.from, memberName: getter.resolvedJSName)
            }
            for type in file.types {
                guard type.constructor != nil || !type.staticMethods.isEmpty else { continue }
                visit(from: type.from, memberName: type.resolvedJSName)
            }
        }
    }

    private static func reference(swiftModuleName: String, from: JSImportFrom?) -> Reference? {
        switch from {
        case .snippet(let path):
            return .snippet(swiftModuleName: swiftModuleName, path: path)
        case .module(let specifier):
            return .module(specifier: specifier)
        case .global, nil:
            return nil
        }
    }

    private static func isOrderedBefore(_ lhs: Reference, _ rhs: Reference) -> Bool {
        switch (lhs, rhs) {
        case (.snippet(let lhsModule, let lhsPath), .snippet(let rhsModule, let rhsPath)):
            return (lhsModule, lhsPath) < (rhsModule, rhsPath)
        case (.module(let lhsSpecifier), .module(let rhsSpecifier)):
            return lhsSpecifier < rhsSpecifier
        case (.snippet, .module):
            return true
        case (.module, .snippet):
            return false
        }
    }

    /// Whether `name` can appear as a bare identifier in generated JavaScript.
    static func isValidJSIdentifier(_ name: String) -> Bool {
        name.range(of: #"^[$A-Z_][0-9A-Z_$]*$"#, options: [.regularExpression, .caseInsensitive]) != nil
    }

    /// Returns the JavaScript expression that evaluates to `memberName` of the given origin.
    func memberExpression(
        swiftModuleName: String,
        from: JSImportFrom?,
        memberName: String
    ) throws -> String {
        switch from {
        case nil:
            return BridgeJSLink.ImportedThunkBuilder.propertyAccessExpr(objectExpr: "imports", propertyName: memberName)
        case .global:
            return BridgeJSLink.ImportedThunkBuilder.propertyAccessExpr(
                objectExpr: "globalThis",
                propertyName: memberName
            )
        case .snippet, .module:
            guard let reference = Self.reference(swiftModuleName: swiftModuleName, from: from),
                let binding = bindings[reference]
            else {
                throw BridgeJSLinkError(
                    message:
                        "Missing JavaScript module \(swiftModuleName)\(from?.snippetPath ?? from?.moduleSpecifier ?? "")"
                )
            }
            if binding.usesNamedImports {
                return Self.namedImportBinding(index: binding.index, memberName: memberName)
            }
            return BridgeJSLink.ImportedThunkBuilder.propertyAccessExpr(
                objectExpr: Self.namespaceAlias(index: binding.index),
                propertyName: memberName
            )
        }
    }

    private static func namespaceAlias(index: Int) -> String {
        "__bjs_imported_module_\(index)"
    }

    private static func namedImportBinding(index: Int, memberName: String) -> String {
        "__bjs_import_\(index)_\(memberName)"
    }

    var importLines: [String] {
        references.compactMap { reference in
            guard let binding = bindings[reference] else { return nil }
            let specifier: String
            switch reference {
            case .snippet(let swiftModuleName, let path):
                let output = SnippetFile(swiftModuleName: swiftModuleName, path: path).relativeOutputPath
                specifier = "./" + BridgeJSLink.escapeForJavaScriptStringLiteral(output)
            case .module(let moduleSpecifier):
                specifier = BridgeJSLink.escapeForJavaScriptStringLiteral(moduleSpecifier)
            }
            guard binding.usesNamedImports else {
                return "import * as \(Self.namespaceAlias(index: binding.index)) from \"\(specifier)\";"
            }
            let clauses = binding.members.map {
                "\($0) as \(Self.namedImportBinding(index: binding.index, memberName: $0))"
            }
            return "import { \(clauses.joined(separator: ", ")) } from \"\(specifier)\";"
        }
    }
}
