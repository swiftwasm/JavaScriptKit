import Testing

@testable import BridgeJSLink
@testable import BridgeJSSkeleton

/// Every type shape gets one module-scope `{ lower, lift }` helper, shared by the
/// container combinators' element positions and by the generic type-handle
/// registration table, and composed codecs are hoisted so that no call site
/// builds one.
@Suite struct NamedCodecHelperTests {
    private func codecDeclarations(in js: String) -> [String] {
        js.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { $0.hasPrefix("const \(ContainerCodecJS.namedCodecPrefix)") }
    }

    @Test
    func composedCodecsAreHoistedAndReusedByCallSites() throws {
        let js = try linkSource(
            """
            @JS func mirror(_ values: [String: Int?]) -> [String: Int?] { values }
            @JS func mirrorAgain(_ values: [String: Int?]) -> [String: Int?] { values }
            """
        ).js

        // Declared once, at module scope, out of the thunks.
        #expect(
            codecDeclarations(in: js) == [
                "const __bjs_codec_Optional_Int = __bjs_optionalCodec(__bjs_primitiveCodecs.Int);",
                "const __bjs_codec_Dict_Optional_Int = __bjs_dictCodec(__bjs_codec_Optional_Int);",
            ]
        )
        // Call sites only read the helper; they never compose one.
        #expect(js.contains("__bjs_codec_Dict_Optional_Int.lower(values);"))
        #expect(js.contains("__bjs_codec_Dict_Optional_Int.lift();"))
        let composedAtCallSite = js.contains("__bjs_dictCodec(__bjs_optionalCodec(")
        #expect(!composedAtCallSite)
    }

    @Test
    func helperNamesAreQualifiedWithTheDeclaringModule() throws {
        let js = try linkSource(
            """
            @JS struct Point {
                var x: Int
                @JS init(x: Int) { self.x = x }
            }
            @JS func mirror(_ points: [Point]) -> [Point] { points }
            """,
            moduleName: "Core"
        ).js

        #expect(js.contains("const __bjs_codec_Core_Point = {"))
        #expect(js.contains("const __bjs_codec_Array_Core_Point = __bjs_arrayCodec(__bjs_codec_Core_Point);"))
    }

    /// The type-table entry and the element position of a container must resolve
    /// to the same helper, so a type's stack ABI is described exactly once.
    @Test
    func registrationTableReusesTheSameHelperAsElementPositions() throws {
        let js = try linkSource(
            """
            @JS struct Point {
                var x: Int
                @JS init(x: Int) { self.x = x }
            }
            @JS func mirror(_ points: [Point]) -> [Point] { points }
            @JSClass struct Consumer {
                @JSFunction func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
            }
            """,
            moduleName: "Core"
        ).js

        #expect(js.contains("const __bjs_codec_Core_Point = {"))
        #expect(js.contains("const __bjs_codec_Array_Core_Point = __bjs_arrayCodec(__bjs_codec_Core_Point);"))
        // One entry in the registration array, referencing the same helper.
        let registrationArray =
            js
            .components(separatedBy: "bjs[\"bjs_Core_register_type_handles\"] = function(base, count) {")
            .last
            .map { $0.components(separatedBy: "];")[0] }
        #expect(registrationArray?.contains("__bjs_codec_Core_Point,") == true)
        // The struct's marshalling code is emitted once, in its helper factory.
        #expect(js.components(separatedBy: "structHelpers.Point.lower(v);").count - 1 == 1)
    }

    /// A string-backed raw value enum bridges exactly as `String`, so it shares
    /// the string codec instead of minting a redundant helper.
    @Test
    func stringBackedRawValueEnumsShareTheStringCodec() throws {
        let js = try linkSource(
            """
            @JS enum Mode: String {
                case light
                case dark
            }
            @JS func mirror(_ modes: [Mode]) -> [Mode] { modes }
            """
        ).js

        #expect(js.contains("const __bjs_codec_Array_String = __bjs_arrayCodec(__bjs_stringCodec);"))
        #expect(!js.contains("__bjs_codec_TestModule_Mode"))
    }
}
