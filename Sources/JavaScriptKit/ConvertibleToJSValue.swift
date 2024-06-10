import _CJavaScriptKit
#if hasFeature(Embedded)
import String16
#endif

/// Objects that can be converted to a JavaScript value, preferably in a lossless manner.
public protocol ConvertibleToJSValue {
    /// Create a JSValue that represents this object
    var jsValue: JSValue { get }
}

#if !hasFeature(Embedded)
extension ConvertibleToJSValue {
    @available(*, deprecated, message: "Use the .jsValue property instead")
    public func jsValue() -> JSValue { jsValue }
}
#endif

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

#if hasFeature(Embedded)
extension String16: ConvertibleToJSValue {
    public var jsValue: JSValue { .string(JSString(self)) }
}
#else
extension String: ConvertibleToJSValue {
    public var jsValue: JSValue { .string(JSString(self)) }
}
#endif

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

private let objectConstructor = JSObject.global.Object.function!
private let arrayConstructor = JSObject.global.Array.function!

#if hasFeature(Embedded)
extension Dictionary where Value == JSValue, Key == String16 {
    public var jsValue: JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue
        }
        return .object(object)
    }
}
#else
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

#if hasFeature(Embedded)
extension Dictionary: ConvertibleToJSValue where Value: ConvertibleToJSValue, Key == String16 {
   public var jsValue: JSValue {
       let object = objectConstructor.new()
       for (key, value) in self {
           object[key] = value.jsValue
       }
       return .object(object)
   }
}
#else
extension Dictionary: ConvertibleToJSValue where Value: ConvertibleToJSValue, Key == String {
    public var jsValue: JSValue {
        let object = objectConstructor.new()
        for (key, value) in self {
            object[key] = value.jsValue
        }
        return .object(object)
    }
}
#endif

#if hasFeature(Embedded)
extension Dictionary: ConstructibleFromJSValue where Value: ConstructibleFromJSValue, Key == String16 {
   public static func construct(from value: JSValue) -> Self? {
       guard
           let objectRef = value.object,
           let keys: [String16] = objectConstructor.keys!(objectRef.jsValue).fromJSValue()
       else { return nil }

       var entries = [(String16, Value)]()
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
#else
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
#endif

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

#if hasFeature(Embedded)
extension Optional: ConvertibleToJSValue where Wrapped == JSValue {
    public var jsValue: JSValue {
        switch self {
        case .none: return .null
        case let .some(wrapped): return wrapped
        }
    }
}
#else
extension Optional: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    public var jsValue: JSValue {
        switch self {
        case .none: return .null
        case let .some(wrapped): return wrapped.jsValue
        }
    }
}
#endif

#if hasFeature(Embedded)
extension Array: ConvertibleToJSValue where Element == JSValue {
    public var jsValue: JSValue {
        let array = arrayConstructor.new(count.jsValue)
        for (index, element) in enumerated() {
            array[index] = element
        }
        return .object(array)
    }
}
#else
extension Array: ConvertibleToJSValue where Element: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let array = arrayConstructor.new(count)
        for (index, element) in enumerated() {
            array[index] = element.jsValue
        }
        return .object(array)
    }
}

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

        for i in 0 ..< count {
            guard let value: Element = objectRef[i].fromJSValue() else { return nil }
            array.append(value)
        }

        return array
    }
}

extension RawJSValue: ConvertibleToJSValue {
    public var jsValue: JSValue {
        #if hasFeature(Embedded)
        switch kind {
        case 0:
            return .boolean(payload1 != 0)
        case 1:
            return .number(payload2)
        case 2:
            return .string(JSString(jsRef: payload1))
        case 3:
            return .object(JSObject(id: UInt32(payload1)))
        case 4:
            return .null
        case 6:
            return .function(JSFunction(id: UInt32(payload1)))
        case 7:
            return .symbol(JSSymbol(id: UInt32(payload1)))
        case 8:
            return .bigInt(JSBigInt(id: UInt32(payload1)))
        default:
            return .undefined
        }
        #else
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
        #endif
    }
}

extension JSValue {
    func withRawJSValue<T>(_ body: (RawJSValue) -> T) -> T {
        #if hasFeature(Embedded)
        let kind: UInt
        #else
        let kind: JavaScriptValueKind
        #endif
        let payload1: JavaScriptPayload1
        var payload2: JavaScriptPayload2 = 0
        switch self {
        case let .boolean(boolValue):
            #if hasFeature(Embedded)
            kind = 0
            #else
            kind = .boolean
            #endif
            payload1 = boolValue ? 1 : 0
        case let .number(numberValue):
            #if hasFeature(Embedded)
            kind = 1
            #else
            kind = .number
            #endif
            payload1 = 0
            payload2 = numberValue
        case let .string(string):
            return string.withRawJSValue(body)
        case let .object(ref):
            #if hasFeature(Embedded)
            kind = 2
            #else
            kind = .object
            #endif
            payload1 = JavaScriptPayload1(ref.id)
        case .null:
            #if hasFeature(Embedded)
            kind = 3
            #else
            kind = .null
            #endif
            payload1 = 0
        case .undefined:
            #if hasFeature(Embedded)
            kind = 4
            #else
            kind = .undefined
            #endif
            payload1 = 0
        case let .function(functionRef):
            #if hasFeature(Embedded)
            kind = 5
            #else
            kind = .function
            #endif
            payload1 = JavaScriptPayload1(functionRef.id)
        case let .symbol(symbolRef):
            #if hasFeature(Embedded)
            kind = 6
            #else
            kind = .symbol
            #endif
            payload1 = JavaScriptPayload1(symbolRef.id)
        case let .bigInt(bigIntRef):
            #if hasFeature(Embedded)
            kind = 7
            #else
            kind = .bigInt
            #endif
            payload1 = JavaScriptPayload1(bigIntRef.id)
        }
        let rawValue = RawJSValue(kind: kind, payload1: payload1, payload2: payload2)
        return body(rawValue)
    }
}

#if hasFeature(Embedded)
extension Array where Element == JSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        // fast path for empty array
        guard self.count != 0 else { return body([]) }

        func _withRawJSValues(
            _ values: [JSValue], _ index: Int,
            _ results: inout [RawJSValue], _ body: ([RawJSValue]) -> T
        ) -> T {
            if index == values.count { return body(results) }
            return values[index].withRawJSValue { (rawValue) -> T in
                results.append(rawValue)
                return _withRawJSValues(values, index + 1, &results, body)
            }
        }
        var _results = [RawJSValue]()
        return _withRawJSValues(self, 0, &_results, body)
    }
}
#else
extension Array where Element == ConvertibleToJSValue {
    func withRawJSValues<T>(_ body: ([RawJSValue]) -> T) -> T {
        // fast path for empty array
        guard self.count != 0 else { return body([]) }

        func _withRawJSValues(
            _ values: [ConvertibleToJSValue], _ index: Int,
            _ results: inout [RawJSValue], _ body: ([RawJSValue]) -> T
        ) -> T {
            if index == values.count { return body(results) }
            return values[index].jsValue.withRawJSValue { (rawValue) -> T in
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
#endif
