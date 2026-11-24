import Testing
import JavaScriptKit

@JSClass struct SpanParameterImports {
    @JSFunction static func jsSum(_ bytes: Span<UInt8>) throws(JSException) -> Double
    @JSFunction static func jsLength(_ bytes: Span<UInt8>) throws(JSException) -> Double
    @JSFunction static func jsByteOffset(_ bytes: Span<UInt8>) throws(JSException) -> Double
    @JSFunction static func jsViewKind(_ bytes: Span<UInt8>) throws(JSException) -> String
    @JSFunction static func jsFill(_ bytes: inout MutableSpan<UInt8>, _ value: Double) throws(JSException)
    @JSFunction static func jsFillThenThrow(_ bytes: inout MutableSpan<UInt8>, _ message: String) throws(JSException)
    @JSFunction static func jsCopy(
        _ source: Span<UInt8>,
        into destination: inout MutableSpan<UInt8>
    ) throws(JSException) -> Double
    @JSFunction static func jsFillWithLengthAndEcho<T: BridgedSwiftGenericBridgeable>(
        _ bytes: inout MutableSpan<UInt8>,
        _ value: T
    ) throws(JSException) -> T
}

@JSClass struct SpanHeaderStore {
    @JSFunction init(_ header: Span<UInt8>) throws(JSException)
    @JSFunction func sum(_ bytes: Span<UInt8>) throws(JSException) -> Double
    @JSFunction func readHeader(into bytes: inout MutableSpan<UInt8>) throws(JSException) -> Double
}

@JSClass struct SpanWebCrypto {
    @JSFunction func getRandomValues(_ bytes: inout MutableSpan<UInt8>) throws(JSException)
}

@JSGetter(jsName: "crypto", from: .global) var spanWebCrypto: SpanWebCrypto

@Suite struct SpanParameterTests {
    @Test func spanBytesReachJavaScript() throws {
        let bytes: [UInt8] = [1, 2, 3, 250]
        #expect(try SpanParameterImports.jsSum(bytes.span) == 256)
        #expect(try SpanParameterImports.jsLength(bytes.span) == 4)
    }

    @Test func emptySpan() throws {
        let bytes: [UInt8] = []
        #expect(try SpanParameterImports.jsLength(bytes.span) == 0)
        #expect(try SpanParameterImports.jsSum(bytes.span) == 0)
    }

    @Test func spanIsViewOfWasmMemoryUnlessMemoryIsShared() throws {
        let bytes: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        let span = bytes.span.extracting(2...)
        #if _runtime(_multithreaded)
        #expect(try SpanParameterImports.jsViewKind(span) == "copy")
        #else
        #expect(try SpanParameterImports.jsViewKind(span) == "view")
        let address = span.withUnsafeBufferPointer { UInt(bitPattern: $0.baseAddress) }
        #expect(try SpanParameterImports.jsByteOffset(span) == Double(address))
        #endif
        #expect(try SpanParameterImports.jsSum(span) == 3 + 4 + 5 + 6 + 7 + 8)
    }

    @Test func mutableSpanReceivesWrites() throws {
        var bytes: [UInt8] = [0, 0, 0, 0]
        do {
            var span = bytes.mutableSpan
            try SpanParameterImports.jsFill(&span, 7)
        }
        #expect(bytes == [7, 7, 7, 7])
    }

    @Test func writesBeforeThrowAreKept() throws {
        var bytes: [UInt8] = [0, 0, 0]
        do {
            var span = bytes.mutableSpan
            let error = #expect(throws: JSException.self) {
                try SpanParameterImports.jsFillThenThrow(&span, "fill failed")
            }
            #expect(error?.thrownValue.object?["message"].string == "fill failed")
        }
        #expect(bytes == [1, 1, 1])
    }

    @Test func spanAndMutableSpanInOneCall() throws {
        let source: [UInt8] = [9, 8, 7, 6]
        var destination: [UInt8] = [0, 0, 0, 0, 0]
        do {
            var span = destination.mutableSpan
            #expect(try SpanParameterImports.jsCopy(source.span, into: &span) == 4)
        }
        #expect(destination == [9, 8, 7, 6, 0])
    }

    @Test func genericFunctionTakesMutableSpan() throws {
        var bytes: [UInt8] = [0, 0, 0]
        do {
            var span = bytes.mutableSpan
            #expect(try SpanParameterImports.jsFillWithLengthAndEcho(&span, "echo") == "echo")
        }
        #expect(bytes == [3, 3, 3])
    }

    @Test func initializerAndMethods() throws {
        let header: [UInt8] = [42, 43, 44]
        let store = try SpanHeaderStore(header.span)
        let other: [UInt8] = [1, 2]
        #expect(try store.sum(other.span) == 3)
        var copy: [UInt8] = [0, 0, 0]
        do {
            var span = copy.mutableSpan
            #expect(try store.readHeader(into: &span) == 3)
        }
        #expect(copy == header)
    }

    @Test func webAPIFillsSixtyFourKiB() throws {
        var bytes = [UInt8](repeating: 0, count: 65536)
        do {
            var span = bytes.mutableSpan
            try spanWebCrypto.getRandomValues(&span)
        }
        #expect(bytes.contains { $0 != 0 })
        #expect(bytes[65280...].contains { $0 != 0 })
    }
}
