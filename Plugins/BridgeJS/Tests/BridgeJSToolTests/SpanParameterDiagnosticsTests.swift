import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct SpanParameterDiagnosticsTests {
    static let position =
        "Span<UInt8> and MutableSpan<UInt8> are supported only as parameters of synchronous @JSFunction declarations."
    static let alias =
        "A type alias of a span is not supported; write Span<UInt8> or MutableSpan<UInt8> in the parameter."

    @Test(arguments: [
        ("@JSFunction func f(_ bytes: Span<Int32>) throws(JSException)", "got 'Span<Int32>'"),
        ("@JSFunction func f(_ bytes: inout MutableSpan<Int8>) throws(JSException)", "got 'MutableSpan<Int8>'"),
        ("@JSFunction func f(_ bytes: Span) throws(JSException)", "got 'Span'"),
        (
            "@JSFunction func f(_ bytes: MutableSpan<UInt8>) throws(JSException)",
            "A MutableSpan<UInt8> parameter must be 'inout'.",
        ),
        (
            "@JSFunction func f(_ bytes: borrowing MutableSpan<UInt8>) throws(JSException)",
            "A MutableSpan<UInt8> parameter must be 'inout'.",
        ),
        (
            "@JSFunction func f(_ bytes: inout Span<UInt8>) throws(JSException)",
            "A Span<UInt8> parameter must be borrowed",
        ),
        (
            "@JSFunction func f(_ bytes: consuming Span<UInt8>) throws(JSException)",
            "A Span<UInt8> parameter must be borrowed",
        ),
        ("typealias Bytes = Span<UInt8>\n@JSFunction func f(_ bytes: Bytes) throws(JSException)", alias),
        ("typealias Bytes = MutableSpan<UInt8>\n@JSFunction func f(_ bytes: inout Bytes) throws(JSException)", alias),
        (
            "typealias Inner = Span<UInt8>\ntypealias Bytes = Inner\n@JSFunction func f(_ bytes: Bytes) throws(JSException)",
            alias,
        ),
    ])
    func invalidSpanParameter(source: String, diagnostic: String) {
        expectDiagnostic(source: source, contains: diagnostic)
    }

    @Test(arguments: [
        "@JSFunction func f(_ bytes: Span<UInt8>) async throws(JSException)",
        "@JSFunction func f() throws(JSException) -> Span<UInt8>",
        "@JSFunction func f(_ bytes: Span<UInt8>?) throws(JSException)",
        "@JSFunction func f(_ bytes: [Span<UInt8>]) throws(JSException)",
        "@JSFunction func f(_ callback: (Span<UInt8>) -> Void) throws(JSException)",
        "@JSGetter var bytes: Span<UInt8>",
        "@JSClass struct S { @JSSetter func setBytes(_ bytes: Span<UInt8>) throws(JSException) }",
        "@JS func f(_ bytes: Span<UInt8>) {}",
        "@JS struct S { var bytes: Span<UInt8> }",
    ])
    func unsupportedSpanPosition(source: String) {
        expectDiagnostic(source: source, contains: Self.position)
    }

    @Test(arguments: [
        ("@JSClass struct Span {}\n@JSFunction func f(_ value: Span) throws(JSException)", "Span"),
        (
            "@JSClass struct MutableSpan {}\n@JSFunction func f(_ value: inout MutableSpan) throws(JSException)",
            "MutableSpan",
        ),
        (
            "@JSClass struct Blob {}\ntypealias Span = Blob\n@JSFunction func f(_ value: Span) throws(JSException)",
            "Blob",
        ),
        (
            "@JSClass struct Span {}\ntypealias Handle = Span\n@JSFunction func f(_ value: Handle) throws(JSException)",
            "Span",
        ),
        (
            "@JSClass struct Blob {}\ntypealias Span = Blob\ntypealias Handle = Span\n@JSFunction func f(_ value: Handle) throws(JSException)",
            "Blob",
        ),
    ])
    func userTypeNamedSpanKeepsItsType(source: String, typeName: String) throws {
        let imported = try #require(try makeSkeleton(source).imported)
        let function = try #require(imported.children.flatMap(\.functions).first)
        #expect(function.parameters.map(\.type) == [.jsObject(typeName)])
    }

    @Test(arguments: [
        ("Span<UInt8>", false),
        ("Span<Swift.UInt8>", false),
        ("Span<Swift . UInt8>", false),
        ("Span<(UInt8)>", false),
        ("Span<((Swift.UInt8))>", false),
        ("inout MutableSpan<(UInt8)>", true),
        ("inout Swift.MutableSpan<Swift . UInt8>", true),
    ])
    func elementSpellingsOfUInt8(parameterType: String, isMutable: Bool) throws {
        let skeleton = try makeSkeleton(
            "@JSFunction func f(_ bytes: \(parameterType)) throws(JSException)"
        )
        let imported = try #require(skeleton.imported)
        let function = try #require(imported.children.flatMap(\.functions).first)
        let expected = BridgeType.span(BridgeSpanType(element: .integer(.uint8), isMutable: isMutable))
        #expect(function.parameters.map(\.type) == [expected])
    }

    @Test(arguments: [
        "Span<(UInt8, UInt8)>",
        "Span<(x: UInt8)>",
        "Span<UInt8?>",
        "Span<[UInt8]>",
        "Span<UInt8.Type>",
        "Span<MyModule.UInt8>",
        "Span<Swift.Swift.UInt8>",
    ])
    func nonUInt8ElementSpellingsAreRejected(parameterType: String) {
        expectDiagnostic(
            source: "@JSFunction func f(_ bytes: \(parameterType)) throws(JSException)",
            contains: "Only Span<UInt8> and MutableSpan<UInt8> are supported"
        )
    }

    @Test func thunkQualifiesStandardLibrarySpans() throws {
        let skeleton = try makeSkeleton(
            """
            @JSClass struct Span {}
            @JSClass struct MutableSpan {}
            @JSFunction func f(_ bytes: Swift.Span<UInt8>, _ buffer: inout Swift.MutableSpan<UInt8>) throws(JSException)
            """
        )
        let imported = try #require(skeleton.imported)
        let thunks = try #require(
            try ImportTS(progress: .silent, moduleName: skeleton.moduleName, skeleton: imported).finalize()
        )
        #expect(thunks.contains("func _$f(_ bytes: Swift.Span<UInt8>, _ buffer: inout Swift.MutableSpan<UInt8>)"))
    }
}
