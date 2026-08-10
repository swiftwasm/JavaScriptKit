import Testing

@Suite struct GenericExportDiagnosticsTests {

    @Test
    func genericExportedFunctionRejected() {
        expectDiagnostic(
            source: """
                @JS public func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
                """,
            contains: "Generic parameters on exported @JS functions are not supported yet"
        )
    }

    @Test
    func genericMethodOnExportedClassRejected() {
        expectDiagnostic(
            source: """
                @JS final class Box {
                    @JS init() {}
                    @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
                }
                """,
            contains: "Generic parameters on exported @JS functions are not supported yet"
        )
    }

    @Test
    func genericMethodOnExportedStructRejected() {
        expectDiagnostic(
            source: """
                @JS struct Pair {
                    @JS init() {}
                    @JS func first<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
                }
                """,
            contains: "Generic parameters on exported @JS functions are not supported yet"
        )
    }

    @Test
    func genericStaticMethodOnExportedEnumRejected() {
        expectDiagnostic(
            source: """
                @JS enum Factory {
                    case primary
                    @JS static func one<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
                }
                """,
            contains: "Generic parameters on exported @JS functions are not supported yet"
        )
    }

    @Test
    func unconstrainedGenericExportedFunctionRejected() {
        expectDiagnostic(
            source: """
                @JS public func identity<T>(_ value: T) -> T { value }
                """,
            contains: "Generic parameters on exported @JS functions are not supported yet"
        )
    }
}
