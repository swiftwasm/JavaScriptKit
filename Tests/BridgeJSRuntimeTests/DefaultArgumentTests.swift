import XCTest
import JavaScriptKit

@JSClass struct DefaultArgumentImports {
    @JSFunction static func runJsDefaultArgumentTests() throws(JSException)
}

final class DefaultArgumentTests: XCTestCase {
    func testRunJsDefaultArgumentTests() throws {
        try DefaultArgumentImports.runJsDefaultArgumentTests()
    }
}

// MARK: - Default Parameters

@JS enum DefaultArgumentExports {
    @JS static func testStringDefault(message: String = "Hello World") -> String {
        return message
    }

    @JS static func testIntDefault(count: Int = 42) -> Int {
        return count
    }

    @JS static func testBoolDefault(flag: Bool = true) -> Bool {
        return flag
    }

    @JS static func testOptionalDefault(name: String? = nil) -> String? {
        return name
    }

    @JS static func testMultipleDefaults(
        title: String = "Default Title",
        count: Int = -10,
        enabled: Bool = false
    ) -> String {
        return "\(title): \(count) (\(enabled))"
    }

    @JS static func testSimpleEnumDefault(status: Status = .success) -> Status {
        return status
    }

    @JS static func testDirectionDefault(direction: Direction = .north) -> Direction {
        return direction
    }

    @JS static func testRawStringEnumDefault(theme: Theme = .light) -> Theme {
        return theme
    }

    @JS static func testComplexInit(greeter: Greeter = Greeter(name: "DefaultGreeter")) -> String {
        return greeter.greet()
    }

    @JS static func testEmptyInit(_ object: StaticPropertyHolder = StaticPropertyHolder()) -> StaticPropertyHolder {
        return object
    }

    @JS static func createConstructorDefaults(
        name: String = "Default",
        count: Int = 42,
        enabled: Bool = true,
        status: Status = .success,
        tag: String? = nil
    ) -> DefaultArgumentConstructorDefaults {
        return DefaultArgumentConstructorDefaults(
            name: name,
            count: count,
            enabled: enabled,
            status: status,
            tag: tag
        )
    }

    @JS static func describeConstructorDefaults(
        _ value: DefaultArgumentConstructorDefaults
    ) -> String {
        return value.describe()
    }

    @JS static func arrayWithDefault(_ values: [Int] = [1, 2, 3]) -> Int {
        return values.reduce(0, +)
    }

    @JS static func arrayWithOptionalDefault(_ values: [Int]? = nil) -> Int {
        return values?.reduce(0, +) ?? -1
    }

    @JS static func arrayMixedDefaults(
        prefix: String = "Sum",
        values: [Int] = [10, 20],
        suffix: String = "!"
    ) -> String {
        return "\(prefix): \(values.reduce(0, +))\(suffix)"
    }
}

@JS class DefaultArgumentConstructorDefaults {
    @JS var name: String
    @JS var count: Int
    @JS var enabled: Bool
    @JS var status: Status
    @JS var tag: String?

    @JS init(
        name: String = "Default",
        count: Int = 42,
        enabled: Bool = true,
        status: Status = .success,
        tag: String? = nil
    ) {
        self.name = name
        self.count = count
        self.enabled = enabled
        self.status = status
        self.tag = tag
    }

    @JS func describe() -> String {
        let tagStr = tag ?? "nil"
        let statusStr: String
        switch status {
        case .loading: statusStr = "loading"
        case .success: statusStr = "success"
        case .error: statusStr = "error"
        }
        return "\(name):\(count):\(enabled):\(statusStr):\(tagStr)"
    }
}
