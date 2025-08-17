import Foundation
import SwiftSyntax
import SwiftParser
import Testing
@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import TS2Skeleton

@Suite struct BridgeJSLinkTests {
    private func snapshot(
        bridgeJSLink: BridgeJSLink,
        name: String? = nil,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) throws {
        let (outputJs, outputDts) = try bridgeJSLink.link()
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

    static func collectInputs(extension: String) -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(`extension`) }
    }

    @Test(arguments: collectInputs(extension: ".swift"))
    func snapshotExport(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = ExportSwift(progress: .silent, moduleName: "TestModule")
        try swiftAPI.addSourceFile(sourceFile, input)
        let name = url.deletingPathExtension().lastPathComponent

        let (_, outputSkeleton) = try #require(try swiftAPI.finalize())
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let outputSkeletonData = try encoder.encode(outputSkeleton)
        var bridgeJSLink = BridgeJSLink(sharedMemory: false)
        try bridgeJSLink.addExportedSkeletonFile(data: outputSkeletonData)
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Export")
    }

    @Test(arguments: collectInputs(extension: ".d.ts"))
    func snapshotImport(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let tsconfigPath = url.deletingLastPathComponent().appendingPathComponent("tsconfig.json")

        var importTS = ImportTS(progress: .silent, moduleName: "TestModule")
        let nodePath = try #require(which("node"))
        try importTS.addSourceFile(url.path, tsconfigPath: tsconfigPath.path, nodePath: nodePath)
        let name = url.deletingPathExtension().deletingPathExtension().lastPathComponent

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let outputSkeletonData = try encoder.encode(importTS.skeleton)

        var bridgeJSLink = BridgeJSLink(sharedMemory: false)
        try bridgeJSLink.addImportedSkeletonFile(data: outputSkeletonData)
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Import")
    }
}
