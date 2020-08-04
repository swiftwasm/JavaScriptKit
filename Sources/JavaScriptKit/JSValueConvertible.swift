import _CJavaScriptKit

public protocol JSValueConvertible {
    subscript(jsValue _: ()) -> JSValue { get }
}

extension JSValue: JSValueConvertible {
    public init(from convertible: JSValueConvertible) {
        self = convertible[jsValue: ()]
    }
    public subscript(jsValue _: ()) -> JSValue { self }
}

extension Bool: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .boolean(self) }
}

extension Int: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension Int8: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension Int16: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension Int32: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension UInt: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension UInt8: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension UInt16: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension Float: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(Double(self)) }
}

extension Double: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .number(self) }
}

extension String: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue { .string(self) }
}

extension JSObjectRef: JSValueConvertible {
    // `JSObjectRef.jsValue` is defined in JSObjectRef.swift to be able to overridden
    // from `JSFunctionRef`
}

private let Object = JSObjectRef.global.Object.function!

extension Dictionary where Value: JSValueConvertible, Key == String {
    public subscript(jsValue _: ()) -> JSValue {
        JSValue(from: self as Dictionary<Key, JSValueConvertible>)
    }
}

extension Dictionary: JSValueConvertible where Value == JSValueConvertible, Key == String {
    public subscript(jsValue _: ()) -> JSValue {
        let object = Object.new()
        for (key, value) in self {
            object[key] = JSValue(from: value)
        }
        return .object(object)
    }
}

private let Array = JSObjectRef.global.Array.function!

extension Array where Element: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue {
        JSValue(from: self as Swift.Array<JSValueConvertible>)
    }
}

extension Array: JSValueConvertible where Element == JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue {
        let array = Array.new(count)
        for (index, element) in enumerated() {
            array[index] = JSValue(from: element)
        }
        return .object(array)
    }
}

extension RawJSValue: JSValueConvertible {
    public subscript(jsValue _: ()) -> JSValue {
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
            return .object(JSObjectRef(id: UInt32(payload1)))
        case .null:
            return .null
        case .undefined:
            return .undefined
        case .function:
            return .function(JSFunctionRef(id: UInt32(payload1)))
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
            return JSValue(from: values[index]).withRawJSValue { (rawValue) -> T in
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
