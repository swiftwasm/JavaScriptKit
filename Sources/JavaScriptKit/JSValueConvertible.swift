import _CJavaScriptKit

public protocol JSValueConvertible {
    static func jsValue(from: Self) -> JSValue
}

extension JSValue {
    public init<T: JSValueConvertible>(from jsValue: T) {
        self = T.jsValue(from: jsValue)
    }
}

extension JSValue: JSValueConvertible {
    public static func jsValue(from jsValue: Self) -> JSValue { jsValue }
}

extension Bool: JSValueConvertible {
    public static func jsValue(from bool: Self) -> JSValue { .boolean(bool) }
}

extension Int: JSValueConvertible {
    public static func jsValue(from int: Self) -> JSValue { .number(Double(int)) }
}

extension Int8: JSValueConvertible {
    public static func jsValue(from int8: Self) -> JSValue { .number(Double(int8)) }
}

extension Int16: JSValueConvertible {
    public static func jsValue(from int16: Self) -> JSValue { .number(Double(int16)) }
}

extension Int32: JSValueConvertible {
    public static func jsValue(from int32: Self) -> JSValue { .number(Double(int32)) }
}

extension UInt: JSValueConvertible {
    public static func jsValue(from uint: Self) -> JSValue { .number(Double(uint)) }
}

extension UInt8: JSValueConvertible {
    public static func jsValue(from uint8: Self) -> JSValue { .number(Double(uint8)) }
}

extension UInt16: JSValueConvertible {
    public static func jsValue(from uint16: Self) -> JSValue { .number(Double(uint16)) }
}

extension Float: JSValueConvertible {
    public static func jsValue(from float: Self) -> JSValue { .number(Double(float)) }
}

extension Double: JSValueConvertible {
    public static func jsValue(from double: Self) -> JSValue { .number(double) }
}

extension String: JSValueConvertible {
    public static func jsValue(from string: Self) -> JSValue { .string(string) }
}

extension JSObjectRef: JSValueConvertible {
    // `JSObjectRef.jsValue` is defined in JSObjectRef.swift to be able to overridden
    // from `JSFunctionRef`
}

private let Object = JSObjectRef.global.Object.function!

extension Dictionary: JSValueConvertible where Value: JSValueConvertible, Key == String {
    public static func jsValue(from dict: Self) -> JSValue {
        let object = Object.new()
        for (key, value) in dict {
            object[key] = JSValue(from: value)
        }
        return .object(object)
    }
}

private let Array = JSObjectRef.global.Array.function!

extension Array: JSValueConvertible where Element: JSValueConvertible {
    public static func jsValue(from array: Self) -> JSValue {
        let jsArray = Array.new(array.count)
        for (index, element) in array.enumerated() {
            jsArray[index] = JSValue(from: element)
        }
        return .object(jsArray)
    }
}

extension RawJSValue: JSValueConvertible {
    public static func jsValue(from rawJSValue: Self) -> JSValue {
        switch rawJSValue.kind {
        case .invalid:
            fatalError()
        case .boolean:
            return .boolean(rawJSValue.payload1 != 0)
        case .number:
            return .number(rawJSValue.payload3)
        case .string:
            // +1 for null terminator
            let buffer = malloc(Int(rawJSValue.payload2 + 1))!.assumingMemoryBound(to: UInt8.self)
            defer { free(buffer) }
            _load_string(JavaScriptObjectRef(rawJSValue.payload1), buffer)
            buffer[Int(rawJSValue.payload2)] = 0
            let string = String(decodingCString: UnsafePointer(buffer), as: UTF8.self)
            return .string(string)
        case .object:
            return .object(JSObjectRef(id: UInt32(rawJSValue.payload1)))
        case .null:
            return .null
        case .undefined:
            return .undefined
        case .function:
            return .function(JSFunctionRef(id: UInt32(rawJSValue.payload1)))
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
