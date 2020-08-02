import _CJavaScriptKit


public protocol JSBridgedType: JSValueCodable, CustomStringConvertible {
    var objectRef: JSObjectRef { get }
    init(objectRef: JSObjectRef)
}

public protocol JSValueEncodable {
    func jsValue() -> JSValue
}

public protocol JSValueDecodable {
    init(jsValue: JSValue)

    static func canDecode(from jsValue: JSValue) -> Bool
}

extension JSBridgedType {

    public var description: String {
        return objectRef.toString!().fromJSValue()
    }
}

public typealias JSValueCodable = JSValueEncodable & JSValueDecodable

extension JSBridgedType {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        jsValue.isObject && jsValue.instanceOf(String(describing: Self.self))
    }

    public init(jsValue: JSValue) {

        self.init(objectRef: jsValue.object!)
    }

    public func jsValue() -> JSValue {
        return JSValue.object(objectRef)
    }
}

extension JSValue: JSValueCodable {

    public static func canDecode(from: JSValue) -> Bool {
        return true
    }

    public init(jsValue: JSValue) {
        self = jsValue
    }

    public func jsValue() -> JSValue { self }
}

extension Bool: JSValueCodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isBoolean
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .boolean(let value):
            self = value
        default:
            fatalError("JSValue \(jsValue) is not decodable to Bool")
        }
    }

    public func jsValue() -> JSValue { .boolean(self) }
}

extension Int: JSValueCodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Int(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue { .number(Double(self)) }
}

extension Double: JSValueCodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = value
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue { .number(self) }
}

extension String: JSValueCodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isString
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .string(let value):
            self = value
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue { .string(self) }
}

extension JSObjectRef: JSValueCodable {

    // `JSObjectRef.jsValue` is defined in JSObjectRef.swift to be able to overridden
    // from `JSFunctionRef`
}

private let Object = JSObjectRef.global.Object.function!

extension Dictionary: JSValueEncodable where Value: JSValueEncodable, Key == String {

    public func jsValue() -> JSValue {
        let object = Object.new()
        for (key, value) in self {
            object.js_set(key, value.jsValue())
        }
        return .object(object)
    }
}

extension Dictionary: JSValueDecodable where Value: JSValueDecodable, Key == String {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isObject
    }

    public init(jsValue: JSValue) {

        let objectRef: JSObjectRef = jsValue.object!

        let keys: [String] = Object.keys!(objectRef.jsValue()).fromJSValue()
        self = Dictionary(uniqueKeysWithValues: keys.map({
            return ($0, objectRef[dynamicMember: $0].fromJSValue())
        }))
    }
}

extension Optional: JSValueDecodable where Wrapped: JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNull || Wrapped.canDecode(from: jsValue)
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .null:
            self = .none
        default:
            self = Wrapped(jsValue: jsValue)
        }
    }
}

extension Optional: JSValueEncodable where Wrapped: JSValueEncodable {

    public func jsValue() -> JSValue {
        switch self {
        case .none: return .null
        case .some(let wrapped): return wrapped.jsValue()
        }
    }
}

private let JSArray = JSObjectRef.global.Array.function!

extension Array: JSValueEncodable where Element: JSValueEncodable {

    public func jsValue() -> JSValue {
        let array = JSArray.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue()
        }
        return .object(array)
    }
}

extension Array: JSValueDecodable where Element: JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isObject
    }

    public init(jsValue: JSValue) {

        let objectRef: JSObjectRef = jsValue.object!
        let count: Int = objectRef.length.fromJSValue()

        self = (0 ..< count).map {
            return objectRef[$0].fromJSValue()
        }
    }
}

extension RawJSValue: JSValueEncodable {

    public func jsValue() -> JSValue {
        switch kind {
        case .invalid:
            fatalError()
        case .boolean:
            return .boolean(payload1 != 0)
        case .number:
            return .number(Double(bitPattern: UInt64(payload1) | (UInt64(payload2) << 32)))
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
    func withRawJSValue<T>(_ body: (inout RawJSValue) -> T) -> T {
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
            payload1 = UInt32(numberValue.bitPattern & 0x00000000ffffffff)
            payload2 = UInt32((numberValue.bitPattern & 0xffffffff00000000) >> 32)
        case var .string(stringValue):
            kind = .string
            return stringValue.withUTF8 { bufferPtr in
                let ptrValue = UInt32(UInt(bitPattern: bufferPtr.baseAddress!))
                var rawValue = RawJSValue(kind: kind, payload1: ptrValue, payload2: JavaScriptPayload(bufferPtr.count))
                return body(&rawValue)
            }
        case let .object(ref):
            kind = .object
            payload1 = ref._id
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
            payload1 = functionRef._id
            payload2 = 0
        }
        var rawValue = RawJSValue(kind: kind, payload1: payload1, payload2: payload2)
        return body(&rawValue)
    }
}

extension Array where Element == JSValueEncodable {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        func _withRawJSValues<T>(
            _ values: [JSValueEncodable], _ index: Int,
            _ results: inout [RawJSValue], _ body: ([RawJSValue]) -> T) -> T {
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

extension Array where Element: JSValueEncodable {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        Swift.Array<JSValueEncodable>.withRawJSValues(self)(body)
    }
}
