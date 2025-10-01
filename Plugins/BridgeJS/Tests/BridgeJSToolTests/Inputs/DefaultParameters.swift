@JS public func testStringDefault(message: String = "Hello World") -> String

@JS public func testIntDefault(count: Int = 42) -> Int

@JS public func testBoolDefault(flag: Bool = true) -> Bool

@JS public func testFloatDefault(value: Float = 3.14) -> Float

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
    @JS init(name: String) {
        self.name = name
    }
}

@JS class EmptyGreeter {
    @JS init() {}
}

@JS public func testComplexInit(greeter: DefaultGreeter = DefaultGreeter(name: "DefaultUser")) -> DefaultGreeter
@JS public func testEmptyInit(greeter: EmptyGreeter = EmptyGreeter()) -> EmptyGreeter
