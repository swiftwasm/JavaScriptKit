import XCTest
import JavaScriptKit

@JS enum JSTypedArrayExports {
    @JS static func roundTripUint8Array(_ v: JSUint8Array) -> JSUint8Array { v }
    @JS static func roundTripFloat32Array(_ v: JSFloat32Array) -> JSFloat32Array { v }
    @JS static func roundTripFloat64Array(_ v: JSFloat64Array) -> JSFloat64Array { v }
    @JS static func roundTripInt32Array(_ v: JSInt32Array) -> JSInt32Array { v }
}

@JSClass struct JSTypedArrayImports {
    @JSFunction static func jsCreateUint8Array() throws(JSException) -> JSUint8Array
    @JSFunction static func jsRoundTripUint8Array(_ v: JSUint8Array) throws(JSException) -> JSUint8Array
    @JSFunction static func jsRoundTripFloat32Array(_ v: JSFloat32Array) throws(JSException) -> JSFloat32Array
    @JSFunction static func jsRoundTripFloat64Array(_ v: JSFloat64Array) throws(JSException) -> JSFloat64Array
    @JSFunction static func jsRoundTripInt32Array(_ v: JSInt32Array) throws(JSException) -> JSInt32Array
    @JSFunction static func runJsTypedArrayTests() throws(JSException)
}

final class JSTypedArrayTests: XCTestCase {
    func testRunJsTypedArrayTests() throws {
        try JSTypedArrayImports.runJsTypedArrayTests()
    }

    func testRoundTripUint8Array() throws {
        let arr = JSUint8Array([1, 2, 3, 255])
        let result = try JSTypedArrayImports.jsRoundTripUint8Array(arr)
        XCTAssertEqual(result.length, 4)
    }

    func testCreateUint8Array() throws {
        let result = try JSTypedArrayImports.jsCreateUint8Array()
        XCTAssertEqual(result.length, 3)
    }

    func testRoundTripFloat32Array() throws {
        let arr = JSFloat32Array([1.0, 2.5, 3.0])
        let result = try JSTypedArrayImports.jsRoundTripFloat32Array(arr)
        XCTAssertEqual(result.length, 3)
    }

    func testRoundTripFloat64Array() throws {
        let arr = JSFloat64Array([1.0, 2.5, 3.14159])
        let result = try JSTypedArrayImports.jsRoundTripFloat64Array(arr)
        XCTAssertEqual(result.length, 3)
    }

    func testRoundTripInt32Array() throws {
        let arr = JSInt32Array([1, -2, 2_147_483_647])
        let result = try JSTypedArrayImports.jsRoundTripInt32Array(arr)
        XCTAssertEqual(result.length, 3)
    }
}
