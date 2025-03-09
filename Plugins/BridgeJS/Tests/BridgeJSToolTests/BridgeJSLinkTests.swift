import Foundation
import SwiftSyntax
import SwiftParser
import Testing

@testable import BridgeJSLink
@testable import BridgeJSTool

@Suite struct BridgeJSLinkTests {
    private func snapshot(
        swiftAPI: ExportSwiftAPI,
        name: String? = nil,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) throws {
        let (_, outputSkeleton) = try #require(try swiftAPI.finalize())
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let outputSkeletonData = try encoder.encode(outputSkeleton)
        var bridgeJSLink = BridgeJSLink()
        try bridgeJSLink.addSkeletonFile(data: outputSkeletonData)
        let (outputJs, outputDts) = bridgeJSLink.link()
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: outputJs.data(using: .utf8)!,
            fileExtension: "js"
        )
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: outputDts.data(using: .utf8)!,
            fileExtension: "d.ts"
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
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        var swiftAPI = ExportSwiftAPI(progress: .silent)
        try swiftAPI.addSourceFile(sourceFile, input)
        let name = url.deletingPathExtension().lastPathComponent
        try snapshot(swiftAPI: swiftAPI, name: name)
    }
}
