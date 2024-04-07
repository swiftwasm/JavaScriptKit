import JavaScriptKit

var printTestNames = false
// Uncomment the next line to print the name of each test suite before running it.
// This will make it easier to debug any errors that occur on the JS side.
//printTestNames = true

func test(_ name: String, testBlock: () throws -> Void) throws {
    if printTestNames { print(name) }
    do {
        try testBlock()
    } catch {
        print("Error in \(name)")
        print(error)
        throw error
    }
    print("✅ \(name)")
}

struct MessageError: Error {
    let message: String
    let file: StaticString
    let line: UInt
    let column: UInt
    init(_ message: String, file: StaticString, line: UInt, column: UInt) {
        self.message = message
        self.file = file
        self.line = line
        self.column = column
    }
}

func expectEqual<T: Equatable>(
    _ lhs: T, _ rhs: T,
    file: StaticString = #file, line: UInt = #line, column: UInt = #column
) throws {
    if lhs != rhs {
        throw MessageError("Expect to be equal \"\(lhs)\" and \"\(rhs)\"", file: file, line: line, column: column)
    }
}

func expectNotEqual<T: Equatable>(
    _ lhs: T, _ rhs: T,
    file: StaticString = #file, line: UInt = #line, column: UInt = #column
) throws {
    if lhs == rhs {
        throw MessageError("Expect to not be equal \"\(lhs)\" and \"\(rhs)\"", file: file, line: line, column: column)
    }
}

func expectObject(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSObject {
    switch value {
    case let .object(ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"object\"", file: file, line: line, column: column)
    }
}

func expectArray(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSArray {
    guard let array = value.array else {
        throw MessageError("Type of \(value) should be \"object\"", file: file, line: line, column: column)
    }
    return array
}

func expectFunction(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSFunction {
    switch value {
    case let .function(ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"function\"", file: file, line: line, column: column)
    }
}

func expectBoolean(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Bool {
    switch value {
    case let .boolean(bool): return bool
    default:
        throw MessageError("Type of \(value) should be \"boolean\"", file: file, line: line, column: column)
    }
}

func expectNumber(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Double {
    switch value {
    case let .number(number): return number
    default:
        throw MessageError("Type of \(value) should be \"number\"", file: file, line: line, column: column)
    }
}

func expectString(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> String {
    switch value {
    case let .string(string): return String(string)
    default:
        throw MessageError("Type of \(value) should be \"string\"", file: file, line: line, column: column)
    }
}

func expect(_ description: String, _ result: Bool, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws {
    if !result {
        throw MessageError(description, file: file, line: line, column: column)
    }
}

func expectThrow<T>(_ body: @autoclosure () throws -> T, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Error {
    do {
        _ = try body()
    } catch {
        return error
    }
    throw MessageError("Expect to throw an exception", file: file, line: line, column: column)
}

func wrapUnsafeThrowableFunction(_ body: @escaping () -> Void, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Error {
    JSObject.global.callThrowingClosure.function!(JSClosure { _ in 
            body() 
            return .undefined
    })
}
func expectNotNil<T>(_ value: T?, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws {
    switch value {
    case .some: return
    case .none:
        throw MessageError("Expect a non-nil value", file: file, line: line, column: column)
    }
}

class Expectation {
    private(set) var isFulfilled: Bool = false
    private let label: String
    private let expectedFulfillmentCount: Int
    private var fulfillmentCount: Int = 0

    init(label: String, expectedFulfillmentCount: Int = 1) {
        self.label = label
        self.expectedFulfillmentCount = expectedFulfillmentCount
    }

    func fulfill() {
        assert(!isFulfilled, "Too many fulfillment (label: \(label)): expectedFulfillmentCount is \(expectedFulfillmentCount)")
        fulfillmentCount += 1
        if fulfillmentCount == expectedFulfillmentCount {
            isFulfilled = true
        }
    }

    static func wait(_ expectations: [Expectation]) {
        var timer: JSTimer!
        timer = JSTimer(millisecondsDelay: 5.0, isRepeating: true) {
            guard expectations.allSatisfy(\.isFulfilled) else { return }
            assert(timer != nil)
            timer = nil
        }
    }
}
