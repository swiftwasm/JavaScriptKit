import XCTest

@testable import JavaScriptKit

final class JSTimerTests: XCTestCase {

    func testOneshotTimerCancelled() {
        let timeoutMilliseconds = 5.0
        var timeout: JSTimer!
        timeout = JSTimer(millisecondsDelay: timeoutMilliseconds, isRepeating: false) {
            XCTFail("timer should be cancelled")
        }
        _ = timeout
        timeout = nil
    }

    func testRepeatingTimerCancelled() async throws {
        var count = 0.0
        let maxCount = 5.0
        var interval: JSTimer?
        let start = JSDate().valueOf()
        let timeoutMilliseconds = 5.0

        await withCheckedContinuation { continuation in
            interval = JSTimer(millisecondsDelay: 5, isRepeating: true) {
                // ensure that JSTimer is living
                XCTAssertNotNil(interval)
                // verify that at least `timeoutMilliseconds * count` passed since the `timeout`
                // timer started
                XCTAssertTrue(start + timeoutMilliseconds * count <= JSDate().valueOf())

                guard count < maxCount else {
                    // stop the timer after `maxCount` reached
                    interval = nil
                    continuation.resume()
                    return
                }

                count += 1
            }
        }
        withExtendedLifetime(interval) {}
    }

    func testTimer() async throws {
        let timeoutMilliseconds = 5.0
        var timeout: JSTimer!
        await withCheckedContinuation { continuation in
            timeout = JSTimer(millisecondsDelay: timeoutMilliseconds, isRepeating: false) {
                continuation.resume()
            }
        }
        withExtendedLifetime(timeout) {}
    }
}
