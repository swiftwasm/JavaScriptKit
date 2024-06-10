#if hasFeature(Embedded)
import String16
#endif

/** A wrapper around [the JavaScript `Error`
 class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) that
 exposes its properties in a type-safe way.
 */
public final class JSError: Error, JSBridgedClass {
    /// The constructor function used to create new JavaScript `Error` objects.
    public static let constructor = JSObject.global.Error.function

    /// The underlying JavaScript `Error` object.
    public let jsObject: JSObject

    /// Creates a new instance of the JavaScript `Error` class with a given message.
    #if hasFeature(Embedded)
    public init(message: String16) {
        jsObject = Self.constructor!.new(arguments: [JSString(message).jsValue])
    }
    #else
    public init(message: String) {
        jsObject = Self.constructor!.new([message])
    }
    #endif

    public init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The error message of the underlying `Error` object.
    #if hasFeature(Embedded)
    public var message: String16 {
        jsObject.message.string!
    }
    #else
    public var message: String {
        jsObject.message.string!
    }
    #endif

    /// The name (usually corresponds to the name of the underlying class) of a given error.
    #if hasFeature(Embedded)
    public var name: String16 {
        jsObject.name.string!
    }
    #else
    public var name: String {
        jsObject.name.string!
    }
    #endif

    /// The JavaScript call stack that led to the creation of this error object.
    #if hasFeature(Embedded)
    public var stack: String16? {
        jsObject.stack.string
    }
    #else
    public var stack: String? {
        jsObject.stack.string
    }
    #endif

    /// Creates a new `JSValue` from this `JSError` instance.
    public var jsValue: JSValue {
        .object(jsObject)
    }
}

extension JSError: CustomStringConvertible {
    /// The textual representation of this error.
    #if hasFeature(Embedded)
    public var description: String16 { jsObject.description }
    #else
    public var description: String { jsObject.description }
    #endif
}
