@preconcurrency import func Foundation.exit
@preconcurrency import func Foundation.fputs
@preconcurrency import func Foundation.kill
@preconcurrency import var Foundation.stderr
@preconcurrency import var Foundation.SIGINT
@preconcurrency import var Foundation.SIGTERM
@preconcurrency import struct Foundation.URL
@preconcurrency import struct Foundation.Data
@preconcurrency import class Foundation.JSONEncoder
@preconcurrency import class Foundation.FileManager
@preconcurrency import class Foundation.JSONDecoder
@preconcurrency import class Foundation.ProcessInfo
@preconcurrency import class Foundation.Process
@preconcurrency import class Foundation.Pipe
import protocol Dispatch.DispatchSourceSignal
import class Dispatch.DispatchSource
import SwiftParser

/// BridgeJS Tool
///
/// A command-line tool to generate Swift-JavaScript bridge code for WebAssembly applications.
/// This tool enables bidirectional interoperability between Swift and JavaScript:
///
/// 1. Import: Generate Swift bindings for TypeScript declarations
/// 2. Export: Generate JavaScript bindings for Swift declarations
///
/// Usage:
///   For importing TypeScript:
///     $ bridge-js import --module-name <name> --output-swift <path> --output-skeleton <path> --project <tsconfig.json> <input.d.ts>
///   For exporting Swift:
///     $ bridge-js export --output-swift <path> --output-skeleton <path> <input.swift>
///
/// This tool is intended to be used through the Swift Package Manager plugin system
/// and is not typically called directly by end users.
@main struct BridgeJSTool {

    static func help() -> String {
        return """
                Usage: \(CommandLine.arguments.first ?? "bridge-js-tool") <subcommand> [options]

                Subcommands:
                    import   Generate binding code to import TypeScript APIs into Swift
                    export   Generate binding code to export Swift APIs to JavaScript
            """
    }

