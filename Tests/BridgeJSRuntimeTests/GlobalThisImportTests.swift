import XCTest
import JavaScriptKit

final class GlobalThisImportTests: XCTestCase {
    func testGlobalFunctionImport() throws {
        XCTAssertEqual(try parseInt("42"), 42)
    }

    func testGlobalClassImport() throws {
        let cat = try Animal("Mimi", 3, true)
        XCTAssertEqual(try cat.bark(), "nyan")
        XCTAssertEqual(try cat.getIsCat(), true)
    }

    func testGlobalGetterImport() throws {
        let value = try globalObject1["prop_2"].number
        XCTAssertEqual(value, 2)
    }
}
