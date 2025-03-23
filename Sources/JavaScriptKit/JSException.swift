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
public struct JSException: Error, Equatable {
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

    /// Initializes a new JSException instance with a value thrown from JavaScript.
    ///
    /// Only available within the package.
    package init(_ thrownValue: JSValue) {
        self._thrownValue = thrownValue
    }
}
