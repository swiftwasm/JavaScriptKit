import Testing

@Test func never() async throws {
    let _: Void = await withUnsafeContinuation { _ in }
}
