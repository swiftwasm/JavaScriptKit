import XCTest
import Foundation
import JavaScriptFoundationCompat
import JavaScriptKit

final class DataJSValueTests: XCTestCase {
    func testDataToJSValue() {
        let data = Data([0x00, 0x01, 0x02, 0x03])
        let jsValue = data.jsValue

        let uint8Array = JSTypedArray<UInt8>(from: jsValue)
        XCTAssertEqual(uint8Array?.lengthInBytes, 4)
        XCTAssertEqual(uint8Array?[0], 0x00)
        XCTAssertEqual(uint8Array?[1], 0x01)
        XCTAssertEqual(uint8Array?[2], 0x02)
        XCTAssertEqual(uint8Array?[3], 0x03)
    }

    func testJSValueToData() {
        let jsValue = JSTypedArray<UInt8>([0x00, 0x01, 0x02, 0x03]).jsValue
        let data = Data.construct(from: jsValue)
        XCTAssertEqual(data, Data([0x00, 0x01, 0x02, 0x03]))
    }

    func testDataToJSValue_withLargeData() {
        let data = Data(repeating: 0x00, count: 1024 * 1024)
        let jsValue = data.jsValue
        let uint8Array = JSTypedArray<UInt8>(from: jsValue)
        XCTAssertEqual(uint8Array?.lengthInBytes, 1024 * 1024)
    }

    func testJSValueToData_withLargeData() {
        let jsValue = JSTypedArray<UInt8>(Array(repeating: 0x00, count: 1024 * 1024)).jsValue
        let data = Data.construct(from: jsValue)
        XCTAssertEqual(data?.count, 1024 * 1024)
    }

    func testDataToJSValue_withEmptyData() {
        let data = Data()
        let jsValue = data.jsValue
        let uint8Array = JSTypedArray<UInt8>(from: jsValue)
        XCTAssertEqual(uint8Array?.lengthInBytes, 0)
    }

    func testJSValueToData_withEmptyData() {
        let jsValue = JSTypedArray<UInt8>([]).jsValue
        let data = Data.construct(from: jsValue)
        XCTAssertEqual(data, Data())
    }

    func testJSValueToData_withInvalidJSValue() {
        let data = Data.construct(from: JSObject().jsValue)
        XCTAssertNil(data)
    }
}
