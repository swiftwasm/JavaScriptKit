import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSFunctionMacroTests {
    private let indentationWidth: Trivia = .spaces(4)

    @Test func topLevelFunction() {
        assertMacroExpansion(
            """
            @JSFunction
            func greet(name: String) -> String
            """,
            expandedSource: """
                func greet(name: String) -> String {
                    return _$greet(name)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionVoidReturn() {
        assertMacroExpansion(
            """
            @JSFunction
            func log(message: String)
            """,
            expandedSource: """
                func log(message: String) {
                    _$log(message)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionWithExplicitVoidReturn() {
        assertMacroExpansion(
            """
            @JSFunction
            func log(message: String) -> Void
            """,
            expandedSource: """
                func log(message: String) -> Void {
                    _$log(message)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionWithEmptyTupleReturn() {
        assertMacroExpansion(
            """
            @JSFunction
            func log(message: String) -> ()
            """,
            expandedSource: """
                func log(message: String) -> () {
                    _$log(message)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionThrows() {
        assertMacroExpansion(
            """
            @JSFunction
            func parse(json: String) throws -> [String: Any]
            """,
            expandedSource: """
                func parse(json: String) throws -> [String: Any] {
                    return try _$parse(json)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionAsync() {
        assertMacroExpansion(
            """
            @JSFunction
            func fetch(url: String) async -> String
            """,
            expandedSource: """
                func fetch(url: String) async -> String {
                    return await _$fetch(url)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionAsyncThrows() {
        assertMacroExpansion(
            """
            @JSFunction
            func fetch(url: String) async throws -> String
            """,
            expandedSource: """
                func fetch(url: String) async throws -> String {
                    return try await _$fetch(url)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionWithUnderscoreParameter() {
        assertMacroExpansion(
            """
            @JSFunction
            func process(_ value: Int) -> Int
            """,
            expandedSource: """
                func process(_ value: Int) -> Int {
                    return _$process(value)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelFunctionWithMultipleParameters() {
        assertMacroExpansion(
            """
            @JSFunction
            func add(a: Int, b: Int) -> Int
            """,
            expandedSource: """
                func add(a: Int, b: Int) -> Int {
                    return _$add(a, b)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func instanceMethod() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                func getName() -> String
            }
            """,
            expandedSource: """
                struct MyClass {
                    func getName() -> String {
                        return _$MyClass_getName(self.jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func staticMethod() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                static func create() -> MyClass
            }
            """,
            expandedSource: """
                struct MyClass {
                    static func create() -> MyClass {
                        return _$create()
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func classMethod() {
        assertMacroExpansion(
            """
            class MyClass {
                @JSFunction
                class func create() -> MyClass
            }
            """,
            expandedSource: """
                class MyClass {
                    class func create() -> MyClass {
                        return _$create()
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func initializer() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                init(name: String)
            }
            """,
            expandedSource: """
                struct MyClass {
                    init(name: String) {
                        let jsObject = _$MyClass_init(name)
                        self.init(unsafelyWrapping: jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func initializerThrows() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                init(name: String) throws
            }
            """,
            expandedSource: """
                struct MyClass {
                    init(name: String) throws {
                        let jsObject = try _$MyClass_init(name)
                        self.init(unsafelyWrapping: jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func initializerAsyncThrows() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                init(name: String) async throws
            }
            """,
            expandedSource: """
                struct MyClass {
                    init(name: String) async throws {
                        let jsObject = try await _$MyClass_init(name)
                        self.init(unsafelyWrapping: jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func initializerWithoutEnclosingType() {
        assertMacroExpansion(
            """
            @JSFunction
            init()
            """,
            expandedSource: """
                init()
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSFunction can only be applied to functions or initializers.",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func unsupportedDeclaration() {
        assertMacroExpansion(
            """
            @JSFunction
            var property: String
            """,
            expandedSource: """
                var property: String
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSFunction can only be applied to functions or initializers.",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func enumInstanceMethod() {
        assertMacroExpansion(
            """
            enum MyEnum {
                @JSFunction
                func getValue() -> Int
            }
            """,
            expandedSource: """
                enum MyEnum {
                    func getValue() -> Int {
                        return _$MyEnum_getValue(self.jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func actorInstanceMethod() {
        assertMacroExpansion(
            """
            actor MyActor {
                @JSFunction
                func getValue() -> Int
            }
            """,
            expandedSource: """
                actor MyActor {
                    func getValue() -> Int {
                        return _$MyActor_getValue(self.jsObject)
                    }
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func functionWithExistingBody() {
        assertMacroExpansion(
            """
            @JSFunction
            func greet(name: String) -> String {
                return "Hello, \\(name)"
            }
            """,
            expandedSource: """
                func greet(name: String) -> String {
                    return _$greet(name)
                }
                """,
            macros: ["JSFunction": JSFunctionMacro.self],
            indentationWidth: indentationWidth
        )
    }
}
