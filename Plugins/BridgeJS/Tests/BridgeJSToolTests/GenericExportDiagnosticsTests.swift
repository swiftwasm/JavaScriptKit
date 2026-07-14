import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct GenericExportDiagnosticsTests {

    @Test
    func genericParameterRequiresBridgeableConstraint() {
        expectDiagnostic(
            source: """
                @JS public func identity<T>(_ value: T) -> T { value }
                """,
            contains: "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable'"
        )
    }

    @Test
    func genericWhereClauseUnsupported() {
        expectDiagnostic(
            source: """
                @JS public func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T where T: Sendable { value }
                """,
            contains: "'where' clauses are not supported"
        )
    }

    @Test
    func asyncGenericExportUnsupported() {
        expectDiagnostic(
            source: """
                @JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) async -> T { v }
                """,
            contains: "Generic @JS functions cannot be 'async' yet."
        )
    }

    @Test
    func throwsGenericExportUnsupported() {
        expectDiagnostic(
            source: """
                @JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> T { v }
                """,
            contains: "Generic @JS functions cannot be 'throws' yet."
        )
    }

    @Test(arguments: [
        ("[[T]]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: [[T]]) {}"),
        ("[T?]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: [T?]) {}"),
        ("T??", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T??) {}"),
        ("[Int: T]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: [Int: T]) {}"),
    ])
    func unsupportedGenericWrapperFormsInParameter(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test(arguments: [
        ("[[T]]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> [[T]] { [[v]] }"),
        ("[T?]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> [T?] { [v] }"),
        ("T??", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> T?? { v }"),
        ("[Int: T]", "@JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> [Int: T] { [0: v] }"),
    ])
    func unsupportedGenericWrapperFormsInReturn(label: String, source: String) {
        expectDiagnostic(
            source: source,
            contains: "may only be used as a bare type"
        )
    }

    @Test
    func fullyUnusedGenericParameterRejected() {
        expectDiagnostic(
            source: """
                @JS public func combine<T: BridgedSwiftGenericBridgeable, U: BridgedSwiftGenericBridgeable>(_ a: T) -> T { a }
                """,
            contains: "must be used in at least one parameter"
        )
    }

    @Test
    func genericParameterMustBeUsedAsParameter() {
        expectDiagnostic(
            source: """
                @JS public func f<T: BridgedSwiftGenericBridgeable>() -> T { fatalError() }
                """,
            contains: "must be used in at least one parameter"
        )
    }

    @Test
    func genericConcreteReturnUnsupported() {
        expectDiagnostic(
            source: """
                @JS public func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> String { "" }
                """,
            contains: "must return the generic type"
        )
    }

    @Test
    func genericInstanceMethodAsyncIsRejected() {
        expectDiagnostic(
            source: """
                @JS class Box {
                    @JS init() {}
                    @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ v: T) async -> T { v }
                }
                """,
            contains: "Generic @JS functions cannot be 'async' yet."
        )
    }

    @Test
    func genericInstanceMethodThrowsIsRejected() {
        expectDiagnostic(
            source: """
                @JS class Box {
                    @JS init() {}
                    @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ v: T) throws(JSException) -> T { v }
                }
                """,
            contains: "Generic @JS functions cannot be 'throws' yet."
        )
    }

    @Test
    func genericMethodWhereClauseIsRejected() {
        expectDiagnostic(
            source: """
                @JS class Box {
                    @JS init() {}
                    @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ v: T) -> T where T: Sendable { v }
                }
                """,
            contains: "'where' clauses are not supported on generic @JS functions."
        )
    }

    @Test
    func genericMethodUnconstrainedParamIsRejected() {
        expectDiagnostic(
            source: """
                @JS class Box {
                    @JS init() {}
                    @JS func f<T>(_ v: T) -> T { v }
                }
                """,
            contains:
                "Generic parameter 'T' must be constrained to 'BridgedSwiftGenericBridgeable' to be used with @JS."
        )
    }

    @Test
    func genericMethodConcreteReturnIsRejected() {
        expectDiagnostic(
            source: """
                @JS class Box {
                    @JS init() {}
                    @JS func count<T: BridgedSwiftGenericBridgeable>(_ v: T) -> Int { 0 }
                }
                """,
            contains: "must return the generic type"
        )
    }

    @Test
    func genericEnumInstanceMethodIsRejected() {
        expectDiagnostic(
            source: """
                @JS enum E {
                    case a
                    @JS func f<T: BridgedSwiftGenericBridgeable>(_ v: T) -> T { v }
                }
                """,
            contains: "Only static functions are supported in enums"
        )
    }

    @Test
    func genericTypedPropertyIsRejectedAsUnsupportedType() {
        expectDiagnostic(
            source: """
                @JS final class Box {
                    @JS init() {}
                    @JS var value: T
                }
                """,
            contains: "Unsupported type 'T'."
        )
    }
}
