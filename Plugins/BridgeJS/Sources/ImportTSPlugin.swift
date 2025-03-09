#if canImport(PackagePlugin)
import PackagePlugin
import Foundation

@main
struct ImportTSPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let selfPath = URL(fileURLWithPath: #filePath)
        let binPath = selfPath.deletingLastPathComponent().deletingLastPathComponent().appending(path: "bin")
        let outputPath = context.pluginWorkDirectoryURL.appending(path: "ImportTS.swift")
        return [
            .buildCommand(
                displayName: "Import TS",
                executable: binPath.appending(path: "check"),
                arguments: [outputPath.path],
                outputFiles: [
                    outputPath
                ]
            )
        ]
    }
}
#endif