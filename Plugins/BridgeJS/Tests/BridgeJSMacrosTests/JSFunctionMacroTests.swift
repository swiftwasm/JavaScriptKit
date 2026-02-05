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
            func greet(name: String) throws(JSException) -> String
            """,
            expandedSource: """
                func greet(name: String) throws(JSException) -> String {
                    return try _$greet(name)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceMethodRequiresJSClass() {
        TestSupport.assertMacroExpansion(
            """
            struct MyClass {
                @JSFunction
                func getName() throws(JSException) -> String
            }
            """,
            expandedSource: """
                struct MyClass {
                    func getName() throws(JSException) -> String {
                        return try _$MyClass_getName(self.jsObject)
                    }
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "JavaScript members must be declared inside a @JSClass struct.",
                    line: 2,
                    column: 5
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionVoidReturn() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func log(message: String) throws(JSException)
            """,
            expandedSource: """
                func log(message: String) throws(JSException) {
                    try _$log(message)
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
            func log(message: String) throws(JSException) -> Void
            """,
            expandedSource: """
                func log(message: String) throws(JSException) -> Void {
                    try _$log(message)
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
            func log(message: String) throws(JSException) -> ()
            """,
            expandedSource: """
                func log(message: String) throws(JSException) -> () {
                    try _$log(message)
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
            func parse(json: String) throws(JSException) -> [String: Any]
            """,
            expandedSource: """
                func parse(json: String) throws(JSException) -> [String: Any] {
                    return try _$parse(json)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionThrowsMissingType() {
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

    @Test func topLevelFunctionThrowsWrongType() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func parse(json: String) throws(CustomError) -> [String: Any]
            """,
            expandedSource: """
                func parse(json: String) throws(CustomError) -> [String: Any] {
                    return try _$parse(json)
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSFunction throws must be declared as throws(JSException).",
                    line: 1,
                    column: 1,
                    severity: .error,
                    notes: [
                        NoteSpec(
                            message: "@JSFunction must propagate JavaScript errors as JSException.",
                            line: 1,
                            column: 1
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Declare throws(JSException)")
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            applyFixIts: ["Declare throws(JSException)"],
            fixedSource: """
                @JSFunction
                func parse(json: String) throws(JSException) -> [String: Any]
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionMissingThrowsClause() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func greet(name: String) -> String
            """,
            expandedSource: """
                func greet(name: String) -> String {
                    return try _$greet(name)
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSFunction throws must be declared as throws(JSException).",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSFunction must propagate JavaScript errors as JSException.",
                            line: 1,
                            column: 1
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Declare throws(JSException)")
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            applyFixIts: ["Declare throws(JSException)"],
            fixedSource: """
                @JSFunction
                func greet(name: String) throws(JSException) -> String
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelFunctionAsync() {
        TestSupport.assertMacroExpansion(
            """
            @JSFunction
            func fetch(url: String) async throws(JSException) -> String
            """,
            expandedSource: """
                func fetch(url: String) async throws(JSException) -> String {
                    return try await _$fetch(url)
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
            func fetch(url: String) async throws(JSException) -> String
            """,
            expandedSource: """
                func fetch(url: String) async throws(JSException) -> String {
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
            func process(_ value: Int) throws(JSException) -> Int
            """,
            expandedSource: """
                func process(_ value: Int) throws(JSException) -> Int {
                    return try _$process(value)
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
            func add(a: Int, b: Int) throws(JSException) -> Int
            """,
            expandedSource: """
                func add(a: Int, b: Int) throws(JSException) -> Int {
                    return try _$add(a, b)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceMethod() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                @JSFunction
                func getName() throws(JSException) -> String
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass {
                    func getName() throws(JSException) -> String {
                        return try _$MyClass_getName(self.jsObject)
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
                static func create() throws(JSException) -> MyClass
            }
            """,
            expandedSource: """
                struct MyClass {
                    static func create() throws(JSException) -> MyClass {
                        return try _$MyClass_create()
                    }
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "JavaScript members must be declared inside a @JSClass struct.",
                    line: 2,
                    column: 5
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func classMethod() {
        TestSupport.assertMacroExpansion(
            """
            class MyClass {
                @JSFunction
                class func create() throws(JSException) -> MyClass
            }
            """,
            expandedSource: """
                class MyClass {
                    class func create() throws(JSException) -> MyClass {
                        return try _$MyClass_create()
                    }
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "JavaScript members must be declared inside a @JSClass struct.",
                    line: 2,
                    column: 5
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func initializer() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                @JSFunction
                init(name: String) throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass {
                    init(name: String) throws(JSException) {
                        let jsObject = try _$MyClass_init(name)
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
            @JSClass
            struct MyClass {
                @JSFunction
                init(name: String) throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass {
                    init(name: String) throws(JSException) {
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
            @JSClass
            struct MyClass {
                @JSFunction
                init(name: String) async throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass {
                    init(name: String) async throws(JSException) {
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
                init() {
                    fatalError("@JSFunction init must be inside a type")
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSFunction can only be applied to functions or initializers.",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Move this initializer inside a JS wrapper type annotated with @JSClass.",
                            line: 1,
                            column: 1
                        )
                    ]
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
                    column: 1,
                    notes: [
                        NoteSpec(
                            message:
                                "Place @JSFunction on a function or initializer; use @JSGetter/@JSSetter for properties.",
                            line: 1,
                            column: 1
                        )
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func enumInstanceMethod() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            enum MyEnum {
                @JSFunction
                func getValue() throws(JSException) -> Int
            }
            """,
            expandedSource: """
                @JSClass
                enum MyEnum {
                    func getValue() throws(JSException) -> Int {
                        return try _$MyEnum_getValue(self.jsObject)
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
            @JSClass
            actor MyActor {
                @JSFunction
                func getValue() throws(JSException) -> Int
            }
            """,
            expandedSource: """
                @JSClass
                actor MyActor {
                    func getValue() throws(JSException) -> Int {
                        return try _$MyActor_getValue(self.jsObject)
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
            func greet(name: String) throws(JSException) -> String {
                return "Hello, \\(name)"
            }
            """,
            expandedSource: """
                func greet(name: String) throws(JSException) -> String {
                    return try _$greet(name)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }
}
