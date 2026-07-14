import XCTest
import JavaScriptKit

@JS struct GenericRTPoint {
    var x: Int
    var y: Int
}

@JS enum GenericRTNamespace {
    @JS struct Metadata {
        var label: String
        var count: Int
    }
}

@JS enum GenericRTColor {
    case red
    case green
    case blue
}

@JS enum GenericRTMode: String {
    case light
    case dark
}

@JS enum GenericRTLevel: Int {
    case low = 1
    case high = 9
}

@JS enum GenericRTOutcome {
    case ok(code: Int)
    case fail(message: String)
}

@JS final class ImportGenericBox {
    @JS var value: Int
    @JS init(value: Int) {
        self.value = value
    }
    @JS func get() -> Int {
        value
    }
}

@JSFunction func jsGenericRoundTrip<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
@JSFunction func jsGenericRoundTripClass<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
@JSFunction func jsGenericParsePoint<T: BridgedSwiftGenericBridgeable>(_ json: String) throws(JSException) -> T
@JSFunction func jsImportPickFirst<T: BridgedSwiftGenericBridgeable>(_ a: T, _ b: T) throws(JSException) -> T
@JSFunction func jsImportMakeInt<T: BridgedSwiftGenericBridgeable>() throws(JSException) -> T
@JSFunction func jsImportCombineSecond<T: BridgedSwiftGenericBridgeable, U: BridgedSwiftGenericBridgeable>(
    _ a: T,
    _ b: U
) throws(JSException) -> U
@JSFunction func jsGenericArrayRoundTrip<T: BridgedSwiftGenericBridgeable>(_ values: [T]) throws(JSException) -> [T]
@JSFunction func jsGenericOptionalRoundTrip<T: BridgedSwiftGenericBridgeable>(_ value: T?) throws(JSException) -> T?
@JSFunction func jsGenericDictRoundTrip<T: BridgedSwiftGenericBridgeable>(
    _ values: [String: T]
) throws(JSException) -> [String: T]

@JSClass struct ImportGenericConsumer {
    @JSFunction init() throws(JSException)
    @JSFunction func identity<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
    @JSFunction static func box<T: BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
}

class ImportGenericAPITests: XCTestCase {
    func testGenericRoundTripScalars() throws {
        XCTAssertEqual(try jsGenericRoundTrip(42), 42)
        XCTAssertEqual(try jsGenericRoundTrip(-7), -7)
        XCTAssertEqual(try jsGenericRoundTrip(3.5), 3.5)
        XCTAssertEqual(try jsGenericRoundTrip(Float(1.25)), Float(1.25))
        XCTAssertEqual(try jsGenericRoundTrip(true), true)
        XCTAssertEqual(try jsGenericRoundTrip(false), false)
        XCTAssertEqual(try jsGenericRoundTrip("hello"), "hello")
        XCTAssertEqual(try jsGenericRoundTrip(""), "")
    }

    func testGenericRoundTripNumerics() throws {
        XCTAssertEqual(try jsGenericRoundTrip(Int8(-5)), Int8(-5))
        XCTAssertEqual(try jsGenericRoundTrip(Int8.min), Int8.min)
        XCTAssertEqual(try jsGenericRoundTrip(Int8.max), Int8.max)
        XCTAssertEqual(try jsGenericRoundTrip(UInt8(200)), UInt8(200))
        XCTAssertEqual(try jsGenericRoundTrip(UInt8.max), UInt8.max)
        XCTAssertEqual(try jsGenericRoundTrip(Int16(-1000)), Int16(-1000))
        XCTAssertEqual(try jsGenericRoundTrip(UInt16(60000)), UInt16(60000))
        XCTAssertEqual(try jsGenericRoundTrip(Int32(-123456)), Int32(-123456))
        XCTAssertEqual(try jsGenericRoundTrip(UInt32(3_000_000_000)), UInt32(3_000_000_000))
        XCTAssertEqual(try jsGenericRoundTrip(UInt32.max), UInt32.max)
        XCTAssertEqual(try jsGenericRoundTrip(UInt(42)), UInt(42))
        XCTAssertEqual(try jsGenericRoundTrip(UInt(4_000_000_000)), UInt(4_000_000_000))
        XCTAssertEqual(try jsGenericRoundTrip(Int64(-9_000_000_000)), Int64(-9_000_000_000))
        XCTAssertEqual(try jsGenericRoundTrip(Int64.min), Int64.min)
        XCTAssertEqual(try jsGenericRoundTrip(Int64.max), Int64.max)
        XCTAssertEqual(try jsGenericRoundTrip(UInt64(18_000_000_000_000_000_000)), UInt64(18_000_000_000_000_000_000))
        XCTAssertEqual(try jsGenericRoundTrip(UInt64.max), UInt64.max)
    }

