import XCTest
import JavaScriptKit
import JavaScriptEventLoop

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

@JS func asyncRoundTripVoid() async -> Void { return }
@JS func asyncRoundTripInt(v: Int) async -> Int { return v }
@JS func asyncRoundTripFloat(v: Float) async -> Float { return v }
@JS func asyncRoundTripDouble(v: Double) async -> Double { return v }
@JS func asyncRoundTripBool(v: Bool) async -> Bool { return v }
@JS func asyncRoundTripString(v: String) async -> String { return v }
@JS func asyncRoundTripSwiftHeapObject(v: Greeter) async -> Greeter { return v }
@JS func asyncRoundTripJSObject(v: JSObject) async -> JSObject { return v }

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

@JS func testGreeterToJSValue() -> JSObject {
    let greeter = Greeter(name: "Test")
    return greeter.jsValue.object!
}

@JS func testCalculatorToJSValue() -> JSObject {
    let calc = Calculator()
    return calc.jsValue.object!
}

@JS func testSwiftClassAsJSValue(greeter: Greeter) -> JSObject {
    return greeter.jsValue.object!
}

// MARK: - Enum Tests

@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS enum Status {
    case loading
    case success
    case error
}

@JS enum Theme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

@JS enum HttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

@JS(enumStyle: .tsEnum) enum TSDirection {
    case north
    case south
    case east
    case west
}

@JS(enumStyle: .tsEnum) enum TSTheme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

@JS func setDirection(_ direction: Direction) -> Direction {
    return direction
}

@JS func getDirection() -> Direction {
    return .north
}

@JS func processDirection(_ input: Direction) -> Status {
    switch input {
    case .north, .south: return .success
    case .east, .west: return .loading
    }
}

@JS func setTheme(_ theme: Theme) -> Theme {
    return theme
}

@JS func getTheme() -> Theme {
    return .light
}

@JS func setHttpStatus(_ status: HttpStatus) -> HttpStatus {
    return status
}

@JS func getHttpStatus() -> HttpStatus {
    return .ok
}

@JS func processTheme(_ theme: Theme) -> HttpStatus {
    switch theme {
    case .light: return .ok
    case .dark: return .notFound
    case .auto: return .serverError
    }
}

@JS func setTSDirection(_ direction: TSDirection) -> TSDirection {
    return direction
}

@JS func getTSDirection() -> TSDirection {
    return .north
}

@JS func setTSTheme(_ theme: TSTheme) -> TSTheme {
    return theme
}

@JS func getTSTheme() -> TSTheme {
    return .light
}

@JS enum Utils {
    @JS class Converter {
        @JS init() {}

        @JS func toString(value: Int) -> String {
            return String(value)
        }
    }
}

@JS enum Networking {
    @JS enum API {
        @JS enum Method {
            case get
            case post
            case put
            case delete
        }
        @JS class HTTPServer {
            @JS init() {}
            @JS func call(_ method: Method) {}
        }
    }
}

@JS enum Configuration {
    @JS enum LogLevel: String {
        case debug = "debug"
        case info = "info"
        case warning = "warning"
        case error = "error"
    }

    @JS enum Port: Int {
        case http = 80
        case https = 443
        case development = 3000
    }
}

@JS(namespace: "Networking.APIV2")
enum Internal {
    @JS enum SupportedMethod {
        case get
        case post
    }
    @JS class TestServer {
        @JS init() {}
        @JS func call(_ method: SupportedMethod) {}
    }
}

@JS enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}

@JS func echoAPIResult(result: APIResult) -> APIResult {
    return result
}

@JS func makeAPIResultSuccess(_ value: String) -> APIResult {
    return .success(value)
}

@JS func makeAPIResultFailure(_ value: Int) -> APIResult {
    return .failure(value)
}

@JS func makeAPIResultInfo() -> APIResult {
    return .info
}

@JS func makeAPIResultFlag(_ value: Bool) -> APIResult {
    return .flag(value)
}

@JS func makeAPIResultRate(_ value: Float) -> APIResult {
    return .rate(value)
}

@JS func makeAPIResultPrecise(_ value: Double) -> APIResult {
    return .precise(value)
}

@JS
enum ComplexResult {
    case success(String)
    case error(String, Int)
    case status(Bool, String)
    case info
}

@JS func echoComplexResult(result: ComplexResult) -> ComplexResult {
    return result
}

@JS func makeComplexResultSuccess(_ value: String) -> ComplexResult {
    return .success(value)
}

@JS func makeComplexResultError(_ message: String, _ code: Int) -> ComplexResult {
    return .error(message, code)
}

@JS func makeComplexResultStatus(_ active: Bool, _ message: String) -> ComplexResult {
    return .status(active, message)
}

@JS func makeComplexResultInfo() -> ComplexResult {
    return .info
}

@JS func roundtripComplexResult(_ result: ComplexResult) -> ComplexResult {
    return result
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

    func testAllAsync() async throws {
        _ = try await runAsyncWorks().value()
    }
}
