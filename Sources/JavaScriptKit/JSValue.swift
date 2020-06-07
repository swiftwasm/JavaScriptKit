import _CJavaScriptKit

public enum JSValue: Equatable {
    case boolean(Bool)
    case string(String)
    case number(Double)
    case object(JSObjectRef)
    case null
    case undefined
    case function(JSFunctionRef)

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
    public var object: JSObjectRef? {
        switch self {
        case let .object(object): return object
        default: return nil
        }
    }
    public var isNull: Bool { return self == .null }
    public var isUndefined: Bool { return self == .undefined }
    public var function: JSFunctionRef? {
        switch self {
        case let .function(function): return function
        default: return nil
        }
    }
}

extension JSValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int32) {
        self = .number(value)
    }
}

public func getJSValue(this: JSObjectRef, name: String) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this._id, name, Int32(name.count), &rawValue)
    return rawValue.jsValue()
}

public func setJSValue(this: JSObjectRef, name: String, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this._id, name, Int32(name.count), &rawValue)
    }
}

public func getJSValue(this: JSObjectRef, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this._id, index, &rawValue)
    return rawValue.jsValue()
}


public func setJSValue(this: JSObjectRef, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this._id, index, &rawValue)
    }
}
    }
}

