import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSSetterMacroTests {
    private let indentationWidth: Trivia = .spaces(4)

    @Test func topLevelSetter() {
        assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo) throws(JSException)
            """,
            expandedSource: """
                func setFoo(_ value: Foo) throws(JSException) {
                    try _$foo_set(value)
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func topLevelSetterWithNamedParameter() {
        assertMacroExpansion(
            """
            @JSSetter
            func setCount(count: Int) throws(JSException)
            """,
            expandedSource: """
                func setCount(count: Int) throws(JSException) {
                    try _$count_set(count)
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func instanceSetter() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSSetter
                func setName(_ name: String) throws(JSException)
            }
            """,
            expandedSource: """
                struct MyClass {
                    func setName(_ name: String) throws(JSException) {
                        try _$MyClass_name_set(self.jsObject, name)
                    }
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func staticSetter() {
        assertMacroExpansion(
            """
            struct MyClass {
                @JSSetter
                static func setVersion(_ version: String) throws(JSException)
            }
            """,
            expandedSource: """
                struct MyClass {
                    static func setVersion(_ version: String) throws(JSException) {
                        try _$version_set(version)
                    }
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func classSetter() {
        assertMacroExpansion(
            """
            class MyClass {
                @JSSetter
                class func setConfig(_ config: Config) throws(JSException)
            }
            """,
            expandedSource: """
                class MyClass {
                    class func setConfig(_ config: Config) throws(JSException) {
                        try _$config_set(config)
                    }
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func enumSetter() {
        assertMacroExpansion(
            """
            enum MyEnum {
                @JSSetter
                func setValue(_ value: Int) throws(JSException)
            }
            """,
            expandedSource: """
                enum MyEnum {
                    func setValue(_ value: Int) throws(JSException) {
                        try _$MyEnum_value_set(self.jsObject, value)
                    }
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func actorSetter() {
        assertMacroExpansion(
            """
            actor MyActor {
                @JSSetter
                func setState(_ state: String) throws(JSException)
            }
            """,
            expandedSource: """
                actor MyActor {
                    func setState(_ state: String) throws(JSException) {
                        try _$MyActor_state_set(self.jsObject, state)
                    }
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func setterWithExistingBody() {
        assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo) throws(JSException) {
                print("Setting foo")
            }
            """,
            expandedSource: """
                func setFoo(_ value: Foo) throws(JSException) {
                    try _$foo_set(value)
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func invalidSetterName() {
        assertMacroExpansion(
            """
            @JSSetter
            func updateFoo(_ value: Foo) throws(JSException)
            """,
            expandedSource: """
                func updateFoo(_ value: Foo) throws(JSException)
                """,
            diagnostics: [
                DiagnosticSpec(
                    message:
                        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo').",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func setterNameTooShort() {
        assertMacroExpansion(
            """
            @JSSetter
            func set(_ value: Foo) throws(JSException)
            """,
            expandedSource: """
                func set(_ value: Foo) throws(JSException)
                """,
            diagnostics: [
                DiagnosticSpec(
                    message:
                        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo').",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func setterWithoutParameter() {
        assertMacroExpansion(
            """
            @JSSetter
            func setFoo() throws(JSException)
            """,
            expandedSource: """
                func setFoo() throws(JSException)
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSSetter function must have at least one parameter.",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func unsupportedDeclaration() {
        assertMacroExpansion(
            """
            @JSSetter
            var property: String
            """,
            expandedSource: """
                var property: String
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSSetter can only be applied to functions.",
                    line: 1,
                    column: 1
                )
            ],
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func setterWithMultipleWords() {
        assertMacroExpansion(
            """
            @JSSetter
            func setConnectionTimeout(_ timeout: Int) throws(JSException)
            """,
            expandedSource: """
                func setConnectionTimeout(_ timeout: Int) throws(JSException) {
                    try _$connectionTimeout_set(timeout)
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }

    @Test func setterWithSingleLetterProperty() {
        assertMacroExpansion(
            """
            @JSSetter
            func setX(_ x: Int) throws(JSException)
            """,
            expandedSource: """
                func setX(_ x: Int) throws(JSException) {
                    try _$x_set(x)
                }
                """,
            macros: ["JSSetter": JSSetterMacro.self],
            indentationWidth: indentationWidth
        )
    }
}
