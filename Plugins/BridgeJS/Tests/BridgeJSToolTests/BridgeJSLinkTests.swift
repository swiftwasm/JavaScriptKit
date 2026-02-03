import Foundation
import SwiftSyntax
import SwiftParser
import Testing
@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import BridgeJSSkeleton

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
    ).appendingPathComponent("MacroSwift")

    static func collectInputs(extension: String) -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(`extension`) }
    }

    @Test(arguments: collectInputs(extension: ".swift"))
    func snapshot(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().lastPathComponent

        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let importSwift = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        importSwift.addSourceFile(sourceFile, inputFilePath: "\(name).swift")
        let importResult = try importSwift.finalize()
        var bridgeJSLink = BridgeJSLink(sharedMemory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let unifiedData = try encoder.encode(importResult)
        try bridgeJSLink.addSkeletonFile(data: unifiedData)
        try snapshot(bridgeJSLink: bridgeJSLink, name: name)
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
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: true)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: inputFile)
        let name = url.deletingPathExtension().lastPathComponent
        let outputSkeleton = try swiftAPI.finalize()
        let bridgeJSLink: BridgeJSLink = BridgeJSLink(
            skeletons: [
                outputSkeleton
            ],
            sharedMemory: false
        )
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Global")
    }

    @Test
    func snapshotMixedModuleExposure() throws {
        let globalURL = Self.inputsDirectory.appendingPathComponent("MixedGlobal.swift")
        let globalSourceFile = Parser.parse(source: try String(contentsOf: globalURL, encoding: .utf8))
        let globalAPI = SwiftToSkeleton(progress: .silent, moduleName: "GlobalModule", exposeToGlobal: true)
        globalAPI.addSourceFile(globalSourceFile, inputFilePath: "MixedGlobal.swift")
        let globalSkeleton = try globalAPI.finalize()

        let privateURL = Self.inputsDirectory.appendingPathComponent("MixedPrivate.swift")
        let privateSourceFile = Parser.parse(source: try String(contentsOf: privateURL, encoding: .utf8))
        let privateAPI = SwiftToSkeleton(progress: .silent, moduleName: "PrivateModule", exposeToGlobal: false)
        privateAPI.addSourceFile(privateSourceFile, inputFilePath: "MixedPrivate.swift")
        let privateSkeleton = try privateAPI.finalize()

        let bridgeJSLink = BridgeJSLink(
            skeletons: [
                globalSkeleton,
                privateSkeleton,
            ],
            sharedMemory: false
        )
        try snapshot(bridgeJSLink: bridgeJSLink, name: "MixedModules")
    }
}
