import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSFunctionMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSFunction": MacroSpec(type: JSFunctionMacro.self)
    ]

    @Test func topLevelFunction() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func greet(name: String) -> String
            """,
            expandedSource: """
                func greet(name: String) -> String {
                    return _$greet(name)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionVoidReturn() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func log(message: String)
            """,
            expandedSource: """
                func log(message: String) {
                    _$log(message)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionWithExplicitVoidReturn() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func log(message: String) -> Void
            """,
            expandedSource: """
                func log(message: String) -> Void {
                    _$log(message)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionWithEmptyTupleReturn() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func log(message: String) -> ()
            """,
            expandedSource: """
                func log(message: String) -> () {
                    _$log(message)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionThrows() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func parse(json: String) throws -> [String: Any]
            """,
            expandedSource: """
                func parse(json: String) throws -> [String: Any] {
                    return try _$parse(json)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionAsync() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func fetch(url: String) async -> String
            """,
            expandedSource: """
                func fetch(url: String) async -> String {
                    return await _$fetch(url)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionAsyncThrows() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func fetch(url: String) async throws -> String
            """,
            expandedSource: """
                func fetch(url: String) async throws -> String {
                    return try await _$fetch(url)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionWithUnderscoreParameter() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func process(_ value: Int) -> Int
            """,
            expandedSource: """
                func process(_ value: Int) -> Int {
                    return _$process(value)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionWithMultipleParameters() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func add(a: Int, b: Int) -> Int
            """,
            expandedSource: """
                func add(a: Int, b: Int) -> Int {
                    return _$add(a, b)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceMethod() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func staticMethod() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func classMethod() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func initializer() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func initializerThrows() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func initializerAsyncThrows() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func initializerWithoutEnclosingType() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func unsupportedDeclaration() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func enumInstanceMethod() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func actorInstanceMethod() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func functionWithExistingBody() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }
}
