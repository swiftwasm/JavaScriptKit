import XCTest
import JavaScriptKit
import JavaScriptEventLoop

private let largeImmortalLiteral = "this is a long immortal literal string"

@inline(never)
private func runtimeCopy(_ string: String) -> String {
    String(decoding: Array(string.utf8), as: UTF8.self)
}

@JSClass struct StringABIImports {
    @JSFunction static func jsEcho(_ value: String) throws(JSException) -> String
    @JSFunction static func jsEchoOptional(_ value: String?) throws(JSException) -> String?
    @JSFunction static func jsEchoArray(_ value: [String]) throws(JSException) -> [String]
    @JSFunction static func runJsStringABITests() throws(JSException)
}

@JS enum StringABIExports {
    @JS static func echo(_ value: String) -> String { value }
    @JS static func echoOptional(_ value: String?) -> String? { value }
    @JS static func echoArray(_ value: [String]) -> [String] { value }
    @JS static func smallEmpty() -> String { "" }
    @JS static func smallASCII() -> String { "div" }
    @JS static func smallEight() -> String { "abcdefgh" }
    @JS static func smallNine() -> String { "abcdefghi" }
    @JS static func smallTen() -> String { "abcdefghij" }
    @JS static func smallUTF8() -> String { "é" }
    @JS static func largeImmortal() -> String { largeImmortalLiteral }
    @JS static func largeImmortalAgain() -> String { largeImmortalLiteral }
    @JS static func largeDynamic() -> String { runtimeCopy(largeImmortalLiteral) }
    @JS static func immortalSubstring() -> String { String(largeImmortalLiteral.dropFirst(10)) }
    @JS static func optionalNone() -> String? { nil }
    @JS static func optionalSome() -> String? { largeImmortalLiteral }
}

final class StringABITests: XCTestCase {
    func testRunJsStringABITests() throws {
        try StringABIImports.runJsStringABITests()
    }

    func testUnicodeAndBOMParametersAndStacks() throws {
        let samples = [
            "abcdefé", "abcdefgé", "abcdefghé", "abcdefghié",
            "abc€", "abcdefg€", "abc😄", "abcdef😄", "abcdefg😄", "a\0b",
            "\u{FEFF}", "\u{FEFF}x", "\u{FEFF}abcde", "\u{FEFF}abcdef", "x\u{FEFF}", "\u{FEFF}\u{FEFF}x",
            "\u{FEFF}abcdefghijk", "abc\u{FEFF}defghijk", "\u{FEFF}\u{FEFF}abcdefghijk",
        ]
        for input in samples {
            try XCTAssertEqual(StringABIImports.jsEcho(input), input)
            try XCTAssertEqual(StringABIImports.jsEchoOptional(input), input)
        }
        try XCTAssertEqual(StringABIImports.jsEchoArray(samples), samples)
    }

    func testImportEchoesSmallStrings() throws {
        try XCTAssertEqual(StringABIImports.jsEcho(""), "")
        try XCTAssertEqual(StringABIImports.jsEcho("div"), "div")
        try XCTAssertEqual(StringABIImports.jsEcho("abcdefgh"), "abcdefgh")
        try XCTAssertEqual(StringABIImports.jsEcho("abcdefghi"), "abcdefghi")
        try XCTAssertEqual(StringABIImports.jsEcho("abcdefghij"), "abcdefghij")
        try XCTAssertEqual(StringABIImports.jsEcho("é"), "é")
    }

    func testImportEchoesLargeImmortalAndDynamicStrings() throws {
        try XCTAssertEqual(StringABIImports.jsEcho(largeImmortalLiteral), largeImmortalLiteral)
        try XCTAssertEqual(StringABIImports.jsEcho(largeImmortalLiteral), largeImmortalLiteral)
        try XCTAssertEqual(StringABIImports.jsEcho(runtimeCopy(largeImmortalLiteral)), largeImmortalLiteral)
        try XCTAssertEqual(
            StringABIImports.jsEcho(String(largeImmortalLiteral.dropFirst(10))),
            String(largeImmortalLiteral.dropFirst(10))
        )
    }

    func testImportEchoesOptionalStrings() throws {
        try XCTAssertNil(StringABIImports.jsEchoOptional(nil))
        try XCTAssertEqual(StringABIImports.jsEchoOptional("div"), "div")
        try XCTAssertEqual(StringABIImports.jsEchoOptional(largeImmortalLiteral), largeImmortalLiteral)
    }
}
