import _CJavaScriptKit

/// Objects that can be converted to a JavaScript value, preferably in a lossless manner.
public protocol ConvertibleToJSValue {
    /// Create a JSValue that represents this object
    func jsValue() -> JSValue
}

public typealias JSValueCompatible = ConvertibleToJSValue & ConstructibleFromJSValue

extension JSValue: JSValueCompatible {
    public static func construct(from value: JSValue) -> Self? {
        return value
    }

    public func jsValue() -> JSValue { self }
}

extension Bool: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .boolean(self) }
}

extension Int: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Float: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Double: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(self) }
}

extension String: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .string(JSString(self)) }
}

extension UInt8: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt16: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt32: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt64: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int8: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int16: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int32: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int64: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension JSString: ConvertibleToJSValue {
    public func jsValue() -> JSValue { .string(self) }
}

extension JSObject: JSValueCompatible {
    // `JSObject.jsValue` is defined in JSObject.swift to be able to overridden
    // from `JSFunction`
}

private let objectConstructor = JSObject.global.Object.function!
private let arrayConstructor = JSObject.global.Array.function!

extension Dictionary where Value == ConvertibleToJSValue, Key == String {
    public func jsValue() -> JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue()
        }
        return .object(object)
    }
}

extension Dictionary: ConvertibleToJSValue where Value: ConvertibleToJSValue, Key == String {
    public func jsValue() -> JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue()
        }
        return .object(object)
    }
}

extension Dictionary: ConstructibleFromJSValue where Value: ConstructibleFromJSValue, Key == String {
    public static func construct(from value: JSValue) -> Self? {
        guard
            let objectRef = value.object,
            let keys: [String] = objectConstructor.keys!(objectRef.jsValue()).fromJSValue()
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
            return nil
        default:
            return Wrapped.construct(from: value)
        }
    }
}

extension Optional: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    public func jsValue() -> JSValue {
        switch self {
        case .none: return .null
        case let .some(wrapped): return wrapped.jsValue()
        }
    }
}

extension Array: ConvertibleToJSValue where Element: ConvertibleToJSValue {
    public func jsValue() -> JSValue {
        let array = arrayConstructor.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue()
        }
        return .object(array)
    }
}

extension Array where Element == ConvertibleToJSValue {
    public func jsValue() -> JSValue {
        let array = arrayConstructor.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue()
        }
        return .object(array)
    }
}

extension Array: ConstructibleFromJSValue where Element: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> [Element]? {
        guard
            let objectRef = value.object,
            objectRef.isInstanceOf(JSObject.global.Array.function!)
        else { return nil }

        let count: Int = objectRef.length.fromJSValue()!
        var array = [Element]()
        array.reserveCapacity(count)

        for i in 0 ..< count {
            guard let value: Element = objectRef[i].fromJSValue() else { return nil }
            array.append(value)
        }

        return array
    }
}

extension RawJSValue: ConvertibleToJSValue {
    public func jsValue() -> JSValue {
        switch kind {
        case .invalid:
            fatalError()
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
        }
    }
}

extension JSValue {
    func withRawJSValue<T>(_ body: (RawJSValue) -> T) -> T {
        let kind: JavaScriptValueKind
        let payload1: JavaScriptPayload1
        var payload2: JavaScriptPayload2 = 0
        switch self {
        case let .boolean(boolValue):
            kind = .boolean
            payload1 = boolValue ? 1 : 0
        case let .number(numberValue):
            kind = .number
            payload1 = 0
            payload2 = numberValue
        case let .string(string):
            return string.withRawJSValue(body)
        case let .object(ref):
            kind = .object
            payload1 = JavaScriptPayload1(ref.id)
        case .null:
            kind = .null
            payload1 = 0
        case .undefined:
            kind = .undefined
            payload1 = 0
        case let .function(functionRef):
            kind = .function
            payload1 = JavaScriptPayload1(functionRef.id)
        }
        let rawValue = RawJSValue(kind: kind, payload1: payload1, payload2: payload2)
        return body(rawValue)
    }
}

extension Array where Element == ConvertibleToJSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        func _withRawJSValues<T>(
            _ values: [ConvertibleToJSValue], _ index: Int,
            _ results: inout [RawJSValue], _ body: ([RawJSValue]) -> T
        ) -> T {
            if index == values.count { return body(results) }
            return values[index].jsValue().withRawJSValue { (rawValue) -> T in
                results.append(rawValue)
                return _withRawJSValues(values, index + 1, &results, body)
            }
        }
        var _results = [RawJSValue]()
        return _withRawJSValues(self, 0, &_results, body)
    }
}

extension Array where Element: ConvertibleToJSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        [ConvertibleToJSValue].withRawJSValues(self)(body)
    }
}
