import _CJavaScriptKit

/// `JSObject` represents an object in JavaScript and supports dynamic member lookup.
/// Any member access like `object.foo` will dynamically request the JavaScript and Swift
/// runtime bridge library for a member with the specified name in this object.
///
/// And this object supports to call a member method of the object.
///
/// e.g.
/// ```swift
/// let document = JSObject.global.document.object!
/// let divElement = document.createElement!("div")
/// ```
///
/// The lifetime of this object is managed by the JavaScript and Swift runtime bridge library with
/// reference counting system.
public class JSObject {
    internal var _id: JavaScriptObjectRef
    public init(id: JavaScriptObjectRef) {
        self._id = id
    }

    /// Access the `index` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter index: The index of this object's member to access.
    /// - Returns: The value of the `index` member of this object.
    public subscript(_ index: Int) -> JSValue {
        get { .undefined }
        set {}
    }

    /// A `JSObject` of the global scope object.
    /// This allows access to the global properties and global names by accessing the `JSObject` returned.
    public static var global: JSObject { return _global.wrappedValue }
    private nonisolated(unsafe) static let _global = LazyThreadLocal(
        initialize: JSObject(id: 1)
    )
}

/// A property wrapper that lazily initializes a thread-local value
/// for each thread that accesses the value.
struct LazyThreadLocal<Value> {
    var wrappedValue: Value

    init(initialize: Value) {
        self.wrappedValue = initialize
    }
}

/// `JSValue` represents a value in JavaScript.
public enum JSValue {
    case undefined
}