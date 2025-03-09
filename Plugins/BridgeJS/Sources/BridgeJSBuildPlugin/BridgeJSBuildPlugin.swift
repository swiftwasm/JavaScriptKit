#if canImport(PackagePlugin)
import PackagePlugin
import Foundation

@main
struct BridgeJSBuildPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let swiftSourceModuleTarget = target as? SwiftSourceModuleTarget else {
            return []
        }
        return try [
            createExportSwiftAPICommand(context: context, target: swiftSourceModuleTarget)
        ]
    }

    private func createExportSwiftAPICommand(context: PluginContext, target: SwiftSourceModuleTarget) throws -> Command
    {
        let outputSwiftPath = context.pluginWorkDirectoryURL.appending(path: "ExportSwiftAPI.js")
        let outputSkeletonPath = context.pluginWorkDirectoryURL.appending(path: "ExportSwiftAPI.json")
        return .buildCommand(
            displayName: "Export Swift API",
            executable: try context.tool(named: "BridgeJSTool").url,
            arguments: [
                "export",
                "--output-skeleton",
                outputSkeletonPath.path,
                "--output-swift",
                outputSwiftPath.path,
            ] + target.sourceFiles.map(\.url.path),
            outputFiles: [
                outputSwiftPath
            ]
        )
    }
}
#endif
