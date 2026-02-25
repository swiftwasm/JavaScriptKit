import XCTest
import JavaScriptKit

@JSClass struct ArrayElementObject {
    @JSGetter var id: String

    @JSFunction init(id: String) throws(JSException)
}

@JS protocol ArrayElementProtocol {
    var value: Int { get set }
}

@JSClass struct ArraySupportImports {
    @JSFunction static func jsIntArrayLength(_ items: [Int]) throws(JSException) -> Int

    @JSFunction static func jsRoundTripIntArray(_ items: [Int]) throws(JSException) -> [Int]
    @JSFunction static func jsRoundTripNumberArray(_ values: [Double]) throws(JSException) -> [Double]
    @JSFunction static func jsRoundTripStringArray(_ values: [String]) throws(JSException) -> [String]
    @JSFunction static func jsRoundTripBoolArray(_ values: [Bool]) throws(JSException) -> [Bool]

    @JSFunction static func jsRoundTripJSValueArray(_ v: [JSValue]) throws(JSException) -> [JSValue]
    @JSFunction static func jsRoundTripJSObjectArray(_ values: [JSObject]) throws(JSException) -> [JSObject]

    @JSFunction static func jsRoundTripJSClassArray(
        _ values: [ArrayElementObject]
    ) throws(JSException) -> [ArrayElementObject]

    @JSFunction static func jsRoundTripOptionalIntArray(_ values: [Int?]) throws(JSException) -> [Int?]
    @JSFunction static func jsRoundTripOptionalStringArray(_ values: [String?]) throws(JSException) -> [String?]
    @JSFunction static func jsRoundTripOptionalBoolArray(_ values: [Bool?]) throws(JSException) -> [Bool?]
    @JSFunction static func jsRoundTripOptionalJSValueArray(_ values: [JSValue?]) throws(JSException) -> [JSValue?]
    @JSFunction static func jsRoundTripOptionalJSObjectArray(_ values: [JSObject?]) throws(JSException) -> [JSObject?]
    @JSFunction static func jsRoundTripOptionalJSClassArray(
        _ values: [ArrayElementObject?]
    ) throws(JSException) -> [ArrayElementObject?]

    @JSFunction static func jsSumNumberArray(_ values: [Double]) throws(JSException) -> Double
    @JSFunction static func jsCreateNumberArray() throws(JSException) -> [Double]

    @JSFunction static func runJsArraySupportTests() throws(JSException)
}

final class ArraySupportTests: XCTestCase {

    func testRunJsArraySupportTests() throws {
        try ArraySupportImports.runJsArraySupportTests()
    }

    func testRoundTripIntArray() throws {
        let values = [1, 2, 3, 4, 5]
        let result = try ArraySupportImports.jsRoundTripIntArray(values)
        XCTAssertEqual(result, values)
        XCTAssertEqual(try ArraySupportImports.jsIntArrayLength(values), values.count)
        XCTAssertEqual(try ArraySupportImports.jsRoundTripIntArray([]), [])
    }

