import XCTest
import JavaScriptKit

class ImportAPITests: XCTestCase {
    func testRoundTripVoid() throws {
        try jsRoundTripVoid()
    }

    func testRoundTripNumber() throws {
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
            try XCTAssertEqual(jsRoundTripNumber(v), v)
        }

        try XCTAssert(jsRoundTripNumber(Double.nan).isNaN)
    }

    func testRoundTripBool() throws {
        for v in [true, false] {
            try XCTAssertEqual(jsRoundTripBool(v), v)
        }
    }

    func testRoundTripString() throws {
        for v in ["", "Hello, world!", "🧑‍🧑‍🧒"] {
            try XCTAssertEqual(jsRoundTripString(v), v)
        }
    }

    func testClass() throws {
        let greeter = try JsGreeter("Alice", "Hello")
        XCTAssertEqual(try greeter.greet(), "Hello, Alice!")
        try greeter.changeName("Bob")
        XCTAssertEqual(try greeter.greet(), "Hello, Bob!")

        try greeter.setName("Charlie")
        XCTAssertEqual(try greeter.greet(), "Hello, Charlie!")
        XCTAssertEqual(try greeter.name, "Charlie")

        XCTAssertEqual(try greeter.prefix, "Hello")
    }
}
