#if canImport(PackagePlugin)
import PackagePlugin
import Foundation

/// Build plugin for runtime code generation with BridgeJS.
/// This plugin automatically generates bridge code between Swift and JavaScript
/// during each build process.
@main
struct BridgeJSBuildPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let swiftSourceModuleTarget = target as? SwiftSourceModuleTarget else {
            return []
        }
        return [try createGenerateCommand(context: context, target: swiftSourceModuleTarget)]
    }

    private func pathToConfigFile(target: SwiftSourceModuleTarget) -> URL {
        return target.directoryURL.appending(path: "bridge-js.config.json")
    }

    private func createGenerateCommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "BridgeJS.swift")

        let inputSwiftFiles = target.sourceFiles.filter {
            !$0.url.path.hasPrefix(context.pluginWorkDirectoryURL.path + "/")
        }
        .map(\.url)

        let configFile = pathToConfigFile(target: target)
        var inputFiles: [URL] = inputSwiftFiles
        if FileManager.default.fileExists(atPath: configFile.path) {
            inputFiles.append(configFile)
        }

        let inputTSFile = target.directoryURL.appending(path: "bridge-js.d.ts")
        let tsconfigPath = context.package.directoryURL.appending(path: "tsconfig.json")

        var arguments: [String] = [
            "generate",
            "--module-name",
            target.name,
            "--target-dir",
            target.directoryURL.path,
            "--output-dir",
            context.pluginWorkDirectoryURL.path,
            "--always-write", "true",
        ]

        if FileManager.default.fileExists(atPath: inputTSFile.path) {
            // Add .d.ts file and tsconfig.json as inputs
            inputFiles.append(contentsOf: [inputTSFile, tsconfigPath])
            arguments.append(contentsOf: [
                "--project",
                tsconfigPath.path,
            ])
        }

        arguments.append(contentsOf: inputSwiftFiles.map(\.path))

        return .buildCommand(
            displayName: "Generate BridgeJS code",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: arguments,
            inputFiles: inputFiles,
            outputFiles: [outputSwiftPath]
        )
    }
}
#endif
