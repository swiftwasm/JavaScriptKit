import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSSetterMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSSetter": MacroSpec(type: JSSetterMacro.self)
    ]

    @Test func topLevelSetter() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo) throws(JSException)
            """,
            expandedSource: """
                func setFoo(_ value: Foo) throws(JSException) {
                    try _$foo_set(value)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func topLevelSetterWithNamedParameter() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setCount(count: Int) throws(JSException)
            """,
            expandedSource: """
                func setCount(count: Int) throws(JSException) {
                    try _$count_set(count)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func instanceSetter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func staticSetter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func classSetter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func enumSetter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func actorSetter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterWithExistingBody() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func invalidSetterName() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterNameTooShort() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterWithoutParameter() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func unsupportedDeclaration() {
        TestSupport.assertMacroExpansion(
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
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterWithMultipleWords() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setConnectionTimeout(_ timeout: Int) throws(JSException)
            """,
            expandedSource: """
                func setConnectionTimeout(_ timeout: Int) throws(JSException) {
                    try _$connectionTimeout_set(timeout)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterWithSingleLetterProperty() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setX(_ x: Int) throws(JSException)
            """,
            expandedSource: """
                func setX(_ x: Int) throws(JSException) {
                    try _$x_set(x)
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }
}
