// Use this protocol when your type has no single JavaScript class.
// For example, a union type of multiple classes.
public protocol JSBridgedType: JSValueCodable, CustomStringConvertible {
    var objectRef: JSObject { get }
    init?(objectRef: JSObject)
}

extension JSBridgedType {
    public static func construct(from value: JSValue) -> Self? {
        guard let object = value.object else { return nil }
        return Self.init(objectRef: object)
    }

    public func jsValue() -> JSValue {
        .object(objectRef)
    }

    public var description: String {
        return objectRef.toString!().fromJSValue()!
    }
}


public protocol JSBridgedClass: JSBridgedType {
    static var classRef: JSFunction { get }
    init(withCompatibleObject objectRef: JSObject)
}

extension JSBridgedClass {
    public init?(objectRef: JSObject) {
        guard objectRef.isInstanceOf(Self.classRef) else { return nil }
        self.init(withCompatibleObject: objectRef)
    }
}

public func staticCast<Type: JSBridgedType>(_ ref: JSBridgedType) -> Type? {
    return Type(objectRef: ref.objectRef)
}

public func dynamicCast<Type: JSBridgedClass>(_ ref: JSBridgedClass) -> Type? {
    guard ref.objectRef.isInstanceOf(Type.classRef) else {
        return nil
    }
    return staticCast(ref)
}
