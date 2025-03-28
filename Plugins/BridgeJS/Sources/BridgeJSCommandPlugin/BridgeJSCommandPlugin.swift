#if canImport(PackagePlugin)
import PackagePlugin
@preconcurrency import Foundation

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
                OVERVIEW: TODO

                OPTIONS:
                    --target <target> TODO
                """
        }
    }

    func performCommand(context: PluginContext, arguments: [String]) throws {
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
                generatedJavaScriptDirectory.appending(path: "ExportSwiftAPI.json").path,
                "--output-swift",
                generatedDirectory.appending(path: "ExportSwiftAPI.swift").path,
            ] + target.sourceFiles.map(\.url.path) + remainingArguments
        )

        try runBridgeJSTool(
            context: context,
            arguments: [
                "import",
                "--output-skeleton",
                generatedJavaScriptDirectory.appending(path: "ImportTypeScriptAPI.json").path,
                "--output-swift",
                generatedDirectory.appending(path: "ImportTypeScriptAPI.swift").path,
            ] + target.sourceFiles.map(\.url.path) + remainingArguments
        )
    }

    private func runBridgeJSTool(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "BridgeJSTool").url
        printStderr("$ \(tool.path) \(arguments.joined(separator: " "))")
        let process = try Process.run(tool, arguments: arguments)
        process.waitUntilExit()
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
#endif
