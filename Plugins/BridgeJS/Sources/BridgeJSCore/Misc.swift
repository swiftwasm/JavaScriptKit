// MARK: - ProgressReporting

public struct ProgressReporting {
    let print: (String) -> Void

    public init(verbose: Bool) {
        self.init(print: verbose ? { Swift.print($0) } : { _ in })
    }

    private init(print: @escaping (String) -> Void) {
        self.print = print
    }

    public static var silent: ProgressReporting {
        return ProgressReporting(print: { _ in })
    }

    public func print(_ message: String) {
        self.print(message)
    }
}

// MARK: - DiagnosticError

import SwiftSyntax

struct DiagnosticError: Error {
    let node: Syntax
    let message: String
    let hint: String?

    init(node: some SyntaxProtocol, message: String, hint: String? = nil) {
        self.node = Syntax(node)
        self.message = message
        self.hint = hint
    }

    func formattedDescription(fileName: String) -> String {
        let locationConverter = SourceLocationConverter(fileName: fileName, tree: node.root)
        let location = locationConverter.location(for: node.position)
        var description = "\(fileName):\(location.line):\(location.column): error: \(message)"
        if let hint {
            description += "\nHint: \(hint)"
        }
        return description
    }
}

// MARK: - BridgeJSCoreError

public struct BridgeJSCoreError: Swift.Error, CustomStringConvertible {
    public let description: String

    public init(_ message: String) {
        self.description = message
    }
}

// MARK: - BridgeJSConfig

import struct Foundation.URL
import struct Foundation.Data
import class Foundation.FileManager
import class Foundation.JSONDecoder

/// Configuration file representation for BridgeJS.
public struct BridgeJSConfig: Codable {
    /// A mapping of tool names to their override paths.
    ///
    /// If not present, the tool will be searched for in the system PATH.
    public var tools: [String: String]?

    /// Whether to expose exported Swift APIs to the global namespace.
    ///
    /// When `true`, exported functions, classes, and namespaces are available
    /// via `globalThis` in JavaScript. When `false`, they are only available
    /// through the exports object returned by `createExports()`.
    ///
    /// Default: `false`
    public var exposeToGlobal: Bool

    public init(tools: [String: String]? = nil, exposeToGlobal: Bool = false) {
        self.tools = tools
        self.exposeToGlobal = exposeToGlobal
    }

    enum CodingKeys: String, CodingKey {
        case tools
        case exposeToGlobal
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tools = try container.decodeIfPresent([String: String].self, forKey: .tools)
        exposeToGlobal = try container.decodeIfPresent(Bool.self, forKey: .exposeToGlobal) ?? false
    }

    /// Load the configuration file from the SwiftPM package target directory.
    ///
    /// Files are loaded **in this order** and merged (later files override earlier ones):
    /// 1. `bridge-js.config.json`
    /// 2. `bridge-js.config.local.json`
    public static func load(targetDirectory: URL) throws -> BridgeJSConfig {
        // Define file paths in priority order: base first, then local overrides
        let files = [
            targetDirectory.appendingPathComponent("bridge-js.config.json"),
            targetDirectory.appendingPathComponent("bridge-js.config.local.json"),
        ]

        var config = BridgeJSConfig()

        for file in files {
            do {
                if let loaded = try loadConfig(from: file) {
                    config = config.merging(overrides: loaded)
                }
            } catch {
                throw BridgeJSCoreError("Failed to parse \(file.path): \(error)")
            }
        }

        return config
    }

    /// Load a config file from the given URL if it exists, otherwise return nil
    private static func loadConfig(from url: URL) throws -> BridgeJSConfig? {
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(BridgeJSConfig.self, from: data)
    }

    /// Merge the current configuration with the overrides.
    func merging(overrides: BridgeJSConfig) -> BridgeJSConfig {
        return BridgeJSConfig(
            tools: (tools ?? [:]).merging(overrides.tools ?? [:], uniquingKeysWith: { $1 }),
            exposeToGlobal: overrides.exposeToGlobal
        )
    }
}
