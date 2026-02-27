import XCTest
import JavaScriptKit
import JavaScriptEventLoop

@JSClass struct OptionalSupportImports {
    @JSFunction static func jsRoundTripOptionalNumberNull(_ value: Int?) throws -> Int?
    @JSFunction static func jsRoundTripOptionalNumberUndefined(_ value: JSUndefinedOr<Int>) throws -> JSUndefinedOr<Int>
    @JSFunction static func jsRoundTripOptionalStringNull(_ name: String?) throws -> String?
    @JSFunction static func jsRoundTripOptionalStringUndefined(
        _ name: JSUndefinedOr<String>
    ) throws -> JSUndefinedOr<String>

    @JSFunction static func jsRoundTripOptionalJSValueArrayNull(
        _ v: Optional<[JSValue]>
    ) throws(JSException) -> Optional<[JSValue]>
    // @JSFunction static func jsRoundTripOptionalJSValueArrayUndefined(
    //     _ v: JSUndefinedOr<[JSValue]>
    // ) throws(JSException) -> JSUndefinedOr<[JSValue]>

    @JSFunction static func jsRoundTripOptionalStringToStringDictionaryNull(
        _ v: Optional<[String: String]>
    ) throws(JSException) -> Optional<[String: String]>
    // @JSFunction static func jsRoundTripOptionalStringToStringDictionaryUndefined(
    //     _ v: JSUndefinedOr<[String: String]>
    // ) throws(JSException) -> JSUndefinedOr<[String: String]>

    @JSFunction static func runJsOptionalSupportTests() throws(JSException)
}

final class OptionalSupportTests: XCTestCase {
    func testRunJsOptionalSupportTests() throws {
        try OptionalSupportImports.runJsOptionalSupportTests()
    }

    private func roundTripTest<T: Equatable>(_ fn: (T?) throws -> T?, _ some: T) throws {
        try XCTAssertNil(fn(nil))
        try XCTAssertEqual(fn(some), some)
    }
    private func roundTripTest<T: Equatable>(_ fn: (JSUndefinedOr<T>) throws -> JSUndefinedOr<T>, _ some: T) throws {
        let undefined = try fn(.undefined)
        if case .value = undefined {
            XCTFail("Expected undefined")
        }
        let value = try fn(.value(some))
        switch value {
        case .value(let value):
            XCTAssertEqual(value, some)
        case .undefined:
            XCTFail("Expected defined value")
        }
    }

    func testRoundTripOptionalStringNull() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalStringNull, "hello")
    }

    func testRoundTripOptionalStringUndefined() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalStringUndefined, "hi")
    }

    func testRoundTripOptionalNumberNull() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalNumberNull, 42)
    }

    func testRoundTripOptionalNumberUndefined() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalNumberUndefined, 42)
    }

    func testRoundTripOptionalJSValueArrayNull() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalJSValueArrayNull, [.number(1), .undefined, .null])
    }

    // func testRoundTripOptionalJSValueArrayUndefined() throws {
    //     try roundTripTest(OptionalSupportImports.jsRoundTripOptionalJSValueArrayUndefined, [.number(1), .undefined, .null])
    // }

    func testRoundTripOptionalStringToStringDictionaryNull() throws {
        try roundTripTest(OptionalSupportImports.jsRoundTripOptionalStringToStringDictionaryNull, ["key": "value"])
    }

    // func testRoundTripOptionalStringToStringDictionaryUndefined() throws {
    //     try roundTripTest(OptionalSupportImports.jsRoundTripOptionalStringToStringDictionaryUndefined, ["key": "value"])
    // }
}

@JS enum OptionalSupportExports {
    @JS static func roundTripOptionalString(_ v: String?) -> String? { v }
    @JS static func roundTripOptionalInt(_ v: Int?) -> Int? { v }
    @JS static func roundTripOptionalBool(_ v: Bool?) -> Bool? { v }
    @JS static func roundTripOptionalFloat(_ v: Float?) -> Float? { v }
    @JS static func roundTripOptionalDouble(_ v: Double?) -> Double? { v }
    @JS static func roundTripOptionalSyntax(_ v: Optional<String>) -> Optional<String> { v }
    @JS static func roundTripOptionalCaseEnum(_ v: Status?) -> Status? { v }
    @JS static func roundTripOptionalStringRawValueEnum(_ v: Theme?) -> Theme? { v }
    @JS static func roundTripOptionalIntRawValueEnum(_ v: HttpStatus?) -> HttpStatus? { v }
    @JS static func roundTripOptionalTSEnum(_ v: TSDirection?) -> TSDirection? { v }
    @JS static func roundTripOptionalTSStringEnum(_ v: TSTheme?) -> TSTheme? { v }
    @JS static func roundTripOptionalNamespacedEnum(_ v: Networking.API.Method?) -> Networking.API.Method? { v }
    @JS static func roundTripOptionalSwiftClass(_ v: Greeter?) -> Greeter? { v }
    @JS static func roundTripOptionalIntArray(_ v: [Int]?) -> [Int]? { v }
    @JS static func roundTripOptionalStringArray(_ v: [String]?) -> [String]? { v }
    @JS static func roundTripOptionalSwiftClassArray(_ v: [Greeter]?) -> [Greeter]? { v }

