import Foundation
import Testing

@testable import BridgeJSSkeleton

/// Golden spellings for the essence-derived surface facets (`swiftType`, `tsType`,
/// `mangleTypeName`). These used to be three ~20-arm switches; they are now derived from
/// `BridgeType.essence` by one general rule each. The goldens pin the derivation output so a
/// change to the rules is a visible, deliberate diff.
@Suite struct TypeEssenceTests {

    struct Golden: Sendable {
        let type: BridgeType
        let swift: String
        let ts: String
        let mangle: String
        init(_ type: BridgeType, swift: String, ts: String, mangle: String) {
            self.type = type
            self.swift = swift
            self.ts = ts
            self.mangle = mangle
        }
    }

    static let goldens: [Golden] = [
        // Scalars: three irreducible names.
        Golden(.bool, swift: "Bool", ts: "boolean", mangle: "Sb"),
        Golden(.integer(.int), swift: "Int", ts: "number", mangle: "Si"),
        Golden(.integer(.uint32), swift: "UInt32", ts: "number", mangle: "u32"),
        Golden(.integer(.int64), swift: "Int64", ts: "bigint", mangle: "s64"),
        Golden(.float, swift: "Float", ts: "number", mangle: "Sf"),
        Golden(.double, swift: "Double", ts: "number", mangle: "Sd"),
        Golden(.string, swift: "String", ts: "string", mangle: "SS"),
        Golden(.jsValue, swift: "JSValue", ts: "any", mangle: "7JSValueV"),
        Golden(.void, swift: "Void", ts: "void", mangle: "y"),
        Golden(.unsafePointer(.init(kind: .unsafeRawPointer)), swift: "UnsafeRawPointer", ts: "number", mangle: "Surp"),
        Golden(
            .unsafePointer(.init(kind: .unsafePointer, pointee: "UInt8")),
            swift: "UnsafePointer<UInt8>",
            ts: "number",
            mangle: "Sup5UInt8"
        ),

        // Nominals: kind derives the mangling suffix (V/O/P/C) and the spelling shape.
        Golden(.swiftStruct("Point"), swift: "Point", ts: "Point", mangle: "5PointV"),
        Golden(.caseEnum("Direction"), swift: "Direction", ts: "DirectionTag", mangle: "9DirectionO"),
        Golden(.rawValueEnum("Mode", .string), swift: "Mode", ts: "ModeTag", mangle: "4ModeO"),
        Golden(.associatedValueEnum("Result"), swift: "Result", ts: "ResultTag", mangle: "6ResultO"),
        Golden(.swiftProtocol("Drawable"), swift: "AnyDrawable", ts: "Drawable", mangle: "8DrawableP"),
        Golden(.swiftHeapObject("Greeter"), swift: "Greeter", ts: "Greeter", mangle: "7GreeterC"),
        Golden(.jsObject(nil), swift: "JSObject", ts: "any", mangle: "8JSObjectC"),
        Golden(.jsObject("Foo"), swift: "Foo", ts: "Foo", mangle: "3FooC"),
        Golden(.jsObject("JSUint8Array"), swift: "JSUint8Array", ts: "Uint8Array", mangle: "12JSUint8ArrayC"),

        // Combinators fold over their children.
        Golden(.nullable(.integer(.int), .null), swift: "Optional<Int>", ts: "number | null", mangle: "SqSi"),
        Golden(
            .nullable(.string, .undefined),
            swift: "JSUndefinedOr<String>",
            ts: "string | undefined",
            mangle: "SuSS"
        ),
        Golden(.array(.string), swift: "[String]", ts: "string[]", mangle: "SaSS"),
        Golden(
            .array(.nullable(.integer(.int), .null)),
            swift: "[Optional<Int>]",
            ts: "(number | null)[]",
            mangle: "SaSqSi"
        ),
        Golden(.dictionary(.bool), swift: "[String: Bool]", ts: "Record<string, boolean>", mangle: "SDSb"),
        Golden(.array(.array(.string)), swift: "[[String]]", ts: "string[][]", mangle: "SaSaSS"),
        Golden(.alias(name: "UserId", underlying: .integer(.int)), swift: "UserId", ts: "number", mangle: "Al6UserId"),
    ]

    @Test(arguments: goldens)
    func derivedFacetsMatchGolden(golden: Golden) {
        #expect(golden.type.swiftType == golden.swift, "swiftType for \(golden.type)")
        #expect(golden.type.tsType == golden.ts, "tsType for \(golden.type)")
        #expect(golden.type.mangleTypeName == golden.mangle, "mangle for \(golden.type)")
    }

    /// Fails when a new `BridgeType` case is added without a golden, so the derivation can't
    /// silently gain an untested case.
    @Test func everyBridgeTypeCaseIsCovered() {
        let seen = Set(Self.goldens.map { String(describing: $0.type).prefix { $0 != "(" } })
        let expected: Set<Substring> = [
            "integer", "float", "double", "string", "bool", "jsObject", "jsValue",
            "swiftHeapObject", "void", "unsafePointer", "nullable", "array", "dictionary",
            "caseEnum", "rawValueEnum", "associatedValueEnum",
            "swiftProtocol", "swiftStruct", "alias",
        ]
        #expect(expected.subtracting(seen).isEmpty, "missing goldens: \(expected.subtracting(seen).sorted())")
        // `.closure` spellings are exercised by the snapshot suites (they are large and
        // signature-dependent), not pinned here.
    }
}
