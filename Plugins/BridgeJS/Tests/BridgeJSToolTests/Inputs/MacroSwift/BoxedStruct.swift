@JS(structStyle: .reference) struct LargePayload {
    @JS let largeContents: [Int]
}

@JS(structStyle: .reference) struct Hi {
    @JS let largeContents: [Int]

    @JS init(largeContents: [Int])
    @JS func summarize() -> String
    @JS func appendingZero() -> Hi
}

@JS(structStyle: .reference) struct Container {
    @JS let payload: LargePayload
}

@JS(structStyle: .reference) struct MutableBox {
    @JS var counter: Int
    @JS let label: String
}

@JS func roundtripBoxed(_ p: LargePayload) -> LargePayload

@JS func mayMakeHi(_ flag: Bool) -> Hi?

@JS struct ValueWithBoxedField {
    let payload: Hi
    let label: String
}

// Boxed structs inside Array / Dictionary parameters and returns.
@JS func consumeBoxedArray(_ items: [Hi]) -> [Hi]
@JS func consumeBoxedDictionary(_ items: [String: Hi]) -> [String: Hi]
@JS func optionalBoxedArray(_ flag: Bool) -> [Hi]?
@JS func arrayOfOptionalBoxed(_ flag: Bool) -> [Hi?]
