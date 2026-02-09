import class Foundation.FileHandle
import class Foundation.ProcessInfo
import func Foundation.open
import func Foundation.strerror
import var Foundation.errno
import var Foundation.O_WRONLY
import var Foundation.O_CREAT
import var Foundation.O_TRUNC

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

/// A simple time-profiler to emit `chrome://tracing` format
public final class Profiling {
    nonisolated(unsafe) static var current: Profiling?

    let startTime: ContinuousClock.Instant
    let clock = ContinuousClock()
    let output: @Sendable (String) -> Void
    var firstEntry = true

    init(output: @Sendable @escaping (String) -> Void) {
        self.startTime = ContinuousClock.now
        self.output = output
    }

    public static func with(body: @escaping () throws -> Void) rethrows -> Void {
        guard let outputPath = ProcessInfo.processInfo.environment["BRIDGE_JS_PROFILING"] else {
            return try body()
        }
        let fd = open(outputPath, O_WRONLY | O_CREAT | O_TRUNC, 0o644)
        guard fd >= 0 else {
            let error = String(cString: strerror(errno))
            fatalError("Failed to open profiling output file \(outputPath): \(error)")
        }
        let output = FileHandle(fileDescriptor: fd, closeOnDealloc: true)
        let profiling = Profiling(output: { output.write($0.data(using: .utf8) ?? Data()) })
        defer {
            profiling.output("]\n")
        }
        Profiling.current = profiling
        defer {
            Profiling.current = nil
        }
        return try body()
    }

    private func formatTimestamp(instant: ContinuousClock.Instant) -> Int {
        let duration = self.startTime.duration(to: instant)
        let (seconds, attoseconds) = duration.components
        // Convert to microseconds
        return Int(seconds * 1_000_000 + attoseconds / 1_000_000_000_000)
    }

    func begin(_ label: String, _ instant: ContinuousClock.Instant) {
        let entry = #"{"ph":"B","pid":1,"name":\#(JSON.serialize(label)),"ts":\#(formatTimestamp(instant: instant))}"#
        if firstEntry {
            firstEntry = false
            output("[\n\(entry)")
        } else {
            output(",\n\(entry)")
        }
    }

    func end(_ label: String, _ instant: ContinuousClock.Instant) {
        let entry = #"{"ph":"E","pid":1,"name":\#(JSON.serialize(label)),"ts":\#(formatTimestamp(instant: instant))}"#
        output(",\n\(entry)")
    }
}

/// Mark a span of code with a label and measure the duration.
public func withSpan<T>(_ label: String, body: @escaping () throws -> T) rethrows -> T {
    guard let profiling = Profiling.current else {
        return try body()
    }
    profiling.begin(label, profiling.clock.now)
    defer {
        profiling.end(label, profiling.clock.now)
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
