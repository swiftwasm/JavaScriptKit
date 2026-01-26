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

    func testRoundTripFeatureFlag() throws {
        for v in [FeatureFlag.foo, .bar] {
            try XCTAssertEqual(jsRoundTripFeatureFlag(v), v)
        }
    }

    func ensureThrows<T>(_ f: (Bool) throws(JSException) -> T) throws {
        do {
            _ = try f(true)
            XCTFail("Expected exception")
        } catch {
            XCTAssertTrue(error.description.contains("TestError"))
        }
    }
    func ensureDoesNotThrow<T>(_ f: (Bool) throws(JSException) -> T, _ assertValue: (T) -> Void) throws {
        do {
            let result = try f(false)
            assertValue(result)
        } catch {
            XCTFail("Expected no exception")
        }
    }

    func testThrowOrVoid() throws {
        try ensureThrows(jsThrowOrVoid)
        try ensureDoesNotThrow(jsThrowOrVoid, { _ in })
    }

    func testThrowOrNumber() throws {
        try ensureThrows(jsThrowOrNumber)
        try ensureDoesNotThrow(jsThrowOrNumber, { XCTAssertEqual($0, 1) })
    }

    func testThrowOrBool() throws {
        try ensureThrows(jsThrowOrBool)
        try ensureDoesNotThrow(jsThrowOrBool, { XCTAssertEqual($0, true) })
    }

    func testThrowOrString() throws {
        try ensureThrows(jsThrowOrString)
        try ensureDoesNotThrow(jsThrowOrString, { XCTAssertEqual($0, "Hello, world!") })
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
