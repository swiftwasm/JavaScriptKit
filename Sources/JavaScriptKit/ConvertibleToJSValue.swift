import _CJavaScriptKit

/// Objects that can be converted to a JavaScript value, preferably in a lossless manner.
public protocol ConvertibleToJSValue {
    /// Create a JSValue that represents this object
    var jsValue: JSValue { get }
}

extension ConvertibleToJSValue {
    @available(*, deprecated, message: "Use the .jsValue property instead")
    public func jsValue() -> JSValue { jsValue }
}

public typealias JSValueCompatible = ConvertibleToJSValue & ConstructibleFromJSValue

extension JSValue: JSValueCompatible {
    public static func construct(from value: JSValue) -> Self? {
        return value
    }

    public var jsValue: JSValue { self }
}

extension Bool: ConvertibleToJSValue {
    public var jsValue: JSValue { .boolean(self) }
}

extension Int: ConvertibleToJSValue {
    public var jsValue: JSValue {
        assert(Self.bitWidth == 32)
        return .number(Double(self))
    }
}

extension UInt: ConvertibleToJSValue {
    public var jsValue: JSValue {
        assert(Self.bitWidth == 32)
        return .number(Double(self))
    }
}

extension Float: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension Double: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(self) }
}

extension String: ConvertibleToJSValue {
    public var jsValue: JSValue { .string }
}

extension UInt8: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension UInt16: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension UInt32: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension Int8: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension Int16: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension Int32: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(Double(self)) }
}

extension JSString: ConvertibleToJSValue {
    public var jsValue: JSValue { .string }
}

extension JSObject: JSValueCompatible {}

private let _objectConstructor = LazyThreadLocal(initialize: { JSObject.global.Object.object! })
private var objectConstructor: JSObject { _objectConstructor.wrappedValue }
private let _arrayConstructor = LazyThreadLocal(initialize: { JSObject.global.Array.object! })
private var arrayConstructor: JSObject { _arrayConstructor.wrappedValue }

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

extension Array where Element: ConvertibleToJSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        let jsValues = map { $0.jsValue }
        // Ensure the jsValues live longer than the temporary raw JS values
        return withExtendedLifetime(jsValues) {
            body(jsValues.map { $0.convertToRawJSValue() })
        }
    }
}

#if !hasFeature(Embedded)
extension Array where Element == ConvertibleToJSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        let jsValues = map { $0.jsValue }
        // Ensure the jsValues live longer than the temporary raw JS values
        return withExtendedLifetime(jsValues) {
            body(jsValues.map { $0.convertToRawJSValue() })
        }
    }
}
#endif
