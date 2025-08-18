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
            tools: (tools ?? [:]).merging(overrides.tools ?? [:], uniquingKeysWith: { $1 })
        )
    }
}
