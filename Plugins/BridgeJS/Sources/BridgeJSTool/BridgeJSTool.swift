@preconcurrency import func Foundation.exit
@preconcurrency import func Foundation.fputs
@preconcurrency import var Foundation.stderr
@preconcurrency import struct Foundation.URL
@preconcurrency import class Foundation.JSONEncoder
@preconcurrency import class Foundation.FileManager
import SwiftParser

@main struct BridgeJSTool {

    static func help() -> String {
        return """
                Usage: \(CommandLine.arguments.first ?? "bridge-js-tool") <subcommand> [options]

                Subcommands:
                    import   Generate binding code to import JavaScript APIs into Swift
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
        let progress = ProgressReporting()
        switch subcommand {
        case "import":
            throw BridgeJSToolError("Not implemented yet")
        case "export":
            let parser = ArgumentParser(
                singleDashOptions: [:],
                doubleDashOptions: [
                    "output-skeleton": OptionRule(
                        help: "The output file path for the skeleton of the exported Swift APIs",
                        required: true
                    ),
                    "output-swift": OptionRule(help: "The output file path for the Swift source code", required: true),
                ]
            )
            let (positionalArguments, _, doubleDashOptions) = try parser.parse(
                arguments: Array(arguments.dropFirst())
            )
            var exporter = ExportSwiftAPI(progress: progress)
            for inputFile in positionalArguments {
                let sourceURL = URL(fileURLWithPath: inputFile)
                guard sourceURL.pathExtension == "swift" else { continue }
                let sourceContent = try String(contentsOf: sourceURL, encoding: .utf8)
                let sourceFile = Parser.parse(source: sourceContent)
                try exporter.addSourceFile(sourceFile, sourceURL.path)
            }

            // Finalize the export
            guard let (outputSwift, outputSkeleton) = try exporter.finalize() else {
                progress.print("No exported Swift APIs found")
                return
            }

            let outputSwiftURL = URL(fileURLWithPath: doubleDashOptions["output-swift"]!)
            let outputSkeletonURL = URL(fileURLWithPath: doubleDashOptions["output-skeleton"]!)

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
            try outputSwift.write(to: outputSwiftURL, atomically: true, encoding: .utf8)

            // Write the output skeleton file
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let outputSkeletonData = try encoder.encode(outputSkeleton)
            try outputSkeletonData.write(to: outputSkeletonURL)
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

struct BridgeJSToolError: Swift.Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = message
    }
}

private func printStderr(_ message: String) {
    fputs(message + "\n", stderr)
}

struct ProgressReporting {
    let print: (String) -> Void

    init(print: @escaping (String) -> Void = { Swift.print($0) }) {
        self.print = print
    }

    static var silent: ProgressReporting {
        return ProgressReporting(print: { _ in })
    }

    func print(_ message: String) {
        self.print(message)
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
