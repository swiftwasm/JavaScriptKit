import Testing

@Suite struct GenericMethodOnlyModuleCodegenTests {
    @Test
    func exportClassMethodOnlyEmitsJSRuntimeInfrastructure() throws {
        let js = try linkSource(
            """
            @JS final class OnlyBox {
                @JS init() {}
                @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
            }
            """
        ).js
        #expect(js.contains("let __bjs_codecsById = [];"))
        #expect(js.contains("function __bjs_resolveGenericType(token) {"))
        #expect(js.contains("export const BridgeTypes = {"))
    }

    @Test(arguments: [
        (
            """
            @JS final class OnlyBox {
                @JS init() {}
                @JS func wrap<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
            }
            """,
            "OnlyBox"
        ),
        (
            """
            @JS struct OnlyPair {
                @JS init() {}
                @JS func first<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
            }
            """,
            "OnlyPair"
        ),
        (
            """
            @JS enum OnlyFactory {
                case primary
                @JS static func one<T: BridgedSwiftGenericBridgeable>(_ value: T) -> T { value }
            }
            """,
            "OnlyFactory"
        ),
    ])
    func exportMethodOnlyEmitsSwiftRuntimeInfrastructure(source: String, typeName: String) throws {
        let swift = try renderExportGlue(source)
        #expect(swift.contains("_bridgeJSExportTypeRegistry"))
        #expect(swift.contains("extension \(typeName): BridgedSwiftGenericBridgeable {"))
        #expect(swift.contains("register(\(typeName).self)"))
    }

    @Test
    func importMethodOnlyEmitsJSRuntimeInfrastructure() throws {
        let js = try linkSource(
            """
            @JSClass struct OnlyConsumer {
                @JSFunction func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
            }
            """
        ).js
        #expect(js.contains("let __bjs_codecsById = [];"))
        #expect(js.contains("function __bjs_resolveGenericType(token) {"))
        #expect(js.contains("__bjs_codecsById["))
    }
}
