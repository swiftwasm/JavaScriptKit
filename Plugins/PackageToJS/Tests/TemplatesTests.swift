import Testing
import Foundation
@testable import PackageToJS

@Suite struct TemplatesTests {
    static let templatesPath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Templates")

    /// `npx tsc -p Templates/tsconfig.json`
    /// Test both node and browser platform variants
    @Test(arguments: ["node", "browser"])
    func tscCheck(platform: String) throws {
        // Create a temporary directory for preprocessed files
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("JavaScriptKit-tsc-\(platform)-\(UUID().uuidString)")
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        // Copy entire templates folder to temp location
        try FileManager.default.copyItem(at: Self.templatesPath, to: tempDir)

        // Setup preprocessing conditions
        let conditions: [String: Bool] = [
            "USE_SHARED_MEMORY": false,
            "IS_WASI": true,
            "USE_WASI_CDN": false,
            "HAS_BRIDGE": false,
            "HAS_IMPORTS": platform == "browser",
            "TARGET_PLATFORM_NODE": platform == "node",
        ]
        let preprocessOptions = PreprocessOptions(conditions: conditions, substitutions: [:])

        // Preprocess all JS and TS files in-place
        let enumerator = FileManager.default.enumerator(at: tempDir, includingPropertiesForKeys: nil)
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
        tsc.arguments = ["tsc", "-p", tempDir.appending(path: "tsconfig.json").path]
        try tsc.run()
        tsc.waitUntilExit()
        #expect(tsc.terminationStatus == 0)
    }
}
