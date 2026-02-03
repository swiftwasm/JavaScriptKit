@frozen public enum JSUndefinedOr<Wrapped> {
    case undefined
    case value(Wrapped)

    /// Convenience accessor for the undefined case.
    public static var undefinedValue: Self { .undefined }

    @inlinable
    init(optional: Wrapped?) {
        self = optional.map(Self.value) ?? .undefined
    }

    @inlinable
    var optionalRepresentation: Wrapped? {
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

// MARK: - BridgeJS Optional-style conformances

extension JSUndefinedOr where Wrapped == Bool {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ value: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(value))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped == Int {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped == UInt {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped == String {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, bytes, count))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped == JSObject {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, objectId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftProtocolWrapper {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ objectId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, objectId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftHeapObject {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, pointer: UnsafeMutableRawPointer)
    {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerParameterWithRetain() -> (
        isSome: Int32, pointer: UnsafeMutableRawPointer
    ) {
        optionalRepresentation.bridgeJSLowerParameterWithRetain()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ pointer: UnsafeMutableRawPointer
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, pointer))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }
}

extension JSUndefinedOr where Wrapped == Float {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped == Double {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float64) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, caseId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(caseId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftTypeLoweredIntoVoidType {
    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == String {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(
        _ isSome: Int32,
        _ bytes: Int32,
        _ count: Int32
    ) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, bytes, count))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Int {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Bool {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Float {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr
where Wrapped: _BridgedSwiftEnumNoPayload, Wrapped: RawRepresentable, Wrapped.RawValue == Double {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, value: Float64) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ wrappedValue: Float64) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, wrappedValue))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturnFromSideChannel() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturnFromSideChannel())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) public consuming func bridgeJSLowerParameter() -> (isSome: Int32, caseId: Int32) {
        optionalRepresentation.bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32, _ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome, caseId))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public static func bridgeJSLiftReturn(_ caseId: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftReturn(caseId))
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}

extension JSUndefinedOr where Wrapped: _BridgedSwiftStruct {
    @_spi(BridgeJS) public static func bridgeJSLiftParameter(_ isSome: Int32) -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter(isSome))
    }

    @_spi(BridgeJS) public static func bridgeJSLiftParameter() -> Self {
        Self(optional: Optional<Wrapped>.bridgeJSLiftParameter())
    }

    @_spi(BridgeJS) public consuming func bridgeJSLowerReturn() -> Void {
        optionalRepresentation.bridgeJSLowerReturn()
    }
}
