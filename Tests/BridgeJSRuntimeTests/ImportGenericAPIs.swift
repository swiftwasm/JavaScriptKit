import Testing
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

@Suite struct ImportGenericAPITests {
    @Test func genericRoundTripScalars() throws {
        #expect(try jsGenericRoundTrip(42) == 42)
        #expect(try jsGenericRoundTrip(-7) == -7)
        #expect(try jsGenericRoundTrip(3.5) == 3.5)
        #expect(try jsGenericRoundTrip(Float(1.25)) == Float(1.25))
        #expect(try jsGenericRoundTrip(true) == true)
        #expect(try jsGenericRoundTrip(false) == false)
        #expect(try jsGenericRoundTrip("hello") == "hello")
        #expect(try jsGenericRoundTrip("") == "")
    }

    @Test func genericRoundTripNumerics() throws {
        #expect(try jsGenericRoundTrip(Int8(-5)) == Int8(-5))
        #expect(try jsGenericRoundTrip(Int8.min) == Int8.min)
        #expect(try jsGenericRoundTrip(Int8.max) == Int8.max)
        #expect(try jsGenericRoundTrip(UInt8(200)) == UInt8(200))
        #expect(try jsGenericRoundTrip(UInt8.max) == UInt8.max)
        #expect(try jsGenericRoundTrip(Int16(-1000)) == Int16(-1000))
        #expect(try jsGenericRoundTrip(UInt16(60000)) == UInt16(60000))
        #expect(try jsGenericRoundTrip(Int32(-123456)) == Int32(-123456))
        #expect(try jsGenericRoundTrip(UInt32(3_000_000_000)) == UInt32(3_000_000_000))
        #expect(try jsGenericRoundTrip(UInt32.max) == UInt32.max)
        #expect(try jsGenericRoundTrip(UInt(42)) == UInt(42))
        #expect(try jsGenericRoundTrip(UInt(4_000_000_000)) == UInt(4_000_000_000))
        #expect(try jsGenericRoundTrip(Int64(-9_000_000_000)) == Int64(-9_000_000_000))
        #expect(try jsGenericRoundTrip(Int64.min) == Int64.min)
        #expect(try jsGenericRoundTrip(Int64.max) == Int64.max)
        #expect(try jsGenericRoundTrip(UInt64(18_000_000_000_000_000_000)) == UInt64(18_000_000_000_000_000_000))
        #expect(try jsGenericRoundTrip(UInt64.max) == UInt64.max)
    }

    @Test func genericRoundTripJSValue() throws {
        let number = try jsGenericRoundTrip(JSValue.number(3.5))
        #expect(number.number == 3.5)
        let string = try jsGenericRoundTrip(JSValue.string("hi"))
        #expect(string.string == "hi")
        let boolean = try jsGenericRoundTrip(JSValue.boolean(true))
        #expect(boolean.boolean == true)
        #expect(try jsGenericRoundTrip(JSValue.null).isNull)
        #expect(try jsGenericRoundTrip(JSValue.undefined).isUndefined)
        let object = JSObject.global.Object.function!.new()
        object.tag = 7
        let roundTripped = try jsGenericRoundTrip(JSValue.object(object))
        #expect(roundTripped.object?.tag.number == 7)
    }

    @Test func genericWrappedRoundTrip() throws {
        #expect(try jsGenericArrayRoundTrip([1, 2, 3]) == [1, 2, 3])
        #expect(try jsGenericArrayRoundTrip(["a", "b"]) == ["a", "b"])
        #expect(try jsGenericArrayRoundTrip([Int]()) == [])
        #expect(try jsGenericOptionalRoundTrip(Optional<Int>.some(7)) == 7)
        #expect(try jsGenericOptionalRoundTrip(Optional<Int>.none) == nil)
        #expect(try jsGenericOptionalRoundTrip(Optional<String>.some("hi")) == "hi")
        let outcome = try jsGenericOptionalRoundTrip(Optional<GenericRTOutcome>.some(.ok(code: 5)))
        guard case .some(.ok(let code)) = outcome else {
            Issue.record("expected .ok")
            return
        }
        #expect(code == 5)
        #expect(try jsGenericOptionalRoundTrip(Optional<GenericRTOutcome>.none) == nil)
        #expect(try jsGenericDictRoundTrip(["x": 1, "y": 2]) == ["x": 1, "y": 2])
        #expect(try jsGenericDictRoundTrip([String: String]()) == [:])
    }

