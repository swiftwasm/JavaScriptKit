/// A wrapper that represents a JavaScript value of `Wrapped | undefined`.
///
/// In BridgeJS, `Optional<Wrapped>` is bridged as `Wrapped | null`.
/// Use `JSUndefinedOr<Wrapped>` when the JavaScript API expects
/// `Wrapped | undefined` instead.
@frozen public enum JSUndefinedOr<Wrapped> {
    /// The JavaScript value is `undefined`.
    case undefined
    /// The JavaScript value is present and wrapped.
    case value(Wrapped)

    /// Creates a wrapper from a Swift optional.
    ///
    /// - Parameter optional: The optional value to wrap.
    ///   `nil` becomes ``undefined`` and a non-`nil` value becomes ``value(_:)``.
    @inlinable
    public init(optional: Wrapped?) {
        self = optional.map(Self.value) ?? .undefined
    }

    /// Returns the wrapped value as a Swift optional.
    ///
    /// Returns `nil` when this value is ``undefined``.
    @inlinable
    public var asOptional: Wrapped? {
        switch self {
        case .undefined:
            return nil
        case .value(let wrapped):
            return wrapped
        }
    }
}

extension JSUndefinedOr: ConstructibleFromJSValue where Wrapped: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        if value.isUndefined { return .undefined }
        guard let wrapped = Wrapped.construct(from: value) else { return nil }
        return .value(wrapped)
    }
}

extension JSUndefinedOr: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    public var jsValue: JSValue {
        switch self {
        case .undefined:
            return .undefined
        case .value(let wrapped):
            return wrapped.jsValue
        }
    }
}

// MARK: - BridgeJS (via _BridgedAsOptional in BridgeJSIntrinsics)

@_spi(BridgeJS) extension JSUndefinedOr: _BridgedAsOptional {}
