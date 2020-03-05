import _CJavaScriptKit

public enum JSValue: Equatable {
    case boolean(Bool)
    case string(String)
    case number(Int32)
    case object(JSObjectRef)
    case null
    case undefined
    case function(JSFunctionRef)

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
    var number: Int32? {
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
    var isNull: Bool { return self == .null }
    var isUndefined: Bool { return self == .undefined }
    var function: JSFunctionRef? {
        switch self {
        case let .function(function): return function
        default: return nil
        }
    }
}

public func getJSValue(this: JSObjectRef, name: String) -> JSValue {
    var rawValue = RawJSValue()
    _get_prop(this.id, name, Int32(name.count),
                  &rawValue.kind,
                  &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue()
}

public func setJSValue(this: JSObjectRef, name: String, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_prop(this.id, name, Int32(name.count), rawValue.kind, rawValue.payload1, rawValue.payload2)
    }
}


public func getJSValue(this: JSObjectRef, index: Int32) -> JSValue {
    var rawValue = RawJSValue()
    _get_subscript(this.id, index,
                   &rawValue.kind,
                   &rawValue.payload1, &rawValue.payload2)
    return rawValue.jsValue()
}


public func setJSValue(this: JSObjectRef, index: Int32, value: JSValue) {
    value.withRawJSValue { rawValue in
        _set_subscript(this.id, index,
                       rawValue.kind,
                       rawValue.payload1, rawValue.payload2)
    }
}

