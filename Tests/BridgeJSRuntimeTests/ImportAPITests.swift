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

    func testRoundTripOptionalNumberNull() throws {
        try XCTAssertEqual(jsRoundTripOptionalNumberNull(42), 42)
        try XCTAssertNil(jsRoundTripOptionalNumberNull(nil))
    }

    func testRoundTripOptionalNumberUndefined() throws {
        let some = try jsRoundTripOptionalNumberUndefined(.value(42))
        switch some {
        case .value(let value):
            XCTAssertEqual(value, 42)
        case .undefined:
            XCTFail("Expected defined value")
        }

        let undefined = try jsRoundTripOptionalNumberUndefined(.undefinedValue)
        if case .value = undefined {
            XCTFail("Expected undefined")
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

    func testClosureParameterIntToInt() throws {
        let result = try jsApplyInt(21) { $0 * 2 }
        XCTAssertEqual(result, 42)
    }

    func testClosureReturnIntToInt() throws {
        let add10 = try jsMakeAdder(10)
        XCTAssertEqual(add10(0), 10)
        XCTAssertEqual(add10(32), 42)
    }

    func testClosureParameterStringToString() throws {
        let result = try jsMapString("Hello") { value in
            value + ", world!"
        }
        XCTAssertEqual(result, "Hello, world!")
    }

    func testClosureReturnStringToString() throws {
        let prefixer = try jsMakePrefixer("Hello, ")
        XCTAssertEqual(prefixer("world!"), "Hello, world!")
    }

    func testRoundTripIntArray() throws {
        let values = [1, 2, 3, 4, 5]
        let result = try jsRoundTripIntArray(values)
        XCTAssertEqual(result, values)
        XCTAssertEqual(try jsArrayLength(values), values.count)
        XCTAssertEqual(try jsRoundTripIntArray([]), [])
    }

    func testRoundTripStringArray() throws {
        let values = ["", "Hello", "こんにちは", "emoji 👋"]
        let result = try jsRoundTripStringArray(values)
        XCTAssertEqual(result, values)
        XCTAssertEqual(try jsRoundTripStringArray([]), [])
    }

    func testJSClassArrayMembers() throws {
        let numbers = [1, 2, 3]
        let labels = ["alpha", "beta"]
        let host = try makeArrayHost(numbers, labels)

        XCTAssertEqual(try host.numbers, numbers)
        XCTAssertEqual(try host.labels, labels)

        try host.setNumbers([10, 20])
        try host.setLabels(["gamma"])
        XCTAssertEqual(try host.numbers, [10, 20])
        XCTAssertEqual(try host.labels, ["gamma"])

        XCTAssertEqual(try host.concatNumbers([30, 40]), [10, 20, 30, 40])
        XCTAssertEqual(try host.concatLabels(["delta", "epsilon"]), ["gamma", "delta", "epsilon"])
        XCTAssertEqual(try host.firstLabel([]), "gamma")
        XCTAssertEqual(try host.firstLabel(["zeta"]), "zeta")
    }

    func testClosureParameterIntToVoid() throws {
        var total = 0
        let ret = try jsCallTwice(5) { total += $0 }
        XCTAssertEqual(ret, 5)
        XCTAssertEqual(total, 10)
    }

    func testJSNameFunctionAndClass() throws {
        XCTAssertEqual(try _jsWeirdFunction(), 42)

        let obj = try _WeirdClass()
        XCTAssertEqual(try obj.method_with_dashes(), "ok")
    }

    func testJSClassStaticFunctions() throws {
        let created = try StaticBox.create(10)
        XCTAssertEqual(try created.value(), 10)

        let defaultBox = try StaticBox.makeDefault()
        XCTAssertEqual(try defaultBox.value(), 0)

        XCTAssertEqual(try StaticBox.value(), 99)

        let dashed = try StaticBox.with_dashes()
        XCTAssertEqual(try dashed.value(), 7)
    }
}
