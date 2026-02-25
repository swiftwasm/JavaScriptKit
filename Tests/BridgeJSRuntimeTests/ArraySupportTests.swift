import XCTest
import JavaScriptKit

@JSClass struct ArrayElementObject {
    @JSGetter var id: String

    @JSFunction init(id: String) throws(JSException)
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

    @JSFunction static func jsSumNumberArray(_ values: [Double]) throws(JSException) -> Double
    @JSFunction static func jsCreateNumberArray() throws(JSException) -> [Double]
}

final class ArraySupportTests: XCTestCase {

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
}
