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
        return try [
            createExportSwiftCommand(context: context, target: swiftSourceModuleTarget),
            createImportTSCommand(context: context, target: swiftSourceModuleTarget),
        ]
    }

    private func createExportSwiftCommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "ExportSwift.swift")
        let outputSkeletonPath = context.pluginWorkDirectoryURL.appending(path: "ExportSwift.json")
        let inputFiles = target.sourceFiles.filter { !$0.url.path.hasPrefix(context.pluginWorkDirectoryURL.path + "/") }
            .map(\.url)
        return .buildCommand(
            displayName: "Export Swift API",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: [
                "export",
                "--output-skeleton",
                outputSkeletonPath.path,
                "--output-swift",
                outputSwiftPath.path,
                "--always-write", "true",
            ] + inputFiles.map(\.path),
            inputFiles: inputFiles,
            outputFiles: [
                outputSwiftPath
            ]
        )
    }

    private func createImportTSCommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "ImportTS.swift")
        let outputSkeletonPath = context.pluginWorkDirectoryURL.appending(path: "ImportTS.json")
        let inputFiles = [
            target.directoryURL.appending(path: "bridge.d.ts")
        ]
        return .buildCommand(
            displayName: "Import TypeScript API",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: [
                "import",
                "--output-skeleton",
                outputSkeletonPath.path,
                "--output-swift",
                outputSwiftPath.path,
                "--module-name",
                target.name,
                "--always-write", "true",
                "--project",
                context.package.directoryURL.appending(path: "tsconfig.json").path,
            ] + inputFiles.map(\.path),
            inputFiles: inputFiles,
            outputFiles: [
                outputSwiftPath
            ]
        )
    }
}
#endif
