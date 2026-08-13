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
