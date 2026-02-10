@_spi(Experimental) @_spi(BridgeJS) import JavaScriptKit
import XCTest

final class DictionaryTests: XCTestCase {
    func testRoundTripDictionary() throws {
        let input: [String: Int] = ["a": 1, "b": 2]
        let result = try jsRoundTripDictionary(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripDictionaryBool() throws {
        let input: [String: Bool] = ["yes": true, "no": false]
        let result = try jsRoundTripDictionaryBool(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripDictionaryDouble() throws {
        let input: [String: Double] = ["pi": 3.14, "tau": 6.28]
        let result = try jsRoundTripDictionaryDouble(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripDictionaryJSObject() throws {
        let global = JSObject.global
        let input: [String: JSObject] = [
            "global": global
        ]
        let result = try jsRoundTripDictionaryJSObject(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripDictionaryJSValue() throws {
        let input: [String: JSValue] = [
            "number": .number(123.5),
            "boolean": .boolean(true),
            "string": .string("hello"),
            "null": .null,
        ]
        let result = try jsRoundTripDictionaryJSValue(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripNestedDictionary() throws {
        let input: [String: [Double]] = [
            "xs": [1.0, 2.5],
            "ys": [],
        ]
        let result = try jsRoundTripNestedDictionary(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripOptionalDictionaryNull() throws {
        let some: [String: String]? = ["k": "v"]
        XCTAssertEqual(try jsRoundTripOptionalDictionary(some), some)
        XCTAssertNil(try jsRoundTripOptionalDictionary(nil))
    }

    func testRoundTripOptionalDictionaryUndefined() throws {
        let some: JSUndefinedOr<[String: Int]> = .value(["n": 42])
        let undefined: JSUndefinedOr<[String: Int]> = .undefined

        let returnedSome = try jsRoundTripUndefinedDictionary(some)
        switch returnedSome {
        case .value(let dict):
            XCTAssertEqual(dict, ["n": 42])
        case .undefined:
            XCTFail("Expected defined dictionary")
        }

        let returnedUndefined = try jsRoundTripUndefinedDictionary(undefined)
        switch returnedUndefined {
        case .value:
            XCTFail("Expected undefined")
        case .undefined:
            break
        }
    }
}

@JSFunction func jsRoundTripDictionary(_ values: [String: Int]) throws(JSException) -> [String: Int]

@JSFunction func jsRoundTripDictionaryBool(_ values: [String: Bool]) throws(JSException) -> [String: Bool]

@JSFunction func jsRoundTripDictionaryDouble(_ values: [String: Double]) throws(JSException) -> [String: Double]

@JSFunction func jsRoundTripDictionaryJSObject(_ values: [String: JSObject]) throws(JSException) -> [String: JSObject]

@JSFunction func jsRoundTripDictionaryJSValue(_ values: [String: JSValue]) throws(JSException) -> [String: JSValue]

@JSFunction func jsRoundTripNestedDictionary(_ values: [String: [Double]]) throws(JSException) -> [String: [Double]]

@JSFunction func jsRoundTripOptionalDictionary(_ values: [String: String]?) throws(JSException) -> [String: String]?

@JSFunction func jsRoundTripUndefinedDictionary(
    _ values: JSUndefinedOr<[String: Int]>
) throws(JSException) -> JSUndefinedOr<[String: Int]>
