import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSGetterFunctionMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSGetterFunction": MacroSpec(type: JSGetterFunctionMacro.self)
    ]

    @Test func topLevelFunction() {
        TestSupport.assertMacroExpansion(
            """
            @JSGetterFunction
            func count() throws(JSException) -> Int
            """,
            expandedSource: """
                func count() throws(JSException) -> Int {
                    return try _$count_get()
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceFunction() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                @JSGetterFunction
                func name() throws(JSException) -> String
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass {
                    func name() throws(JSException) -> String {
                        return try _$MyClass_name_get(self.jsObject)
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func noncopyableInstanceFunction() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass: ~Copyable {
                @JSGetterFunction
                func style() throws(JSException) -> Style
            }
            """,
            expandedSource: """
                @JSClass
                struct MyClass: ~Copyable {
                    func style() throws(JSException) -> Style {
                        return try _$MyClass_style_get(self.jsRef)
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceFunctionRequiresJSClass() {
        TestSupport.assertMacroExpansion(
            """
            struct MyClass {
                @JSGetterFunction
                func name() throws(JSException) -> String
            }
            """,
            expandedSource: """
                struct MyClass {
                    func name() throws(JSException) -> String {
                        return try _$MyClass_name_get(self.jsObject)
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

    @Test func missingThrowsClause() {
        TestSupport.assertMacroExpansion(
            """
            @JSGetterFunction
            func count() -> Int
            """,
            expandedSource: """
                func count() -> Int {
                    return try _$count_get()
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSGetterFunction throws must be declared as throws(JSException).",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSGetterFunction must propagate JavaScript errors as JSException.",
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
                @JSGetterFunction
                func count() throws(JSException) -> Int
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func throwsWrongType() {
        TestSupport.assertMacroExpansion(
            """
            @JSGetterFunction
            func count() throws(CustomError) -> Int
            """,
            expandedSource: """
                func count() throws(CustomError) -> Int {
                    return try _$count_get()
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSGetterFunction throws must be declared as throws(JSException).",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSGetterFunction must propagate JavaScript errors as JSException.",
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
                @JSGetterFunction
                func count() throws(JSException) -> Int
                """,
            indentationWidth: indentationWidth,
        )
    }
}
