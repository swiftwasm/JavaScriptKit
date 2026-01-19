@preconcurrency import func Foundation.exit
@preconcurrency import func Foundation.fputs
@preconcurrency import var Foundation.stderr
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.ObjCBool
@preconcurrency import class Foundation.JSONEncoder
@preconcurrency import class Foundation.FileManager
@preconcurrency import class Foundation.JSONDecoder
@preconcurrency import class Foundation.ProcessInfo
import SwiftParser
import SwiftSyntax

#if canImport(BridgeJSCore)
import BridgeJSCore
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(TS2Swift)
import TS2Swift
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// BridgeJS Tool
///
/// A command-line tool to generate Swift-JavaScript bridge code for WebAssembly applications.
/// This tool enables bidirectional interoperability between Swift and JavaScript:
///
/// 1. Import: Generate Swift bindings for TypeScript declarations
/// 2. Export: Generate JavaScript bindings for Swift declarations
///
/// Usage:
///     $ bridge-js generate --module-name <name> --target-dir <dir> --output-swift <path> --output-skeleton <path> [--output-import-swift <path>] [--output-import-skeleton <path>] [--project <tsconfig.json>] <input.swift>... [<input-macro.swift>...]
///
/// This tool is intended to be used through the Swift Package Manager plugin system
/// and is not typically called directly by end users.
@main struct BridgeJSTool {

    static func help() -> String {
        return """
                Usage: \(CommandLine.arguments.first ?? "bridge-js-tool") generate [options] <input.swift>...

                Generate bridge code for both exporting Swift APIs and importing TypeScript APIs.
                Input files can be Swift source files (for export) or macro-annotated Swift files (for import).
            """
    }

    static func main() throws {
        do {
            try run()
        } catch {
            printStderr("error: \(error)")
            exit(1)
        }
    }

    static func run() throws {
        let arguments = Array(CommandLine.arguments.dropFirst())
        guard let subcommand = arguments.first else {
            throw BridgeJSToolError(
                """
                Error: No subcommand provided

                \(BridgeJSTool.help())
                """
            )
        }
        switch subcommand {
        case "generate":
            let parser = ArgumentParser(
                singleDashOptions: [:],
                doubleDashOptions: [
                    "module-name": OptionRule(
                        help: "The name of the module",
                        required: true
                    ),
                    "always-write": OptionRule(
                        help: "Always write the output files even if no APIs are found",
                        required: false
                    ),
                    "verbose": OptionRule(
                        help: "Print verbose output",
                        required: false
                    ),
                    "target-dir": OptionRule(
                        help: "The SwiftPM package target directory",
                        required: true
                    ),
                    "output-dir": OptionRule(
                        help: "The output directory for generated code",
                        required: true
                    ),
                    "project": OptionRule(
                        help: "The path to the TypeScript project configuration file (required for .d.ts files)",
                        required: false
                    ),
                ]
            )
            let (positionalArguments, _, doubleDashOptions) = try parser.parse(
                arguments: Array(arguments.dropFirst())
            )
            let progress = ProgressReporting(verbose: doubleDashOptions["verbose"] == "true")
            let moduleName = doubleDashOptions["module-name"]!
            let targetDirectory = URL(fileURLWithPath: doubleDashOptions["target-dir"]!)
            let outputDirectory = URL(fileURLWithPath: doubleDashOptions["output-dir"]!)
            let config = try BridgeJSConfig.load(targetDirectory: targetDirectory)
            let nodePath: URL = try config.findTool("node", targetDirectory: targetDirectory)

            let bridgeJsDtsPath = targetDirectory.appending(path: "bridge-js.d.ts")
            if FileManager.default.fileExists(atPath: bridgeJsDtsPath.path) {
                guard let tsconfigPath = doubleDashOptions["project"] else {
                    throw BridgeJSToolError("--project option is required when processing .d.ts files")
                }
                let bridgeJSMacrosPath = outputDirectory.appending(path: "BridgeJS.Macros.swift")
                _ = try invokeTS2Swift(
                    dtsFile: bridgeJsDtsPath.path,
                    tsconfigPath: tsconfigPath,
                    nodePath: nodePath,
                    progress: progress,
                    outputPath: bridgeJSMacrosPath.path
                )
            }

            let inputFiles = inputSwiftFiles(targetDirectory: targetDirectory, positionalArguments: positionalArguments)
            let exporter = ExportSwift(
                progress: progress,
                moduleName: moduleName,
                exposeToGlobal: config.exposeToGlobal
            )
            let importSwift = ImportSwiftMacros(progress: progress, moduleName: moduleName)

            for inputFile in inputFiles.sorted() {
                let content = try String(contentsOf: URL(fileURLWithPath: inputFile), encoding: .utf8)
                if hasBridgeJSSkipComment(content) {
                    continue
                }

                let sourceFile = Parser.parse(source: content)
                try exporter.addSourceFile(sourceFile, inputFile)
                importSwift.addSourceFile(sourceFile, inputFile)
            }

            let importResult = try importSwift.finalize()
            let exportResult = try exporter.finalize()
            let importSkeleton = importResult.outputSkeleton

            // Combine and write unified Swift output
            let outputSwiftURL = outputDirectory.appending(path: "BridgeJS.swift")
            let combinedSwift = [exportResult?.outputSwift, importResult.outputSwift].compactMap { $0 }
            let outputSwift = combineGeneratedSwift(combinedSwift)
            let shouldWrite = doubleDashOptions["always-write"] == "true" || !outputSwift.isEmpty
            if shouldWrite {
                try FileManager.default.createDirectory(
                    at: outputSwiftURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                try outputSwift.write(to: outputSwiftURL, atomically: true, encoding: .utf8)
            }

            // Write unified skeleton
            let outputSkeletonURL = outputDirectory.appending(path: "JavaScript/BridgeJS.json")
            let unifiedSkeleton = BridgeJSSkeleton(
                moduleName: moduleName,
                exported: exportResult?.outputSkeleton,
                imported: importSkeleton
            )
            try FileManager.default.createDirectory(
                at: outputSkeletonURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let skeletonData = try encoder.encode(unifiedSkeleton)
            try skeletonData.write(to: outputSkeletonURL)

            if exportResult != nil || importResult.outputSwift != nil {
                progress.print("Generated BridgeJS code")
            }
        case "export", "import":
            throw BridgeJSToolError(
                """
                Error: Subcommands 'export' and 'import' have been unified into 'generate'.

                \(BridgeJSTool.help())
                """
            )
        default:
            throw BridgeJSToolError(
                """
                Error: Invalid subcommand: \(subcommand)

                \(BridgeJSTool.help())
                """
            )
        }
    }
}

struct BridgeJSToolError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = message
    }
}

