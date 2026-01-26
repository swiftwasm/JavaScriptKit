import Foundation
import SwiftSyntax
import SwiftParser
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct ExportSwiftTests {
    private func snapshot(
        skeleton: BridgeJSSkeleton,
        name: String? = nil,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: Testing.SourceLocation = #_sourceLocation
    ) throws {
        guard let exported = skeleton.exported else { return }
        let exportSwift = ExportSwift(
            progress: .silent,
            moduleName: skeleton.moduleName,
            skeleton: exported
        )
        let closureSupport = try ClosureCodegen().renderSupport(for: skeleton)
        let exportResult = try #require(try exportSwift.finalize())
        let outputSwift = ([closureSupport, exportResult] as [String?])
            .compactMap { $0?.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
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
        let outputSkeletonData = try encoder.encode(exported)
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

    static let multifileInputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent(
            "MultifileInputs"
        )

    static func collectInputs() -> [String] {
        let fileManager = FileManager.default
        let inputs = try! fileManager.contentsOfDirectory(atPath: Self.inputsDirectory.path)
        return inputs.filter { $0.hasSuffix(".swift") }
    }

    @Test(arguments: collectInputs())
    func snapshot(input: String) throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let name = url.deletingPathExtension().lastPathComponent
        try snapshot(skeleton: swiftAPI.finalize(), name: name)
    }

    @Test(arguments: [
        "Namespaces.swift",
        "StaticFunctions.swift",
        "StaticProperties.swift",
        "EnumNamespace.swift",
    ])
    func snapshotWithGlobal(input: String) throws {
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: true)
        let url = Self.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let name = url.deletingPathExtension().lastPathComponent
        try snapshot(skeleton: swiftAPI.finalize(), name: name + ".Global")
    }

    @Test
    func snapshotCrossFileTypeResolution() throws {
        // Test that types defined in one file can be referenced from another file
        // This tests the fix for cross-file type resolution in BridgeJS
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)

        // Add ClassB first, then ClassA (which references ClassB)
        let classBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassB.swift")
        let classBSourceFile = Parser.parse(source: try String(contentsOf: classBURL, encoding: .utf8))
        swiftAPI.addSourceFile(classBSourceFile, inputFilePath: "CrossFileClassB.swift")

        let classAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassA.swift")
        let classASourceFile = Parser.parse(source: try String(contentsOf: classAURL, encoding: .utf8))
        swiftAPI.addSourceFile(classASourceFile, inputFilePath: "CrossFileClassA.swift")

        try snapshot(skeleton: swiftAPI.finalize(), name: "CrossFileTypeResolution")
    }

    @Test
    func snapshotCrossFileTypeResolutionReverseOrder() throws {
        // Test that types can be resolved regardless of the order files are added
        // Add ClassA first (which references ClassB), then ClassB
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)

        let classAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassA.swift")
        let classASourceFile = Parser.parse(source: try String(contentsOf: classAURL, encoding: .utf8))
        swiftAPI.addSourceFile(classASourceFile, inputFilePath: "CrossFileClassA.swift")

        let classBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileClassB.swift")
        let classBSourceFile = Parser.parse(source: try String(contentsOf: classBURL, encoding: .utf8))
        swiftAPI.addSourceFile(classBSourceFile, inputFilePath: "CrossFileClassB.swift")

        try snapshot(skeleton: swiftAPI.finalize(), name: "CrossFileTypeResolution.ReverseOrder")
    }

    @Test
    func snapshotCrossFileFunctionTypes() throws {
        // Test that functions and methods can use cross-file types as parameters and return types
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)

        // Add FunctionB first, then FunctionA (which references FunctionB in methods and functions)
        let functionBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionB.swift")
        let functionBSourceFile = Parser.parse(source: try String(contentsOf: functionBURL, encoding: .utf8))
        swiftAPI.addSourceFile(functionBSourceFile, inputFilePath: "CrossFileFunctionB.swift")

        let functionAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionA.swift")
        let functionASourceFile = Parser.parse(source: try String(contentsOf: functionAURL, encoding: .utf8))
        swiftAPI.addSourceFile(functionASourceFile, inputFilePath: "CrossFileFunctionA.swift")

        try snapshot(skeleton: swiftAPI.finalize(), name: "CrossFileFunctionTypes")
    }

    @Test
    func snapshotCrossFileFunctionTypesReverseOrder() throws {
        // Test that function types can be resolved regardless of the order files are added
        let swiftAPI = SwiftToSkeleton(progress: .silent, moduleName: "TestModule", exposeToGlobal: false)

        // Add FunctionA first (which references FunctionB), then FunctionB
        let functionAURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionA.swift")
        let functionASourceFile = Parser.parse(source: try String(contentsOf: functionAURL, encoding: .utf8))
        swiftAPI.addSourceFile(functionASourceFile, inputFilePath: "CrossFileFunctionA.swift")

        let functionBURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileFunctionB.swift")
        let functionBSourceFile = Parser.parse(source: try String(contentsOf: functionBURL, encoding: .utf8))
        swiftAPI.addSourceFile(functionBSourceFile, inputFilePath: "CrossFileFunctionB.swift")

        try snapshot(skeleton: swiftAPI.finalize(), name: "CrossFileFunctionTypes.ReverseOrder")
    }
}
