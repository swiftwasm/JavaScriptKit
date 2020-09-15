// Use this protocol when your type has no single JavaScript class.
// For example, a union type of multiple classes.
public protocol JSBridgedType: JSValueCodable, CustomStringConvertible {
    var value: JSValue { get }
    init?(from value: JSValue)
}

extension JSBridgedType {
    public static func construct(from value: JSValue) -> Self? {
        return Self.init(from: value)
    }

    public func jsValue() -> JSValue { value }

    public var description: String { value.description }
}


public protocol JSBridgedClass: JSBridgedType {
    static var constructor: JSFunction { get }
    var jsObject: JSObject { get }
    init(withCompatibleObject jsObject: JSObject)
}

extension JSBridgedClass {
    public var value: JSValue { jsObject.jsValue() }
    public init?(from value: JSValue) {
        guard let object = value.object, object.isInstanceOf(Self.constructor) else { return nil }
        self.init(withCompatibleObject: object)
    }
}
