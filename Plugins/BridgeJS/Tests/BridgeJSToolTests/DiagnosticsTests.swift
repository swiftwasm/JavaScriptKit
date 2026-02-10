import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore

@Suite struct DiagnosticsTests {
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
