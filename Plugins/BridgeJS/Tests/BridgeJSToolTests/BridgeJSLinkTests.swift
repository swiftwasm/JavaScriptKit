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
        let swiftAPI = ExportSwift(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        try swiftAPI.addSourceFile(sourceFile, input)
        let name = url.deletingPathExtension().lastPathComponent

        let (_, outputSkeleton) = try #require(try swiftAPI.finalize())
        let bridgeJSLink: BridgeJSLink = BridgeJSLink(exportedSkeletons: [outputSkeleton], sharedMemory: false)
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

    @Test(arguments: [
        "Namespaces.swift",
        "StaticFunctions.swift",
        "StaticProperties.swift",
        "EnumNamespace.swift",
    ])
    func snapshotExportWithGlobal(inputFile: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(inputFile)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = ExportSwift(progress: .silent, moduleName: "TestModule", exposeToGlobal: true)
        try swiftAPI.addSourceFile(sourceFile, inputFile)
        let name = url.deletingPathExtension().lastPathComponent
        let (_, outputSkeleton) = try #require(try swiftAPI.finalize())
        let bridgeJSLink: BridgeJSLink = BridgeJSLink(exportedSkeletons: [outputSkeleton], sharedMemory: false)
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Global.Export")
    }

    @Test
    func snapshotMixedModuleExposure() throws {
        let globalURL = Self.inputsDirectory.appendingPathComponent("MixedGlobal.swift")
        let globalSourceFile = Parser.parse(source: try String(contentsOf: globalURL, encoding: .utf8))
        let globalAPI = ExportSwift(progress: .silent, moduleName: "GlobalModule", exposeToGlobal: true)
        try globalAPI.addSourceFile(globalSourceFile, "MixedGlobal.swift")
        let (_, globalSkeleton) = try #require(try globalAPI.finalize())

        let privateURL = Self.inputsDirectory.appendingPathComponent("MixedPrivate.swift")
        let privateSourceFile = Parser.parse(source: try String(contentsOf: privateURL, encoding: .utf8))
        let privateAPI = ExportSwift(progress: .silent, moduleName: "PrivateModule", exposeToGlobal: false)
        try privateAPI.addSourceFile(privateSourceFile, "MixedPrivate.swift")
        let (_, privateSkeleton) = try #require(try privateAPI.finalize())

        let bridgeJSLink = BridgeJSLink(
            exportedSkeletons: [globalSkeleton, privateSkeleton],
            sharedMemory: false
        )
        try snapshot(bridgeJSLink: bridgeJSLink, name: "MixedModules.Export")
    }
}
