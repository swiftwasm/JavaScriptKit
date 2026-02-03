import SwiftSyntaxMacrosGenericTestSupport
import Testing
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacroExpansion

enum TestSupport {
    static func failureHandler(spec: TestFailureSpec) {
        Issue.record(
            Comment(rawValue: spec.message),
            sourceLocation: .init(
                fileID: spec.location.fileID,
                filePath: spec.location.filePath,
                line: spec.location.line,
                column: spec.location.column
            )
        )
    }

    static func assertMacroExpansion(
        _ originalSource: String,
        expandedSource expectedExpandedSource: String,
        diagnostics: [DiagnosticSpec] = [],
        macroSpecs: [String: MacroSpec],
        applyFixIts: [String]? = nil,
        fixedSource expectedFixedSource: String? = nil,
        testModuleName: String = "TestModule",
        testFileName: String = "test.swift",
        indentationWidth: Trivia = .spaces(4),
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) {
        SwiftSyntaxMacrosGenericTestSupport.assertMacroExpansion(
            originalSource,
            expandedSource: expectedExpandedSource,
            diagnostics: diagnostics,
            macroSpecs: macroSpecs,
            applyFixIts: applyFixIts,
            fixedSource: expectedFixedSource,
            testModuleName: testModuleName,
            testFileName: testFileName,
            indentationWidth: indentationWidth,
            failureHandler: TestSupport.failureHandler,
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
    }
}