    func testRoundTripNumberArray() throws {
        let input: [Double] = [1.0, 2.5, 3.0, -4.5]
        let result = try ArraySupportImports.jsRoundTripNumberArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try ArraySupportImports.jsRoundTripNumberArray([]), [])
        XCTAssertEqual(try ArraySupportImports.jsRoundTripNumberArray([42.0]), [42.0])
    }

    func testRoundTripStringArray() throws {
        let input = ["Hello", "World", "🎉"]
        let result = try ArraySupportImports.jsRoundTripStringArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try ArraySupportImports.jsRoundTripStringArray([]), [])
        XCTAssertEqual(try ArraySupportImports.jsRoundTripStringArray(["", "a", ""]), ["", "a", ""])
    }

    func testRoundTripBoolArray() throws {
        let input = [true, false, true, false]
        let result = try ArraySupportImports.jsRoundTripBoolArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try ArraySupportImports.jsRoundTripBoolArray([]), [])
    }

    func testSumNumberArray() throws {
        XCTAssertEqual(try ArraySupportImports.jsSumNumberArray([1.0, 2.0, 3.0, 4.0]), 10.0)
        XCTAssertEqual(try ArraySupportImports.jsSumNumberArray([]), 0.0)
        XCTAssertEqual(try ArraySupportImports.jsSumNumberArray([42.0]), 42.0)
    }

    func testCreateNumberArray() throws {
        let result = try ArraySupportImports.jsCreateNumberArray()
        XCTAssertEqual(result, [1.0, 2.0, 3.0, 4.0, 5.0])
    }

    func testRoundTripJSValueArray() throws {
        let object = JSObject.global
        let symbol = JSSymbol("array")
        let bigInt = JSBigInt(_slowBridge: Int64(42))
        let values: [JSValue] = [
            .boolean(false),
            .number(123.5),
            .string(JSString("hello")),
            .object(object),
            .null,
            .undefined,
            .symbol(symbol),
            .bigInt(bigInt),
        ]
        let roundTripped = try ArraySupportImports.jsRoundTripJSValueArray(values)
        XCTAssertEqual(roundTripped, values)
        XCTAssertEqual(try ArraySupportImports.jsRoundTripJSValueArray([]), [])
    }

    func testRoundTripJSObjectArray() throws {
        let values: [JSObject] = [.global, JSObject(), ["a": 1, "b": 2]]
        let result = try ArraySupportImports.jsRoundTripJSObjectArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripJSClassArray() throws {
        let values = try [ArrayElementObject(id: "1"), ArrayElementObject(id: "2"), ArrayElementObject(id: "3")]
        let result = try ArraySupportImports.jsRoundTripJSClassArray(values)
        XCTAssertEqual(result, values)
        XCTAssertEqual(try result[0].id, "1")
        XCTAssertEqual(try result[1].id, "2")
        XCTAssertEqual(try result[2].id, "3")

        XCTAssertEqual(try ArraySupportImports.jsRoundTripJSClassArray([]), [])
    }

    func testRoundTripOptionalIntArray() throws {
        let values = [1, nil, 3, nil, 5]
        let result = try ArraySupportImports.jsRoundTripOptionalIntArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripOptionalStringArray() throws {
        let values = ["hello", nil, "world", nil, "🎉"]
        let result = try ArraySupportImports.jsRoundTripOptionalStringArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripOptionalBoolArray() throws {
        let values = [true, nil, false, nil, true]
        let result = try ArraySupportImports.jsRoundTripOptionalBoolArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripOptionalJSValueArray() throws {
        let values: [JSValue?] = [.number(1), nil, .string("hello"), nil, .object(.global)]
        let result = try ArraySupportImports.jsRoundTripOptionalJSValueArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripOptionalJSObjectArray() throws {
        let values = [.global, nil, JSObject(), nil, ["a": 1, "b": 2]]
        let result = try ArraySupportImports.jsRoundTripOptionalJSObjectArray(values)
        XCTAssertEqual(result, values)
    }

    func testRoundTripOptionalJSClassArray() throws {
        let values = try [
            ArrayElementObject(id: "1"), nil, ArrayElementObject(id: "2"), nil, ArrayElementObject(id: "3"),
        ]
        let result = try ArraySupportImports.jsRoundTripOptionalJSClassArray(values)
        XCTAssertEqual(result, values)
        XCTAssertEqual(try result[0]?.id, "1")
        XCTAssertEqual(result[1], nil)
        XCTAssertEqual(try result[2]?.id, "2")
        XCTAssertEqual(result[3], nil)
        XCTAssertEqual(try result[4]?.id, "3")

        XCTAssertEqual(try ArraySupportImports.jsRoundTripOptionalJSClassArray([]), [])
    }
}

@JS enum ArraySupportExports {
    @JS static func roundTripIntArray(_ v: [Int]) -> [Int] { v }
    @JS static func roundTripStringArray(_ v: [String]) -> [String] { v }
    @JS static func roundTripDoubleArray(_ v: [Double]) -> [Double] { v }
    @JS static func roundTripBoolArray(_ v: [Bool]) -> [Bool] { v }
    @JS static func roundTripUnsafeRawPointerArray(_ v: [UnsafeRawPointer]) -> [UnsafeRawPointer] { v }
    @JS static func roundTripUnsafeMutableRawPointerArray(_ v: [UnsafeMutableRawPointer]) -> [UnsafeMutableRawPointer] {
        v
    }
    @JS static func roundTripOpaquePointerArray(_ v: [OpaquePointer]) -> [OpaquePointer] { v }
    @JS static func roundTripUnsafePointerArray(_ v: [UnsafePointer<UInt8>]) -> [UnsafePointer<UInt8>] { v }
    @JS static func roundTripUnsafeMutablePointerArray(
        _ v: [UnsafeMutablePointer<UInt8>]
    ) -> [UnsafeMutablePointer<UInt8>] { v }
    @JS static func roundTripJSValueArray(_ v: [JSValue]) -> [JSValue] { v }
    @JS static func roundTripJSObjectArray(_ v: [JSObject]) -> [JSObject] { v }
    @JS static func roundTripCaseEnumArray(_ v: [Direction]) -> [Direction] { v }
    @JS static func roundTripStringRawValueEnumArray(_ v: [Theme]) -> [Theme] { v }
    @JS static func roundTripIntRawValueEnumArray(_ v: [HttpStatus]) -> [HttpStatus] { v }
    @JS static func roundTripStructArray(_ v: [DataPoint]) -> [DataPoint] { v }
    @JS static func roundTripSwiftClassArray(_ v: [Greeter]) -> [Greeter] { v }
    @JS static func roundTripNamespacedSwiftClassArray(_ v: [Utils.Converter]) -> [Utils.Converter] { v }
    @JS static func roundTripProtocolArray(_ v: [ArrayElementProtocol]) -> [ArrayElementProtocol] { v }
    @JS static func roundTripJSClassArray(_ v: [ArrayElementObject]) -> [ArrayElementObject] { v }

    @JS static func roundTripOptionalIntArray(_ v: [Int?]) -> [Int?] { v }
    @JS static func roundTripOptionalStringArray(_ v: [String?]) -> [String?] { v }
    @JS static func roundTripOptionalJSObjectArray(_ v: [JSObject?]) -> [JSObject?] { v }
    @JS static func roundTripOptionalCaseEnumArray(_ v: [Direction?]) -> [Direction?] { v }
    @JS static func roundTripOptionalStringRawValueEnumArray(_ v: [Theme?]) -> [Theme?] { v }
    @JS static func roundTripOptionalIntRawValueEnumArray(_ v: [HttpStatus?]) -> [HttpStatus?] { v }
    @JS static func roundTripOptionalStructArray(_ v: [DataPoint?]) -> [DataPoint?] { v }
    @JS static func roundTripOptionalSwiftClassArray(_ v: [Greeter?]) -> [Greeter?] { v }
    @JS static func roundTripOptionalJSClassArray(_ v: [ArrayElementObject?]) -> [ArrayElementObject?] { v }

    @JS static func roundTripNestedIntArray(_ v: [[Int]]) -> [[Int]] { v }
    @JS static func roundTripNestedStringArray(_ v: [[String]]) -> [[String]] { v }
    @JS static func roundTripNestedDoubleArray(_ v: [[Double]]) -> [[Double]] { v }
    @JS static func roundTripNestedBoolArray(_ v: [[Bool]]) -> [[Bool]] { v }
    @JS static func roundTripNestedStructArray(_ v: [[DataPoint]]) -> [[DataPoint]] { v }
    @JS static func roundTripNestedCaseEnumArray(_ v: [[Direction]]) -> [[Direction]] { v }
    @JS static func roundTripNestedSwiftClassArray(_ v: [[Greeter]]) -> [[Greeter]] { v }

    // MARK: - Multiple Array Parameters
    @JS static func multiArrayFirst(_ a: [Int], _ b: [String]) -> [Int] { a }
    @JS static func multiArraySecond(_ a: [Int], _ b: [String]) -> [String] { b }
    @JS static func multiOptionalArrayFirst(_ a: [Int]?, _ b: [String]?) -> [Int]? { a }
    @JS static func multiOptionalArraySecond(_ a: [Int]?, _ b: [String]?) -> [String]? { b }
}
