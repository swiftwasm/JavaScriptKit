import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import BridgeJSSkeleton
@testable import TS2Swift

func makeSkeleton(
    _ source: String,
    moduleName: String = "TestModule",
    dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)] = []
) throws -> BridgeJSSkeleton {
    let swiftAPI = SwiftToSkeleton(
        progress: .silent,
        moduleName: moduleName,
        exposeToGlobal: false,
        externalModuleIndex: ExternalModuleIndex(dependencies: dependencies)
    )
    swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "\(moduleName).swift")
    return try swiftAPI.finalize()
}

func expectLinkedGlueScriptPasses(
    fixture: String,
    script: String,
    sharedMemory: Bool,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) throws {
    let inputs = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("Inputs")
    let fixtureURL = inputs.appendingPathComponent("MacroSwift").appendingPathComponent(fixture)
    let skeleton = try makeSkeleton(String(contentsOf: fixtureURL, encoding: .utf8))
    var linker = BridgeJSLink()
    try linker.addSkeletonFile(data: JSONEncoder().encode(skeleton))
    let output = try linker.link(sharedMemory: sharedMemory)
    guard let node = which("node") else {
        Issue.record("Node.js is required to run \(script)", sourceLocation: sourceLocation)
        return
    }
    try withTemporaryDirectory { temporaryDirectory, _ in
        let glue = temporaryDirectory.appendingPathComponent("bridge.js")
        try output.outputJs.write(to: glue, atomically: true, encoding: .utf8)
        let process = Process()
        process.executableURL = node
        process.arguments = [
            inputs.appendingPathComponent(script).path, glue.path, sharedMemory ? "shared" : "unshared",
        ]
        try process.run()
        process.waitUntilExit()
        #expect(process.terminationStatus == 0, sourceLocation: sourceLocation)
    }
}

func expectDiagnostic(
    source: String,
    moduleName: String = "App",
    contains message: String,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    do {
        _ = try makeSkeleton(source, moduleName: moduleName)
        Issue.record("Expected diagnostic but resolution succeeded", sourceLocation: sourceLocation)
    } catch let error as BridgeJSCoreDiagnosticError {
        let combined = error.diagnostics.map(\.diagnostic.message).joined(separator: "\n")
        #expect(combined.contains(message), sourceLocation: sourceLocation)
    } catch {
        Issue.record("Unexpected error: \(error)", sourceLocation: sourceLocation)
    }
}
