import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct GenericImportDiagnosticsTests {

    @Test
    func genericParameterRequiresBridgeableConstraint() {
        expectDiagnostic(
            source: """
                @JSFunction func identity<T>(_ value: T) throws(JSException) -> T
                """,
            contains: "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable'"
        )
    }

    @Test
    func genericWhereClauseUnsupported() {
        expectDiagnostic(
            source: """
                @JSFunction func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T where T: Sendable
                """,
            contains: "'where' clauses are not supported on @JSFunction"
        )
    }

    @Test
    func asyncGenericImportUnsupported() {
        expectDiagnostic(
            source: """
                @JSFunction func identityAsync<T: BridgedSwiftGenericBridgeable>(_ value: T) async throws(JSException) -> T
                """,
            contains: "Generic @JSFunction declarations cannot be 'async' yet."
        )
    }

    @Test
    func genericImportedMethodIsParsed() throws {
        let skeleton = try makeSkeleton(
            """
            @JSClass struct Box {
                @JSFunction func member<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
            }
            """,
            moduleName: "App"
        )
        let imported = try #require(skeleton.imported)
        let types = imported.children.flatMap { $0.types }
        let box = try #require(types.first { $0.name == "Box" })
        let method = try #require(box.methods.first { $0.name == "member" })
        #expect(method.genericParameters == ["T"])
    }

    @Test(arguments: [
        ("[[T]]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [[T]]) throws(JSException)"),
        ("[T?]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [T?]) throws(JSException)"),
        ("T??", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T??) throws(JSException)"),
        ("[Int: T]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: [Int: T]) throws(JSException)"),
    ])
    func unsupportedGenericWrapperFormsInParameter(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test(arguments: [
        ("[[T]]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [[T]]"),
        ("[T?]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [T?]"),
        ("T??", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> T??"),
        ("[Int: T]", "@JSFunction func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> [Int: T]"),
    ])
    func unsupportedGenericWrapperFormsInReturn(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test
    func genericImportedMethodAsyncIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T: BridgedSwiftGenericBridgeable>(_ value: T) async throws(JSException) -> T
                }
                """,
            contains: "Generic @JSFunction declarations cannot be 'async' yet."
        )
    }

    @Test
    func genericImportedMethodUnconstrainedParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T>(_ value: T) throws(JSException) -> T
                }
                """,
            contains:
                "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable' to be used with @JSFunction."
        )
    }

    @Test
    func genericImportedFunctionUnusedTypeParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSFunction func unused<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> Int
                """,
            contains:
                "The generic parameter 'T' must be used in a parameter or return type of a generic @JSFunction declaration."
        )
    }

    @Test
    func genericImportedMethodUnusedTypeParamIsRejected() {
        expectDiagnostic(
            source: """
                @JSClass struct Box {
                    @JSFunction func member<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> Int
                }
                """,
            contains:
                "The generic parameter 'T' must be used in a parameter or return type of a generic @JSFunction declaration."
        )
    }

    @Test
    func genericImportedReturnOnlyTypeParamIsAllowed() throws {
        let skeleton = try makeSkeleton(
            """
            @JSFunction func make<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> T
            """,
            moduleName: "App"
        )
        let imported = try #require(skeleton.imported)
        let functions = imported.children.flatMap { $0.functions }
        let function = try #require(functions.first { $0.name == "make" })
        #expect(function.genericParameters == ["T"])
    }
}
