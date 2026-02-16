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

        let additionalDirs = resolveAdditionalSourceDirs(targetDirectory: target.directoryURL)
        for dir in additionalDirs {
            inputFiles.append(contentsOf: recursivelyCollectSwiftFiles(from: dir))
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

private struct PluginConfig: Decodable {
    var additionalSourceDirs: [String]?
}

private func resolveAdditionalSourceDirs(targetDirectory: URL) -> [URL] {
    let configFiles = [
        targetDirectory.appending(path: "bridge-js.config.json"),
        targetDirectory.appending(path: "bridge-js.config.local.json"),
    ]
    var dirs: [String] = []
    for file in configFiles {
        guard FileManager.default.fileExists(atPath: file.path),
            let data = try? Data(contentsOf: file),
            let config = try? JSONDecoder().decode(PluginConfig.self, from: data),
            let additional = config.additionalSourceDirs
        else { continue }
        dirs.append(contentsOf: additional)
    }
    return dirs.compactMap { dir in
        let resolved = targetDirectory.appending(path: dir).standardized
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: resolved.path, isDirectory: &isDirectory),
            isDirectory.boolValue
        else {
            return nil
        }
        return resolved
    }
}

private func recursivelyCollectSwiftFiles(from directory: URL) -> [URL] {
    var swiftFiles: [URL] = []
    guard
        let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )
    else {
        return []
    }
    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension == "swift" {
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if resourceValues?.isRegularFile == true {
                swiftFiles.append(fileURL)
            }
        }
    }
    return swiftFiles.sorted { $0.path < $1.path }
}
#endif
