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
    static var classRef: JSFunction { get }
    var objectRef: JSObject { get }
    init(withCompatibleObject objectRef: JSObject)
}

extension JSBridgedClass {
    public var value: JSValue { objectRef.jsValue() }
    public init?(from value: JSValue) {
        guard let object = value.object, object.isInstanceOf(Self.classRef) else { return nil }
        self.init(withCompatibleObject: object)
    }
}
