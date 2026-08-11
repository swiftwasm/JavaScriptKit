import Foundation
import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct DiagnosticsTests {
    private func moduleDiagnostics(source: String) -> BridgeJSCoreDiagnosticError? {
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        do {
            _ = try swiftAPI.finalize()
            return nil
        } catch let error as BridgeJSCoreDiagnosticError {
            return error
        } catch {
            Issue.record("Unexpected error: \(error)")
            return nil
        }
    }

    @Test
    func missingJavaScriptModuleProducesDiagnostic() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .snippet("/missing.js")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript snippet file was not found at '/missing.js'"))
        #expect(diagnostics.description.contains("test.swift:2:28:"))
    }

    @Test
    func bareJavaScriptModuleSpecifierIsAccepted() throws {
        let source = """
            let unrelated = 0
            @JSFunction(jsName: "basename", from: .module("node:path")) func imported() throws(JSException)
            """
        #expect(moduleDiagnostics(source: source) == nil)
    }

    @Test
    func relativeJavaScriptModuleSpecifierIsRejected() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .module("./missing.js")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("Relative JavaScript module specifiers are not supported"))
        #expect(diagnostics.description.contains("test.swift:2:27:"))
    }

    @Test
    func emptyJavaScriptModuleSpecifierIsRejected() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .module("")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript module specifier must not be empty."))
    }

    @Test
    func defaultExportRequiresModuleOrigin() throws {
        let source = """
            let unrelated = 0
            @JSFunction(jsName: .default) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(
            diagnostics.description.contains(
                "'jsName: .default' requires 'from: .module(...)' or 'from: .snippet(...)'."
            )
        )
    }

    @Test
    func defaultExportIsRejectedForGlobalOrigin() throws {
        let source = """
            let unrelated = 0
            @JSFunction(jsName: .default, from: .global) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("globalThis has no default export"))
    }

    @Test
    func defaultExportIsRejectedForSetter() throws {
        let source = """
            @JSClass(from: .module("node:fs")) struct Wrapper {
                @JSSetter(jsName: .default) func setValue(_ value: Int) throws(JSException)
            }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("ECMAScript module bindings are read-only"))
    }

    @Test
    func defaultExportIsRejectedForClassMember() throws {
        let source = """
            @JSClass(from: .module("node:fs")) struct Wrapper {
                @JSFunction(jsName: .default) func value() throws(JSException) -> Int
            }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("is not supported on a class member"))
    }

    /// `jsName: nil` is valid Swift and means the same as omitting the argument.
    @Test
    func explicitNilJSNameIsAccepted() throws {
        let source = """
            let unrelated = 0
            @JSFunction(jsName: nil, from: .global) func imported() throws(JSException)
            """
        #expect(moduleDiagnostics(source: source) == nil)
    }

    /// `JSName.name(_:)` is public and documented, so its explicit spelling must work.
    @Test
    func explicitNameCaseSpellingIsAccepted() throws {
        let source = """
            let unrelated = 0
            @JSFunction(jsName: .name("basename"), from: .module("node:path")) func imported() throws(JSException)
            """
        #expect(moduleDiagnostics(source: source) == nil)
    }

    @Test
    func jsNameMustBeStringLiteralOrDefault() throws {
        let source = """
            let name = "basename"
            @JSFunction(jsName: name, from: .module("node:path")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("jsName must be a string literal or '.default'."))
    }

    /// A rooted path in `.module(...)` is the most likely mistake now that the two cases
    /// are separate, so it must point at `.snippet(...)` rather than being passed to the
    /// JavaScript resolver where it would fail much later.
    @Test
    func rootedPathInModuleSuggestsSnippet() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .module("/Modules/utils.mjs")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("looks like a file in this target"))
        #expect(diagnostics.description.contains(#"from: .snippet("/Modules/utils.mjs")"#))
    }

    /// The reverse mistake: a bare specifier in `.snippet(...)` must point at `.module(...)`.
    @Test
    func bareSpecifierInSnippetSuggestsModule() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .snippet("node:path")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript snippet paths must start with '/'"))
        #expect(diagnostics.description.contains(#"from: .module("node:path")"#))
    }

    /// A snippet origin may also name a default export.
    @Test
    func defaultExportIsAcceptedForSnippetOrigin() throws {
        let source = """
            let unrelated = 0
            @JSGetter(jsName: .default, from: .snippet("/Modules/utils.mjs")) var value: JSObject
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        // The file does not exist in this fixture, so the missing file must be the only
        // complaint. Match on the diagnostic wording, not on `.default` itself, since the
        // rendered diagnostic echoes the source line back.
        #expect(diagnostics.description.contains("JavaScript snippet file was not found"))
        #expect(!diagnostics.description.contains("requires 'from:"))
    }

    @Test
    func javaScriptModulePathMustNotTraverse() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .snippet("/../missing.js")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript snippet paths must not contain '..'"))
        #expect(diagnostics.description.contains("test.swift:2:28:"))
    }

    @Test
    func javaScriptModulePathMustUseSupportedExtension() throws {
        let source = """
            let unrelated = 0
            @JSFunction(from: .snippet("/module.ts")) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript snippets must use a '.js' or '.mjs' extension"))
        #expect(diagnostics.description.contains("test.swift:2:28:"))
    }

    @Test
    func javaScriptModulePathMustBeStringLiteral() throws {
        let source = """
            let modulePath = "/module.js"
            @JSFunction(from: .module(modulePath)) func imported() throws(JSException)
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("JavaScript module specifier must be a string literal."))
        #expect(diagnostics.description.contains("test.swift:2:27:"))
    }

    /// Returns the first parameter's type node from a function in the source (the first `@JS func`-like decl), for pinpointing diagnostics.
    private func firstParameterTypeNode(source: String) -> TypeSyntax? {
        let tree = Parser.parse(source: source)
        for stmt in tree.statements {
            if let funcDecl = stmt.item.as(FunctionDeclSyntax.self),
                let firstParam = funcDecl.signature.parameterClause.parameters.first
            {
                return firstParam.type
            }
        }
        return nil
    }

    @Test
    func diagnosticIncludesLocationSourceAndHint() throws {
        let source = "@JS func foo(_ bar: A<X>) {}\n"
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(
            node: typeNode,
            message: "Unsupported type 'A<X>'.",
            hint: "Only primitive types and types defined in the same module are allowed"
        )
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        let expectedPrefix = """
            <stdin>:1:21: error: Unsupported type 'A<X>'.
              1 | @JS func foo(_ bar: A<X>) {}
                |                     `- error: Unsupported type 'A<X>'.
              2 |
            """.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(description.hasPrefix(expectedPrefix))
        #expect(description.contains("Hint: Only primitive types and types defined in the same module are allowed"))
    }

    @Test
    func diagnosticOmitsHintWhenNotProvided() throws {
        let source = "@JS static func foo() {}\n"
        let tree = Parser.parse(source: source)
        let diagnostic = DiagnosticError(
            node: tree,
            message: "Top-level functions cannot be static",
            hint: nil
        )
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        let expectedPrefix = """
            <stdin>:1:1: error: Top-level functions cannot be static
              1 | @JS static func foo() {}
                | `- error: Top-level functions cannot be static
              2 |
            """.trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(description.hasPrefix(expectedPrefix))
        #expect(!description.contains("Hint:"))
    }

    @Test
    func diagnosticUsesGivenFileNameNotStdin() throws {
        let source = "@JS func foo(_ bar: A<X>) {}\n"
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(
            node: typeNode,
            message: "Unsupported type 'A<X>'.",
            hint: nil
        )
        let description = diagnostic.formattedDescription(fileName: "Sources/Foo.swift", colorize: false)
        #expect(description.hasPrefix("Sources/Foo.swift:1:21: error: Unsupported type 'A<X>'."))
    }

    @Test
    func diagnosticWithColorizeTrueIncludesANSISequences() throws {
        let source = "@JS func foo(_ bar: A<X>) {}\n"
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(
            node: typeNode,
            message: "Unsupported type 'A<X>'.",
            hint: nil
        )
        let description = diagnostic.formattedDescription(fileName: "-", colorize: true)
        let esc = "\u{001B}"
        let boldRed = "\(esc)[1;31m"
        let boldDefault = "\(esc)[1;39m"
        let reset = "\(esc)[0;0m"
        let cyan = "\(esc)[0;36m"
        let underline = "\(esc)[4;39m"
        let expected =
            "<stdin>:1:21: \(boldRed)error: \(boldDefault)Unsupported type 'A<X>'.\(reset)\n"
            + "\(cyan)  1\(reset) | @JS func foo(_ bar: \(underline)A<X>\(reset)) {}\n"
            + "    |                     `- \(boldRed)error: \(boldDefault)Unsupported type 'A<X>'.\(reset)\n"
            + "\(cyan)  2\(reset) | "
        #expect(description == expected)
    }

    // MARK: - Context source lines

    @Test
    func showsOnePreviousLineWhenErrorNotOnFirstLine() throws {
        let source = """
            preamble
            @JS func foo(_ bar: A<X>) {}
            """
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(node: typeNode, message: "Unsupported type 'A<X>'.", hint: nil)
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        #expect(description.contains("  1 | preamble"))
        #expect(description.contains("  2 | @JS func foo(_ bar: A<X>) {}"))
        #expect(description.contains("<stdin>:2:"))
    }

    @Test
    func showsThreePreviousLinesWhenAvailable() throws {
        let source = """
            first
            second
            third
            @JS func foo(_ bar: A<X>) {}
            """
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(node: typeNode, message: "Unsupported type 'A<X>'.", hint: nil)
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        #expect(description.contains("  1 | first"))
        #expect(description.contains("  2 | second"))
        #expect(description.contains("  3 | third"))
        #expect(description.contains("  4 | @JS func foo(_ bar: A<X>) {}"))
        #expect(description.contains("<stdin>:4:"))
    }

    @Test
    func capsContextAtThreePreviousLines() throws {
        let source = """
            line0
            line1
            line2
            line3
            @JS func foo(_ bar: A<X>) {}
            """
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(node: typeNode, message: "Unsupported type 'A<X>'.", hint: nil)
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        #expect(!description.contains("  1 | line0"))
        #expect(description.contains("  2 | line1"))
        #expect(description.contains("  3 | line2"))
        #expect(description.contains("  4 | line3"))
        #expect(description.contains("  5 | @JS func foo(_ bar: A<X>) {}"))
        #expect(description.contains("<stdin>:5:"))
    }

    @Test
    func includesNextLineAfterErrorLine() throws {
        let source = """
            @JS func foo(
              _ bar: A<X>
            ) {}
            """
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(node: typeNode, message: "Unsupported type 'A<X>'.", hint: nil)
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        #expect(description.contains("  1 | @JS func foo("))
        #expect(description.contains("  2 |   _ bar: A<X>"))
        #expect(description.contains("  3 | ) {}"))
        #expect(description.contains("<stdin>:2:"))
    }

    // MARK: - Nested type validation

    @Test
    func nestedStructInsideClassSucceeds() throws {
        let source = """
            @JS class User {
                @JS struct Stats {
                    var health: Int
                }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported != nil)
        let structs = skeleton.exported?.structs ?? []
        #expect(structs.count == 1)
        #expect(structs.first?.swiftCallName == "User.Stats")
    }

    @Test
    func nestedClassInsideStructSucceeds() throws {
        let source = """
            @JS struct Container {
                var value: Int
                @JS class Inner {
                }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported != nil)
        let classes = skeleton.exported?.classes ?? []
        #expect(classes.count == 1)
        #expect(classes.first?.swiftCallName == "Container.Inner")
    }

    @Test
    func structInsideEnumNamespaceSucceeds() throws {
        let source = """
            @JS enum API {
                @JS struct Point {
                    var x: Double
                    var y: Double
                }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported != nil)
    }

    // MARK: - Struct init order validation

    @Test
    func structInitMismatchedOrderProducesDiagnostic() throws {
        let source = """
            @JS struct Animal {
                var size: Double
                var age: Int

                @JS init(age: Int, size: Double) {
                    self.age = age
                    self.size = size
                }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        #expect(throws: BridgeJSCoreDiagnosticError.self) {
            _ = try swiftAPI.finalize()
        }
    }

    @Test
    func structInitMatchingOrderSucceeds() throws {
        let source = """
            @JS struct Point {
                var x: Double
                var y: Double

                @JS init(x: Double, y: Double) {
                    self.x = x
                    self.y = y
                }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported != nil)
    }

    @Test
    func structWithoutExplicitInitSucceeds() throws {
        let source = """
            @JS struct Point {
                var x: Double
                var y: Double
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        #expect(skeleton.exported != nil)
    }

    // MARK: - Async return validation

    @Test
    func asyncReturnOfUnsupportedTypeIsDiagnosed() throws {
        // Protocol existentials still can't be lowered through the imported-parameter ABI, so
        // an async return of one must still be diagnosed.
        let source = """
            @JS protocol PayloadDelegate {
                func notify()
            }
            @JS func loadPayload() async -> PayloadDelegate {
                fatalError()
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        let exported = try #require(skeleton.exported)
        let exportSwift = ExportSwift(progress: .silent, moduleName: skeleton.moduleName, skeleton: exported)
        #expect(throws: BridgeJSCoreError.self) {
            _ = try exportSwift.finalize()
        }
    }

    @Test
    func asyncReturnOfConvertibleTypeSucceeds() throws {
        let source = """
            @JS func loadCount() async -> Int {
                1
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        let skeleton = try swiftAPI.finalize()
        let exported = try #require(skeleton.exported)
        let exportSwift = ExportSwift(progress: .silent, moduleName: skeleton.moduleName, skeleton: exported)
        #expect(try exportSwift.finalize() != nil)
    }

    @Test
    func chainedJSAsDiagnostic() throws {
        let source = """
            @JS(as: B.self) struct A {
                consuming func bridgeToJS() -> B { fatalError() }
                static func bridgeFromJS(_ value: consuming B) -> A { fatalError() }
            }
            @JS(as: C.self) struct B {
                consuming func bridgeToJS() -> C { fatalError() }
                static func bridgeFromJS(_ value: consuming C) -> B { fatalError() }
            }
            @JS class C { @JS init() {} }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        #expect(throws: BridgeJSCoreDiagnosticError.self) {
            _ = try swiftAPI.finalize()
        }
    }

    @Test
    func cyclicJSAsDiagnostic() throws {
        let source = """
            @JS(as: B.self) struct A {
                consuming func bridgeToJS() -> B { fatalError() }
                static func bridgeFromJS(_ value: consuming B) -> A { fatalError() }
            }
            @JS(as: A.self) struct B {
                consuming func bridgeToJS() -> A { fatalError() }
                static func bridgeFromJS(_ value: consuming A) -> B { fatalError() }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        #expect(throws: BridgeJSCoreDiagnosticError.self) {
            _ = try swiftAPI.finalize()
        }
    }

    @Test
    func jsAsProtocolTargetDiagnostic() throws {
        let source = """
            @JS protocol Audible {
                func play()
            }
            @JS(as: Audible.self) struct AudibleTag {
                consuming func bridgeToJS() -> any Audible { fatalError() }
                static func bridgeFromJS(_ value: consuming any Audible) -> AudibleTag { fatalError() }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        #expect(throws: BridgeJSCoreDiagnosticError.self) {
            _ = try swiftAPI.finalize()
        }
    }

    @Test
    func jsAsWithNamespaceDiagnostic() throws {
        let source = """
            @JS final class Box { @JS init() {} }
            @JS(as: Box.self, namespace: "Foo") struct Wrapped {
                consuming func bridgeToJS() -> Box { fatalError() }
                static func bridgeFromJS(_ value: consuming Box) -> Wrapped { fatalError() }
            }
            """
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty
        )
        swiftAPI.addSourceFile(Parser.parse(source: source), inputFilePath: "test.swift")
        #expect(throws: BridgeJSCoreDiagnosticError.self) {
            _ = try swiftAPI.finalize()
        }
    }

    @Test
    func jsNameOnClassDiagnostic() throws {
        let source = """
            @JS("Renamed") class Box { @JS init() {} }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func jsNameOnStructDiagnostic() throws {
        let source = """
            @JS("Renamed") struct Box { var x: Int }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func jsNameOnEnumDiagnostic() throws {
        let source = """
            @JS("Renamed") enum Box { case a }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func jsNameOnProtocolDiagnostic() throws {
        let source = """
            @JS("Renamed") protocol Box { func run() }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func jsNameOnInitializerDiagnostic() throws {
        let source = """
            @JS class Box { @JS("create") init() {} }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func jsNameOnProtocolRequirementDiagnostic() throws {
        let source = """
            @JS protocol Box { @JS("run") func run() }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("A separate name for JavaScript is not supported here"))
    }

    @Test
    func invalidJSNameDiagnostic() throws {
        let source = """
            @JS("1notAnIdentifier") func a() -> Int { 42 }
            @JS("has space") func b() -> Int { 42 }
            @JS("has-dash") func c() -> Int { 42 }
            @JS("") func d() -> Int { 42 }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("`1notAnIdentifier` is not a valid JavaScript identifier"))
        #expect(diagnostics.description.contains("`has space` is not a valid JavaScript identifier"))
        #expect(diagnostics.description.contains("`has-dash` is not a valid JavaScript identifier"))
        #expect(diagnostics.description.contains("`` is not a valid JavaScript identifier"))
    }

    @Test
    func jsNameOnMultipleBindingsDiagnostic() throws {
        let source = """
            @JS class Box {
                @JS init() {}
                @JS("renamed") var first: Int = 1, second: Int = 2
            }
            """
        let diagnostics = try #require(moduleDiagnostics(source: source))
        #expect(diagnostics.description.contains("Name targets declaration with multiple bindings"))
    }

    @Test
    func omitsNextLineWhenErrorIsOnLastLine() throws {
        let source = """
            preamble
            @JS func foo(_ bar: A<X>)
            """
        let typeNode = try #require(firstParameterTypeNode(source: source))
        let diagnostic = DiagnosticError(node: typeNode, message: "Unsupported type 'A<X>'.", hint: nil)
        let description = diagnostic.formattedDescription(fileName: "-", colorize: false)
        #expect(description.contains("  2 | @JS func foo(_ bar: A<X>)"))
        #expect(description.contains("<stdin>:2:"))
        // No line 3 in source, so output must not show a "  3 |" context line after the pointer
        #expect(!description.contains("  3 |"))
    }
}
