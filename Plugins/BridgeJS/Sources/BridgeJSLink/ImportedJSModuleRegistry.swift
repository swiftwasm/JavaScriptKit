#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

final class ImportedJSModuleRegistry {
    private struct Key: Hashable {
        let swiftModuleName: String
        let path: String
    }

    private var aliases: [Key: String] = [:]
    private(set) var artifacts: [BridgeJSLinkOutput.Module] = []

    func configure(skeletons: [BridgeJSSkeleton]) throws {
        aliases.removeAll(keepingCapacity: true)
        artifacts.removeAll(keepingCapacity: true)

        var sources: [Key: String] = [:]
        for skeleton in skeletons {
            for module in skeleton.imported?.modules ?? [] {
                let key = Key(swiftModuleName: skeleton.moduleName, path: module.path)
                if let existing = sources[key], existing != module.source {
                    throw BridgeJSLinkError(
                        message: "Conflicting JavaScript module contents for \(skeleton.moduleName)/\(module.path)"
                    )
                }
                sources[key] = module.source
            }
        }

        for (index, entry) in sources.sorted(by: {
            ($0.key.swiftModuleName, $0.key.path) < ($1.key.swiftModuleName, $1.key.path)
        }).enumerated() {
            let relativePath = "bridge-js-modules/\(entry.key.swiftModuleName)/\(entry.key.path)"
            aliases[entry.key] = "__bjs_imported_module_\(index)"
            artifacts.append(.init(relativePath: relativePath, source: entry.value))
        }
    }

    func namespaceExpression(swiftModuleName: String, from: JSImportFrom?) throws -> String {
        switch from {
        case nil:
            return "imports"
        case .global:
            return "globalThis"
        case .module(let path):
            let key = Key(swiftModuleName: swiftModuleName, path: path)
            guard let alias = aliases[key] else {
                throw BridgeJSLinkError(
                    message: "Missing embedded JavaScript module for \(swiftModuleName)/\(path)"
                )
            }
            return alias
        }
    }

    var importLines: [String] {
        artifacts.enumerated().map { index, artifact in
            let path = BridgeJSLink.escapeForJavaScriptStringLiteral(artifact.relativePath)
            return "import * as __bjs_imported_module_\(index) from \"./\(path)\";"
        }
    }
}
