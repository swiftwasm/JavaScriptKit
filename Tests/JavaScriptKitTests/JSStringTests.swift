import JavaScriptKit
import XCTest

final class JSStringTests: XCTestCase {
    func testEquatable() {
        let string1 = JSString("Hello, world!")
        let string2 = JSString("Hello, world!")
        let string3 = JSString("Hello, world")
        XCTAssertEqual(string1, string1)
        XCTAssertEqual(string1, string2)
        XCTAssertNotEqual(string1, string3)
    }
}
