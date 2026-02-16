@preconcurrency import func Foundation.exit
@preconcurrency import func Foundation.fputs
@preconcurrency import func Foundation.open
@preconcurrency import func Foundation.strerror
@preconcurrency import var Foundation.stderr
@preconcurrency import var Foundation.errno
@preconcurrency import var Foundation.O_WRONLY
@preconcurrency import var Foundation.O_CREAT
@preconcurrency import var Foundation.O_TRUNC
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import struct Foundation.ObjCBool
@preconcurrency import class Foundation.JSONEncoder
@preconcurrency import class Foundation.FileHandle
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
            try Profiling.with(Profiling.make) {
                try run()
            }
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
            let bridgeJsGlobalDtsPath = targetDirectory.appending(path: "bridge-js.global.d.ts")
            let hasDts = FileManager.default.fileExists(atPath: bridgeJsDtsPath.path)
            let hasGlobalDts = FileManager.default.fileExists(atPath: bridgeJsGlobalDtsPath.path)
            var generatedMacrosPath: String? = nil
            if hasDts || hasGlobalDts {
                guard let tsconfigPath = doubleDashOptions["project"] else {
                    throw BridgeJSToolError("--project option is required when processing .d.ts files")
                }
                let bridgeJSMacrosPath = outputDirectory.appending(path: "BridgeJS.Macros.swift")
                let primaryDtsPath = hasDts ? bridgeJsDtsPath.path : bridgeJsGlobalDtsPath.path
                let globalDtsFiles = (hasDts && hasGlobalDts) ? [bridgeJsGlobalDtsPath.path] : []
                try withSpan("invokeTS2Swift") {
                    _ = try invokeTS2Swift(
                        dtsFile: primaryDtsPath,
                        globalDtsFiles: globalDtsFiles,
                        tsconfigPath: tsconfigPath,
                        nodePath: nodePath,
                        progress: progress,
                        outputPath: bridgeJSMacrosPath.path
                    )
                }
                generatedMacrosPath = bridgeJSMacrosPath.path
            }

            var inputFiles = withSpan("Collecting Swift files") {
                return inputSwiftFiles(targetDirectory: targetDirectory, positionalArguments: positionalArguments)
            }

            // BridgeJS.Macros.swift contains imported declarations (@JSFunction, @JSClass, etc.) that need
            // to be processed by SwiftToSkeleton to populate the imported skeleton. The command plugin
            // filters out Generated/ files, so we explicitly add it here after generation.
            if let macrosPath = generatedMacrosPath, FileManager.default.fileExists(atPath: macrosPath) {
                // Only add if not already present (when running directly vs through plugin)
                if !inputFiles.contains(macrosPath) {
                    inputFiles.append(macrosPath)
                }
            }
            let swiftToSkeleton = SwiftToSkeleton(
                progress: progress,
                moduleName: moduleName,
                exposeToGlobal: config.exposeToGlobal
            )
            for inputFile in inputFiles.sorted() {
                try withSpan("Parsing \(inputFile)") {
                    let inputURL = URL(fileURLWithPath: inputFile)
                    // Skip directories (e.g. .docc catalogs included in target.sourceFiles)
                    var isDirectory: ObjCBool = false
                    if FileManager.default.fileExists(atPath: inputFile, isDirectory: &isDirectory),
                        isDirectory.boolValue
                    {
                        return
                    }
                    let content = try String(contentsOf: inputURL, encoding: .utf8)
                    if hasBridgeJSSkipComment(content) {
                        return
                    }

                    let sourceFile = Parser.parse(source: content)
                    swiftToSkeleton.addSourceFile(sourceFile, inputFilePath: inputFile)
                }
            }

            let skeleton = try withSpan("SwiftToSkeleton.finalize") {
                return try swiftToSkeleton.finalize()
            }

            var exporter: ExportSwift?
            if let skeleton = skeleton.exported {
                exporter = ExportSwift(
                    progress: progress,
                    moduleName: moduleName,
                    skeleton: skeleton
                )
            }
            var importer: ImportTS?
            if let skeleton = skeleton.imported {
                importer = ImportTS(
                    progress: progress,
                    moduleName: moduleName,
                    skeleton: skeleton
                )
            }

            // Generate unified closure support for both import/export to avoid duplicate symbols when concatenating.
            let closureSupport = try withSpan("ClosureCodegen.renderSupport") {
                return try ClosureCodegen().renderSupport(for: skeleton)
            }

            let importResult = try withSpan("ImportTS.finalize") {
                return try importer?.finalize()
            }
            let exportResult = try withSpan("ExportSwift.finalize") {
                return try exporter?.finalize()
            }

            // Combine and write unified Swift output
            let outputSwiftURL = outputDirectory.appending(path: "BridgeJS.swift")
            let combinedSwift = [closureSupport, exportResult, importResult].compactMap { $0 }
            let outputSwift = combineGeneratedSwift(combinedSwift)
            let shouldWrite = doubleDashOptions["always-write"] == "true" || !outputSwift.isEmpty
            if shouldWrite {
                try withSpan("Writing output Swift") {
                    try FileManager.default.createDirectory(
                        at: outputSwiftURL.deletingLastPathComponent(),
                        withIntermediateDirectories: true,
                        attributes: nil
                    )
                    try writeIfChanged(outputSwift, to: outputSwiftURL)
                }
            }

            // Write unified skeleton
            let outputSkeletonURL = outputDirectory.appending(path: "JavaScript/BridgeJS.json")
            try withSpan("Writing output skeleton") {
                try FileManager.default.createDirectory(
                    at: outputSkeletonURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let skeletonData = try encoder.encode(skeleton)
                try writeIfChanged(skeletonData, to: outputSkeletonURL)
            }

            if skeleton.exported != nil || skeleton.imported != nil {
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

private func writeIfChanged(_ content: String, to url: URL) throws {
    let existing = try? String(contentsOf: url, encoding: .utf8)
    guard existing != content else { return }
    try content.write(to: url, atomically: true, encoding: .utf8)
}

private func writeIfChanged(_ data: Data, to url: URL) throws {
    let existing = try? Data(contentsOf: url)
    guard existing != data else { return }
    try data.write(to: url)
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

extension Profiling {
    static func make() -> Profiling? {
        guard let outputPath = ProcessInfo.processInfo.environment["BRIDGEJS_PROFILING"] else {
            return nil
        }
        let fd = open(outputPath, O_WRONLY | O_CREAT | O_TRUNC, 0o644)
        guard fd >= 0 else {
            let error = String(cString: strerror(errno))
            fatalError("Failed to open profiling output file \(outputPath): \(error)")
        }
        let output = FileHandle(fileDescriptor: fd, closeOnDealloc: true)
        return Profiling.traceEvent(output: { output.write($0.data(using: .utf8) ?? Data()) })
    }
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
