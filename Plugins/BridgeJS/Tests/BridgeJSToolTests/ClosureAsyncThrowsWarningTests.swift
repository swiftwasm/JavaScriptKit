import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct ClosureAsyncThrowsWarningTests {
    @Test
    func warnsOnTypedAsyncThrowsClosureReturn() throws {
        let result = try resolveApp(
            source: """
                @JS public func makeParser() -> JSTypedClosure<(String) async throws(JSException) -> String> {
                    fatalError()
                }
                """
        )
        #expect(result.warnings.count == 1)
        let warning = try #require(result.warnings.first)
        #expect(warning.diagnostic.severity == .warning)
        #expect(warning.diagnostic.message.contains("swiftlang/swift#89320"))
    }

    @Test
    func warnsOnPlainAsyncThrowsClosureReturn() throws {
        let result = try resolveApp(
            source: """
                @JS public func makeParser() -> (String) async throws(JSException) -> String {
                    fatalError()
                }
                """
        )
        #expect(result.warnings.count == 1)
        #expect(result.warnings.first?.diagnostic.severity == .warning)
    }

    @Test
    func doesNotWarnOnAsyncThrowsClosureParameter() throws {
        let result = try resolveApp(
            source: """
                @JS public func process(_ cb: (String) async throws(JSException) -> String) {}
                """
        )
        #expect(result.warnings.isEmpty)
    }

    @Test
    func doesNotWarnOnNonThrowingAsyncClosureReturn() throws {
        let result = try resolveApp(
            source: """
                @JS public func makeParser() -> JSTypedClosure<(String) async -> String> {
                    fatalError()
                }
                """
        )
        #expect(result.warnings.isEmpty)
    }

    @Test
    func doesNotWarnOnSyncThrowsClosureReturn() throws {
        let result = try resolveApp(
            source: """
                @JS public func makeParser() -> JSTypedClosure<(String) throws(JSException) -> String> {
                    fatalError()
                }
                """
        )
        #expect(result.warnings.isEmpty)
    }

    @Test
    func warnsOnTypedAsyncThrowsClosureImportParameter() throws {
        let result = try resolveApp(
            source: """
                @JSFunction func register(
                    _ cb: JSTypedClosure<(String) async throws(JSException) -> String>
                ) throws(JSException)
                """
        )
        #expect(result.warnings.count == 1)
        #expect(result.warnings.first?.diagnostic.severity == .warning)
    }

    @Test
    func warningDoesNotFailSkeletonResolution() throws {
        let result = try resolveApp(
            source: """
                @JS public func makeParser() -> JSTypedClosure<(String) async throws(JSException) -> String> {
                    fatalError()
                }
                """
        )
        let function = try #require(result.skeleton.exported?.functions.first(where: { $0.name == "makeParser" }))
        guard case .closure(let signature, true) = function.returnType else {
            Issue.record("Expected typed closure return type, got \(function.returnType)")
            return
        }
        #expect(signature.isAsync)
        #expect(signature.isThrows)
    }

    // MARK: - Utilities

    private struct Resolution {
        let skeleton: BridgeJSSkeleton
        let warnings: [(file: String, diagnostic: DiagnosticError)]
    }

    private func resolveApp(source appSource: String) throws -> Resolution {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "App",
            exposeToGlobal: false,
            externalModuleIndex: ExternalModuleIndex(dependencies: [])
        )
        let sourceFile = Parser.parse(source: appSource)
        swiftAPI.addSourceFile(sourceFile, inputFilePath: "App.swift")
        let skeleton = try swiftAPI.finalize()
        return Resolution(skeleton: skeleton, warnings: swiftAPI.warnings)
    }
}
