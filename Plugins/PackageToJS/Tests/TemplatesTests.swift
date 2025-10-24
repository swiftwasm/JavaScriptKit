import Testing
import Foundation
@testable import PackageToJS

@Suite struct TemplatesTests {
    static let pluginPackagePath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
    static let templatesPath =
        pluginPackagePath
        .appendingPathComponent("Templates")
    static let localTemporaryDirectory =
        pluginPackagePath
        .appendingPathComponent("Tests")
        .appendingPathComponent("TemporaryDirectory")

    /// `npx tsc -p Templates/tsconfig.json`
    /// Test both node and browser platform variants
    @Test(arguments: ["node", "browser"])
    func tscCheck(platform: String) throws {
        // Use a local temporary directory to place instantiated templates so that
        // they can reference repo-root node_modules packages like @types/node.
        try FileManager.default.createDirectory(
            at: Self.localTemporaryDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        try withTemporaryDirectory(prefixDirectory: Self.localTemporaryDirectory) { tempDir, _ in
            let destination = tempDir.appending(path: Self.templatesPath.lastPathComponent)
            // Copy entire templates folder to temp location
            try FileManager.default.copyItem(at: Self.templatesPath, to: destination)

            // Setup preprocessing conditions
            let conditions: [String: Bool] = [
                "USE_SHARED_MEMORY": false,
                "IS_WASI": true,
                "USE_WASI_CDN": false,
                "HAS_BRIDGE": false,
                "HAS_IMPORTS": false,
                "TARGET_DEFAULT_PLATFORM_NODE": platform == "node",
                "TARGET_DEFAULT_PLATFORM_BROWSER": platform == "browser",
            ]
            let preprocessOptions = PreprocessOptions(conditions: conditions, substitutions: [:])

            // Preprocess all JS and TS files in-place
            let enumerator = FileManager.default.enumerator(at: destination, includingPropertiesForKeys: nil)
            while let fileURL = enumerator?.nextObject() as? URL {
                guard !fileURL.hasDirectoryPath,
                    fileURL.pathExtension == "js" || fileURL.pathExtension == "ts"
                else {
                    continue
                }

                let content = try String(contentsOf: fileURL, encoding: .utf8)
                let preprocessed = try preprocess(source: content, file: fileURL.path, options: preprocessOptions)
                try preprocessed.write(to: fileURL, atomically: true, encoding: .utf8)
            }

            // Run TypeScript on the preprocessed files
            let tsc = Process()
            tsc.executableURL = try which("npx")
            tsc.arguments = ["tsc", "-p", destination.appending(path: "tsconfig.json").path]
            try tsc.run()
            tsc.waitUntilExit()
            #expect(tsc.terminationStatus == 0)
        }
    }
}
