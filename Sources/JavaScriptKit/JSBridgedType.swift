#if hasFeature(Embedded)
import String16
#endif

/// Use this protocol when your type has no single JavaScript class.
/// For example, a union type of multiple classes or primitive values.
public protocol JSBridgedType: JSValueCompatible, CustomStringConvertible {
    /// If your class is incompatible with the provided value, return `nil`.
    init?(from value: JSValue)
}

public extension JSBridgedType {
    static func construct(from value: JSValue) -> Self? {
        Self(from: value)
    }
    #if hasFeature(Embedded)
    var description: String16 { jsValue.description }
    #else
    var description: String { jsValue.description }
    #endif
}

/// Conform to this protocol when your Swift class wraps a JavaScript class.
public protocol JSBridgedClass: JSBridgedType {
    /// The constructor function for the JavaScript class
    static var constructor: JSFunction? { get }

    /// The JavaScript object wrapped by this instance.
    /// You may assume that `jsObject instanceof Self.constructor == true`
    var jsObject: JSObject { get }

    /// Create an instance wrapping the given JavaScript object.
    /// You may assume that `jsObject instanceof Self.constructor`
    init(unsafelyWrapping jsObject: JSObject)
}

public extension JSBridgedClass {
    var jsValue: JSValue { jsObject.jsValue }

    init?(from value: JSValue) {
        guard let object = value.object else { return nil }
        self.init(from: object)
    }

    init?(from object: JSObject) {
        guard let constructor = Self.constructor, object.isInstanceOf(constructor) else { return nil }
        self.init(unsafelyWrapping: object)
    }
}
