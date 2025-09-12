/// A wrapper around [the JavaScript `Error`
/// class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) that
/// exposes its properties in a type-safe way.
public final class JSError: JSBridgedClass {
    /// The constructor function used to create new JavaScript `Error` objects.
    public static var constructor: JSObject? { _constructor.wrappedValue }
    private static let _constructor = LazyThreadLocal(initialize: { JSObject.global.Error.object })

    /// The underlying JavaScript `Error` object.
    public let jsObject: JSObject

    /// Creates a new instance of the JavaScript `Error` class with a given message.
    public init(message: String) {
        jsObject = Self.constructor!.new([message])
    }

    public init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The error message of the underlying `Error` object.
    public var message: String {
        jsObject.message.string!
    }

    /// The name (usually corresponds to the name of the underlying class) of a given error.
    public var name: String {
        jsObject.name.string!
    }

    /// The JavaScript call stack that led to the creation of this error object.
    public var stack: String? {
        jsObject.stack.string
    }

    /// Creates a new `JSValue` from this `JSError` instance.
    public var jsValue: JSValue {
        .object(jsObject)
    }
}

extension JSError: CustomStringConvertible {
    /// The textual representation of this error.
    public var description: String { jsObject.description }
}