    @Test func genericRoundTripEnums() throws {
        #expect(try jsGenericRoundTrip(GenericRTColor.red) == .red)
        #expect(try jsGenericRoundTrip(GenericRTColor.blue) == .blue)
        #expect(try jsGenericRoundTrip(GenericRTMode.dark) == .dark)
        #expect(try jsGenericRoundTrip(GenericRTMode.light).rawValue == "light")
        #expect(try jsGenericRoundTrip(GenericRTLevel.high) == .high)
        let outcome = try jsGenericRoundTrip(GenericRTOutcome.ok(code: 42))
        guard case .ok(let code) = outcome else {
            Issue.record("expected .ok")
            return
        }
        #expect(code == 42)
        let failure = try jsGenericRoundTrip(GenericRTOutcome.fail(message: "boom"))
        guard case .fail(let message) = failure else {
            Issue.record("expected .fail")
            return
        }
        #expect(message == "boom")
    }

    @Test func genericRoundTripStruct() throws {
        let point = try jsGenericRoundTrip(GenericRTPoint(x: 1, y: 2))
        #expect(point.x == 1)
        #expect(point.y == 2)
    }

    @Test func genericRoundTripNestedStruct() throws {
        let metadata = try jsGenericRoundTrip(GenericRTNamespace.Metadata(label: "alpha", count: 7))
        #expect(metadata.label == "alpha")
        #expect(metadata.count == 7)
    }

    @Test func genericParse() throws {
        let point: GenericRTPoint = try jsGenericParsePoint("{\"x\": 10, \"y\": 20}")
        #expect(point.x == 10)
        #expect(point.y == 20)
        let n: Int = try jsGenericParsePoint("42")
        #expect(n == 42)
        let string: String = try jsGenericParsePoint("\"hi\"")
        #expect(string == "hi")
    }

    @Test func genericPickFirstMultiUse() throws {
        #expect(try jsImportPickFirst(10, 20) as Int == 10)
        #expect(try jsImportPickFirst("a", "b") as String == "a")
        let firstPoint = try jsImportPickFirst(GenericRTPoint(x: 1, y: 2), GenericRTPoint(x: 3, y: 4))
        #expect(firstPoint.x == 1)
        #expect(firstPoint.y == 2)
    }

    @Test func genericMakeReturnOnly() throws {
        let made: Int = try jsImportMakeInt()
        #expect(made == 123)
    }

    @Test func genericCombineSecondMultiParameter() throws {
        #expect(try jsImportCombineSecond(7, "hello") as String == "hello")
        #expect(try jsImportCombineSecond("x", 9) as Int == 9)
        let point = try jsImportCombineSecond(42, GenericRTPoint(x: 5, y: 6))
        #expect(point.x == 5)
        #expect(point.y == 6)
    }

    @Test func genericRoundTripHeapObjectClass() throws {
        let box = ImportGenericBox(value: 314)
        #expect(box.get() == 314)
        let sameBox = try jsGenericRoundTripClass(box)
        #expect(sameBox.get() == 314)
        sameBox.value = 271
        #expect(box.get() == 271)
    }

    @Test func genericMixedConsecutiveCalls() throws {
        #expect(try jsGenericRoundTrip(1) == 1)
        #expect(try jsGenericRoundTrip("two") == "two")
        #expect(try jsGenericRoundTrip(3.0) == 3.0)
        let p = try jsGenericRoundTrip(GenericRTPoint(x: 4, y: 5))
        #expect(p.x == 4)
        #expect(p.y == 5)
    }

    @Test func importGenericInstanceMethod() throws {
        let consumer = try ImportGenericConsumer()
        #expect(try consumer.identity(42) == 42)
        #expect(try consumer.identity(-7) == -7)
        #expect(try consumer.identity("hi") == "hi")
        #expect(try consumer.identity(true) == true)
        #expect(try consumer.identity(false) == false)
        let point = try consumer.identity(GenericRTPoint(x: 3, y: 4))
        #expect(point.x == 3)
        #expect(point.y == 4)
    }

    @Test func importGenericStaticMethod() throws {
        #expect(try ImportGenericConsumer.box(7) == 7)
        #expect(try ImportGenericConsumer.box("s") == "s")
        #expect(try ImportGenericConsumer.box(true) == true)
        let color = try ImportGenericConsumer.box(GenericRTColor.green)
        #expect(color == .green)
    }
}
