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
import class Foundation.ProcessInfo

struct DiagnosticError: Error {
    let node: Syntax
    let message: String
    let hint: String?

    init(node: some SyntaxProtocol, message: String, hint: String? = nil) {
        self.node = Syntax(node)
        self.message = message
        self.hint = hint
    }

    /// Formats the diagnostic error as a string.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file to display in the output.
    ///   - colorize: Whether to colorize the output with ANSI escape sequences.
    /// - Returns: The formatted diagnostic error string.
    func formattedDescription(fileName: String, colorize: Bool = Self.shouldColorize) -> String {
        let displayFileName = fileName == "-" ? "<stdin>" : fileName
        let converter = SourceLocationConverter(fileName: displayFileName, tree: node.root)
        let startLocation = converter.location(for: node.positionAfterSkippingLeadingTrivia)
        let endLocation = converter.location(for: node.endPositionBeforeTrailingTrivia)

        let sourceText = node.root.description
        let lines = sourceText.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
        let startLineIndex = max(0, min(lines.count - 1, startLocation.line - 1))
        let mainLine = String(lines[startLineIndex])

        let lineNumberWidth = max(3, String(lines.count).count)

        let header: String = {
            guard colorize else {
                return "\(displayFileName):\(startLocation.line):\(startLocation.column): error: \(message)"
            }
            return
                "\(displayFileName):\(startLocation.line):\(startLocation.column): \(ANSI.boldRed)error: \(ANSI.boldDefault)\(message)\(ANSI.reset)"
        }()

        let highlightStartColumn = min(max(1, startLocation.column), mainLine.utf8.count + 1)
        let availableColumns = max(0, mainLine.utf8.count - (highlightStartColumn - 1))
        let rawHighlightLength: Int = {
            guard availableColumns > 0 else { return 0 }
            if startLocation.line == endLocation.line {
                return max(1, min(endLocation.column - startLocation.column, availableColumns))
            } else {
                return min(1, availableColumns)
            }
        }()
        let highlightLength = min(rawHighlightLength, availableColumns)

        let formattedMainLine: String = {
            guard colorize, highlightLength > 0 else { return mainLine }

            let startIndex = Self.index(atUTF8Offset: highlightStartColumn - 1, in: mainLine)
            let endIndex = Self.index(atUTF8Offset: highlightStartColumn - 1 + highlightLength, in: mainLine)

            let prefix = String(mainLine[..<startIndex])
            let highlighted = String(mainLine[startIndex..<endIndex])
            let suffix = String(mainLine[endIndex...])

            return prefix + ANSI.underline + highlighted + ANSI.reset + suffix
        }()

        var descriptionParts = [header]

        // Include up to the previous three lines for context
        for offset in (-3)...(-1) {
            let lineIndex = startLineIndex + offset
            guard lineIndex >= 0, lineIndex < lines.count else { continue }
            descriptionParts.append(
                Self.formatSourceLine(
                    number: lineIndex + 1,
                    text: String(lines[lineIndex]),
                    width: lineNumberWidth,
                    colorize: colorize
                )
            )
        }

        descriptionParts.append(
            Self.formatSourceLine(
                number: startLocation.line,
                text: formattedMainLine,
                width: lineNumberWidth,
                colorize: colorize
            )
        )

        let pointerSpacing = max(0, highlightStartColumn - 1)
        let pointerMessage: String = {
            let pointer = String(repeating: " ", count: pointerSpacing) + "`- "
            guard colorize else { return pointer + "error: \(message)" }
            return pointer + "\(ANSI.boldRed)error: \(ANSI.boldDefault)\(message)\(ANSI.reset)"
        }()
        descriptionParts.append(
            Self.formatSourceLine(
                number: nil,
                text: pointerMessage,
                width: lineNumberWidth,
                colorize: colorize
            )
        )

        if startLineIndex + 1 < lines.count {
            descriptionParts.append(
                Self.formatSourceLine(
                    number: startLocation.line + 1,
                    text: String(lines[startLineIndex + 1]),
                    width: lineNumberWidth,
                    colorize: colorize
                )
            )
        }

        if let hint {
            descriptionParts.append("Hint: \(hint)")
        }

        return descriptionParts.joined(separator: "\n")
    }

    private static func formatSourceLine(
        number: Int?,
        text: String,
        width: Int,
        colorize: Bool
    ) -> String {
        let gutter: String
        if let number {
            let paddedNumber = String(repeating: " ", count: max(0, width - String(number).count)) + String(number)
            gutter = colorize ? ANSI.cyan + paddedNumber + ANSI.reset : paddedNumber
        } else {
            gutter = String(repeating: " ", count: width)
        }
        return "\(gutter) | \(text)"
    }

    private static var shouldColorize: Bool {
        let env = ProcessInfo.processInfo.environment
        let termIsDumb = env["TERM"] == "dumb"
        return env["NO_COLOR"] == nil && !termIsDumb
    }

    private static func index(atUTF8Offset offset: Int, in line: String) -> String.Index {
        let clamped = max(0, min(offset, line.utf8.count))
        let utf8Index = line.utf8.index(line.utf8.startIndex, offsetBy: clamped)
        // String.Index initializer is guaranteed to succeed because the UTF8 index comes from the same string.
        return String.Index(utf8Index, within: line)!
    }
}

private enum ANSI {
    static let reset = "\u{001B}[0;0m"
    static let boldRed = "\u{001B}[1;31m"
    static let boldDefault = "\u{001B}[1;39m"
    static let cyan = "\u{001B}[0;36m"
    static let underline = "\u{001B}[4;39m"
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
