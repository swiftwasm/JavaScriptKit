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

// MARK: - Profiling

/// A simple time-profiler API
public final class Profiling {
    nonisolated(unsafe) static var current: Profiling?

    let beginEntry: (_ label: String) -> Void
    let endEntry: (_ label: String) -> Void
    let finalize: () -> Void

    /// Create a profiling instance that outputs Trace Event Format, which
    /// can be viewed in chrome://tracing or other compatible viewers.
    /// https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/edit?usp=sharing
    public static func traceEvent(output: @escaping (String) -> Void) -> Profiling {
        let clock = ContinuousClock()
        let startTime = clock.now
        var firstEntry = true

        func formatTimestamp() -> Int {
            let duration = startTime.duration(to: .now)
            let (seconds, attoseconds) = duration.components
            // Convert to microseconds
            return Int(seconds * 1_000_000 + attoseconds / 1_000_000_000_000)
        }

        return Profiling(
            beginEntry: { label in
                let entry = #"{"ph":"B","pid":1,"name":\#(JSON.serialize(label)),"ts":\#(formatTimestamp())}"#
                if firstEntry {
                    firstEntry = false
                    output("[\n\(entry)")
                } else {
                    output(",\n\(entry)")
                }
            },
            endEntry: { label in
                output(#",\#n{"ph":"E","pid":1,"name":\#(JSON.serialize(label)),"ts":\#(formatTimestamp())}"#)
            },
            finalize: {
                output("]\n")
            }
        )
    }

    public init(
        beginEntry: @escaping (_ label: String) -> Void,
        endEntry: @escaping (_ label: String) -> Void,
        finalize: @escaping () -> Void
    ) {
        self.beginEntry = beginEntry
        self.endEntry = endEntry
        self.finalize = finalize
    }

    public static func with(_ makeCurrent: () -> Profiling?, body: @escaping () throws -> Void) rethrows -> Void {
        guard let current = makeCurrent() else {
            return try body()
        }
        defer { current.finalize() }
        Profiling.current = current
        defer { Profiling.current = nil }
        return try body()
    }
}

/// Mark a span of code with a label and measure the duration.
public func withSpan<T>(_ label: String, body: @escaping () throws -> T) rethrows -> T {
    guard let profiling = Profiling.current else {
        return try body()
    }
    profiling.beginEntry(label)
    defer {
        profiling.endEntry(label)
    }
    return try body()
}

/// Foundation-less JSON serialization
private enum JSON {
    static func serialize(_ value: String) -> String {
        // https://www.ietf.org/rfc/rfc4627.txt
        var output = "\""
        for scalar in value.unicodeScalars {
            switch scalar {
            case "\"":
                output += "\\\""
            case "\\":
                output += "\\\\"
            case "\u{08}":
                output += "\\b"
            case "\u{0C}":
                output += "\\f"
            case "\n":
                output += "\\n"
            case "\r":
                output += "\\r"
            case "\t":
                output += "\\t"
            case "\u{20}"..."\u{21}", "\u{23}"..."\u{5B}", "\u{5D}"..."\u{10FFFF}":
                output.unicodeScalars.append(scalar)
            default:
                var hex = String(scalar.value, radix: 16, uppercase: true)
                hex = String(repeating: "0", count: 4 - hex.count) + hex
                output += "\\u" + hex
            }
        }
        output += "\""
        return output
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
