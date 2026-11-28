@JSFunction func readBytes(_ bytes: Span<UInt8>) throws(JSException) -> Double
@JSFunction func fillBytes(_ bytes: inout MutableSpan<UInt8>) throws(JSException)
@JSFunction func copyBytes(
    _ source: borrowing Span<UInt8>,
    _ label: String,
    into destination: inout Swift.MutableSpan<UInt8>
) throws(JSException) -> Double

@JSClass struct ByteSink {
    @JSFunction init(_ header: Span<UInt8>) throws(JSException)
    @JSFunction func write(_ bytes: Span<UInt8>) throws(JSException) -> Double
    @JSFunction func read(into bytes: inout MutableSpan<UInt8>) throws(JSException) -> Double
    @JSFunction static func checksum(_ bytes: Span<UInt8>) throws(JSException) -> Double
}
