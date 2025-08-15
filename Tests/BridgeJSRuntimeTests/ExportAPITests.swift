import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runJsWorks")
@_extern(c)
func runJsWorks() -> Void

@JS func roundTripVoid() -> Void {
    return
}

@JS func roundTripInt(v: Int) -> Int {
    return v
}
@JS func roundTripFloat(v: Float) -> Float {
    return v
}
@JS func roundTripDouble(v: Double) -> Double {
    return v
}
@JS func roundTripBool(v: Bool) -> Bool {
    return v
}
@JS func roundTripString(v: String) -> String {
    return v
}
@JS func roundTripSwiftHeapObject(v: Greeter) -> Greeter {
    return v
}

@JS func roundTripJSObject(v: JSObject) -> JSObject {
    return v
}

struct TestError: Error {
    let message: String
}

@JS func throwsSwiftError(shouldThrow: Bool) throws(JSException) -> Void {
    if shouldThrow {
        throw JSException(JSError(message: "TestError").jsValue)
    }
}
@JS func throwsWithIntResult() throws(JSException) -> Int { return 1 }
@JS func throwsWithStringResult() throws(JSException) -> String { return "Ok" }
@JS func throwsWithBoolResult() throws(JSException) -> Bool { return true }
@JS func throwsWithFloatResult() throws(JSException) -> Float { return 1.0 }
@JS func throwsWithDoubleResult() throws(JSException) -> Double { return 1.0 }
@JS func throwsWithSwiftHeapObjectResult() throws(JSException) -> Greeter { return Greeter(name: "Test") }
@JS func throwsWithJSObjectResult() throws(JSException) -> JSObject { return JSObject() }

@JS class Greeter {
    var name: String

    nonisolated(unsafe) static var onDeinit: () -> Void = {}

    @JS init(name: String) {
        self.name = name
    }

    @JS func greet() -> String {
        return "Hello, \(name)!"
    }
    @JS func changeName(name: String) {
        self.name = name
    }

    deinit {
        Self.onDeinit()
    }
}

@JS func takeGreeter(g: Greeter, name: String) {
    g.changeName(name: name)
}

// Test class without @JS init constructor
@JS class Calculator {
    nonisolated(unsafe) static var onDeinit: () -> Void = {}

    @JS func square(value: Int) -> Int {
        return value * value
    }

    @JS func add(a: Int, b: Int) -> Int {
        return a + b
    }

    deinit {
        Self.onDeinit()
    }
}

@JS func createCalculator() -> Calculator {
    return Calculator()
}

@JS func useCalculator(calc: Calculator, x: Int, y: Int) -> Int {
    return calc.add(a: calc.square(value: x), b: y)
}

class ExportAPITests: XCTestCase {
    func testAll() {
        var hasDeinitGreeter = false
        var hasDeinitCalculator = false

        Greeter.onDeinit = {
            hasDeinitGreeter = true
        }

        Calculator.onDeinit = {
            hasDeinitCalculator = true
        }

        runJsWorks()

        XCTAssertTrue(hasDeinitGreeter, "Greeter (with @JS init) should have been deinitialized")
        XCTAssertTrue(hasDeinitCalculator, "Calculator (without @JS init) should have been deinitialized")
    }
}
