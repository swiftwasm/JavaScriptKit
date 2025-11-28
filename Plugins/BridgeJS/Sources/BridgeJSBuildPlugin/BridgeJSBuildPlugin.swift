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
        var commands: [Command] = []
        commands.append(try createExportSwiftCommand(context: context, target: swiftSourceModuleTarget))
        if let importCommand = try createImportTSCommand(context: context, target: swiftSourceModuleTarget) {
            commands.append(importCommand)
        }
        return commands
    }

    private func pathToConfigFile(target: SwiftSourceModuleTarget) -> URL {
        return target.directoryURL.appending(path: "bridge-js.config.json")
    }

    private func createExportSwiftCommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "BridgeJS.ExportSwift.swift")
        let outputSkeletonPath = context.pluginWorkDirectoryURL.appending(path: "BridgeJS.ExportSwift.json")
        let inputSwiftFiles = target.sourceFiles.filter {
            !$0.url.path.hasPrefix(context.pluginWorkDirectoryURL.path + "/")
        }
        .map(\.url)
        let configFile = pathToConfigFile(target: target)
        let inputFiles: [URL]
        if FileManager.default.fileExists(atPath: configFile.path) {
            inputFiles = inputSwiftFiles + [configFile]
        } else {
            inputFiles = inputSwiftFiles
        }
        return .buildCommand(
            displayName: "Export Swift API",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: [
                "export",
                "--module-name",
                target.name,
                "--target-dir",
                target.directoryURL.path,
                "--output-skeleton",
                outputSkeletonPath.path,
                "--output-swift",
                outputSwiftPath.path,
                // Generate the output files even if nothing is exported not to surprise
                // the build system.
                "--always-write", "true",
            ] + inputSwiftFiles.map(\.path),
            inputFiles: inputFiles,
            outputFiles: [
                outputSwiftPath
            ]
        )
    }

    private func createImportTSCommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command? {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "BridgeJS.ImportTS.swift")
        let outputSkeletonPath = context.pluginWorkDirectoryURL.appending(path: "BridgeJS.ImportTS.json")
        let inputTSFile = target.directoryURL.appending(path: "bridge-js.d.ts")
        guard FileManager.default.fileExists(atPath: inputTSFile.path) else {
            return nil
        }

        let configFile = pathToConfigFile(target: target)
        let inputFiles: [URL]
        if FileManager.default.fileExists(atPath: configFile.path) {
            inputFiles = [inputTSFile, configFile]
        } else {
            inputFiles = [inputTSFile]
        }
        return .buildCommand(
            displayName: "Import TypeScript API",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: [
                "import",
                "--target-dir",
                target.directoryURL.path,
                "--output-skeleton",
                outputSkeletonPath.path,
                "--output-swift",
                outputSwiftPath.path,
                "--module-name",
                target.name,
                // Generate the output files even if nothing is imported not to surprise
                // the build system.
                "--always-write", "true",
                "--project",
                context.package.directoryURL.appending(path: "tsconfig.json").path,
                inputTSFile.path,
            ],
            inputFiles: inputFiles,
            outputFiles: [
                outputSwiftPath
            ]
        )
    }
}
#endif
