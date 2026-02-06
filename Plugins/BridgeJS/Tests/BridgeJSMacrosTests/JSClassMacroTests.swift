import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSClassMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSClass": MacroSpec(type: JSClassMacro.self, conformances: ["_JSBridgedClass"])
    ]

    @Test func emptyStruct() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
            }
            """,
            expandedSource: """
                struct MyClass {

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth,
        )
    }

    @Test func structWithExistingJSObject() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                let jsObject: JSObject
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithExistingInit() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                init(unsafelyWrapping jsObject: JSObject) {
                    self.jsObject = jsObject
                }
            }
            """,
            expandedSource: """
                struct MyClass {
                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }

                    let jsObject: JSObject
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithBothExisting() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                let jsObject: JSObject

                init(unsafelyWrapping jsObject: JSObject) {
                    self.jsObject = jsObject
                }
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithMembers() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var name: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    var name: String

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func _class() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            class MyClass {
            }
            """,
            expandedSource: """
                class MyClass {
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSClass can only be applied to structs.",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Use @JSClass on a struct wrapper to synthesize jsObject and JS bridging members.",
                            line: 1,
                            column: 1
                        )
                    ],
                    fixIts: [
                        FixItSpec(message: "Change 'class' to 'struct'")
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func _enum() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            enum MyEnum {
            }
            """,
            expandedSource: """
                enum MyEnum {
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSClass can only be applied to structs.",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Use @JSClass on a struct wrapper to synthesize jsObject and JS bridging members.",
                            line: 1,
                            column: 1
                        )
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func _actor() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            actor MyActor {
            }
            """,
            expandedSource: """
                actor MyActor {
                }
                """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@JSClass can only be applied to structs.",
                    line: 1,
                    column: 1,
                    notes: [
                        NoteSpec(
                            message: "Use @JSClass on a struct wrapper to synthesize jsObject and JS bridging members.",
                            line: 1,
                            column: 1
                        )
                    ]
                )
            ],
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithDifferentJSObjectName() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var otherProperty: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    var otherProperty: String

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithDifferentInit() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                init(name: String) {
                }
            }
            """,
            expandedSource: """
                struct MyClass {
                    init(name: String) {
                    }

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithMultipleMembers() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var name: String
                var age: Int
            }
            """,
            expandedSource: """
                struct MyClass {
                    var name: String
                    var age: Int

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithComment() {
        TestSupport.assertMacroExpansion(
            """
            /// Documentation comment
            @JSClass
            struct MyClass {
            }
            """,
            expandedSource: """
                /// Documentation comment
                struct MyClass {

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyClass: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structAlreadyConforms() {
        TestSupport.assertMacroExpansion(
            """
            @JSClass
            struct MyClass: _JSBridgedClass {
            }
            """,
            expandedSource: """
                struct MyClass: _JSBridgedClass {

                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }
}
