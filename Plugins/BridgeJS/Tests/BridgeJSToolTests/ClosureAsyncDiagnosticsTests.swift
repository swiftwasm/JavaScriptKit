import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct ClosureAsyncDiagnosticsTests {
    @Test
    func parsesAsyncClosureParameter() throws {
        let app = try resolveApp(
            source: """
                @JS public func process(_ cb: (Int) async -> String) {}
                """
        )
        let function = try #require(app.exported?.functions.first(where: { $0.name == "process" }))
        let parameter = try #require(function.parameters.first)
        guard case .closure(let signature, _) = parameter.type else {
            Issue.record("Expected closure parameter type, got \(parameter.type)")
            return
        }
        #expect(signature.isAsync)
    }

    @Test
    func collectsResolveRejectSignaturesForAsyncClosure() throws {
        let app = try resolveApp(
            source: """
                @JS public func process(_ cb: (Int) async -> String) {}
                """
        )
        let signatures = collectSignatures(from: app)

        let reject = ClosureSignature(
            parameters: [.jsValue],
            returnType: .void,
            moduleName: "App",
            sendingParameters: true
        )
        let resolve = ClosureSignature(
            parameters: [.string],
            returnType: .void,
            moduleName: "App",
            sendingParameters: true
        )

        #expect(signatures.contains(reject))
        #expect(signatures.contains(resolve))
    }

    @Test
    func collectsVoidResolveSignatureForVoidReturningAsyncClosure() throws {
        let app = try resolveApp(
            source: """
                @JS public func process(_ cb: (Int) async -> Void) {}
                """
        )
        let signatures = collectSignatures(from: app)

        let reject = ClosureSignature(
            parameters: [.jsValue],
            returnType: .void,
            moduleName: "App",
            sendingParameters: true
        )
        let voidResolve = ClosureSignature(
            parameters: [],
            returnType: .void,
            moduleName: "App"
        )

        #expect(signatures.contains(reject))
        #expect(signatures.contains(voidResolve))
    }

    @Test
    func supportsAsyncClosureReturningJSStruct() throws {
        let app = try resolveApp(
            source: """
                @JS struct Point { var x: Int }
                @JS public func makePoint() -> JSTypedClosure<(Int) async -> Point> {
                    fatalError()
                }
                """
        )
        let resolveTypes = try #require(app.exported?.asyncPromiseResolveReturnTypes)
        #expect(resolveTypes.contains { $0.mangleTypeName == "5PointV" })
    }

    @Test
    func supportsAsyncThrowsClosureReturningJSStruct() throws {
        let app = try resolveApp(
            source: """
                @JS struct Point { var x: Int }
                @JS public func makePoint() -> JSTypedClosure<(Int) async throws(JSException) -> Point> {
                    fatalError()
                }
                """
        )
        let resolveTypes = try #require(app.exported?.asyncPromiseResolveReturnTypes)
        #expect(resolveTypes.contains { $0.mangleTypeName == "5PointV" })
    }

    @Test
    func supportsAsyncClosureReturningAssociatedValueEnum() throws {
        let app = try resolveApp(
            source: """
                @JS enum Shape { case circle(radius: Double); case square(side: Double) }
                @JS public func process(_ cb: (Int) async -> Shape) {}
                """
        )
        let resolveTypes = try #require(app.exported?.asyncPromiseResolveReturnTypes)
        #expect(resolveTypes.contains { $0.mangleTypeName == "5ShapeO" })
    }

    @Test
    func supportsAsyncThrowsClosureReturningAssociatedValueEnum() throws {
        let app = try resolveApp(
            source: """
                @JS enum Shape { case circle(radius: Double); case square(side: Double) }
                @JS public func makeShape() -> JSTypedClosure<(Int) async throws(JSException) -> Shape> {
                    fatalError()
                }
                """
        )
        let resolveTypes = try #require(app.exported?.asyncPromiseResolveReturnTypes)
        #expect(resolveTypes.contains { $0.mangleTypeName == "5ShapeO" })
    }

    // MARK: - Utilities

    private func collectSignatures(from skeleton: BridgeJSSkeleton) -> Set<ClosureSignature> {
        let collector = ClosureSignatureCollectorVisitor(moduleName: skeleton.moduleName)
        var walker = BridgeSkeletonWalker(visitor: collector)
        walker.walk(skeleton)
        return walker.visitor.signatures
    }

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
