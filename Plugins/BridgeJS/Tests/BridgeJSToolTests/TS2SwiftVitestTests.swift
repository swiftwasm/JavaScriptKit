import Foundation
import Testing

/// Runs the TS2Swift JavaScript test suite (Vitest) so that `swift test --package-path ./Plugins/BridgeJS`
/// validates both the TypeScript ts2swift output and the Swift codegen. For fast iteration on ts2swift,
/// run `npm test` directly in `Sources/TS2Swift/JavaScript`.
@Suite struct TS2SwiftVitestTests {
    @Test
    func ts2SwiftVitestSuitePasses() throws {
        let testFileURL = URL(fileURLWithPath: #filePath)
        let ts2SwiftJSDir =
            testFileURL
            .deletingLastPathComponent()  // BridgeJSToolTests
            .deletingLastPathComponent()  // Tests
            .deletingLastPathComponent()  // BridgeJS package root
            .appendingPathComponent("Sources")
            .appendingPathComponent("TS2Swift")
            .appendingPathComponent("JavaScript")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        var arguments = ["npm", "run", "test"]
        if ProcessInfo.processInfo.environment["UPDATE_SNAPSHOTS"] != nil {
            arguments.append(contentsOf: ["--", "--update"])
        }
        process.arguments = arguments
        process.currentDirectoryURL = ts2SwiftJSDir
        try process.run()
        process.waitUntilExit()
        #expect(
            process.terminationStatus == 0,
            "TS2Swift Vitest suite failed (exit code \(process.terminationStatus)). Run `cd Sources/TS2Swift/JavaScript && npm test` for details."
        )
    }
}
