import JavaScriptKit
import XCTest

@JSClass struct IntegerTypesSupportImports {
    @JSFunction static func jsRoundTripInt(_ v: Int) throws(JSException) -> Int
    @JSFunction static func jsRoundTripUInt(_ v: UInt) throws(JSException) -> UInt
    @JSFunction static func jsRoundTripInt8(_ v: Int8) throws(JSException) -> Int8
    @JSFunction static func jsRoundTripUInt8(_ v: UInt8) throws(JSException) -> UInt8
    @JSFunction static func jsRoundTripInt16(_ v: Int16) throws(JSException) -> Int16
    @JSFunction static func jsRoundTripUInt16(_ v: UInt16) throws(JSException) -> UInt16
    @JSFunction static func jsRoundTripInt32(_ v: Int32) throws(JSException) -> Int32
    @JSFunction static func jsRoundTripUInt32(_ v: UInt32) throws(JSException) -> UInt32
    @JSFunction static func jsRoundTripInt64(_ v: Int64) throws(JSException) -> Int64
    @JSFunction static func jsRoundTripUInt64(_ v: UInt64) throws(JSException) -> UInt64

    @JSFunction static func runJsIntegerTypesSupportTests() throws(JSException) -> Void
}

final class IntegerTypesSupportTests: XCTestCase {
    func testRunJsIntegerTypesSupportTests() throws {
        try IntegerTypesSupportImports.runJsIntegerTypesSupportTests()
    }

    private func roundTripTest<T: Equatable>(_ fn: (T) throws -> T, _ input: [T]) throws {
        for v in input {
            let result = try fn(v)
            XCTAssertEqual(result, v)
        }
    }
    func testRoundTripInt() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripInt, [0, 1, -1, Int.min, Int.max])
    }
    func testRoundTripUInt() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripUInt, [0, 1, UInt.max])
    }
    func testRoundTripInt8() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripInt8, [0, 1, -1, Int8.min, Int8.max])
    }
    func testRoundTripUInt8() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripUInt8, [0, 1, UInt8.max])
    }
    func testRoundTripInt16() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripInt16, [0, 1, -1, Int16.min, Int16.max])
    }
    func testRoundTripUInt16() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripUInt16, [0, 1, UInt16.max])
    }
    func testRoundTripInt32() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripInt32, [0, 1, -1, Int32.min, Int32.max])
    }
    func testRoundTripUInt32() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripUInt32, [0, 1, UInt32.max])
    }
    func testRoundTripInt64() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripInt64, [0, 1, -1, Int64.min, Int64.max])
    }
    func testRoundTripUInt64() throws {
        try roundTripTest(IntegerTypesSupportImports.jsRoundTripUInt64, [0, 1, UInt64.max])
    }
}

@JS enum IntegerTypesSupportExports {
    @JS static func roundTripInt(_ v: Int) -> Int { v }
    @JS static func roundTripUInt(_ v: UInt) -> UInt { v }
    @JS static func roundTripInt8(_ v: Int8) -> Int8 { v }
    @JS static func roundTripUInt8(_ v: UInt8) -> UInt8 { v }
    @JS static func roundTripInt16(_ v: Int16) -> Int16 { v }
    @JS static func roundTripUInt16(_ v: UInt16) -> UInt16 { v }
    @JS static func roundTripInt32(_ v: Int32) -> Int32 { v }
    @JS static func roundTripUInt32(_ v: UInt32) -> UInt32 { v }
    @JS static func roundTripInt64(_ v: Int64) -> Int64 { v }
    @JS static func roundTripUInt64(_ v: UInt64) -> UInt64 { v }
}
