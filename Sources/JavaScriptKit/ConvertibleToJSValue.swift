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
