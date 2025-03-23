import JavaScriptBigIntSupport
import JavaScriptKit
import XCTest

class JavaScriptBigIntSupportTests: XCTestCase {
    func testBigIntSupport() {
        // Test signed values
        func testSignedValue(_ value: Int64, file: StaticString = #filePath, line: UInt = #line) {
            let bigInt = JSBigInt(value)
            XCTAssertEqual(bigInt.description, value.description, file: file, line: line)
            let bigInt2 = JSBigInt(_slowBridge: value)
            XCTAssertEqual(bigInt2.description, value.description, file: file, line: line)
        }

        // Test unsigned values
        func testUnsignedValue(_ value: UInt64, file: StaticString = #filePath, line: UInt = #line) {
            let bigInt = JSBigInt(unsigned: value)
            XCTAssertEqual(bigInt.description, value.description, file: file, line: line)
            let bigInt2 = JSBigInt(_slowBridge: value)
            XCTAssertEqual(bigInt2.description, value.description, file: file, line: line)
        }

        // Test specific signed values
        testSignedValue(0)
        testSignedValue(1 << 62)
        testSignedValue(-2305)

        // Test random signed values
        for _ in 0..<100 {
            testSignedValue(.random(in: .min ... .max))
        }

        // Test edge signed values
        testSignedValue(.min)
        testSignedValue(.max)

        // Test specific unsigned values
        testUnsignedValue(0)
        testUnsignedValue(1 << 62)
        testUnsignedValue(1 << 63)
        testUnsignedValue(.min)
        testUnsignedValue(.max)
        testUnsignedValue(~0)

        // Test random unsigned values
        for _ in 0..<100 {
            testUnsignedValue(.random(in: .min ... .max))
        }
    }
}
