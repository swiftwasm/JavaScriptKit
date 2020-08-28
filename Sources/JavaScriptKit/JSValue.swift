import _CJavaScriptKit

public enum JSValue: Equatable {
    case boolean(Bool)
    case string(String)
    case number(Double)
    case object(JSObject)
    case null
    case undefined
    case function(JSFunction)

    public var boolean: Bool? {
        switch self {
        case let .boolean(boolean): return boolean
        default: return nil
        }
    }

    public var string: String? {
        switch self {
        case let .string(string): return string
        default: return nil
        }
    }

    public var number: Double? {
        switch self {
        case let .number(number): return number
        default: return nil
        }
    }

    public var object: JSObject? {
        switch self {
        case let .object(object): return object
        default: return nil
        }
    }

    public var isNull: Bool { return self == .null }
    public var isUndefined: Bool { return self == .undefined }
    public var function: JSFunction? {
        switch self {
        case let .function(function): return function
        default: return nil
        }
    }
}

extension JSValue {
    public static func function(_ body: @escaping ([JSValue]) -> JSValue) -> JSValue {
        .function(JSClosure(body))
    }
}

extension JSValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Double) {
        self = .number(value)
    }
}

public func getJSValue(this: JSObject, name: String) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, name, Int32(name.count),
              &rawValue.kind,
              &rawValue.payload1, &rawValue.payload2, &rawValue.payload3)
    return rawValue.jsValue()
}

public func setJSValue(this: JSObject, name: String, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, name, Int32(name.count), rawValue.kind, rawValue.payload1, rawValue.payload2, rawValue.payload3)
    }
}

public func getJSValue(this: JSObject, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this.id, index,
                   &rawValue.kind,
                   &rawValue.payload1, &rawValue.payload2, &rawValue.payload3)
    return rawValue.jsValue()
}

public func setJSValue(this: JSObject, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this.id, index,
                       rawValue.kind,
                       rawValue.payload1, rawValue.payload2, rawValue.payload3)
    }
}
