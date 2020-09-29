/** A wrapper around [the JavaScript Error 
class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) that
exposes its properties in a type-safe way.
*/
public final class JSError: Error, JSValueConvertible {
    /// The constructor function used to create new JavaScript `Error` objects.
    public static let constructor = JSObject.global.Error.function!

    /// The underlying JavaScript `Error` object.
    public let jsObject: JSObject

    /// Creates a new instance of the JavaScript `Error` class with a given message.
    public init(message: String) {
        jsObject = Self.constructor.new([message])
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
    public func jsValue() -> JSValue {
        .object(jsObject)
    }
}

extension JSError: CustomStringConvertible {
    /// The textual representation of this error.
    public var description: String { jsObject.description }
}

extension JSError: JSValueConstructible {
  public static func construct(from value: JSValue) -> JSError? {
    guard let object = value.object else { return nil }
    return JSError(unsafelyWrapping: object)
  }
}
