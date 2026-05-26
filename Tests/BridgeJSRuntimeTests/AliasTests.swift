import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runAliasWorks")
@_extern(c)
func runAliasWorks() -> Void

final class AliasTests: XCTestCase {
    func testAliasEndToEnd() {
        runAliasWorks()
    }

    func testAliasAsyncEndToEnd() async throws {
        try await runAliasAsyncWorks()
    }

    // MARK: - Imports

    func testRoundTripTagged() throws {
        let result = try AliasImports.jsRoundTripTagged(Tagged(raw: "hello"))
        XCTAssertEqual(result.raw, "hello")
    }

    func testRoundTripOptionalTagged() throws {
        XCTAssertNil(try AliasImports.jsRoundTripOptionalTagged(nil))
        let echoed = try AliasImports.jsRoundTripOptionalTagged(Tagged(raw: "present"))
        XCTAssertEqual(echoed?.raw, "present")
    }

    func testProduceOptionalCanvas() throws {
        XCTAssertNil(try AliasImports.jsProduceOptionalCanvas(nil))
        let canvas = try AliasImports.jsProduceOptionalCanvas("hello")
        XCTAssertEqual(canvas?.label, "hello")
    }

    func testRoundTripAliasedTagArray() throws {
        let inputs: [AliasedTag?] = [
            AliasedTag(underlying: .payload(7)),
            nil,
            AliasedTag(underlying: .empty),
            nil,
        ]
        let echoed = try AliasImports.jsRoundTripAliasedTags(inputs)
        XCTAssertEqual(echoed.count, 4)
        if case .payload(let n) = echoed[0]?.underlying {
            XCTAssertEqual(n, 7)
        } else {
            XCTFail("expected .payload(7) at index 0")
        }
        XCTAssertNil(echoed[1])
        if case .empty = echoed[2]?.underlying {
            // ok
        } else {
            XCTFail("expected .empty at index 2")
        }
        XCTAssertNil(echoed[3])
    }

    func testRoundTripPolygonImport() throws {
        let polygon = Polygon(vertices: [1, 2, 3], label: "import")
        let echoed = try AliasImports.jsRoundTripPolygon(polygon)
        XCTAssertEqual(echoed.label, "import")
        XCTAssertEqual(echoed.vertices, [1, 2, 3])
    }

    func testRoundTripCoordinateImport() throws {
        let coordinate = Coordinate(latitude: 12.5, longitude: -34.25)
        let echoed = try AliasImports.jsRoundTripCoordinate(coordinate)
        XCTAssertEqual(echoed.latitude, 12.5)
        XCTAssertEqual(echoed.longitude, -34.25)
    }
}
