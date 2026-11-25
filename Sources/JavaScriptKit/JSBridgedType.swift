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
/// The conformance is automatically synthesized by `@JSClass` for BridgeJS-generated declarations.
public protocol _JSBridgedClass: Equatable, _BridgedSwiftStackType {
    /// The JavaScript object wrapped by this instance.
    /// You may assume that `jsObject instanceof Self.constructor == true`
    var jsObject: JSObject { get }

    /// Create an instance wrapping the given JavaScript object.
    /// You may assume that `jsObject instanceof Self.constructor`
    init(unsafelyWrapping jsObject: JSObject)
}

extension _JSBridgedClass {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.jsObject == rhs.jsObject
    }
}

/// A protocol that noncopyable `@JSClass` wrappers conform to. Each instance owns its JavaScript object.
///
/// The conformance is automatically synthesized by `@JSClass` for `~Copyable` structs.
public protocol _JSUniqueBridgedClass: _BridgedSwiftUniqueStackType, ~Copyable {
    /// The reference to the JavaScript object this instance owns.
    var jsID: Int32 { get }

    /// Create an instance owning the given reference.
    /// You may assume that the referenced object is an instance of the JavaScript class this type wraps.
    init(unsafelyAdopting jsRef: consuming JSUniqueRef)

    consuming func takeJSRef() -> JSUniqueRef
}

extension _JSUniqueBridgedClass where Self: ~Copyable {
    /// Lends `body` an instance for `id` without taking ownership of the reference.
    ///
    /// Some other value must own `id` until `body` returns. Nothing checks that it does.
    @_spi(BridgeJS) public static func withUnownedID<R: ~Copyable, E: Error>(
        _ id: Int32,
        _ body: (borrowing Self) throws(E) -> R
    ) throws(E) -> R {
        let instance = Self(unsafelyAdopting: JSUniqueRef(adopting: id))
        do {
            let result = try body(instance)
            _ = instance.takeJSRef().relinquish()
            return result
        } catch {
            _ = instance.takeJSRef().relinquish()
            throw error
        }
    }

    /// Lends `body` an instance of `type` for the object this instance owns.
    public borrowing func withView<T: _JSUniqueBridgedClass & ~Copyable, R: ~Copyable, E: Error>(
        as type: T.Type,
        _ body: (borrowing T) throws(E) -> R
    ) throws(E) -> R {
        try T.withUnownedID(jsID, body)
    }
}

/// Conform to this protocol when your Swift class wraps a JavaScript class.
public protocol JSBridgedClass: JSBridgedType, _JSBridgedClass {
    /// The constructor function for the JavaScript class
    static var constructor: JSObject? { get }

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
