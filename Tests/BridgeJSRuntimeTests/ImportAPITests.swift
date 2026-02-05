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

    func testRoundTripJSValue() throws {
        let symbol = JSSymbol("roundTrip")
        let bigInt = JSBigInt(_slowBridge: Int64(123456789))
        let values: [JSValue] = [
            .boolean(true),
            .number(42),
            .string(JSString("hello")),
            .object(JSObject.global),
            .null,
            .undefined,
            .symbol(symbol),
            .bigInt(bigInt),
        ]
        for value in values {
            try XCTAssertEqual(jsRoundTripJSValue(value), value)
        }
    }

    func testRoundTripJSValueArray() throws {
        let object = JSObject.global
        let symbol = JSSymbol("array")
        let bigInt = JSBigInt(_slowBridge: Int64(42))
        let values: [JSValue] = [
            .boolean(false),
            .number(123.5),
            .string(JSString("hello")),
            .object(object),
            .null,
            .undefined,
            .symbol(symbol),
            .bigInt(bigInt),
        ]
        let roundTripped = try jsRoundTripJSValueArray(values)
        XCTAssertEqual(roundTripped, values)
        XCTAssertEqual(try jsRoundTripJSValueArray([]), [])
    }

    func testRoundTripOptionalJSValueArray() throws {
        XCTAssertNil(try jsRoundTripOptionalJSValueArray(nil))
        let values: [JSValue] = [.number(1), .undefined, .null]
        let result = try jsRoundTripOptionalJSValueArray(values)
        XCTAssertEqual(result, values)
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

    func testRoundTripNumberArray() throws {
        let input: [Double] = [1.0, 2.5, 3.0, -4.5]
        let result = try jsRoundTripNumberArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try jsRoundTripNumberArray([]), [])
        XCTAssertEqual(try jsRoundTripNumberArray([42.0]), [42.0])
    }

    func testRoundTripStringArray() throws {
        let input = ["Hello", "World", "🎉"]
        let result = try jsRoundTripStringArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try jsRoundTripStringArray([]), [])
        XCTAssertEqual(try jsRoundTripStringArray(["", "a", ""]), ["", "a", ""])
    }

    func testRoundTripBoolArray() throws {
        let input = [true, false, true, false]
        let result = try jsRoundTripBoolArray(input)
        XCTAssertEqual(result, input)
        XCTAssertEqual(try jsRoundTripBoolArray([]), [])
    }

    func testSumNumberArray() throws {
        XCTAssertEqual(try jsSumNumberArray([1.0, 2.0, 3.0, 4.0]), 10.0)
        XCTAssertEqual(try jsSumNumberArray([]), 0.0)
        XCTAssertEqual(try jsSumNumberArray([42.0]), 42.0)
    }

    func testCreateNumberArray() throws {
        let result = try jsCreateNumberArray()
        XCTAssertEqual(result, [1.0, 2.0, 3.0, 4.0, 5.0])
    }
}
