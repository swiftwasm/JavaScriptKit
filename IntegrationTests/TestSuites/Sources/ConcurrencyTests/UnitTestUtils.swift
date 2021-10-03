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
}

func asyncTest(_ name: String, testBlock: () async throws -> Void) async throws -> Void {
    if printTestNames { print(name) }
    do {
        try await testBlock()
    } catch {
        print("Error in \(name)")
        print(error)
        throw error
    }
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

func expectCast<T, U>(
    _ value: T, to type: U.Type = U.self,
    file: StaticString = #file, line: UInt = #line, column: UInt = #column
) throws -> U {
    guard let value = value as? U else {
        throw MessageError("Expect \"\(value)\" to be \(U.self)", file: file, line: line, column: column)
    }
    return value
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

func expectAsyncThrow<T>(_ body: @autoclosure () async throws -> T, file: StaticString = #file, line: UInt = #line, column: UInt = #column) async throws -> Error {
    do {
        _ = try await body()
    } catch {
        return error
    }
    throw MessageError("Expect to throw an exception", file: file, line: line, column: column)
}

func expectNotNil<T>(_ value: T?, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws {
    switch value {
    case .some: return
    case .none:
        throw MessageError("Expect a non-nil value", file: file, line: line, column: column)
    }
}
