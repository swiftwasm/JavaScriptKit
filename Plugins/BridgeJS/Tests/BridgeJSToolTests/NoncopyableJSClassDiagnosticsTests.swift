import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct NoncopyableJSClassDiagnosticsTests {
    private static let objectDeclaration = """
        @JSClass struct NoncopyableObject: ~Copyable {
            @JSFunction func value() throws(JSException) -> Int
        }

        """

    private func firstDiagnostic(for declaration: String) throws -> DiagnosticError {
        var diagnostics: [DiagnosticError] = []
        do {
            _ = try makeSkeleton(Self.objectDeclaration + declaration, moduleName: "App")
        } catch let error as BridgeJSCoreDiagnosticError {
            diagnostics = error.diagnostics.map(\.diagnostic)
        }
        return try #require(diagnostics.first, "Expected a diagnostic, but resolution succeeded")
    }

    @Test(arguments: [
        "@JSClass struct NoncopyableObjectRoundtrip: ~Copyable { @JSFunction func take(_ objects: [NoncopyableObject]) throws(JSException) }",
        "@JS func makeObjects() -> Array<NoncopyableObject> { fatalError() }",
        "@JS func maybeObjects() -> [NoncopyableObject]? { fatalError() }",
    ])
    func arrayOfWrappersMustBeUniqueArray(declaration: String) throws {
        let diagnostic = try firstDiagnostic(for: declaration)
        #expect(diagnostic.message == "An array of noncopyable '@JSClass' wrappers must be a 'UniqueArray'")
        #expect(diagnostic.hint == "Use 'UniqueArray<NoncopyableObject>'")
    }

    @Test func uniqueArrayOfCopyableElementsIsRejected() throws {
        let diagnostic = try firstDiagnostic(
            for: """
                @JSClass struct NoncopyableObjectRoundtrip: ~Copyable {
                    @JSFunction func takeAll(_ values: borrowing UniqueArray<Int>) throws(JSException) -> Int
                }
                """
        )
        #expect(diagnostic.message == "'UniqueArray' is supported only for noncopyable '@JSClass' wrapper elements")
        #expect(diagnostic.hint == "Use '[Int]'")
    }

    @Test func dictionaryOfWrappersIsRejected() throws {
        let diagnostic = try firstDiagnostic(
            for: "@JS func objects() -> [String: NoncopyableObject] { fatalError() }"
        )
        #expect(diagnostic.message == "Dictionaries of noncopyable '@JSClass' wrappers are not supported")
        #expect(diagnostic.hint == "Use JSObject values, or a copyable '@JSClass' wrapper")
    }

    @Test func structFieldOfWrapperTypeIsRejected() throws {
        let diagnostic = try firstDiagnostic(
            for: """
                @JS struct Pair {
                    var name: String
                    var object: NoncopyableObject
                }
                """
        )
        #expect(diagnostic.message == "A '@JS struct' field cannot be a noncopyable '@JSClass' wrapper")
        #expect(diagnostic.hint == "Use a JSObject field, or a copyable '@JSClass' wrapper")
    }

    @Test func associatedValueOfWrapperTypeIsRejected() throws {
        let diagnostic = try firstDiagnostic(
            for: """
                @JS enum Choice {
                    case object(NoncopyableObject)
                    case nothing
                }
                """
        )
        #expect(diagnostic.message == "Unsupported associated value type: NoncopyableObject")
    }

    @Test(arguments: [
        (
            "@JSClass struct NoncopyableObjectRoundtrip: ~Copyable { @JSGetter var child: NoncopyableObject }",
            "Use '@JSGetterFunction func child() throws(JSException) -> NoncopyableObject'"
        ),
        (
            "@JSGetter(jsName: \"sharedObject\", from: .global) var child: NoncopyableObject",
            "Use '@JSGetterFunction(jsName: \"sharedObject\", from: .global) func child() throws(JSException) -> NoncopyableObject'"
        ),
    ])
    func getterOfWrapperTypeIsRejected(declaration: String, hint: String) throws {
        let diagnostic = try firstDiagnostic(for: declaration)
        #expect(diagnostic.message == "@JSGetter cannot read a noncopyable '@JSClass' wrapper")
        #expect(diagnostic.hint == hint)
    }

    @Test(arguments: [
        (
            "@JSGetterFunction func child(_ index: Int) throws(JSException) -> NoncopyableObject",
            "@JSGetterFunction function must have no parameters."
        ),
        ("@JSGetterFunction func child() throws(JSException)", "@JSGetterFunction function must have a return type."),
    ])
    func getterFunctionNeedsNoParametersAndAReturnType(member: String, message: String) throws {
        let diagnostic = try firstDiagnostic(
            for: "@JSClass struct NoncopyableObjectRoundtrip: ~Copyable { \(member) }"
        )
        #expect(diagnostic.message == message)
    }

    @Test func staticGetterFunctionIsRejected() throws {
        let diagnostic = try firstDiagnostic(
            for: """
                @JSClass struct NoncopyableObjectRoundtrip: ~Copyable {
                    @JSGetterFunction static func shared() throws(JSException) -> NoncopyableObject
                }
                """
        )
        #expect(
            diagnostic.message
                == "@JSGetterFunction is not supported for static members. Use it only for instance members in @JSClass types."
        )
    }

    @Test func borrowedWrappersAndUniqueArraysResolve() throws {
        let skeleton = try makeSkeleton(
            Self.objectDeclaration + """
                @JSClass struct NoncopyableObjectRoundtrip: ~Copyable {
                    @JSFunction func take(_ object: borrowing NoncopyableObject, _ objects: borrowing UniqueArray<NoncopyableObject>) throws(JSException) -> UniqueArray<NoncopyableObject>?
                    @JSGetterFunction func child() throws(JSException) -> NoncopyableObject
                }
                """,
            moduleName: "App"
        )
        let types = try #require(skeleton.imported?.children.first?.types)
        #expect(types.map(\.name) == ["NoncopyableObject", "NoncopyableObjectRoundtrip"])
        #expect(types.map(\.isNoncopyable) == [true, true])
        let roundtrip = types[1]
        let take = try #require(roundtrip.methods.first)
        let objectType = BridgeType.jsUniqueObject("NoncopyableObject")
        #expect(take.parameters.map(\.type) == [objectType, .array(objectType)])
        #expect(take.returnType == .nullable(.array(objectType), .null))
        #expect(roundtrip.getters.map(\.name) == ["child"])
        #expect(roundtrip.getters.map(\.type) == [objectType])
    }
}
