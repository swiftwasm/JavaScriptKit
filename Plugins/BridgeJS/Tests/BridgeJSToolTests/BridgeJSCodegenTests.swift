import Foundation
import SwiftSyntax
import SwiftParser
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct BridgeJSCodegenTests {
    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    ).appendingPathComponent("MacroSwift")
    static let multifileInputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent("Inputs").appendingPathComponent("MacroSwift").appendingPathComponent("Multifile")

    private func snapshotCodegen(
        skeleton: BridgeJSSkeleton,
        name: String,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) throws {
        var swiftParts: [String] = []
        if let closureSupport = try ClosureCodegen().renderSupport(for: skeleton) {
            swiftParts.append(closureSupport)
        }
        if let exported = skeleton.exported {
            let exportSwift = ExportSwift(
                progress: .silent,
                moduleName: skeleton.moduleName,
                skeleton: exported
            )
            if let s = try exportSwift.finalize() {
                swiftParts.append(s)
            }
        }
        if let imported = skeleton.imported {
            let importTS = ImportTS(progress: .silent, moduleName: skeleton.moduleName, skeleton: imported)
            if let s = try importTS.finalize() {
                swiftParts.append(s)
            }
        }
        let combinedSwift =
            swiftParts
            .map { $0.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: combinedSwift.data(using: String.Encoding.utf8)!,
            fileExtension: "swift"
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let skeletonData = try encoder.encode(skeleton)
        try assertSnapshot(
            name: name,
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: skeletonData,
            fileExtension: "json"
        )
    }

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".swift") }.sorted()
    }

    @Test(arguments: collectInputs())
    func codegenSnapshot(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().lastPathComponent
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: name)
    }

    @Test(arguments: [
        "Namespaces.swift",
        "StaticFunctions.swift",
        "StaticProperties.swift",
        "EnumNamespace.swift",
    ])
    func codegenSnapshotWithGlobal(input: String) throws {
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let name = url.deletingPathExtension().lastPathComponent
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: true)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: name + ".Global")
    }

    @Test
    func codegenCrossFileTypeResolution() throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let classBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassB.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classBURL, encoding: .utf8)),
            inputFilePath: "CrossFileClassB.swift"
        )
        let classAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassA.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classAURL, encoding: .utf8)),
            inputFilePath: "CrossFileClassA.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileTypeResolution")
    }

    @Test
    func codegenCrossFileTypeResolutionReverseOrder() throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let classAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassA.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classAURL, encoding: .utf8)),
            inputFilePath: "CrossFileClassA.swift"
        )
        let classBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassB.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classBURL, encoding: .utf8)),
            inputFilePath: "CrossFileClassB.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileTypeResolution.ReverseOrder")
    }

    @Test
    func codegenCrossFileFunctionTypes() throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let functionBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionB.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: functionBURL, encoding: .utf8)),
            inputFilePath: "CrossFileFunctionB.swift"
        )
        let functionAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionA.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: functionAURL, encoding: .utf8)),
            inputFilePath: "CrossFileFunctionA.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileFunctionTypes")
    }

    @Test
    func codegenCrossFileFunctionTypesReverseOrder() throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let functionAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionA.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: functionAURL, encoding: .utf8)),
            inputFilePath: "CrossFileFunctionA.swift"
        )
        let functionBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionB.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: functionBURL, encoding: .utf8)),
            inputFilePath: "CrossFileFunctionB.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileFunctionTypes.ReverseOrder")
    }

    @Test
    func codegenSkipsEmptySkeletons() throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let importedURL = Self.multifileInputsDirectory.appendingPathComponent("ImportedFunctions.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: importedURL, encoding: .utf8)),
            inputFilePath: "ImportedFunctions.swift"
        )
        let exportedOnlyURL = Self.multifileInputsDirectory.appendingPathComponent("ExportedOnly.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: exportedOnlyURL, encoding: .utf8)),
            inputFilePath: "ExportedOnly.swift"
        )
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported == nil, "Empty exported skeleton should be omitted")
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileSkipsEmptySkeletons")
    }
}
