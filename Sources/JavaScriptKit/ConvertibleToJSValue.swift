import _CJavaScriptKit

/// Objects that can be converted to a JavaScript value, preferably in a lossless manner.
public protocol ConvertibleToJSValue {
    /// Create a JSValue that represents this object
    var jsValue: JSValue { get }
}

extension RawJSValue: ConvertibleToJSValue {
    public var jsValue: JSValue {
        switch kind {
        case .boolean:
            return .boolean(payload1 != 0)
        case .number:
            return .number(payload2)
        case .string:
            return .string
        case .object:
            return .object
        case .null:
            return .null
        case .undefined:
            return .undefined
        }
    }
}

extension JSValue {
    func withRawJSValue<T>(_ body: (RawJSValue) -> T) -> T {
        body(convertToRawJSValue())
    }

    fileprivate func convertToRawJSValue() -> RawJSValue {
        let kind: JavaScriptValueKind
        let payload1: JavaScriptPayload1
        var payload2: JavaScriptPayload2 = 0
        switch self {
        case .boolean(let boolValue):
            kind = .boolean
            payload1 = boolValue ? 1 : 0
        case .number(let numberValue):
            kind = .number
            payload1 = 0
            payload2 = numberValue
        case .string:
            kind = .string
            payload1 = 0
            payload2 = 0
        case .object:
            kind = .object
            payload1 = 0
        case .null:
            kind = .null
            payload1 = 0
        case .undefined:
            kind = .undefined
            payload1 = 0
        }
        return RawJSValue(kind: kind, payload1: payload1, payload2: payload2)
    }
}
