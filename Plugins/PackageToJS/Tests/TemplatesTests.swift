import Testing
import Foundation
@testable import PackageToJS

@Suite struct TemplatesTests {
    static let templatesPath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Templates")

    /// `npx tsc -p Templates/tsconfig.json`
    @Test func tscCheck() throws {
        let tsc = Process()
        tsc.executableURL = try which("npx")
        tsc.arguments = ["tsc", "-p", Self.templatesPath.appending(path: "tsconfig.json").path]
        try tsc.run()
        tsc.waitUntilExit()
        #expect(tsc.terminationStatus == 0)
    }
}
