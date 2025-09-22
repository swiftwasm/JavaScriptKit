/// Types conforming to this protocol can be constructed from `JSValue`.
public protocol ConstructibleFromJSValue {
    /// Construct an instance of `Self`, if possible, from the given `JSValue`.
    /// Return `nil` if the value is not compatible with the conforming Swift type.
    ///
    /// - Parameter value: The `JSValue` to decode
    /// - Returns: An instance of `Self`, if one was successfully constructed from the value.
    static func construct(from value: JSValue) -> Self?
}
