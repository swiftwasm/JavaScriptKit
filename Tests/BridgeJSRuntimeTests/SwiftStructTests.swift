import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runJsStructWorks")
@_extern(c)
func runJsStructWorks() -> Void

final class SwiftStructTests: XCTestCase {
    func testExportedStructSupport() {
        runJsStructWorks()
    }

    func testSwiftStructInImportedSignature() throws {
        let point = Point(x: 1, y: 2)
        let moved = try jsTranslatePoint(point, dx: 3, dy: -1)
        XCTAssertEqual(moved.x, 4)
        XCTAssertEqual(moved.y, 1)
    }
}
