import JavaScriptKit

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

func expectObject(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSObjectRef {
    switch value {
    case .object(let ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"object\"", file: file, line: line, column: column)
    }
}

func expectArray(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSArrayRef {
    guard let array = value.array else {
        throw MessageError("Type of \(value) should be \"object\"", file: file, line: line, column: column)
    }
    return array
}

func expectFunction(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> JSFunctionRef {
    switch value {
    case .function(let ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"function\"", file: file, line: line, column: column)
    }
}

func expectBoolean(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Bool {
    switch value {
    case .boolean(let bool): return bool
    default:
        throw MessageError("Type of \(value) should be \"boolean\"", file: file, line: line, column: column)
    }
}

func expectNumber(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> Double {
    switch value {
    case .number(let number): return number
    default:
        throw MessageError("Type of \(value) should be \"number\"", file: file, line: line, column: column)
    }
}

func expectString(_ value: JSValue, file: StaticString = #file, line: UInt = #line, column: UInt = #column) throws -> String {
    switch value {
    case .string(let string): return string
    default:
        throw MessageError("Type of \(value) should be \"string\"", file: file, line: line, column: column)
    }
}
