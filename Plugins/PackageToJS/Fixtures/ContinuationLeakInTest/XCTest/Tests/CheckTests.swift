import XCTest

final class CheckTests: XCTestCase {
    func testNever() async throws {
        let _: Void = await withUnsafeContinuation { _ in }
    }
}
