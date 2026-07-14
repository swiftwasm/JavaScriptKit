import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import BridgeJSSkeleton

func makeSkeleton(
    _ source: String,
    moduleName: String = "TestModule",
    dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)] = []
) throws -> BridgeJSSkeleton {
    let swiftAPI = SwiftToSkeleton(
        progress: .silent,
        moduleName: moduleName,
        exposeToGlobal: false,
        externalModuleIndex: ExternalModuleIndex(dependencies: dependencies)
    )
    swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "\(moduleName).swift")
    return try swiftAPI.finalize()
}

func renderExportGlue(
    _ source: String,
    moduleName: String = "TestModule"
) throws -> String {
    let skeleton = try makeSkeleton(source, moduleName: moduleName)
    let exported = try #require(skeleton.exported)
    let exportSwift = ExportSwift(
        progress: .silent,
        moduleName: skeleton.moduleName,
        skeleton: exported,
        imported: skeleton.imported
    )
    return try #require(try exportSwift.finalize())
}

func renderImportGlue(_ source: String, moduleName: String = "TestModule") throws -> String {
    let skeleton = try makeSkeleton(source, moduleName: moduleName)
    let imported = try #require(skeleton.imported)
    let importTS = ImportTS(progress: .silent, moduleName: skeleton.moduleName, skeleton: imported)
    return try #require(try importTS.finalize())
}

func expectDiagnostic(
    source: String,
    moduleName: String = "App",
    contains message: String,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    do {
        _ = try makeSkeleton(source, moduleName: moduleName)
        Issue.record("Expected diagnostic but resolution succeeded", sourceLocation: sourceLocation)
    } catch let error as BridgeJSCoreDiagnosticError {
        let combined = error.diagnostics.map(\.diagnostic.message).joined(separator: "\n")
        #expect(combined.contains(message), sourceLocation: sourceLocation)
    } catch {
        Issue.record("Unexpected error: \(error)", sourceLocation: sourceLocation)
    }
}

func linkSource(_ source: String, moduleName: String = "TestModule") throws -> (js: String, dts: String) {
    let skeleton = try makeSkeleton(source, moduleName: moduleName)
    var bridgeJSLink = BridgeJSLink(sharedMemory: false)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let unifiedData = try encoder.encode(skeleton)
    try bridgeJSLink.addSkeletonFile(data: unifiedData)
    let result = try bridgeJSLink.link()
    return (result.outputJs, result.outputDts)
}
