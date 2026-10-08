import Foundation
import SwiftParser
import Testing
@testable import BridgeJSCore
@testable import BridgeJSLink
@testable import TS2Swift

@Suite struct StringDecoderTests {
    @Test(arguments: [false, true])
    func generatedStringDecoder(sharedMemory: Bool) throws {
        let directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        let fixture = directory.appendingPathComponent("Inputs/MacroSwift/StringReturn.swift")
        let collector = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        collector.addSourceFile(
            Parser.parse(source: try String(contentsOf: fixture, encoding: .utf8)),
            inputFilePath: fixture.path
        )
        var linker = BridgeJSLink()
        try linker.addSkeletonFile(data: JSONEncoder().encode(collector.finalize()))
        let output = try linker.link(sharedMemory: sharedMemory)
        guard let node = which("node") else {
            Issue.record("Node.js is required for string decoder regression tests")
            return
        }
        try withTemporaryDirectory { temporaryDirectory, _ in
            let glue = temporaryDirectory.appendingPathComponent("bridge.js")
            try output.outputJs.write(to: glue, atomically: true, encoding: .utf8)
            let process = Process()
            process.executableURL = node
            process.arguments = [
                directory.appendingPathComponent("Inputs/StringDecoderTests.mjs").path,
                glue.path, sharedMemory ? "shared" : "unshared",
            ]
            try process.run()
            process.waitUntilExit()
            #expect(process.terminationStatus == 0)
        }
    }
}
