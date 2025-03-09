import Foundation
import SwiftSyntax
import SwiftParser
import Testing

@testable import BridgeJSTool

@Suite struct ExportSwiftAPITests {
    private func snapshot(
        swiftAPI: ExportSwiftAPI,
        name: String? = nil,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) throws {
        let (outputSwift, outputSkeleton) = try #require(try swiftAPI.finalize())
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: outputSwift.data(using: .utf8)!,
            fileExtension: "swift"
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let outputSkeletonData = try encoder.encode(outputSkeleton)
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: outputSkeletonData,
            fileExtension: "json"
        )
    }

    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    )

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs
    }

    @Test(arguments: collectInputs())
    func snapshot(input: String) throws {
        var swiftAPI = ExportSwiftAPI(progress: .silent)
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        try swiftAPI.addSourceFile(sourceFile, input)
        let name = url.deletingPathExtension().lastPathComponent
        try snapshot(swiftAPI: swiftAPI, name: name)
    }
}
