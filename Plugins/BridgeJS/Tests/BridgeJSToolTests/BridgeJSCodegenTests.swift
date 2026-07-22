import Foundation
import SwiftSyntax
import SwiftParser
import Testing

@testable import BridgeJSCore
@testable import BridgeJSLink
@testable import BridgeJSSkeleton

@Suite struct BridgeJSCodegenTests {
    static let inputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent(
        "Inputs"
    ).appendingPathComponent("MacroSwift")
    static let multifileInputsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        .appendingPathComponent("Inputs").appendingPathComponent("MacroSwift").appendingPathComponent("Multifile")

    @Test
    func legacyImportedModuleSkeletonDecodesWithoutModules() throws {
        let decoded = try JSONDecoder().decode(
            ImportedModuleSkeleton.self,
            from: Data(#"{"children":[]}"#.utf8)
        )
        #expect(decoded.children.isEmpty)
        #expect(decoded.modules == nil)
    }

    @Test
    func changingOnlyJavaScriptModuleContentsUpdatesGeneratedArtifacts() throws {
        let modulePath = "/Modules/math.mjs"
        let swiftSource = """
            @JSFunction(from: .module("/Modules/math.mjs"))
            func add(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int

            @JSGetter(jsName: "version", from: .module("/Modules/math.mjs"))
            var moduleVersion: String
            """

        func generate(source: String) throws -> (BridgeJSSkeleton, String, BridgeJSLinkOutput) {
            var moduleLoadCount = 0
            let generator = SwiftToSkeleton(
                progress: .silent,
                moduleName: "TestModule",
                exposeToGlobal: false,
                externalModuleIndex: .empty,
                javaScriptModuleSource: {
                    moduleLoadCount += 1
                    return $0 == modulePath ? source : nil
                }
            )
            generator.addSourceFile(Parser.parse(source: swiftSource), inputFilePath: "Imports.swift")
            let skeleton = try generator.finalize()
            let imported = try #require(skeleton.imported)
            let generatedThunks = try ImportTS(
                progress: .silent,
                moduleName: skeleton.moduleName,
                skeleton: imported
            ).finalize()
            let swiftThunks = try #require(generatedThunks)
            let linked = try BridgeJSLink(skeletons: [skeleton]).link()
            #expect(moduleLoadCount == 1)
            return (skeleton, swiftThunks, linked)
        }

        let firstSource = "export const version = 'one'; export function add(a, b) { return a + b; }"
        let secondSource = "export const version = 'two'; export function add(a, b) { return a + b; }"
        let first = try generate(source: firstSource)
        let second = try generate(source: secondSource)

        #expect(first.1 == second.1)
        #expect(first.0.imported?.moduleContentFingerprint != second.0.imported?.moduleContentFingerprint)
        #expect(first.2.modules.map(\.relativePath) == second.2.modules.map(\.relativePath))
        #expect(first.2.modules.map(\.source) == [firstSource])
        #expect(second.2.modules.map(\.source) == [secondSource])
    }

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
        let moduleSource =
            input == "JSImportModule.swift"
            ? try String(
                contentsOf: Self.inputsDirectory.appending(path: "Modules/JSImportModule.mjs"),
                encoding: .utf8
            )

            : nil
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty,
            javaScriptModuleSource: { $0 == "/Modules/JSImportModule.mjs" ? moduleSource : nil }
        )
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
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: true,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: name + ".Global")
    }

    @Test
    func codegenCrossFileTypeResolution() throws {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
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
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
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
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
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
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
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
    func codegenCrossFileExtension() throws {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        let classURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileExtensionClass.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classURL, encoding: .utf8)),
            inputFilePath: "CrossFileExtensionClass.swift"
        )
        let extensionURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileExtension.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: extensionURL, encoding: .utf8)),
            inputFilePath: "CrossFileExtension.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileExtension")
    }

    @Test
    func codegenSkipsEmptySkeletons() throws {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
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
