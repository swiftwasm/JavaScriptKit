import JavaScriptKit

struct MessageError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

func expectEqual<T: Equatable>(_ lhs: T, _ rhs: T) throws {
    if lhs != rhs {
        throw MessageError("Expect to be equal \"\(lhs)\" and \"\(rhs)\"")
    }
}

func expectObject(_ value: JSValue) throws -> JSObjectRef {
    switch value {
    case .object(let ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"object\"")
    }
}

func expectFunction(_ value: JSValue) throws -> JSFunctionRef {
    switch value {
    case .function(let ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"function\"")
    }
}

func expectBoolean(_ value: JSValue) throws -> Bool {
    switch value {
    case .boolean(let bool): return bool
    default:
        throw MessageError("Type of \(value) should be \"boolean\"")
    }
}

func expectNumber(_ value: JSValue) throws -> Int32 {
    switch value {
    case .number(let number): return number
    default:
        throw MessageError("Type of \(value) should be \"number\"")
    }
}

func expectString(_ value: JSValue) throws -> String {
    switch value {
    case .string(let string): return string
    default:
        throw MessageError("Type of \(value) should be \"string\"")
    }
}