    func testGenericRoundTripJSValue() throws {
        let number = try jsGenericRoundTrip(JSValue.number(3.5))
        XCTAssertEqual(number.number, 3.5)
        let string = try jsGenericRoundTrip(JSValue.string("hi"))
        XCTAssertEqual(string.string, "hi")
        let boolean = try jsGenericRoundTrip(JSValue.boolean(true))
        XCTAssertEqual(boolean.boolean, true)
        XCTAssertTrue(try jsGenericRoundTrip(JSValue.null).isNull)
        XCTAssertTrue(try jsGenericRoundTrip(JSValue.undefined).isUndefined)
        let object = JSObject.global.Object.function!.new()
        object.tag = 7
        let roundTripped = try jsGenericRoundTrip(JSValue.object(object))
        XCTAssertEqual(roundTripped.object?.tag.number, 7)
    }

    func testGenericWrappedRoundTrip() throws {
        XCTAssertEqual(try jsGenericArrayRoundTrip([1, 2, 3]), [1, 2, 3])
        XCTAssertEqual(try jsGenericArrayRoundTrip(["a", "b"]), ["a", "b"])
        XCTAssertEqual(try jsGenericArrayRoundTrip([Int]()), [])
        XCTAssertEqual(try jsGenericOptionalRoundTrip(Optional<Int>.some(7)), 7)
        XCTAssertEqual(try jsGenericOptionalRoundTrip(Optional<Int>.none), nil)
        XCTAssertEqual(try jsGenericOptionalRoundTrip(Optional<String>.some("hi")), "hi")
        let outcome = try jsGenericOptionalRoundTrip(Optional<GenericRTOutcome>.some(.ok(code: 5)))
        guard case .some(.ok(let code)) = outcome else {
            return XCTFail("expected .ok")
        }
        XCTAssertEqual(code, 5)
        XCTAssertNil(try jsGenericOptionalRoundTrip(Optional<GenericRTOutcome>.none))
        XCTAssertEqual(try jsGenericDictRoundTrip(["x": 1, "y": 2]), ["x": 1, "y": 2])
        XCTAssertEqual(try jsGenericDictRoundTrip([String: String]()), [:])
    }

    func testGenericRoundTripEnums() throws {
        XCTAssertEqual(try jsGenericRoundTrip(GenericRTColor.red), .red)
        XCTAssertEqual(try jsGenericRoundTrip(GenericRTColor.blue), .blue)
        XCTAssertEqual(try jsGenericRoundTrip(GenericRTMode.dark), .dark)
        XCTAssertEqual(try jsGenericRoundTrip(GenericRTMode.light).rawValue, "light")
        XCTAssertEqual(try jsGenericRoundTrip(GenericRTLevel.high), .high)
        let outcome = try jsGenericRoundTrip(GenericRTOutcome.ok(code: 42))
        guard case .ok(let code) = outcome else {
            return XCTFail("expected .ok")
        }
        XCTAssertEqual(code, 42)
        let failure = try jsGenericRoundTrip(GenericRTOutcome.fail(message: "boom"))
        guard case .fail(let message) = failure else {
            return XCTFail("expected .fail")
        }
        XCTAssertEqual(message, "boom")
    }

