import XCTest
import JavaScriptKit

class ImportAPITests: XCTestCase {
    func testRoundTripVoid() {
        jsRoundTripVoid()
    }

    func testRoundTripNumber() {
        for v in [
            0, 1, -1,
            Double(Int32.max), Double(Int32.min),
            Double(Int64.max), Double(Int64.min),
            Double(UInt32.max), Double(UInt32.min),
            Double(UInt64.max), Double(UInt64.min),
            Double.greatestFiniteMagnitude, Double.leastNonzeroMagnitude,
            Double.infinity,
            Double.pi,
        ] {
            XCTAssertEqual(jsRoundTripNumber(v), v)
        }

        XCTAssert(jsRoundTripNumber(Double.nan).isNaN)
    }

    func testRoundTripBool() {
        for v in [true, false] {
            XCTAssertEqual(jsRoundTripBool(v), v)
        }
    }

    func testRoundTripString() {
        for v in ["", "Hello, world!", "🧑‍🧑‍🧒"] {
            XCTAssertEqual(jsRoundTripString(v), v)
        }
    }

    func testClass() {
        let greeter = JsGreeter("Alice")
        XCTAssertEqual(greeter.greet(), "Hello, Alice!")
        greeter.changeName("Bob")
        XCTAssertEqual(greeter.greet(), "Hello, Bob!")
    }
}
