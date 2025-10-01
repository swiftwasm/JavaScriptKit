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
    @JS var name: String
    @JS let prefix: String = "Hello"

    nonisolated(unsafe) static var onDeinit: () -> Void = {}

    @JS init(name: String) {
        self.name = name
    }

    @JS func greet() -> String {
        return "\(prefix), \(name)!"
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

@JS internal class InternalGreeter {}
@JS public class PublicGreeter {}
@JS package class PackageGreeter {}

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

// MARK: - Namespace Enums

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

@JS func roundtripNetworkingAPIMethod(_ method: Networking.API.Method) -> Networking.API.Method {
    return method
}

@JS func roundtripConfigurationLogLevel(_ level: Configuration.LogLevel) -> Configuration.LogLevel {
    return level
}

@JS func roundtripConfigurationPort(_ port: Configuration.Port) -> Configuration.Port {
    return port
}

@JS func processConfigurationLogLevel(_ level: Configuration.LogLevel) -> Configuration.Port {
    switch level {
    case .debug: return .development
    case .info: return .http
    case .warning: return .https
    case .error: return .development
    }
}

@JS func roundtripInternalSupportedMethod(_ method: Internal.SupportedMethod) -> Internal.SupportedMethod {
    return method
}

@JS enum APIResult {
    case success(String)
    case failure(Int)
    case flag(Bool)
    case rate(Float)
    case precise(Double)
    case info
}

@JS func roundtripAPIResult(result: APIResult) -> APIResult {
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
    case location(Double, Double, String)
    case status(Bool, Int, String)
    case coordinates(Double, Double, Double)
    case comprehensive(Bool, Bool, Int, Int, Double, Double, String, String, String)
    case info
}

@JS func roundtripComplexResult(_ result: ComplexResult) -> ComplexResult {
    return result
}

@JS func makeComplexResultSuccess(_ value: String) -> ComplexResult {
    return .success(value)
}

@JS func makeComplexResultError(_ message: String, _ code: Int) -> ComplexResult {
    return .error(message, code)
}

@JS func makeComplexResultLocation(_ lat: Double, _ lng: Double, _ name: String) -> ComplexResult {
    return .location(lat, lng, name)
}

@JS func makeComplexResultStatus(_ active: Bool, _ code: Int, _ message: String) -> ComplexResult {
    return .status(active, code, message)
}

@JS func makeComplexResultCoordinates(_ x: Double, _ y: Double, _ z: Double) -> ComplexResult {
    return .coordinates(x, y, z)
}

@JS func makeComplexResultComprehensive(
    _ flag1: Bool,
    _ flag2: Bool,
    _ count1: Int,
    _ count2: Int,
    _ value1: Double,
    _ value2: Double,
    _ text1: String,
    _ text2: String,
    _ text3: String
) -> ComplexResult {
    return .comprehensive(flag1, flag2, count1, count2, value1, value2, text1, text2, text3)
}

@JS func makeComplexResultInfo() -> ComplexResult {
    return .info
}

@JS enum Utilities {
    @JS enum Result {
        case success(String)
        case failure(String, Int)
        case status(Bool, Int, String)
    }
}

@JS enum API {
    @JS enum NetworkingResult {
        case success(String)
        case failure(String, Int)
    }
}

@JS func makeUtilitiesResultSuccess(_ message: String) -> Utilities.Result {
    return .success(message)
}

@JS func makeUtilitiesResultFailure(_ error: String, _ code: Int) -> Utilities.Result {
    return .failure(error, code)
}

@JS func makeUtilitiesResultStatus(_ active: Bool, _ code: Int, _ message: String) -> Utilities.Result {
    return .status(active, code, message)
}

@JS func makeAPINetworkingResultSuccess(_ message: String) -> API.NetworkingResult {
    return .success(message)
}

@JS func makeAPINetworkingResultFailure(_ error: String, _ code: Int) -> API.NetworkingResult {
    return .failure(error, code)
}

@JS func roundtripUtilitiesResult(_ result: Utilities.Result) -> Utilities.Result {
    return result
}

@JS func roundtripAPINetworkingResult(_ result: API.NetworkingResult) -> API.NetworkingResult {
    return result
}

// MARK: - Optionals

@JS func roundTripOptionalString(name: String?) -> String? {
    return name
}

@JS func roundTripOptionalInt(value: Int?) -> Int? {
    return value
}

@JS func roundTripOptionalBool(flag: Bool?) -> Bool? {
    return flag
}

@JS func roundTripOptionalFloat(number: Float?) -> Float? {
    return number
}

@JS func roundTripOptionalDouble(precision: Double?) -> Double? {
    return precision
}

@JS func roundTripOptionalSyntax(name: Optional<String>) -> Optional<String> {
    return name
}

@JS func roundTripOptionalMixSyntax(name: String?) -> Optional<String> {
    return name
}

@JS func roundTripOptionalSwiftSyntax(name: Swift.Optional<String>) -> Swift.Optional<String> {
    return name
}

@JS func roundTripOptionalWithSpaces(value: Optional<Double>) -> Optional<Double> {
    return value
}

typealias OptionalAge = Int?
@JS func roundTripOptionalTypeAlias(age: OptionalAge) -> OptionalAge {
    return age
}

@JS func roundTripOptionalStatus(value: Status?) -> Status? {
    return value
}

@JS func roundTripOptionalTheme(value: Theme?) -> Theme? {
    return value
}

@JS func roundTripOptionalHttpStatus(value: HttpStatus?) -> HttpStatus? {
    return value
}

@JS func roundTripOptionalTSDirection(value: TSDirection?) -> TSDirection? {
    return value
}

@JS func roundTripOptionalTSTheme(value: TSTheme?) -> TSTheme? {
    return value
}

@JS func roundTripOptionalNetworkingAPIMethod(_ method: Networking.API.Method?) -> Networking.API.Method? {
    return method
}

@JS func roundTripOptionalAPIResult(value: APIResult?) -> APIResult? {
    return value
}

@JS func roundTripOptionalComplexResult(_ result: ComplexResult?) -> ComplexResult? {
    return result
}

@JS func roundTripOptionalClass(value: Greeter?) -> Greeter? {
    return value
}
@JS class OptionalPropertyHolder {
    @JS var optionalName: String?
    @JS var optionalAge: Int? = nil
    @JS var optionalGreeter: Greeter? = nil

    @JS init(optionalName: String?) {
        self.optionalName = optionalName
    }
}

@JS
enum APIOptionalResult {
    case success(String?)
    case failure(Int?, Bool?)
    case status(Bool?, Int?, String?)
}
@JS func roundTripOptionalAPIOptionalResult(result: APIOptionalResult?) -> APIOptionalResult? {
    return result
}

// MARK: - Property Tests

// Simple class for SwiftHeapObject property testing
@JS class SimplePropertyHolder {
    @JS var value: Int

    @JS init(value: Int) {
        self.value = value
    }
}

// Test class for various property types
@JS class PropertyHolder {
    // Primitive properties
    @JS var intValue: Int
    @JS var floatValue: Float
    @JS var doubleValue: Double
    @JS var boolValue: Bool
    @JS var stringValue: String

    // Readonly primitive properties
    @JS let readonlyInt: Int = 42
    @JS let readonlyFloat: Float = 3.14
    @JS let readonlyDouble: Double = 2.718281828
    @JS let readonlyBool: Bool = true
    @JS let readonlyString: String = "constant"

    // JSObject property
    @JS var jsObject: JSObject

    // SwiftHeapObject property
    @JS var sibling: SimplePropertyHolder

    // Lazy stored property
    @JS lazy var lazyValue: String = "computed lazily"

    // Computed property with getter only (readonly)
    @JS var computedReadonly: Int {
        return intValue * 2
    }

    // Computed property with getter and setter
    @JS var computedReadWrite: String {
        get {
            return "Value: \(intValue)"
        }
        set {
            // Parse the number from "Value: X" format
            if let range = newValue.range(of: "Value: "),
                let number = Int(String(newValue[range.upperBound...]))
            {
                intValue = number
            }
        }
    }

    // Property with property observers
    @JS var observedProperty: Int {
        willSet {
            Self.willSetCallCount += 1
            Self.lastWillSetOldValue = self.observedProperty
            Self.lastWillSetNewValue = newValue
        }
        didSet {
            Self.didSetCallCount += 1
            Self.lastDidSetOldValue = oldValue
            Self.lastDidSetNewValue = self.observedProperty
        }
    }

    // Static properties to track observer calls
    nonisolated(unsafe) static var willSetCallCount: Int = 0
    nonisolated(unsafe) static var didSetCallCount: Int = 0
    nonisolated(unsafe) static var lastWillSetOldValue: Int = 0
    nonisolated(unsafe) static var lastWillSetNewValue: Int = 0
    nonisolated(unsafe) static var lastDidSetOldValue: Int = 0
    nonisolated(unsafe) static var lastDidSetNewValue: Int = 0

    @JS init(
        intValue: Int,
        floatValue: Float,
        doubleValue: Double,
        boolValue: Bool,
        stringValue: String,
        jsObject: JSObject,
        sibling: SimplePropertyHolder
    ) {
        self.intValue = intValue
        self.floatValue = floatValue
        self.doubleValue = doubleValue
        self.boolValue = boolValue
        self.stringValue = stringValue
        self.jsObject = jsObject
        self.sibling = sibling
        self.observedProperty = intValue  // Initialize observed property
    }

    @JS func getAllValues() -> String {
        return "int:\(intValue),float:\(floatValue),double:\(doubleValue),bool:\(boolValue),string:\(stringValue)"
    }
}

@JS func createPropertyHolder(
    intValue: Int,
    floatValue: Float,
    doubleValue: Double,
    boolValue: Bool,
    stringValue: String,
    jsObject: JSObject
) -> PropertyHolder {
    let sibling = SimplePropertyHolder(value: 999)
    return PropertyHolder(
        intValue: intValue,
        floatValue: floatValue,
        doubleValue: doubleValue,
        boolValue: boolValue,
        stringValue: stringValue,
        jsObject: jsObject,
        sibling: sibling
    )
}

@JS func testPropertyHolder(holder: PropertyHolder) -> String {
    return holder.getAllValues()
}

@JS func resetObserverCounts() {
    PropertyHolder.willSetCallCount = 0
    PropertyHolder.didSetCallCount = 0
    PropertyHolder.lastWillSetOldValue = 0
    PropertyHolder.lastWillSetNewValue = 0
    PropertyHolder.lastDidSetOldValue = 0
    PropertyHolder.lastDidSetNewValue = 0
}

@JS func getObserverStats() -> String {
    return
        "willSet:\(PropertyHolder.willSetCallCount),didSet:\(PropertyHolder.didSetCallCount),willSetOld:\(PropertyHolder.lastWillSetOldValue),willSetNew:\(PropertyHolder.lastWillSetNewValue),didSetOld:\(PropertyHolder.lastDidSetOldValue),didSetNew:\(PropertyHolder.lastDidSetNewValue)"
}

// MARK: - Static Functions
@JS class MathUtils {
    @JS static func add(a: Int, b: Int) -> Int {
        return a + b
    }
    @JS class func substract(a: Int, b: Int) -> Int {
        return a - b
    }
}

@JS enum StaticCalculator {
    case scientific
    case basic

    @JS static func roundtrip(_ value: Int) -> Int {
        return value
    }
}

@JS enum StaticUtils {
    @JS enum Nested {
        @JS static func roundtrip(_ value: String) -> String {
            return value
        }
    }
}

// MARK: - Default Parameters

@JS func testStringDefault(message: String = "Hello World") -> String {
    return message
}

@JS func testIntDefault(count: Int = 42) -> Int {
    return count
}

@JS func testBoolDefault(flag: Bool = true) -> Bool {
    return flag
}

@JS func testOptionalDefault(name: String? = nil) -> String? {
    return name
}

@JS func testMultipleDefaults(
    title: String = "Default Title",
    count: Int = 10,
    enabled: Bool = false
) -> String {
    return "\(title): \(count) (\(enabled))"
}

@JS func testSimpleEnumDefault(status: Status = .success) -> Status {
    return status
}

@JS func testDirectionDefault(direction: Direction = .north) -> Direction {
    return direction
}

@JS func testRawStringEnumDefault(theme: Theme = .light) -> Theme {
    return theme
}

@JS func testComplexInit(greeter: Greeter = Greeter(name: "DefaultGreeter")) -> String {
    return greeter.greet()
}

@JS func testEmptyInit(_ object: StaticPropertyHolder = StaticPropertyHolder()) -> StaticPropertyHolder {
    return object
}

// MARK: - Static Properties

@JS class StaticPropertyHolder {
    @JS static let staticConstant: String = "constant"
    @JS nonisolated(unsafe) static var staticVariable: Int = 42
    @JS nonisolated(unsafe) static var staticString: String = "initial"
    @JS nonisolated(unsafe) static var staticBool: Bool = true
    @JS nonisolated(unsafe) static var staticFloat: Float = 3.14
    @JS nonisolated(unsafe) static var staticDouble: Double = 2.718

    @JS static var computedProperty: String {
        get { return "computed: \(staticVariable)" }
        set {
            if let number = Int(newValue.replacingOccurrences(of: "computed: ", with: "")) {
                staticVariable = number
            }
        }
    }

    @JS static var readOnlyComputed: Int {
        return staticVariable * 2
    }

    @JS nonisolated(unsafe) static var optionalString: String? = nil
    @JS nonisolated(unsafe) static var optionalInt: Int? = nil

    @JS nonisolated(unsafe) static var jsObjectProperty: JSObject = JSObject()

    @JS init() {}

}

@JS enum StaticPropertyEnum {
    case option1
    case option2

    @JS nonisolated(unsafe) static var enumProperty: String = "enum value"
    @JS static let enumConstant: Int = 42
    @JS nonisolated(unsafe) static var enumBool: Bool = false

    @JS nonisolated(unsafe) static var enumVariable: Int = 200

    @JS static var computedReadonly: Int {
        return enumVariable * 2
    }

    @JS static var computedReadWrite: String {
        get {
            return "Value: \(enumVariable)"
        }
        set {
            if let range = newValue.range(of: "Value: "),
                let number = Int(String(newValue[range.upperBound...]))
            {
                enumVariable = number
            }
        }
    }
}

@JS enum StaticPropertyNamespace {
    @JS nonisolated(unsafe) static var namespaceProperty: String = "namespace"
    @JS static let namespaceConstant: String = "constant"

    @JS enum NestedProperties {
        @JS nonisolated(unsafe) static var nestedProperty: Int = 999
        @JS static let nestedConstant: String = "nested"
        @JS nonisolated(unsafe) static var nestedDouble: Double = 1.414
    }
}

// Test functions for static properties
@JS func getAllStaticPropertyValues() -> String {
    return
        "const:\(StaticPropertyHolder.staticConstant),var:\(StaticPropertyHolder.staticVariable),computed:\(StaticPropertyHolder.computedProperty),readonly:\(StaticPropertyHolder.readOnlyComputed)"
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
