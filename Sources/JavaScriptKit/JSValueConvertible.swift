import _CJavaScriptKit

/// Objects that can be converted to a JavaScript value, preferably in a lossless manner.
public protocol JSValueConvertible {
    /// Create a JSValue that represents this object
    func jsValue() -> JSValue
}

public typealias JSValueCodable = JSValueConvertible & JSValueConstructible

extension JSValue: JSValueCodable {
    public static func construct(from value: JSValue) -> Self? {
        return value
    }

    public func jsValue() -> JSValue { self }
}

extension Bool: JSValueConvertible {
    public func jsValue() -> JSValue { .boolean(self) }
}

extension Int: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Float: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Double: JSValueConvertible {
    public func jsValue() -> JSValue { .number(self) }
}

extension String: JSValueConvertible {
    public func jsValue() -> JSValue { .string(self) }
}

extension UInt8: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt16: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt32: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension UInt64: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int8: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int16: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int32: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Int64: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension JSObject: JSValueCodable {
    // `JSObject.jsValue` is defined in JSObject.swift to be able to overridden
    // from `JSFunction`
}

private let Object = JSObject.global.Object.function!

extension Dictionary where Value: JSValueConvertible, Key == String {
    public func jsValue() -> JSValue {
        Swift.Dictionary<Key, JSValueConvertible>.jsValue(self)()
    }
}

extension Dictionary: JSValueConvertible where Value == JSValueConvertible, Key == String {
    public func jsValue() -> JSValue {
        let object = Object.new()
        for (key, value) in self {
            object[key] = value.jsValue()
        }
        return .object(object)
    }
}

private let NativeJSArray = JSObject.global.Array.function!
extension Dictionary: JSValueConstructible where Value: JSValueConstructible, Key == String {
    public static func construct(from value: JSValue) -> Self? {
        guard
            let objectRef = value.object,
            let keys: [String] = Object.keys!(objectRef.jsValue()).fromJSValue()
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

extension Optional: JSValueConstructible where Wrapped: JSValueConstructible {
    public static func construct(from value: JSValue) -> Self? {
        switch value {
        case .null, .undefined:
            return nil
        default:
            return Wrapped.construct(from: value)
        }
    }
}

extension Optional: JSValueConvertible where Wrapped: JSValueConvertible {
    public func jsValue() -> JSValue {
        switch self {
        case .none: return .null
        case let .some(wrapped): return wrapped.jsValue()
        }
    }
}

extension Array where Element: JSValueConvertible {
    public func jsValue() -> JSValue {
        Array<JSValueConvertible>.jsValue(self)()
    }
}

extension Array: JSValueConvertible where Element == JSValueConvertible {
    public func jsValue() -> JSValue {
        let array = NativeJSArray.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue()
        }
        return .object(array)
    }
}

extension Array: JSValueConstructible where Element: JSValueConstructible {
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

extension RawJSValue: JSValueConvertible {
    public func jsValue() -> JSValue {
        switch kind {
        case .invalid:
            fatalError()
        case .boolean:
            return .boolean(payload1 != 0)
        case .number:
            return .number(payload3)
        case .string:
            // +1 for null terminator
            let buffer = malloc(Int(payload2 + 1))!.assumingMemoryBound(to: UInt8.self)
            defer { free(buffer) }
            _load_string(JavaScriptObjectRef(payload1), buffer)
            buffer[Int(payload2)] = 0
            let string = String(decodingCString: UnsafePointer(buffer), as: UTF8.self)
            return .string(string)
        case .object:
            return .object(JSObject(id: UInt32(payload1)))
        case .null:
            return .null
        case .undefined:
            return .undefined
        case .function:
            return .function(JSFunction(id: UInt32(payload1)))
        default:
            fatalError("unreachable")
        }
    }
}

extension JSValue {
    func withRawJSValue<T>(_ body: (RawJSValue) -> T) -> T {
        let kind: JavaScriptValueKind
        let payload1: JavaScriptPayload1
        let payload2: JavaScriptPayload2
        var payload3: JavaScriptPayload3 = 0
        switch self {
        case let .boolean(boolValue):
            kind = .boolean
            payload1 = boolValue ? 1 : 0
            payload2 = 0
        case let .number(numberValue):
            kind = .number
            payload1 = 0
            payload2 = 0
            payload3 = numberValue
        case var .string(stringValue):
            kind = .string
            return stringValue.withUTF8 { bufferPtr in
                let ptrValue = UInt32(UInt(bitPattern: bufferPtr.baseAddress!))
                let rawValue = RawJSValue(kind: kind, payload1: JavaScriptPayload1(ptrValue), payload2: JavaScriptPayload2(bufferPtr.count), payload3: 0)
                return body(rawValue)
            }
        case let .object(ref):
            kind = .object
            payload1 = JavaScriptPayload1(ref.id)
            payload2 = 0
        case .null:
            kind = .null
            payload1 = 0
            payload2 = 0
        case .undefined:
            kind = .undefined
            payload1 = 0
            payload2 = 0
        case let .function(functionRef):
            kind = .function
            payload1 = JavaScriptPayload1(functionRef.id)
            payload2 = 0
        }
        let rawValue = RawJSValue(kind: kind, payload1: payload1, payload2: payload2, payload3: payload3)
        return body(rawValue)
    }
}

extension Array where Element == JSValueConvertible {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        func _withRawJSValues<T>(
            _ values: [JSValueConvertible], _ index: Int,
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

extension Array where Element: JSValueConvertible {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        Array<JSValueConvertible>.withRawJSValues(self)(body)
    }
}
