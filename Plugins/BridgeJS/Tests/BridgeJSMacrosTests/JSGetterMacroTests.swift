import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSGetterMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSGetter": MacroSpec(type: JSGetterMacro.self)
    ]

    @Test func topLevelVariable() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelLet() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceProperty() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceLetProperty() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func staticProperty() {
        TestSupport.assertMacroExpansion(
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
                            return try _$MyClass_version_get()
                        }
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func classProperty() {
        TestSupport.assertMacroExpansion(
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
                            return try _$MyClass_version_get()
                        }
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func enumProperty() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func actorProperty() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func variableWithExistingAccessor() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func variableWithInitializer() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func multipleBindings() {
        TestSupport.assertMacroExpansion(
            """
            @JSGetter
            var x: Int, y: Int
            """,
            expandedSource: """
                var x: Int, y: Int
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "accessor macro can only be applied to a single variable",
                    line: 1,
                    column: 1,
                    severity: .error
                ),
                DiagnosticSpec(
                    message: "peer macro can only be applied to a single variable",
                    line: 1,
                    column: 1,
                    severity: .error
                ),
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func unsupportedDeclaration() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    #if canImport(SwiftSyntax601)
    // https://github.com/swiftlang/swift-syntax/pull/2722
    @Test func variableWithTrailingComment() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }
    #endif

    @Test func variableWithUnderscoreName() {
        TestSupport.assertMacroExpansion(
            """
            @JSGetter
            var _internal: String
            """,
            expandedSource: """
                var _internal: String {
                    get throws(JSException) {
                        return try _$_internal_get()
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }
}
