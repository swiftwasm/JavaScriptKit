@JSClass struct AsyncBox {
    @JSFunction static func asyncStaticRoundTrip(_ v: Double) async throws(JSException) -> Double
    @JSFunction static func asyncStaticVoid() async throws(JSException)
}
