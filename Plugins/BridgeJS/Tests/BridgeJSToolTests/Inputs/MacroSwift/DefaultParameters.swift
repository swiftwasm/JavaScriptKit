@JS public func testStringDefault(message: String = "Hello World") -> String

@JS public func testNegativeIntDefault(value: Int = -42) -> Int

@JS public func testBoolDefault(flag: Bool = true) -> Bool

@JS public func testNegativeFloatDefault(temp: Float = -273.15) -> Float

@JS public func testDoubleDefault(precision: Double = 2.718) -> Double

@JS public func testOptionalDefault(name: String? = nil) -> String?

@JS public func testOptionalStringDefault(greeting: String? = "Hi") -> String?

@JS public func testMultipleDefaults(
    title: String = "Default Title",
    count: Int = 10,
    enabled: Bool = false
) -> String

@JS public enum Status {
    case active
    case inactive
    case pending
}

@JS public func testEnumDefault(status: Status = .active) -> Status

@JS class DefaultGreeter {
    @JS var name: String
    @JS init(name: String)
}

@JS class EmptyGreeter {
    @JS init()
}

@JS public func testComplexInit(greeter: DefaultGreeter = DefaultGreeter(name: "DefaultUser")) -> DefaultGreeter
@JS public func testEmptyInit(greeter: EmptyGreeter = EmptyGreeter()) -> EmptyGreeter

@JS class ConstructorDefaults {
    @JS var name: String
    @JS var count: Int
    @JS var enabled: Bool
    @JS var status: Status
    @JS var tag: String?

    @JS init(
        name: String = "Default",
        count: Int = 42,
        enabled: Bool = true,
        status: Status = .active,
        tag: String? = nil
    )
}

@JS struct Config {
    var name: String
    var value: Int
    var enabled: Bool
}

@JS public func testOptionalStructDefault(point: Config? = nil) -> Config?
@JS public func testOptionalStructWithValueDefault(
    point: Config? = Config(name: "default", value: 42, enabled: true)
) -> Config?

@JS struct MathOperations {
    var baseValue: Double

    @JS init(baseValue: Double = 0.0)
    @JS func add(a: Double, b: Double = 10.0) -> Double
    @JS func multiply(a: Double, b: Double) -> Double
    @JS static func subtract(a: Double, b: Double = 5.0) -> Double
}

// Array default values
@JS public func testIntArrayDefault(values: [Int] = [1, 2, 3]) -> [Int]
@JS public func testStringArrayDefault(names: [String] = ["a", "b", "c"]) -> [String]
@JS public func testDoubleArrayDefault(values: [Double] = [1.5, 2.5, 3.5]) -> [Double]
@JS public func testBoolArrayDefault(flags: [Bool] = [true, false, true]) -> [Bool]
@JS public func testEmptyArrayDefault(items: [Int] = []) -> [Int]
@JS public func testMixedWithArrayDefault(
    name: String = "test",
    values: [Int] = [10, 20, 30],
    enabled: Bool = true
) -> String
