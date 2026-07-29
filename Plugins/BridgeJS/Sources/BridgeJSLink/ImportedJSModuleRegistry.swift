#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

final class ImportedJSModuleRegistry {
    struct Reference: Hashable {
        let swiftModuleName: String
        let path: String

        var relativeOutputPath: String {
            "bridge-js-modules/\(swiftModuleName)\(path)"
        }
    }

    private var aliases: [Reference: String] = [:]
    private(set) var references: [Reference] = []

    func configure(skeletons: [BridgeJSSkeleton]) {
        aliases.removeAll(keepingCapacity: true)
        references = Self.collectReferences(skeletons: skeletons)
        for (index, reference) in references.enumerated() {
            aliases[reference] = "__bjs_imported_module_\(index)"
        }
    }

    static func collectReferences(skeletons: [BridgeJSSkeleton]) -> [Reference] {
        var references = Set<Reference>()
        for skeleton in skeletons {
            for file in skeleton.imported?.children ?? [] {
                let origins =
                    file.functions.compactMap(\.from)
                    + file.globalGetters.compactMap(\.from)
                    + file.types.compactMap(\.from)
                for case .module(let path) in origins {
                    references.insert(Reference(swiftModuleName: skeleton.moduleName, path: path))
                }
            }
        }
        return references.sorted {
            ($0.swiftModuleName, $0.path) < ($1.swiftModuleName, $1.path)
        }
    }

    func namespaceExpression(swiftModuleName: String, from: JSImportFrom?) throws -> String {
        switch from {
        case nil:
            return "imports"
        case .global:
            return "globalThis"
        case .module(let path):
            let reference = Reference(swiftModuleName: swiftModuleName, path: path)
            guard let alias = aliases[reference] else {
                throw BridgeJSLinkError(
                    message: "Missing JavaScript module \(swiftModuleName)\(path)"
                )
            }
            return alias
        }
    }

    var importLines: [String] {
        references.enumerated().map { index, reference in
            let path = BridgeJSLink.escapeForJavaScriptStringLiteral(reference.relativeOutputPath)
            return "import * as __bjs_imported_module_\(index) from \"./\(path)\";"
        }
    }
}
