import XCTest
import JavaScriptKit

// MARK: - Direction B: Swift closure (throws) called from JS

@JS func makeThrowingParser() -> JSTypedClosure<(String) throws(JSException) -> Int> {
    return JSTypedClosure { (text: String) throws(JSException) -> Int in
        guard let value = Int(text) else {
            throw JSException(JSError(message: "ParseError: \(text)").jsValue)
        }
        return value
    }
}

// MARK: - Direction A: JS callback (throws) called from Swift

@JS func runValidator(_ validate: (String) throws(JSException) -> Bool) throws(JSException) -> Bool {
    return try validate("input")
}

// MARK: - XCTest entry point

final class ClosureThrowsTests: XCTestCase {
    func testRunJsClosureThrowsTests() throws {
        try ClosureThrowsImports.runJsClosureThrowsTests()
    }
}

@JSClass struct ClosureThrowsImports {
    @JSFunction static func runJsClosureThrowsTests() throws(JSException)
}
