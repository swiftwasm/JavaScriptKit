@frozen public enum JSUndefinedOr<Wrapped> {
    case undefined
    case value(Wrapped)

    /// Convenience accessor for the undefined case.
    public static var undefinedValue: Self { .undefined }

    @inlinable
    public init(optional: Wrapped?) {
        self = optional.map(Self.value) ?? .undefined
    }

    @inlinable
    public var optionalRepresentation: Wrapped? {
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

extension JSUndefinedOr: _BridgedAsOptional {}
