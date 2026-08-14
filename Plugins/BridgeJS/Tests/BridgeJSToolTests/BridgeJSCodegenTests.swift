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
    func javaScriptModuleReferencesAreStoredWithoutSourceContents() throws {
        let modulePath = "/Modules/math.mjs"
        let swiftSource = """
            @JSFunction(from: .snippet("/Modules/math.mjs"))
            func add(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int

            @JSGetter(jsName: "version", from: .snippet("/Modules/math.mjs"))
            var moduleVersion: String
            """
        var validationCount = 0
        let generator = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty,
            javaScriptModuleExists: {
                validationCount += 1
                return $0 == modulePath
            }
        )
        generator.addSourceFile(Parser.parse(source: swiftSource), inputFilePath: "Imports.swift")
        let skeleton = try generator.finalize()
        let encoded = String(decoding: try JSONEncoder().encode(skeleton), as: UTF8.self)
        let imported = try #require(skeleton.imported)

        #expect(validationCount == 1)
        #expect(imported.children.flatMap(\.functions).first?.from == .snippet(modulePath))
        #expect(!encoded.contains(#""modules""#))
    }

    @Test
    func invalidJSImportFromValueFailsToDecode() {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(JSImportFrom.self, from: Data(#""module.js""#.utf8))
        }
        // A bare path string is no longer an origin at all; snippets are tagged.
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(JSImportFrom.self, from: Data(#""/Modules/utils.mjs""#.utf8))
        }
    }

    @Test(arguments: [
        JSImportFrom.global,
        JSImportFrom.snippet("/Modules/utils.mjs"),
        JSImportFrom.module("node:path"),
        JSImportFrom.module("@scope/package/sub"),
        // A package literally named "global" is why specifiers are encoded as tagged
        // objects rather than plain strings: a plain string would be indistinguishable
        // from the `.global` sentinel.
        JSImportFrom.module("global"),
        JSImportFrom.module("#internal"),
        JSImportFrom.module("https://esm.sh/lodash@4"),
    ])
    func jsImportFromRoundTrips(origin: JSImportFrom) throws {
        let encoded = try JSONEncoder().encode(origin)
        #expect(try JSONDecoder().decode(JSImportFrom.self, from: encoded) == origin)
    }

    @Test
    func originsEncodeToTheirDocumentedShapes() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        #expect(String(data: try encoder.encode(JSImportFrom.global), encoding: .utf8) == #""global""#)
        #expect(
            String(data: try encoder.encode(JSImportFrom.snippet("/a.js")), encoding: .utf8)
                == #"{"kind":"snippet","path":"\/a.js"}"#
        )
        #expect(
            String(data: try encoder.encode(JSImportFrom.module("node:path")), encoding: .utf8)
                == #"{"kind":"module","specifier":"node:path"}"#
        )
    }

    @Test
    func unknownJSImportFromKindFailsToDecode() {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                JSImportFrom.self,
                from: Data(#"{"kind": "somethingElse", "specifier": "x"}"#.utf8)
            )
        }
    }

    /// The keyed form must reject what the string form rejects, so a specifier cannot reach
    /// code generation through the tagged object that the plain-string path would refuse.
    @Test(arguments: [
        #"{"kind": "module", "specifier": ""}"#,
        #"{"kind": "module", "specifier": "./relative.mjs"}"#,
        #"{"kind": "module", "specifier": "/../../escape.mjs"}"#,
        #"{"kind": "snippet", "path": "node:path"}"#,
        #"{"kind": "snippet", "path": "/../../escape.mjs"}"#,
        #"{"kind": "snippet", "path": "relative.mjs"}"#,
    ])
    func invalidKeyedJSImportFromFailsToDecode(json: String) {
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(JSImportFrom.self, from: Data(json.utf8))
        }
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
        if let typeRegistration = GenericTypeRegistrationCodegen().render(for: skeleton) {
            swiftParts.append(typeRegistration)
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

    /// Target-local JavaScript module files that each input pretends to have on disk.
    static let existingModulePaths: [String: Set<String>] = [
        "JSImportModule.swift": [
            "/Modules/JSImportModule.mjs",
            "/Modules/ModuleCounter.mjs",
        ],
        "JSImportBareModule.swift": [
            "/Modules/DefaultExport.mjs"
        ],
    ]

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
        let modulePaths = Self.existingModulePaths[input] ?? []
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty,
            javaScriptModuleExists: { modulePaths.contains($0) }
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
    func codegenCrossFileNestedTypeExtension() throws {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        let classURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileNestedTypeClass.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: classURL, encoding: .utf8)),
            inputFilePath: "CrossFileNestedTypeClass.swift"
        )
        let extensionURL = Self.multifileInputsDirectory.appendingPathComponent("CrossFileNestedTypeExtension.swift")
        swiftAPI.addSourceFile(
            Parser.parse(source: try String(contentsOf: extensionURL, encoding: .utf8)),
            inputFilePath: "CrossFileNestedTypeExtension.swift"
        )
        let skeleton = try swiftAPI.finalize()
        try snapshotCodegen(skeleton: skeleton, name: "CrossFileNestedTypeExtension")
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
