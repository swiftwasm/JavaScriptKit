import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "runJsStructWorks")
@_extern(c)
func runJsStructWorks() -> Void

final class SwiftStructTests: XCTestCase {
    private func requireGC() throws -> JSFunction {
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }
        return gc
    }

    private func runGCUntil(
        gc: JSFunction,
        timeoutIterations: Int = 200,
        _ condition: () throws -> Bool
    ) async throws -> Bool {
        for _ in 0..<timeoutIterations {
            gc()
            // Allow FinalizationRegistry callbacks to run.
            try await Task.sleep(for: .milliseconds(0))
            if try condition() {
                return true
            }
        }
        return try condition()
    }

    func testExportedStructSupport() {
        runJsStructWorks()
    }

    func testSwiftStructInImportedSignature() throws {
        let point = Point(x: 1, y: 2)
        let moved = try jsTranslatePoint(point, dx: 3, dy: -1)
        XCTAssertEqual(moved.x, 4)
        XCTAssertEqual(moved.y, 1)
    }

    func testSwiftStructImportedLifetime_NoEscape() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        try jsObservePointLifetime(Point(x: 1, y: 2), token)

        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected the bridged JS object to be finalized eventually (token: \(token))")
        XCTAssertFalse(try jsIsPointWeakAlive(token), "Expected WeakRef to be cleared (token: \(token))")
    }

    func testSwiftStructImportedLifetime_EscapesAndReleases() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        let handle = try jsStorePointStrong(Point(x: 10, y: 20), token)

        for _ in 0..<50 {
            gc()
            try await Task.sleep(for: .milliseconds(0))
        }
        XCTAssertFalse(try jsIsPointFinalized(token), "Expected object to remain alive while stored (token: \(token))")
        XCTAssertTrue(try jsIsPointWeakAlive(token), "Expected WeakRef to still be alive (token: \(token))")

        try jsReleaseStoredPoint(handle)
        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected object to be finalized after release (token: \(token))")
    }

    func testSwiftStructImportedLifetime_ReturnValueDoesNotLeak() async throws {
        let gc = try requireGC()
        let token = Int.random(in: 1...Int.max)

        let point = try jsMakePoint(token, x: 7, y: 8)
        XCTAssertEqual(point.x, 7)
        XCTAssertEqual(point.y, 8)

        let finalized = try await runGCUntil(gc: gc) { try jsIsPointFinalized(token) }
        XCTAssertTrue(finalized, "Expected returned JS object to be finalized eventually (token: \(token))")
    }
}
