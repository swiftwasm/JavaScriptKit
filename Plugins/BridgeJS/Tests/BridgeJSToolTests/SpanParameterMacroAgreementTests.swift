import SwiftParser
import SwiftSyntax
import Testing

@testable import BridgeJSCore
@testable import BridgeJSMacros
@testable import BridgeJSSkeleton

@Suite struct SpanParameterMacroAgreementTests {
    @Test(arguments: [
        ("", "Span<UInt8>", false),
        ("", "borrowing Span<UInt8>", false),
        ("", "Swift.Span<UInt8>", false),
        ("", "inout MutableSpan<UInt8>", true),
        ("", "inout Swift.MutableSpan<UInt8>", true),
        ("", "inout Swift . MutableSpan<UInt8>", true),
        ("", "inout MyModule.MutableSpan<UInt8>", false),
        ("", "inout Double", false),
        ("@JSClass struct Span {}", "Span", false),
        ("@JSClass struct MutableSpan {}", "inout MutableSpan", false),
        ("@JSClass struct Blob {}", "inout Blob", false),
    ])
    func macroForwardsInoutExactlyWhenToolResolvesMutableSpan(
        declarations: String,
        parameterType: String,
        isMutableSpan: Bool
    ) throws {
        #expect(try toolResolvesMutableSpan(declarations: declarations, parameterType: parameterType) == isMutableSpan)
        #expect(try macroForwardsInout(parameterType: parameterType) == isMutableSpan)
    }

    private func toolResolvesMutableSpan(declarations: String, parameterType: String) throws -> Bool {
        let skeleton = try makeSkeleton(
            "\(declarations)\n@JSFunction func f(_ value: \(parameterType)) throws(JSException)"
        )
        let imported = try #require(skeleton.imported)
        let function = try #require(imported.children.flatMap(\.functions).first)
        guard case .span(let span)? = function.parameters.first?.type else { return false }
        return span.isMutable
    }

    private func macroForwardsInout(parameterType: String) throws -> Bool {
        let file = Parser.parse(source: "func f(_ value: \(parameterType)) {}")
        let function = try #require(file.statements.first?.item.as(FunctionDeclSyntax.self))
        let names = JSMacroHelper.parameterNames(function.signature.parameterClause.parameters)
        return try #require(names.first).hasPrefix("&")
    }
}
