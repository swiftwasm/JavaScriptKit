protocol _AnyJSValueConvertible: JSValueConvertible {}

public struct AnyJSValueConvertible: JSValueCodable, ExpressibleByNilLiteral {
    public static let void = AnyJSValueConvertible.construct(from: .undefined)

    private struct Box<T: JSValueConvertible>: _AnyJSValueConvertible {
        let value: T

        func jsValue() -> JSValue {
            value.jsValue()
        }
    }

    private struct ConcreteBox: _AnyJSValueConvertible {
        let value: JSValue

        func jsValue() -> JSValue {
            return value
        }
    }

    private let value: _AnyJSValueConvertible

    public init<T>(_ value: T) where T: JSValueConvertible {
        self.value = Box(value: value)
    }
    private init(boxed value: _AnyJSValueConvertible) {
        self.value = value
    }

    public static func construct(from value: JSValue) -> AnyJSValueConvertible? {
        self.init(boxed: ConcreteBox(value: value))
    }

    public init(nilLiteral _: ()) {
        value = ConcreteBox(value: .null)
    }

    public func jsValue() -> JSValue {
        value.jsValue()
    }
}
