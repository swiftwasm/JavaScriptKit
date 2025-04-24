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
    public var jsValue: JSValue { .string(JSString(self)) }
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
    public var jsValue: JSValue { .string(self) }
}

extension JSObject: JSValueCompatible {
    // `JSObject.jsValue` is defined in JSObject.swift to be able to overridden
    // from `JSFunction`
}

private let _objectConstructor = LazyThreadLocal(initialize: { JSObject.global.Object.function! })
private var objectConstructor: JSFunction { _objectConstructor.wrappedValue }
private let _arrayConstructor = LazyThreadLocal(initialize: { JSObject.global.Array.function! })
private var arrayConstructor: JSFunction { _arrayConstructor.wrappedValue }

#if !hasFeature(Embedded)
extension Dictionary where Value == ConvertibleToJSValue, Key == String {
    public var jsValue: JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue
        }
        return .object(object)
    }
}
#endif

extension Dictionary: ConvertibleToJSValue where Value: ConvertibleToJSValue, Key == String {
    public var jsValue: JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue
        }
        return .object(object)
    }
}

extension Dictionary: ConstructibleFromJSValue where Value: ConstructibleFromJSValue, Key == String {
    public static func construct(from value: JSValue) -> Self? {
        guard
            let objectRef = value.object,
            let keys: [String] = objectConstructor.keys!(objectRef.jsValue).fromJSValue()
        else { return nil }

        var entries = [(String, Value)]()
        entries.reserveCapacity(keys.count)
        for key in keys {
            guard let value: Value = objectRef[key].fromJSValue() else {
                return nil
            }
            entries.append((key, value))
        }
        return Dictionary(uniqueKeysWithValues: entries)
    }
}

extension Optional: ConstructibleFromJSValue where Wrapped: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        switch value {
        case .null, .undefined:
            return .some(nil)
        default:
            guard let wrapped = Wrapped.construct(from: value) else { return nil }
            return .some(wrapped)
        }
    }
}

extension Optional: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    public var jsValue: JSValue {
        switch self {
        case .none: return .null
        case .some(let wrapped): return wrapped.jsValue
        }
    }
}

extension Array: ConvertibleToJSValue where Element: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let array = arrayConstructor.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue
        }
        return .object(array)
    }
}

#if !hasFeature(Embedded)
extension Array where Element == ConvertibleToJSValue {
    public var jsValue: JSValue {
        let array = arrayConstructor.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue
        }
        return .object(array)
    }
}
#endif

extension Array: ConstructibleFromJSValue where Element: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> [Element]? {
        guard
            let objectRef = value.object,
            objectRef.isInstanceOf(JSObject.global.Array.function!)
        else { return nil }

        let count: Int = objectRef.length.fromJSValue()!
        var array = [Element]()
        array.reserveCapacity(count)

        for i in 0..<count {
            guard let value: Element = objectRef[i].fromJSValue() else { return nil }
            array.append(value)
        }

        return array
    }
}

extension RawJSValue: ConvertibleToJSValue {
    public var jsValue: JSValue {
        switch kind {
        case .boolean:
            return .boolean(payload1 != 0)
        case .number:
            return .number(payload2)
        case .string:
            return .string(JSString(jsRef: payload1))
        case .object:
            return .object(JSObject(id: UInt32(payload1)))
        case .null:
            return .null
        case .undefined:
            return .undefined
        case .function:
            return .function(JSFunction(id: UInt32(payload1)))
        case .symbol:
            return .symbol(JSSymbol(id: UInt32(payload1)))
        case .bigInt:
            return .bigInt(JSBigInt(id: UInt32(payload1)))
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
        case .string(let string):
            kind = .string
            payload1 = string.asInternalJSRef()
            payload2 = 0
        case .object(let ref):
            kind = .object
            payload1 = JavaScriptPayload1(ref.id)
        case .null:
            kind = .null
            payload1 = 0
        case .undefined:
            kind = .undefined
            payload1 = 0
        case .function(let functionRef):
            kind = .function
            payload1 = JavaScriptPayload1(functionRef.id)
        case .symbol(let symbolRef):
            kind = .symbol
            payload1 = JavaScriptPayload1(symbolRef.id)
        case .bigInt(let bigIntRef):
            kind = .bigInt
            payload1 = JavaScriptPayload1(bigIntRef.id)
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
