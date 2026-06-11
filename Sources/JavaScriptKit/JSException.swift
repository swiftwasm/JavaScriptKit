/// `JSException` is a wrapper that handles exceptions thrown during JavaScript execution as Swift
/// `Error` objects.
/// When a JavaScript function throws an exception, it's wrapped as a `JSException` and propagated
/// through Swift's error handling mechanism.
///
/// Example:
/// ```swift
/// do {
///     try jsFunction.throws()
/// } catch let error as JSException {
///     // Access the value thrown from JavaScript
///     let jsErrorValue = error.thrownValue
/// }
/// ```
public struct JSException: Error, Equatable, CustomStringConvertible {
    /// Boxes the exception payload in a class so `JSException` stays within the direct
    /// typed-error convention on wasm32.
    private final class Storage {
        /// The actual JavaScript value that was thrown.
        let thrownValue: JSValue

        /// A description of the exception.
        let description: String

        /// The stack trace of the exception.
        let stack: String?

        init(thrownValue: JSValue, description: String, stack: String?) {
            self.thrownValue = thrownValue
            self.description = description
            self.stack = stack
        }
    }

    /// The boxed payload of the exception.
    ///
    /// Marked as `nonisolated(unsafe)` to satisfy `Sendable` requirement
    /// from `Error` protocol.
    private nonisolated(unsafe) let storage: Storage

    /// The value thrown from JavaScript.
    /// This can be any JavaScript value (error object, string, number, etc.).
    public var thrownValue: JSValue {
        return storage.thrownValue
    }

    /// A description of the exception.
    public var description: String {
        return storage.description
    }

    /// The stack trace of the exception.
    public var stack: String? {
        return storage.stack
    }

    /// Initializes a new JSException instance with a value thrown from JavaScript.
    ///
    /// Only available within the package. This must be called on the thread where the exception object created.
    /// The stringified representation is captured on the object owner thread to bring useful info
    /// to the catching thread even if they are different threads.
    @usableFromInline
    package init(_ thrownValue: JSValue) {
        if let errorObject = thrownValue.object, let stack = errorObject.stack.string {
            self.storage = Storage(
                thrownValue: thrownValue,
                description: "JSException(\(stack))",
                stack: stack
            )
        } else {
            self.storage = Storage(
                thrownValue: thrownValue,
                description: "JSException(\(thrownValue))",
                stack: nil
            )
        }
    }

    /// Initializes a new JavaScript `Error` instance with a message and prepare it to be thrown.
    ///
    /// - Parameters:
    ///   - message: The message to throw.
    public init(message: String) {
        self.init(JSError(message: message).jsValue)
    }

    public static func == (lhs: JSException, rhs: JSException) -> Bool {
        return lhs.storage.thrownValue == rhs.storage.thrownValue
            && lhs.storage.description == rhs.storage.description
            && lhs.storage.stack == rhs.storage.stack
    }
}
