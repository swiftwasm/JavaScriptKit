import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import BridgeJSMacros

@Suite struct JSClassMacroTests {
    private let indentationWidth: Trivia = .spaces(4)
    private let macroSpecs: [String: MacroSpec] = [
        "JSClass": MacroSpec(type: JSClassMacro.self, conformances: ["_JSBridgedClass"])
    ]

    @Test func emptyStruct() {
        assertMacroExpansion(
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
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithExistingJSObject() {
        assertMacroExpansion(
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
        assertMacroExpansion(
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

    @Test func structWithBothExisting() {
        assertMacroExpansion(
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
        assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var name: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    var name: String

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
        assertMacroExpansion(
            """
            @JSClass
            class MyClass {
            }
            """,
            expandedSource: """
                class MyClass {
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

    @Test func _enum() {
        assertMacroExpansion(
            """
            @JSClass
            enum MyEnum {
            }
            """,
            expandedSource: """
                enum MyEnum {
                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyEnum: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func _actor() {
        assertMacroExpansion(
            """
            @JSClass
            actor MyActor {
            }
            """,
            expandedSource: """
                actor MyActor {
                    let jsObject: JSObject

                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                }

                extension MyActor: _JSBridgedClass {
                }
                """,
            macroSpecs: macroSpecs,
            indentationWidth: indentationWidth
        )
    }

    @Test func structWithDifferentJSObjectName() {
        assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var otherProperty: String
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    var otherProperty: String

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
        assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                init(name: String) {
                }
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    init(name: String) {
                    }

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
        assertMacroExpansion(
            """
            @JSClass
            struct MyClass {
                var name: String
                var age: Int
            }
            """,
            expandedSource: """
                struct MyClass {
                    let jsObject: JSObject

                    var name: String
                    var age: Int

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
        assertMacroExpansion(
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
        assertMacroExpansion(
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
