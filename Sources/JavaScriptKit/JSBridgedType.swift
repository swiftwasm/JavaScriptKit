/// Use this protocol when your type has no single JavaScript class.
/// For example, a union type of multiple classes or primitive values.
public protocol JSBridgedType: JSValueCompatible, CustomStringConvertible {
    /// This is the value your class wraps.
    var value: JSValue { get }

    /// If your class is incompatible with the provided value, return `nil`.
    init?(from value: JSValue)
}

extension JSBridgedType {
    public static func construct(from value: JSValue) -> Self? {
        return Self.init(from: value)
    }

    public func jsValue() -> JSValue { value }

    public var description: String { value.description }
}

/// Conform to this protocol when your Swift class wraps a JavaScript class.
public protocol JSBridgedClass: JSBridgedType {
    /// The constructor function for the JavaScript class
    static var constructor: JSFunction { get }

    /// The JavaScript object wrapped by this instance.
    /// You may assume that `jsObject instanceof Self.constructor == true`
    var jsObject: JSObject { get }

    /// Create an instannce wrapping the given JavaScript object.
    /// You may assume that `jsObject instanceof Self.constructor`
    init(unsafelyWrapping jsObject: JSObject)
}

extension JSBridgedClass {
    public var value: JSValue { jsObject.jsValue() }
    public init?(from value: JSValue) {
        guard let object = value.object, object.isInstanceOf(Self.constructor) else { return nil }
        self.init(unsafelyWrapping: object)
    }
}
