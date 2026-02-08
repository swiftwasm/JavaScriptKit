#if canImport(PackagePlugin)
import PackagePlugin
@preconcurrency import Foundation

/// Command plugin for ahead-of-time (AOT) code generation with BridgeJS.
/// This plugin allows you to generate bridge code between Swift and JavaScript
/// before the build process, improving build times for larger projects.
/// See documentation: Ahead-of-Time-Code-Generation.md
@main
struct BridgeJSCommandPlugin: CommandPlugin {
    static let JAVASCRIPTKIT_PACKAGE_NAME: String = "JavaScriptKit"

    struct Options {
        var targets: [String]
        var verbose: Bool

        static func parse(extractor: inout ArgumentExtractor) -> Options {
            let targets = extractor.extractOption(named: "target")
            let verbose = extractor.extractFlag(named: "verbose")
            return Options(targets: targets, verbose: verbose != 0)
        }

        static func help() -> String {
            return """
                OVERVIEW: Generate ahead-of-time (AOT) bridge code between Swift and JavaScript.

                This command generates bridge code before the build process, which can significantly
                improve build times for larger projects by avoiding runtime code generation.
                Generated code will be placed in the target's 'Generated' directory.

                OPTIONS:
                    --target <target> Specify target(s) to generate bridge code for. If omitted,
                                      generates for all targets with JavaScriptKit dependency.
                    --verbose Print verbose output.
                """
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) throws {
        // Check for help flags to display usage information
        if arguments.contains(where: { ["-h", "--help"].contains($0) }) {
            printStderr(Options.help())
            return
        }

        var extractor = ArgumentExtractor(arguments)
        let options = Options.parse(extractor: &extractor)
        let remainingArguments = extractor.remainingArguments

        let context = Context(options: options, context: context)

        if options.targets.isEmpty {
            try context.runOnTargets(
                remainingArguments: remainingArguments,
                where: { target in
                    target.hasDependency(named: Self.JAVASCRIPTKIT_PACKAGE_NAME)
                }
            )
        } else {
            try context.runOnTargets(
                remainingArguments: remainingArguments,
                where: { options.targets.contains($0.name) }
            )
        }
    }

    struct Context {
        let options: Options
        let context: PluginContext
    }
}

extension BridgeJSCommandPlugin.Context {
    func runOnTargets(
        remainingArguments: [String],
        where predicate: (SwiftSourceModuleTarget) -> Bool
    ) throws {
        for target in context.package.targets {
            guard let target = target as? SwiftSourceModuleTarget else {
                continue
            }
            let configFilePath = target.directoryURL.appending(path: "bridge-js.config.json")
            if !FileManager.default.fileExists(atPath: configFilePath.path) {
                printVerbose("No bridge-js.config.json found for \(target.name), skipping...")
                continue
            }
            guard predicate(target) else {
                continue
            }
            try runSingleTarget(target: target, remainingArguments: remainingArguments)
        }
    }

    private func runSingleTarget(
        target: SwiftSourceModuleTarget,
        remainingArguments: [String]
    ) throws {
        printStderr("Generating bridge code for \(target.name)...")

        let generatedDirectory = target.directoryURL.appending(path: "Generated")

        let bridgeDtsPath = target.directoryURL.appending(path: "bridge-js.d.ts")
        let tsconfigPath = context.package.directoryURL.appending(path: "tsconfig.json")

        // Unified generate command
        var generateArguments: [String] = [
            "generate",
            "--module-name",
            target.name,
            "--target-dir",
            target.directoryURL.path,
            "--output-dir",
            generatedDirectory.path,
            "--verbose",
            options.verbose ? "true" : "false",
        ]

        if FileManager.default.fileExists(atPath: bridgeDtsPath.path) {
            generateArguments.append(contentsOf: [
                "--project",
                tsconfigPath.path,
                bridgeDtsPath.path,
            ])
        }

        generateArguments.append(
            contentsOf: target.sourceFiles.filter {
                !$0.url.path.hasPrefix(generatedDirectory.path + "/")
            }.map(\.url.path)
        )
        generateArguments.append(contentsOf: remainingArguments)

        try runBridgeJSTool(arguments: generateArguments)
    }

    private func runBridgeJSTool(arguments: [String]) throws {
        let tool = try context.tool(named: "BridgeJSTool").url
        printVerbose("$ \(tool.path) \(arguments.joined(separator: " "))")
        let process = Process()
        process.executableURL = tool
        process.arguments = arguments
        try process.forwardTerminationSignals {
            try process.run()
            process.waitUntilExit()
        }
        if process.terminationStatus != 0 {
            exit(process.terminationStatus)
        }
    }

    private func printVerbose(_ message: String) {
        if options.verbose {
            printStderr(message)
        }
    }
}

private func printStderr(_ message: String) {
    fputs(message + "\n", stderr)
}

extension SwiftSourceModuleTarget {
    func hasDependency(named name: String) -> Bool {
        return dependencies.contains(where: {
            switch $0 {
            case .product(let product):
                return product.name == name
            case .target(let target):
                return target.name == name
            @unknown default:
                return false
            }
        })
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
#endif
