/// Use this protocol when your type has no single JavaScript class.
/// For example, a union type of multiple classes or primitive values.
public protocol JSBridgedType: JSValueCompatible, CustomStringConvertible {
    /// If your class is incompatible with the provided value, return `nil`.
    init?(from value: JSValue)
}

extension JSBridgedType {
    public static func construct(from value: JSValue) -> Self? {
        Self(from: value)
    }

    public var description: String { jsValue.description }
}

/// A protocol that Swift classes that are exposed to JavaScript via `@JS class` conform to.
///
/// The conformance is automatically synthesized by the BridgeJS code generator.
public protocol _JSBridgedClass {
    /// The JavaScript object wrapped by this instance.
    /// You may assume that `jsObject instanceof Self.constructor == true`
    var jsObject: JSObject { get }

    /// Create an instance wrapping the given JavaScript object.
    /// You may assume that `jsObject instanceof Self.constructor`
    init(unsafelyWrapping jsObject: JSObject)
}

/// Conform to this protocol when your Swift class wraps a JavaScript class.
public protocol JSBridgedClass: JSBridgedType, _JSBridgedClass {
    /// The constructor function for the JavaScript class
    static var constructor: JSFunction? { get }

    /// The JavaScript object wrapped by this instance.
    /// You may assume that `jsObject instanceof Self.constructor == true`
    var jsObject: JSObject { get }

    /// Create an instance wrapping the given JavaScript object.
    /// You may assume that `jsObject instanceof Self.constructor`
    init(unsafelyWrapping jsObject: JSObject)
}

extension JSBridgedClass {
    public var jsValue: JSValue { jsObject.jsValue }

    public init?(from value: JSValue) {
        guard let object = value.object else { return nil }
        self.init(from: object)
    }

    public init?(from object: JSObject) {
        guard let constructor = Self.constructor, object.isInstanceOf(constructor) else { return nil }
        self.init(unsafelyWrapping: object)
    }
}
