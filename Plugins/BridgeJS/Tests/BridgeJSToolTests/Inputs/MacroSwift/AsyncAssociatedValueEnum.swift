@JS enum AsyncPayloadResult {
    case success(String)
    case failure(Int)
    case idle
}

@JS func asyncRoundTripAssociatedValueEnum(_ value: AsyncPayloadResult) async -> AsyncPayloadResult {
    return value
}

@JS func asyncRoundTripOptionalAssociatedValueEnum(_ value: AsyncPayloadResult?) async -> AsyncPayloadResult? {
    return value
}
