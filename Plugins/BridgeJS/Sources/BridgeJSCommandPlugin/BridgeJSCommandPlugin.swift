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

        static func parse(extractor: inout ArgumentExtractor) -> Options {
            let targets = extractor.extractOption(named: "target")
            return Options(targets: targets)
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
                """
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) throws {
        // Check for help flags to display usage information
        // This allows users to run `swift package plugin bridge-js --help` to understand the plugin's functionality
        if arguments.contains(where: { ["-h", "--help"].contains($0) }) {
            printStderr(Options.help())
            return
        }

        var extractor = ArgumentExtractor(arguments)
        let options = Options.parse(extractor: &extractor)
        let remainingArguments = extractor.remainingArguments

        if options.targets.isEmpty {
            try runOnTargets(
                context: context,
                remainingArguments: remainingArguments,
                where: { target in
                    target.hasDependency(named: Self.JAVASCRIPTKIT_PACKAGE_NAME)
                }
            )
        } else {
            try runOnTargets(
                context: context,
                remainingArguments: remainingArguments,
                where: { options.targets.contains($0.name) }
            )
        }
    }

    private func runOnTargets(
        context: PluginContext,
        remainingArguments: [String],
        where predicate: (SwiftSourceModuleTarget) -> Bool
    ) throws {
        for target in context.package.targets {
            guard let target = target as? SwiftSourceModuleTarget else {
                continue
            }
            guard predicate(target) else {
                continue
            }
            try runSingleTarget(context: context, target: target, remainingArguments: remainingArguments)
        }
    }

    private func runSingleTarget(
        context: PluginContext,
        target: SwiftSourceModuleTarget,
        remainingArguments: [String]
    ) throws {
        Diagnostics.progress("Exporting Swift API for \(target.name)...")

        let generatedDirectory = target.directoryURL.appending(path: "Generated")
        let generatedJavaScriptDirectory = generatedDirectory.appending(path: "JavaScript")

        try runBridgeJSTool(
            context: context,
            arguments: [
                "export",
                "--output-skeleton",
                generatedJavaScriptDirectory.appending(path: "ExportSwift.json").path,
                "--output-swift",
                generatedDirectory.appending(path: "ExportSwift.swift").path,
            ]
                + target.sourceFiles.filter {
                    !$0.url.path.hasPrefix(generatedDirectory.path + "/")
                }.map(\.url.path) + remainingArguments
        )

        try runBridgeJSTool(
            context: context,
            arguments: [
                "import",
                "--output-skeleton",
                generatedJavaScriptDirectory.appending(path: "ImportTS.json").path,
                "--output-swift",
                generatedDirectory.appending(path: "ImportTS.swift").path,
                "--module-name",
                target.name,
                "--project",
                context.package.directoryURL.appending(path: "tsconfig.json").path,
                target.directoryURL.appending(path: "bridge.d.ts").path,
            ] + remainingArguments
        )
    }

    private func runBridgeJSTool(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "BridgeJSTool").url
        printStderr("$ \(tool.path) \(arguments.joined(separator: " "))")
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