    func testGenericRoundTripStruct() throws {
        let point = try jsGenericRoundTrip(GenericRTPoint(x: 1, y: 2))
        XCTAssertEqual(point.x, 1)
        XCTAssertEqual(point.y, 2)
    }

    func testGenericRoundTripNestedStruct() throws {
        let metadata = try jsGenericRoundTrip(GenericRTNamespace.Metadata(label: "alpha", count: 7))
        XCTAssertEqual(metadata.label, "alpha")
        XCTAssertEqual(metadata.count, 7)
    }

    func testGenericParse() throws {
        let point: GenericRTPoint = try jsGenericParsePoint("{\"x\": 10, \"y\": 20}")
        XCTAssertEqual(point.x, 10)
        XCTAssertEqual(point.y, 20)
        let n: Int = try jsGenericParsePoint("42")
        XCTAssertEqual(n, 42)
        let string: String = try jsGenericParsePoint("\"hi\"")
        XCTAssertEqual(string, "hi")
    }

    func testGenericPickFirstMultiUse() throws {
        XCTAssertEqual(try jsImportPickFirst(10, 20) as Int, 10)
        XCTAssertEqual(try jsImportPickFirst("a", "b") as String, "a")
        let firstPoint = try jsImportPickFirst(GenericRTPoint(x: 1, y: 2), GenericRTPoint(x: 3, y: 4))
        XCTAssertEqual(firstPoint.x, 1)
        XCTAssertEqual(firstPoint.y, 2)
    }

    func testGenericMakeReturnOnly() throws {
        let made: Int = try jsImportMakeInt()
        XCTAssertEqual(made, 123)
    }

    func testGenericCombineSecondMultiParameter() throws {
        XCTAssertEqual(try jsImportCombineSecond(7, "hello") as String, "hello")
        XCTAssertEqual(try jsImportCombineSecond("x", 9) as Int, 9)
        let point = try jsImportCombineSecond(42, GenericRTPoint(x: 5, y: 6))
        XCTAssertEqual(point.x, 5)
        XCTAssertEqual(point.y, 6)
    }

    func testGenericRoundTripHeapObjectClass() throws {
        let box = ImportGenericBox(value: 314)
        XCTAssertEqual(box.get(), 314)
        let sameBox = try jsGenericRoundTripClass(box)
        XCTAssertEqual(sameBox.get(), 314)
        sameBox.value = 271
        XCTAssertEqual(box.get(), 271)
    }

    func testGenericMixedConsecutiveCalls() throws {
        XCTAssertEqual(try jsGenericRoundTrip(1), 1)
        XCTAssertEqual(try jsGenericRoundTrip("two"), "two")
        XCTAssertEqual(try jsGenericRoundTrip(3.0), 3.0)
        let p = try jsGenericRoundTrip(GenericRTPoint(x: 4, y: 5))
        XCTAssertEqual(p.x, 4)
        XCTAssertEqual(p.y, 5)
    }

    func testImportGenericInstanceMethod() throws {
        let consumer = try ImportGenericConsumer()
        XCTAssertEqual(try consumer.identity(42), 42)
        XCTAssertEqual(try consumer.identity(-7), -7)
        XCTAssertEqual(try consumer.identity("hi"), "hi")
        XCTAssertEqual(try consumer.identity(true), true)
        XCTAssertEqual(try consumer.identity(false), false)
        let point = try consumer.identity(GenericRTPoint(x: 3, y: 4))
        XCTAssertEqual(point.x, 3)
        XCTAssertEqual(point.y, 4)
    }

    func testImportGenericStaticMethod() throws {
        XCTAssertEqual(try ImportGenericConsumer.box(7), 7)
        XCTAssertEqual(try ImportGenericConsumer.box("s"), "s")
        XCTAssertEqual(try ImportGenericConsumer.box(true), true)
        let color = try ImportGenericConsumer.box(GenericRTColor.green)
        XCTAssertEqual(color, .green)
    }
}
