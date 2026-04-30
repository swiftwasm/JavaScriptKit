#if canImport(PackagePlugin)
#if os(Windows)
import WinSDK
#endif
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
    private func collectBridgeJSTargets() -> [String: SwiftSourceModuleTarget] {
        var bridgeJSTargets: [String: SwiftSourceModuleTarget] = [:]
        for target in context.package.targets {
            guard
                let swiftTarget = target as? SwiftSourceModuleTarget,
                FileManager.default.fileExists(
                    atPath: swiftTarget.directoryURL.appending(path: "bridge-js.config.json").path
                )
            else {
                continue
            }
            bridgeJSTargets[swiftTarget.name] = swiftTarget
        }
        return bridgeJSTargets
    }

    private func targetsInDependencyOrder(
        _ bridgeJSTargets: [String: SwiftSourceModuleTarget]
    ) -> [SwiftSourceModuleTarget] {
        var visitedTargetNames = Set<String>()
        var orderedTargets: [SwiftSourceModuleTarget] = []
        func visit(_ target: SwiftSourceModuleTarget) {
            if !visitedTargetNames.insert(target.name).inserted {
                return
            }
            for dependency in target.recursiveTargetDependencies {
                if let dependencyTarget = bridgeJSTargets[dependency.name] {
                    visit(dependencyTarget)
                }
            }
            orderedTargets.append(target)
        }
        for target in bridgeJSTargets.values.sorted(by: { $0.name < $1.name }) {
            visit(target)
        }
        return orderedTargets
    }

    func runOnTargets(
        remainingArguments: [String],
        where predicate: (SwiftSourceModuleTarget) -> Bool
    ) throws {
        let allBridgeJSTargets = collectBridgeJSTargets()
        let requestedTargets = allBridgeJSTargets.filter { predicate($1) }
        for target in targetsInDependencyOrder(requestedTargets) {
            try runSingleTarget(
                target: target,
                bridgeJSTargets: allBridgeJSTargets,
                remainingArguments: remainingArguments
            )
        }
    }

    private func runSingleTarget(
        target: SwiftSourceModuleTarget,
        bridgeJSTargets: [String: SwiftSourceModuleTarget],
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

        for dependency in target.recursiveTargetDependencies {
            guard let dependencyTarget = bridgeJSTargets[dependency.name] else { continue }
            let dependencySkeletonPath = dependencyTarget.directoryURL
                .appending(path: "Generated/JavaScript/BridgeJS.json")
            guard FileManager.default.fileExists(atPath: dependencySkeletonPath.path) else {
                throw BridgeJSCommandPluginError(
                    """
                    Dependency '\(dependencyTarget.name)' is configured for BridgeJS, but its AOT skeleton has not been generated yet. \
                    Run `swift package bridge-js --target \(dependencyTarget.name)` to generate it first, \
                    or run without `--target` to process in dependency order.
                    """
                )
            }
            generateArguments.append(contentsOf: [
                "--dependency-skeleton",
                "\(dependencyTarget.name)=\(dependencySkeletonPath.path)",
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

struct BridgeJSCommandPluginError: Error, CustomStringConvertible {
    let description: String

    init(_ message: String) {
        self.description = message
    }
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
            #if os(Windows)
            _ = TerminateProcess(processHandle, 0)
            #else
            kill(processIdentifier, signalNo)
            #endif
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
