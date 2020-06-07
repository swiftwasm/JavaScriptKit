
extension UInt8: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = UInt8(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension UInt16: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = UInt16(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension UInt32: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = UInt32(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension UInt64: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = UInt64(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension Int8: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Int8(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension Int16: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Int16(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension Int32: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Int32(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension Int64: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Int64(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

extension Float: JSValueEncodable, JSValueDecodable {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        return jsValue.isNumber
    }

    public init(jsValue: JSValue) {
        switch jsValue {
        case .number(let value):
            self = Float(value)
        default:
            fatalError()
        }
    }

    public func jsValue() -> JSValue {
        return .number(Double(self))
    }
}

protocol _AnyJSValueCodable {

    func jsValue() -> JSValue
}

public struct AnyJSValueCodable: JSValueCodable, ExpressibleByNilLiteral {

    public static func canDecode(from jsValue: JSValue) -> Bool {
        true
    }

    public static let void = AnyJSValueCodable(jsValue: .undefined)

    private struct Box<T: JSValueEncodable>: _AnyJSValueCodable {
        let value: T

        func jsValue() -> JSValue {
            return value.jsValue()
        }
    }

    private struct ConcreteBox: _AnyJSValueCodable {
        let value: JSValue

        func jsValue() -> JSValue {
            return value
        }
    }

    private let value: _AnyJSValueCodable

    public init<T>(_ value: T) where T: JSValueEncodable {
        self.value = Box(value: value)
    }

    public init(jsValue: JSValue) {
        self.value = ConcreteBox(value: jsValue)
    }

    public init(nilLiteral: ()) {
        self.value = ConcreteBox(value: .null)
    }

    public func jsValue() -> JSValue {
        return value.jsValue()
    }

    public func fromJSValue<Type: JSValueDecodable>() -> Type {
        return jsValue().fromJSValue()
    }
}


public func staticCast<Type: JSBridgedType>(_ ref: JSBridgedType) -> Type {

    return Type(objectRef: ref.objectRef)
}

public func dynamicCast<Type: JSBridgedType>(_ ref: JSBridgedType) -> Type? {

    guard ref.objectRef.instanceOf(String(describing: Type.self)) else {
        return nil
    }
    return staticCast(ref)
}
