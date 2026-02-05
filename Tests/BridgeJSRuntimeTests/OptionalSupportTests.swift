import XCTest
@_spi(Experimental) import JavaScriptKit
import JavaScriptEventLoop

@JSFunction func runJsOptionalSupportTests() throws

final class OptionalSupportTests: XCTestCase {
    func testRunJsOptionalSupportTests() throws {
        try runJsOptionalSupportTests()
    }

    func testRoundTripOptionalStringNull() throws {
        try XCTAssertEqual(jsRoundTripOptionalStringNull("hello"), "hello")
        try XCTAssertNil(jsRoundTripOptionalStringNull(nil))
    }

    func testRoundTripOptionalStringUndefined() throws {
        let some = try jsRoundTripOptionalStringUndefined(.value("hi"))
        switch some {
        case .value(let value):
            XCTAssertEqual(value, "hi")
        case .undefined:
            XCTFail("Expected defined value")
        }

        let undefined = try jsRoundTripOptionalStringUndefined(.undefinedValue)
        if case .value = undefined {
            XCTFail("Expected undefined")
        }
    }

    func testRoundTripOptionalNumberNull() throws {
        try XCTAssertEqual(jsRoundTripOptionalNumberNull(42), 42)
        try XCTAssertNil(jsRoundTripOptionalNumberNull(nil))
    }

    func testRoundTripOptionalNumberUndefined() throws {
        let some = try jsRoundTripOptionalNumberUndefined(.value(42))
        switch some {
        case .value(let value):
            XCTAssertEqual(value, 42)
        case .undefined:
            XCTFail("Expected defined value")
        }

        let undefined = try jsRoundTripOptionalNumberUndefined(.undefined)
        if case .value = undefined {
            XCTFail("Expected undefined")
        }
    }
}

// MARK: - Optional Bridging

@JSFunction func jsRoundTripOptionalNumberNull(_ value: Int?) throws -> Int?
@JSFunction func jsRoundTripOptionalNumberUndefined(_ value: JSUndefinedOr<Int>) throws -> JSUndefinedOr<Int>
@JSFunction func jsRoundTripOptionalStringNull(_ name: String?) throws -> String?
@JSFunction func jsRoundTripOptionalStringUndefined(_ name: JSUndefinedOr<String>) throws -> JSUndefinedOr<String>

@JS func roundTripOptionalString(name: String?) -> String? {
    name
}

@JS func roundTripOptionalInt(value: Int?) -> Int? {
    value
}

@JS func roundTripOptionalBool(flag: Bool?) -> Bool? {
    flag
}

@JS func roundTripOptionalFloat(number: Float?) -> Float? {
    number
}

@JS func roundTripOptionalDouble(precision: Double?) -> Double? {
    precision
}

@JS func roundTripOptionalSyntax(name: Optional<String>) -> Optional<String> {
    name
}

@JS func roundTripOptionalMixSyntax(name: String?) -> Optional<String> {
    name
}

@JS func roundTripOptionalSwiftSyntax(name: Swift.Optional<String>) -> Swift.Optional<String> {
    name
}

@JS func roundTripOptionalWithSpaces(value: Optional<Double>) -> Optional<Double> {
    value
}

typealias OptionalAge = Int?
@JS func roundTripOptionalTypeAlias(age: OptionalAge) -> OptionalAge {
    age
}

@JS func roundTripOptionalStatus(value: Status?) -> Status? {
    value
}

@JS func roundTripOptionalTheme(value: Theme?) -> Theme? {
    value
}

@JS func roundTripOptionalHttpStatus(value: HttpStatus?) -> HttpStatus? {
    value
}

@JS func roundTripOptionalTSDirection(value: TSDirection?) -> TSDirection? {
    value
}

@JS func roundTripOptionalTSTheme(value: TSTheme?) -> TSTheme? {
    value
}

@JS func roundTripOptionalNetworkingAPIMethod(_ method: Networking.API.Method?) -> Networking.API.Method? {
    method
}

@JS func roundTripOptionalAPIResult(value: APIResult?) -> APIResult? {
    value
}

@JS func roundTripOptionalTypedPayloadResult(_ result: TypedPayloadResult?) -> TypedPayloadResult? {
    result
}

@JS func compareAPIResults(_ r1: APIResult?, _ r2: APIResult?) -> String {
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

@JS func roundTripOptionalComplexResult(_ result: ComplexResult?) -> ComplexResult? {
    result
}

@JS func roundTripOptionalAllTypesResult(_ result: AllTypesResult?) -> AllTypesResult? {
    result
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

@JS func roundTripOptionalPayloadResult(_ result: OptionalAllTypesResult) -> OptionalAllTypesResult {
    result
}

@JS func roundTripOptionalPayloadResultOpt(_ result: OptionalAllTypesResult?) -> OptionalAllTypesResult? {
    result
}

@JS func roundTripOptionalClass(value: Greeter?) -> Greeter? {
    value
}

@JS func roundTripOptionalGreeter(_ value: Greeter?) -> Greeter? {
    value
}

@JS func applyOptionalGreeter(_ value: Greeter?, _ transform: (Greeter?) -> Greeter?) -> Greeter? {
    transform(value)
}

@JS class OptionalHolder {
    @JS var nullableGreeter: Greeter?
    @JS var undefinedNumber: JSUndefinedOr<Double>

    @JS init(nullableGreeter: Greeter?, undefinedNumber: JSUndefinedOr<Double>) {
        self.nullableGreeter = nullableGreeter
        self.undefinedNumber = undefinedNumber
    }
}

@JS func makeOptionalHolder(nullableGreeter: Greeter?, undefinedNumber: JSUndefinedOr<Double>) -> OptionalHolder {
    OptionalHolder(nullableGreeter: nullableGreeter, undefinedNumber: undefinedNumber)
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

@JS func roundTripOptionalAPIOptionalResult(result: APIOptionalResult?) -> APIOptionalResult? {
    result
}
