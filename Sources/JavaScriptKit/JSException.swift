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
    /// The value thrown from JavaScript.
    /// This can be any JavaScript value (error object, string, number, etc.).
    public var thrownValue: JSValue {
        return _thrownValue
    }

    /// The actual JavaScript value that was thrown.
    ///
    /// Marked as `nonisolated(unsafe)` to satisfy `Sendable` requirement
    /// from `Error` protocol.
    private nonisolated(unsafe) let _thrownValue: JSValue

    /// A description of the exception.
    public let description: String

    /// The stack trace of the exception.
    public let stack: String?

    /// Initializes a new JSException instance with a value thrown from JavaScript.
    ///
    /// Only available within the package. This must be called on the thread where the exception object created.
    package init(_ thrownValue: JSValue) {
        self._thrownValue = thrownValue
        // Capture the stringified representation on the object owner thread
        // to bring useful info to the catching thread even if they are different threads.
        if let errorObject = thrownValue.object, let stack = errorObject.stack.string {
            self.description = "JSException(\(stack))"
            self.stack = stack
        } else {
            self.description = "JSException(\(thrownValue))"
            self.stack = nil
        }
    }
}
