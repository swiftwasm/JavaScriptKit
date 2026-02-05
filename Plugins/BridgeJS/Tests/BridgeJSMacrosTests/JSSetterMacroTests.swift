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
            @JSClass
            struct MyClass {
                @JSSetter
                func setName(_ name: String) throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
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

    @Test func instanceSetterRequiresJSClass() {
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
                        try _$MyClass_version_set(version)
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
                        try _$MyClass_config_set(config)
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

    @Test func enumSetter() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            enum MyEnum {
                @JSSetter
                func setValue(_ value: Int) throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
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
            @JSClass
            actor MyActor {
                @JSSetter
                func setState(_ state: String) throws(JSException)
            }
            """,
            expandedSource: """
                @JSClass
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
                func updateFoo(_ value: Foo) throws(JSException) {
                    fatalError("@JSSetter function name must start with 'set' followed by a property name")
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message:
                        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo').",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Setter names must start with 'set' followed by the property name.",
                            line: 2,
                            column: 6
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Rename setter to 'setFoo'")
                    ]
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
                func set(_ value: Foo) throws(JSException) {
                    fatalError("@JSSetter function name must start with 'set' followed by a property name")
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message:
                        "@JSSetter function name must start with 'set' followed by a property name (e.g., 'setFoo').",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Setter names must start with 'set' followed by the property name.",
                            line: 2,
                            column: 6
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Rename setter to 'setFoo'")
                    ]
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
                func setFoo() throws(JSException) {
                    fatalError("@JSSetter function must have at least one parameter")
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSSetter function must have at least one parameter.",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSSetter needs a parameter for the value being assigned.",
                            line: 1,
                            column: 1
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Add a value parameter to the setter")
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            applyFixIts: ["Add a value parameter to the setter"],
            fixedSource: """
                @JSSetter
                func setFoo(_ value: <#Type#>) throws(JSException)
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterMissingThrows() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo)
            """,
            expandedSource: """
                func setFoo(_ value: Foo) {
                    try _$foo_set(value)
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSSetter function must declare throws(JSException).",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSSetter must propagate JavaScript errors as JSException.",
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
                @JSSetter
                func setFoo(_ value: Foo) throws(JSException)
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterThrowsWrongType() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo) throws(CustomError)
            """,
            expandedSource: """
                func setFoo(_ value: Foo) throws(CustomError) {
                    try _$foo_set(value)
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSSetter function must declare throws(JSException).",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSSetter must propagate JavaScript errors as JSException.",
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
                @JSSetter
                func setFoo(_ value: Foo) throws(JSException)
                """,
            indentationWidth: indentationWidth,
        )
    }

    @Test func setterThrowsErrorAccepted() {
        TestSupport.assertMacroExpansion(
            """
            @JSSetter
            func setFoo(_ value: Foo) throws(Error)
            """,
            expandedSource: """
                func setFoo(_ value: Foo) throws(Error) {
                    try _$foo_set(value)
                }
                """,
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
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "@JSSetter should be attached to a method that writes a JavaScript property.",
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
