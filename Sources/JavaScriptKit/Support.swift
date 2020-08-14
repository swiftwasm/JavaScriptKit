protocol _AnyJSValueCodable: JSValueConvertible {}

public struct AnyJSValueCodable: JSValueCodable, ExpressibleByNilLiteral {
    public static let void = AnyJSValueCodable.construct(from: .undefined)

    private struct Box<T: JSValueConvertible>: _AnyJSValueCodable {
        let value: T

        func jsValue() -> JSValue {
            value.jsValue()
        }
    }

    private struct ConcreteBox: _AnyJSValueCodable {
        let value: JSValue

        func jsValue() -> JSValue {
            return value
        }
    }

    private let value: _AnyJSValueCodable

    public init<T>(_ value: T) where T: JSValueConvertible {
        self.value = Box(value: value)
    }
    private init(boxed value: _AnyJSValueCodable) {
        self.value = value
    }

    public static func construct(from value: JSValue) -> AnyJSValueCodable? {
        self.init(boxed: ConcreteBox(value: value))
    }

    public init(nilLiteral _: ()) {
        value = ConcreteBox(value: .null)
    }

    public func jsValue() -> JSValue {
        value.jsValue()
    }

    public func fromJSValue<Type: JSValueConstructible>() -> Type? {
        self.jsValue().fromJSValue()
    }
}

public func staticCast<Type: JSBridgedType>(_ ref: JSBridgedType) -> Type? {
    return Type(from: ref.value)
}

public func dynamicCast<Type: JSBridgedClass>(_ ref: JSBridgedClass) -> Type? {
    guard ref.objectRef.isInstanceOf(Type.classRef) else {
        return nil
    }
    return staticCast(ref)
}