    @JS static func roundTripOptionalAPIResult(_ v: APIResult?) -> APIResult? { v }
    @JS static func roundTripOptionalTypedPayloadResult(_ v: TypedPayloadResult?) -> TypedPayloadResult? { v }
    @JS static func roundTripOptionalComplexResult(_ v: ComplexResult?) -> ComplexResult? { v }
    @JS static func roundTripOptionalAllTypesResult(_ v: AllTypesResult?) -> AllTypesResult? { v }
    @JS static func roundTripOptionalPayloadResult(_ v: OptionalAllTypesResult) -> OptionalAllTypesResult { v }
    @JS static func roundTripOptionalPayloadResultOpt(_ v: OptionalAllTypesResult?) -> OptionalAllTypesResult? { v }
    @JS static func roundTripOptionalAPIOptionalResult(_ v: APIOptionalResult?) -> APIOptionalResult? { v }

    @JS static func takeOptionalJSObject(_ value: JSObject?) {}

    @JS static func applyOptionalGreeter(_ value: Greeter?, _ transform: (Greeter?) -> Greeter?) -> Greeter? {
        transform(value)
    }

    @JS static func makeOptionalHolder(
        nullableGreeter: Greeter?,
        undefinedNumber: JSUndefinedOr<Double>
    ) -> OptionalHolder {
        OptionalHolder(nullableGreeter: nullableGreeter, undefinedNumber: undefinedNumber)
    }

    @JS static func compareAPIResults(_ r1: APIResult?, _ r2: APIResult?) -> String {
        let r1Str: String
        switch r1 {
        case .none: r1Str = "nil"
        case .some(.success(let msg)): r1Str = "success:\(msg)"
        case .some(.failure(let code)): r1Str = "failure:\(code)"
        case .some(.info): r1Str = "info"
        case .some(.flag(let b)): r1Str = "flag:\(b)"
        case .some(.rate(let r)): r1Str = "rate:\(r)"
        case .some(.precise(let p)): r1Str = "precise:\(p)"
        }

        let r2Str: String
        switch r2 {
        case .none: r2Str = "nil"
        case .some(.success(let msg)): r2Str = "success:\(msg)"
        case .some(.failure(let code)): r2Str = "failure:\(code)"
        case .some(.info): r2Str = "info"
        case .some(.flag(let b)): r2Str = "flag:\(b)"
        case .some(.rate(let r)): r2Str = "rate:\(r)"
        case .some(.precise(let p)): r2Str = "precise:\(p)"
        }

        return "r1:\(r1Str),r2:\(r2Str)"
    }
}

@JS
enum OptionalAllTypesResult {
    case optStruct(Address?)
    case optClass(Greeter?)
    case optJSObject(JSObject?)
    case optNestedEnum(APIResult?)
    case optArray([Int]?)
    case optJsClass(Foo?)
    case empty
}

@JS class OptionalHolder {
    @JS var nullableGreeter: Greeter?
    @JS var undefinedNumber: JSUndefinedOr<Double>

    @JS init(nullableGreeter: Greeter?, undefinedNumber: JSUndefinedOr<Double>) {
        self.nullableGreeter = nullableGreeter
        self.undefinedNumber = undefinedNumber
    }
}

@JS class OptionalPropertyHolder {
    @JS var optionalName: String?
    @JS var optionalAge: Int? = nil
    @JS var optionalGreeter: Greeter? = nil

    @JS init(optionalName: String?) {
        self.optionalName = optionalName
    }
}

@JS
enum APIOptionalResult {
    case success(String?)
    case failure(Int?, Bool?)
    case status(Bool?, Int?, String?)
}
