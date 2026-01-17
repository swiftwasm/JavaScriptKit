import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSGetterMacroTests {
    private let indentationWidth: Trivia = .spaces(4)

    @Test func topLevelVariable() {
        assertMacroExpansion(
            """
            @JSGetter
            var count: Int
            """,
            expandedSource: """
                var count: Int {
                    get throws(JSException) {
                        return try _$count_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelLet() {
        assertMacroExpansion(
            """
            @JSGetter
            let constant: String
            """,
            expandedSource: """
                let constant: String {
                    get throws(JSException) {
                        return try _$constant_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func instanceProperty() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSGetter
                var name: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    var name: String {
                        get throws(JSException) {
                            return try _$MyClass_name_get(self.jsObject)
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func instanceLetProperty() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSGetter
                let id: Int
            }
            """,
            expandedSource: """
                struct MyClass {
                    let id: Int {
                        get throws(JSException) {
                            return try _$MyClass_id_get(self.jsObject)
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func staticProperty() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSGetter
                static var version: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    static var version: String {
                        get throws(JSException) {
                            return try _$version_get()
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func classProperty() {
        assertMacroExpansion(
            """
            class MyClass {
                @JSGetter
                class var version: String
            }
            """,
            expandedSource: """
                class MyClass {
                    class var version: String {
                        get throws(JSException) {
                            return try _$version_get()
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func enumProperty() {
        assertMacroExpansion(
            """
            enum MyEnum {
                @JSGetter
                var value: Int
            }
            """,
            expandedSource: """
                enum MyEnum {
                    var value: Int {
                        get throws(JSException) {
                            return try _$MyEnum_value_get(self.jsObject)
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func actorProperty() {
        assertMacroExpansion(
            """
            actor MyActor {
                @JSGetter
                var state: String
            }
            """,
            expandedSource: """
                actor MyActor {
                    var state: String {
                        get throws(JSException) {
                            return try _$MyActor_state_get(self.jsObject)
                        }
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func variableWithExistingAccessor() {
        assertMacroExpansion(
            """
            @JSGetter
            var count: Int {
                return 0
            }
            """,
            expandedSource: """
                var count: Int {
                    get {
                        return 0
                    }
                    get throws(JSException) {
                        return try _$count_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func variableWithInitializer() {
        assertMacroExpansion(
            """
            @JSGetter
            var count: Int = 0
            """,
            expandedSource: """
                var count: Int {
                    get throws(JSException) {
                        return try _$count_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func multipleBindings() {
        assertMacroExpansion(
            """
            @JSGetter
            var x: Int, y: Int
            """,
            expandedSource: """
                var x: Int, y: Int
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSGetter can only be applied to single-variable declarations.",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func unsupportedDeclaration() {
        assertMacroExpansion(
            """
            @JSGetter
            func test() {}
            """,
            expandedSource: """
                func test() {}
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSGetter can only be applied to single-variable declarations.",
                    line: 1,
                    column: 1,
                    severity: .error
                )
            ],
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func variableWithTrailingComment() {
        assertMacroExpansion(
            """
            @JSGetter
            var count: Int // comment
            """,
            expandedSource: """
                var count: Int { // comment
                    get throws(JSException) {
                        return try _$count_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func variableWithUnderscoreName() {
        assertMacroExpansion(
            """
            @JSGetter
            var _internal: String
            """,
            expandedSource: """
                var _internal: String {
                    get throws(JSException) {
                        return try _$internal_get()
                    }
                }
                """,
            macros: ["JSGetter": JSGetterMacro.self],
            indentationWidth: indentationWidth
        )
    }
}
