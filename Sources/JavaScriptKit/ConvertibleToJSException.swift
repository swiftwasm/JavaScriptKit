/// Errors that can be converted to a JSException.
/// 
/// If an error conforms to this protocol, it is possible to throw it from a `@JS` method.
public protocol ConvertibleToJSException: Error {
    var jsException: JSException { get }
}
