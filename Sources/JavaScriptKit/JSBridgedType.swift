// Use this protocol when your type has no single JavaScript class.
// For example, a union type of multiple classes.
public protocol JSBridgedType: JSValueCodable, CustomStringConvertible {
    var objectRef: JSObject { get }
    init?(objectRef: JSObject)
    static func canDecode(_ object: JSObject) -> Bool
}

extension JSBridgedType {
    public static func construct(from value: JSValue) -> Self? {
        guard let object = value.object, canDecode(object) else {
            return nil
        }
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
}

extension JSBridgedClass {
    public static func canDecode(from jsValue: JSValue) -> Bool {
        jsValue.isInstanceOf(Self.classRef)
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
