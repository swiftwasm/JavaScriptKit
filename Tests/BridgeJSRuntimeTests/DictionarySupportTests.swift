@_spi(BridgeJS) import JavaScriptKit
import XCTest

@JSClass struct DictionarySupportImports {
    @JSFunction static func jsRoundTripDictionaryInt(_ values: [String: Int]) throws(JSException) -> [String: Int]
    @JSFunction static func jsRoundTripDictionaryBool(_ values: [String: Bool]) throws(JSException) -> [String: Bool]
    @JSFunction static func jsRoundTripDictionaryDouble(
        _ values: [String: Double]
    ) throws(JSException) -> [String: Double]
    @JSFunction static func jsRoundTripDictionaryJSObject(
        _ values: [String: JSObject]
    ) throws(JSException) -> [String: JSObject]
    @JSFunction static func jsRoundTripDictionaryJSValue(
        _ values: [String: JSValue]
    ) throws(JSException) -> [String: JSValue]
    @JSFunction static func jsRoundTripDictionaryDoubleArray(
        _ values: [String: [Double]]
    ) throws(JSException) -> [String: [Double]]
}

final class DictionarySupportTests: XCTestCase {

    private func roundTripTest<T: Equatable>(_ fn: ([String: T]) throws -> [String: T], _ input: [String: T]) throws {
        let result = try fn(input)
        XCTAssertEqual(result, input)
    }

    func testRoundTripDictionaryInt() throws {
        try roundTripTest(DictionarySupportImports.jsRoundTripDictionaryInt, ["a": 1, "b": 2])
    }

    func testRoundTripDictionaryBool() throws {
        try roundTripTest(DictionarySupportImports.jsRoundTripDictionaryBool, ["yes": true, "no": false])
    }

    func testRoundTripDictionaryDouble() throws {
        try roundTripTest(DictionarySupportImports.jsRoundTripDictionaryDouble, ["pi": 3.14, "tau": 6.28])
    }

    func testRoundTripDictionaryJSObject() throws {
        try roundTripTest(DictionarySupportImports.jsRoundTripDictionaryJSObject, ["global": JSObject.global])
    }

    func testRoundTripDictionaryJSValue() throws {
        try roundTripTest(
            DictionarySupportImports.jsRoundTripDictionaryJSValue,
            ["number": .number(123.5), "boolean": .boolean(true), "string": .string("hello"), "null": .null]
        )
    }

    func testRoundTripDictionaryDoubleArray() throws {
        try roundTripTest(DictionarySupportImports.jsRoundTripDictionaryDoubleArray, ["xs": [1.0, 2.5], "ys": []])
    }
}
