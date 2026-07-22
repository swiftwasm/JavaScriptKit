import Foundation
import Testing

@testable import BridgeJSBuildPlugin

@Suite struct BuildPluginInputDiscoveryTests {
    @Test
    func discoversJavaScriptModuleInputsInStableOrder() throws {
        let targetDirectory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: targetDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let nested = targetDirectory.appending(path: "Nested")
        let hidden = targetDirectory.appending(path: ".hidden")
        try FileManager.default.createDirectory(at: nested, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: hidden, withIntermediateDirectories: true)

        for path in ["z.js", "Nested/a.mjs", "Nested/b.JS", "ignored.swift", ".hidden/hidden.js"] {
            #expect(
                FileManager.default.createFile(
                    atPath: targetDirectory.appending(path: path).path,
                    contents: Data("input".utf8)
                )
            )
        }

        let resolvedTargetPath = targetDirectory.resolvingSymlinksInPath().path
        let relativePaths = discoverJavaScriptModuleFiles(in: targetDirectory).map {
            String($0.resolvingSymlinksInPath().path.dropFirst(resolvedTargetPath.count + 1))
        }
        #expect(relativePaths == ["Nested/a.mjs", "Nested/b.JS", "z.js"])
    }
}
