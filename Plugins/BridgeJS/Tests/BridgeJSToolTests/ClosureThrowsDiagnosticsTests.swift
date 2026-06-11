import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct ClosureThrowsDiagnosticsTests {
    @Test
    func parsesThrowsJSExceptionClosureParameter() throws {
        let app = try resolveApp(
            source: """
                @JS public func process(_ cb: (Int) throws(JSException) -> Int) {}
                """
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "process" }))
        let parameter = try #require(function.parameters.first)
        guard case .closure(let signature, _) = parameter.type else {
            Issue.record("Expected closure parameter type, got \(parameter.type)")
            return
        }
        #expect(signature.isThrows)
        #expect(!signature.isAsync)
    }

    @Test
    func rejectsPlainThrowsClosureParameter() throws {
        do {
            _ = try resolveApp(
                source: """
                    @JS public func process(_ cb: (Int) throws -> Int) {}
                    """
            )
            Issue.record("Expected a plain-throws closure diagnostic, but resolution succeeded")
        } catch let error as BridgeJSCoreDiagnosticError {
            let combined = error.diagnostics.map(\.diagnostic.message).joined(separator: "\n")
            #expect(combined.contains("JSException"))
            #expect(!combined.contains("Throws is not supported for Swift closures yet."))
        }
    }

    // MARK: - Utilities

    private func resolveApp(source appSource: String) throws -> BridgeJSSkeleton {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "App",
            exposeToGlobal: false,
            externalModuleIndex: ExternalModuleIndex(dependencies: [])
        )
        let sourceFile = Parser.parse(source: appSource)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: "App.swift")
        return try swiftAPI.finalize()
    }
}
