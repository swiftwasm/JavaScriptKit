import Foundation
import SwiftSyntax
import SwiftParser
import Testing
@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import TS2Swift
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
    )

    static let importMacroInputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent("ImportMacroInputs")

    static func collectInputs(extension: String) -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(`extension`) }
    }

    static func collectImportMacroInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.importMacroInputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".swift") }
    }

    @Test(arguments: collectInputs(extension: ".swift"))
    func snapshotExport(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let name = url.deletingPathExtension().lastPathComponent

        let outputSkeleton = try swiftAPI.finalize()
        let bridgeJSLink: BridgeJSLink = BridgeJSLink(
            skeletons: [outputSkeleton],
            sharedMemory: false
        )
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Export")
    }

    @Test(arguments: collectInputs(extension: ".d.ts"))
    func snapshotImport(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().deletingPathExtension().lastPathComponent
        let tsconfigPath = url.deletingLastPathComponent().appendingPathComponent("tsconfig.json")

        let nodePath = try #require(which("node"))
        let swiftSource = try invokeTS2Swift(
            dtsFile: url.path,
            tsconfigPath: tsconfigPath.path,
            nodePath: nodePath,
            progress: .silent
        )

        let sourceFile = Parser.parse(source: swiftSource)
        let importSwift = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        importSwift.addSourceFile(sourceFile, inputFilePath: "\(name).Macros.swift")
        let skeleton = try importSwift.finalize()
        let bridgeJSLink = BridgeJSLink(
            skeletons: [skeleton],
            sharedMemory: false
        )
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Import")
    }

    @Test(arguments: collectImportMacroInputs())
    func snapshotImportMacroInput(input: String) throws {
        let url = Self.importMacroInputsDirectory.appendingPathComponent(input)
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
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".ImportMacros")
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
        try snapshot(bridgeJSLink: bridgeJSLink, name: name + ".Global.Export")
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
        try snapshot(bridgeJSLink: bridgeJSLink, name: "MixedModules.Export")
    }
}
