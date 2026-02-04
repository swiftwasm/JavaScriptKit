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
        guard let object = try globalObject1.object else {
            XCTFail("globalObject1 was not an object")
            return
        }
        let value = object[dynamicMember: "prop_2"].number
        XCTAssertEqual(value, 2)
    }
}
