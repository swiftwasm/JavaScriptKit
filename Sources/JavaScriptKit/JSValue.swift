import _CJavaScriptKit

public enum JSValue: Equatable {
    
    case boolean(Bool)
    case string(String)
    case number(Double)
    case object(JSObjectRef)
    case null
    case undefined
    case function(JSFunctionRef)
}

// MARK: - Accessors

public extension JSValue {
    
    var boolean: Bool? {
        switch self {
        case let .boolean(boolean): return boolean
        default: return nil
        }
    }

    var string: String? {
        switch self {
        case let .string(string): return string
        default: return nil
        }
    }
    var number: Double? {
        switch self {
        case let .number(number): return number
        default: return nil
        }
    }
    var object: JSObjectRef? {
        switch self {
        case let .object(object): return object
        default: return nil
        }
    }
    var array: JSArrayRef? {
        object.flatMap { JSArrayRef($0) }
    }
    var isNull: Bool { return self == .null }
    var isUndefined: Bool { return self == .undefined }
    var function: JSFunctionRef? {
        switch self {
        case let .function(function): return function
        default: return nil
        }
    }
}


extension JSValue {
    public static func function(_ body: @escaping ([JSValue]) -> JSValue) -> JSValue {
        .function(JSFunctionRef.from(body))
    }
}

// MARK: - ExpressibleByStringLiteral

extension JSValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension JSValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(value)
    }
}

// MARK: - Functions

internal func getJSValue(this: JSObjectRef, name: String) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, name, Int32(name.count),
                  &rawValue.kind,
                  &rawValue.payload1, &rawValue.payload2, &rawValue.payload3)
    return rawValue.jsValue()
}

internal func setJSValue(this: JSObjectRef, name: String, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, name, Int32(name.count), rawValue.kind, rawValue.payload1, rawValue.payload2, rawValue.payload3)
    }
}

internal func getJSValue(this: JSObjectRef, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this.id, index,
                   &rawValue.kind,
                   &rawValue.payload1, &rawValue.payload2, &rawValue.payload3)
    return rawValue.jsValue()
}


internal func setJSValue(this: JSObjectRef, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this.id, index,
                       rawValue.kind,
                       rawValue.payload1, rawValue.payload2, rawValue.payload3)
    }
}