    static func main() throws {
        do {
            try run()
        } catch {
            printStderr("Error: \(error)")
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
        case "import":
            let parser = ArgumentParser(
                singleDashOptions: [:],
                doubleDashOptions: [
                    "module-name": OptionRule(
                        help: "The name of the module to import the TypeScript API into",
                        required: true
                    ),
                    "always-write": OptionRule(
                        help: "Always write the output files even if no APIs are imported",
                        required: false
                    ),
                    "verbose": OptionRule(
                        help: "Print verbose output",
                        required: false
                    ),
                    "output-swift": OptionRule(help: "The output file path for the Swift source code", required: true),
                    "output-skeleton": OptionRule(
                        help: "The output file path for the skeleton of the imported TypeScript APIs",
                        required: true
                    ),
                    "project": OptionRule(
                        help: "The path to the TypeScript project configuration file",
                        required: true
                    ),
                ]
            )
            let (positionalArguments, _, doubleDashOptions) = try parser.parse(
                arguments: Array(arguments.dropFirst())
            )
            let progress = ProgressReporting(verbose: doubleDashOptions["verbose"] == "true")
            var importer = ImportTS(progress: progress, moduleName: doubleDashOptions["module-name"]!)
            for inputFile in positionalArguments {
                if inputFile.hasSuffix(".json") {
                    let sourceURL = URL(fileURLWithPath: inputFile)
                    let skeleton = try JSONDecoder().decode(
                        ImportedFileSkeleton.self,
                        from: Data(contentsOf: sourceURL)
                    )
                    importer.addSkeleton(skeleton)
                } else if inputFile.hasSuffix(".d.ts") {
                    let tsconfigPath = URL(fileURLWithPath: doubleDashOptions["project"]!)
                    try importer.addSourceFile(inputFile, tsconfigPath: tsconfigPath.path)
                }
            }

            let outputSwift = try importer.finalize()
            let shouldWrite = doubleDashOptions["always-write"] == "true" || outputSwift != nil
            guard shouldWrite else {
                progress.print("No imported TypeScript APIs found")
                return
            }

            let outputSwiftURL = URL(fileURLWithPath: doubleDashOptions["output-swift"]!)
            try FileManager.default.createDirectory(
                at: outputSwiftURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
            try (outputSwift ?? "").write(to: outputSwiftURL, atomically: true, encoding: .utf8)

            let outputSkeletonsURL = URL(fileURLWithPath: doubleDashOptions["output-skeleton"]!)
            try FileManager.default.createDirectory(
                at: outputSkeletonsURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            try encoder.encode(importer.skeleton).write(to: outputSkeletonsURL)

            progress.print(
                """
                Imported TypeScript APIs:
                  - \(outputSwiftURL.path)
                  - \(outputSkeletonsURL.path)
                """
            )
        case "export":
            let parser = ArgumentParser(
                singleDashOptions: [:],
                doubleDashOptions: [
                    "output-skeleton": OptionRule(
                        help: "The output file path for the skeleton of the exported Swift APIs",
                        required: true
                    ),
                    "output-swift": OptionRule(help: "The output file path for the Swift source code", required: true),
                    "always-write": OptionRule(
                        help: "Always write the output files even if no APIs are exported",
                        required: false
                    ),
                    "verbose": OptionRule(
                        help: "Print verbose output",
                        required: false
                    ),
                ]
            )
            let (positionalArguments, _, doubleDashOptions) = try parser.parse(
                arguments: Array(arguments.dropFirst())
            )
            let progress = ProgressReporting(verbose: doubleDashOptions["verbose"] == "true")
            let exporter = ExportSwift(progress: progress)
            for inputFile in positionalArguments {
                let sourceURL = URL(fileURLWithPath: inputFile)
                guard sourceURL.pathExtension == "swift" else { continue }
                let sourceContent = try String(contentsOf: sourceURL, encoding: .utf8)
                let sourceFile = Parser.parse(source: sourceContent)
                try exporter.addSourceFile(sourceFile, sourceURL.path)
            }

            // Finalize the export
            let output = try exporter.finalize()
            let outputSwiftURL = URL(fileURLWithPath: doubleDashOptions["output-swift"]!)
            let outputSkeletonURL = URL(fileURLWithPath: doubleDashOptions["output-skeleton"]!)

            let shouldWrite = doubleDashOptions["always-write"] == "true" || output != nil
            guard shouldWrite else {
                progress.print("No exported Swift APIs found")
                return
            }

            // Create the output directory if it doesn't exist
            try FileManager.default.createDirectory(
                at: outputSwiftURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )
            try FileManager.default.createDirectory(
                at: outputSkeletonURL.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Write the output Swift file
            try (output?.outputSwift ?? "").write(to: outputSwiftURL, atomically: true, encoding: .utf8)

            if let outputSkeleton = output?.outputSkeleton {
                // Write the output skeleton file
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let outputSkeletonData = try encoder.encode(outputSkeleton)
                try outputSkeletonData.write(to: outputSkeletonURL)
            }
            progress.print(
                """
                Exported Swift APIs:
                  - \(outputSwiftURL.path)
                  - \(outputSkeletonURL.path)
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

internal func which(_ executable: String) throws -> URL {
    do {
        // Check overriding environment variable
        let envVariable = executable.uppercased().replacingOccurrences(of: "-", with: "_") + "_PATH"
        if let path = ProcessInfo.processInfo.environment[envVariable] {
            let url = URL(fileURLWithPath: path).appendingPathComponent(executable)
            if FileManager.default.isExecutableFile(atPath: url.path) {
                return url
            }
        }
    }
    let pathSeparator: Character
    #if os(Windows)
    pathSeparator = ";"
    #else
    pathSeparator = ":"
    #endif
    let paths = ProcessInfo.processInfo.environment["PATH"]!.split(separator: pathSeparator)
    for path in paths {
        let url = URL(fileURLWithPath: String(path)).appendingPathComponent(executable)
        if FileManager.default.isExecutableFile(atPath: url.path) {
            return url
        }
    }
    throw BridgeJSToolError("Executable \(executable) not found in PATH")
}

extension ImportTS {
    /// Processes a TypeScript definition file and extracts its API information
    mutating func addSourceFile(_ sourceFile: String, tsconfigPath: String) throws {
        let nodePath = try which("node")
        let ts2skeletonPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("JavaScript")
            .appendingPathComponent("bin")
            .appendingPathComponent("ts2skeleton.js")
        let arguments = [ts2skeletonPath.path, sourceFile, "--project", tsconfigPath]

        progress.print("Running ts2skeleton...")
        progress.print("  \(([nodePath.path] + arguments).joined(separator: " "))")

        let process = Process()
        let stdoutPipe = Pipe()
        nonisolated(unsafe) var stdoutData = Data()

        process.executableURL = nodePath
        process.arguments = arguments
        process.standardOutput = stdoutPipe

        stdoutPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if data.count > 0 {
                stdoutData.append(data)
            }
        }
        try process.forwardTerminationSignals {
            try process.run()
            process.waitUntilExit()
        }

        if process.terminationStatus != 0 {
            throw BridgeJSCoreError("ts2skeleton returned \(process.terminationStatus)")
        }
        let skeleton = try JSONDecoder().decode(ImportedFileSkeleton.self, from: stdoutData)
        self.addSkeleton(skeleton)
    }
}

extension Foundation.Process {
    // Monitor termination/interrruption signals to forward them to child process
    func setSignalForwarding(_ signalNo: Int32) -> DispatchSourceSignal {
        let signalSource = DispatchSource.makeSignalSource(signal: signalNo)
        signalSource.setEventHandler { [self] in
            signalSource.cancel()
            kill(processIdentifier, signalNo)
        }
        signalSource.resume()
        return signalSource
    }

    func forwardTerminationSignals(_ body: () throws -> Void) rethrows {
        let sources = [
            setSignalForwarding(SIGINT),
            setSignalForwarding(SIGTERM),
        ]
        defer {
            for source in sources {
                source.cancel()
            }
        }
        try body()
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