private func printStderr(_ message: String) {
    fputs(message + "\n", stderr)
}

private func hasBridgeJSSkipComment(_ content: String) -> Bool {
    BridgeJSGeneratedFile.hasSkipComment(content)
}

private func combineGeneratedSwift(_ pieces: [String]) -> String {
    let trimmedPieces =
        pieces
        .map { $0.trimmingCharacters(in: .newlines) }
        .filter { !$0.isEmpty }
    guard !trimmedPieces.isEmpty else { return "" }

    return ([BridgeJSGeneratedFile.swiftPreamble] + trimmedPieces).joined(separator: "\n\n")
}

private func recursivelyCollectSwiftFiles(from directory: URL) -> [URL] {
    var swiftFiles: [URL] = []
    let fileManager = FileManager.default

    guard
        let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
    else {
        return []
    }

    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension == "swift" {
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if resourceValues?.isRegularFile == true {
                swiftFiles.append(fileURL)
            }
        }
    }

    return swiftFiles.sorted { $0.path < $1.path }
}

private func inputSwiftFiles(targetDirectory: URL, positionalArguments: [String]) -> [String] {
    if positionalArguments.isEmpty {
        return recursivelyCollectSwiftFiles(from: targetDirectory).map(\.path)
    }
    return positionalArguments
}

// MARK: - Minimal Argument Parsing

struct OptionRule {
    var help: String
    var required: Bool = false
}

struct ArgumentParser {

    let singleDashOptions: [String: OptionRule]
    let doubleDashOptions: [String: OptionRule]

    init(singleDashOptions: [String: OptionRule], doubleDashOptions: [String: OptionRule]) {
        self.singleDashOptions = singleDashOptions
        self.doubleDashOptions = doubleDashOptions
    }

    typealias ParsedArguments = (
        positionalArguments: [String],
        singleDashOptions: [String: String],
        doubleDashOptions: [String: String]
    )

    func help() -> String {
        var help = "Usage: \(CommandLine.arguments.first ?? "bridge-js-tool") [options] <positional arguments>\n\n"
        help += "Options:\n"
        // Align the options by the longest option
        let maxOptionLength = max(
            (singleDashOptions.keys.map(\.count).max() ?? 0) + 1,
            (doubleDashOptions.keys.map(\.count).max() ?? 0) + 2
        )
        for (key, rule) in singleDashOptions {
            help += "  -\(key)\(String(repeating: " ", count: maxOptionLength - key.count)): \(rule.help)\n"
        }
        for (key, rule) in doubleDashOptions {
            help += "  --\(key)\(String(repeating: " ", count: maxOptionLength - key.count)): \(rule.help)\n"
        }
        return help
    }

    func parse(arguments: [String]) throws -> ParsedArguments {
        var positionalArguments: [String] = []
        var singleDashOptions: [String: String] = [:]
        var doubleDashOptions: [String: String] = [:]

        var arguments = arguments.makeIterator()

        while let arg = arguments.next() {
            if arg.starts(with: "-") {
                if arg.starts(with: "--") {
                    let key = String(arg.dropFirst(2))
                    let value = arguments.next()
                    doubleDashOptions[key] = value
                } else {
                    let key = String(arg.dropFirst(1))
                    let value = arguments.next()
                    singleDashOptions[key] = value
                }
            } else {
                positionalArguments.append(arg)
            }
        }

        for (key, rule) in self.doubleDashOptions {
            if rule.required, doubleDashOptions[key] == nil {
                throw BridgeJSToolError("Option --\(key) is required")
            }
        }

        return (positionalArguments, singleDashOptions, doubleDashOptions)
    }
}
