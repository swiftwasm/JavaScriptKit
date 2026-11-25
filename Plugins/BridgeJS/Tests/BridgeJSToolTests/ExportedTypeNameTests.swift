import Foundation
import SwiftParser
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct ExportedTypeNameTests {
    private func parse(_ source: String) throws -> ExportedSkeleton {
        let generator = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        generator.addSourceFile(Parser.parse(source: source), inputFilePath: "Types.swift")
        return try #require(generator.finalize().exported)
    }

    @Test
    func renamedTypesKeepSwiftIdentities() throws {
        let exported = try parse(
            """
            @JS func box() -> SwiftBox
            @JS func record() -> SwiftRecord
            @JS func choice() -> SwiftChoice
            @JS func delegate(_ value: SwiftDelegate)
            @JS("PublicBox") class SwiftBox { @JS init() {} }
            @JS("PublicRecord") struct SwiftRecord { var value: Int }
            @JS("PublicChoice") enum SwiftChoice { case first }
            @JS("PublicDelegate") protocol SwiftDelegate { func run() }
            """
        )
        #expect(exported.classes.first?.resolvedJSName == "PublicBox")
        #expect(exported.structs.first?.resolvedJSName == "PublicRecord")
        #expect(exported.enums.first?.resolvedJSName == "PublicChoice")
        #expect(exported.protocols.first?.resolvedJSName == "PublicDelegate")
        #expect(exported.functions[0].returnType == .swiftHeapObject("SwiftBox"))
        #expect(exported.functions[1].returnType == .swiftStruct("SwiftRecord"))
        #expect(exported.functions[2].returnType == .caseEnum("SwiftChoice"))
        #expect(exported.functions[3].parameters.first?.type == .swiftProtocol("SwiftDelegate"))
    }

    @Test
    func renamedParentsKeepSwiftThunkABI() throws {
        let source = """
            @JS(namespace: "API") enum InternalAPI {
                @JS class Item { @JS init() {} }
            }
            """
        let original = try parse(source)
        let renamed = try parse(
            source.replacingOccurrences(of: "@JS(namespace:", with: "@JS(\"PublicAPI\", namespace:")
        )
        let originalThunks = try ExportSwift(
            progress: .silent,
            moduleName: "TestModule",
            skeleton: original,
            availability: .empty
        ).finalize()
        let renamedThunks = try ExportSwift(
            progress: .silent,
            moduleName: "TestModule",
            skeleton: renamed,
            availability: .empty
        ).finalize()
        #expect(renamedThunks == originalThunks)
        #expect(renamed.classes.first?.tsFullPath == "API.PublicAPI.Item")
    }
}
