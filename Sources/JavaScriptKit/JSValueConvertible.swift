import _CJavaScriptKit

public protocol JSValueConvertible {
    func jsValue() -> JSValue
}

extension JSValue: JSValueConvertible {
    public func jsValue() -> JSValue { self }
}

extension Bool: JSValueConvertible {
    public func jsValue() -> JSValue { .boolean(self) }
}

extension Int: JSValueConvertible {
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

extension UInt: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
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

extension Float: JSValueConvertible {
    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Double: JSValueConvertible {
    public func jsValue() -> JSValue { .number(self) }
}

extension String: JSValueConvertible {
    public func jsValue() -> JSValue { .string(self) }
}

extension JSObject: JSValueConvertible {
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

private let Array = JSObject.global.Array.function!

extension Array where Element: JSValueConvertible {
    public func jsValue() -> JSValue {
        Swift.Array<JSValueConvertible>.jsValue(self)()
    }
}

extension Array: JSValueConvertible where Element == JSValueConvertible {
    public func jsValue() -> JSValue {
        let array = Array.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue()
        }
        return .object(array)
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
        Swift.Array<JSValueConvertible>.withRawJSValues(self)(body)
    }
}
