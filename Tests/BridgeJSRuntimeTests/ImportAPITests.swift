import XCTest
import JavaScriptKit

class ImportAPITests: XCTestCase {
    private func requireGC() throws -> JSFunction {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }
        return gc
    }

    private func runGCUntil(
        gc: JSFunction,
        timeoutIterations: Int = 200,
        _ condition: () throws -> Bool
    ) async throws -> Bool {
        for _ in 0..<timeoutIterations {
            gc()
            // Allow FinalizationRegistry callbacks to run.
            try await Task.sleep(for: .milliseconds(0))
            if try condition() {
                return true
            }
        }
        return try condition()
    }

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

    func testSwiftStructInImportedSignature() throws {
        let point = Point(x: 1, y: 2)
        let moved = try jsTranslatePoint(point, dx: 3, dy: -1)
        XCTAssertEqual(moved.x, 4)
        XCTAssertEqual(moved.y, 1)
    }

    func testSwiftStructImportedLifetime_NoEscape() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        // Passing a Swift struct to an imported function should not leak the bridged JS object.
        try jsObservePointLifetime(Point(x: 1, y: 2), token)

        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected the bridged JS object to be finalized eventually (token: \(token))")
        XCTAssertFalse(try jsIsPointWeakAlive(token), "Expected WeakRef to be cleared (token: \(token))")
    }

    func testSwiftStructImportedLifetime_EscapesAndReleases() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        // If JS stores the object, it should remain alive across GCs.
        let handle = try jsStorePointStrong(Point(x: 10, y: 20), token)

        // Give the runtime some GC cycles; it should not be finalized while strongly referenced.
        for _ in 0..<50 {
            gc()
            try await Task.sleep(for: .milliseconds(0))
        }
        XCTAssertFalse(try jsIsPointFinalized(token), "Expected object to remain alive while stored (token: \(token))")
        XCTAssertTrue(try jsIsPointWeakAlive(token), "Expected WeakRef to still be alive (token: \(token))")

        // Release the strong reference and ensure it can be collected.
        try jsReleaseStoredPoint(handle)
        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected object to be finalized after release (token: \(token))")
    }

    func testSwiftStructImportedLifetime_ReturnValueDoesNotLeak() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        // Returning a struct from JS should not leak the retained return object ID.
        let point = try jsMakePoint(token, x: 7, y: 8)
        XCTAssertEqual(point.x, 7)
        XCTAssertEqual(point.y, 8)

        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected returned JS object to be finalized eventually (token: \(token))")
    }
}
