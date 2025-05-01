import XCTest

@testable import JavaScriptKit

final class JSPromiseTests: XCTestCase {
    func testPromiseThen() async throws {
        var p1 = JSPromise.resolve(JSValue.null)
        await withCheckedContinuation { continuation in
            p1 = p1.then { value in
                XCTAssertEqual(value, .null)
                continuation.resume()
                return JSValue.number(1.0).jsValue
            }
        }
        await withCheckedContinuation { continuation in
            p1 = p1.then { value in
                XCTAssertEqual(value, .number(1.0))
                continuation.resume()
                return JSPromise.resolve(JSValue.boolean(true)).jsValue
            }
        }
        await withCheckedContinuation { continuation in
            p1 = p1.then { value in
                XCTAssertEqual(value, .boolean(true))
                continuation.resume()
                return JSValue.undefined
            }
        }
        await withCheckedContinuation { continuation in
            p1 = p1.catch { error in
                XCTFail("Not fired due to no throw")
                return JSValue.undefined
            }
            .finally { continuation.resume() }
        }
    }

    func testPromiseCatch() async throws {
        var p2 = JSPromise.reject(JSValue.boolean(false))
        await withCheckedContinuation { continuation in
            p2 = p2.catch { error in
                XCTAssertEqual(error, .boolean(false))
                continuation.resume()
                return JSValue.boolean(true)
            }
        }
        await withCheckedContinuation { continuation in
            p2 = p2.then { value in
                XCTAssertEqual(value, .boolean(true))
                continuation.resume()
                return JSPromise.reject(JSValue.number(2.0)).jsValue
            }
        }
        await withCheckedContinuation { continuation in
            p2 = p2.catch { error in
                XCTAssertEqual(error, .number(2.0))
                continuation.resume()
                return JSValue.undefined
            }
        }
        await withCheckedContinuation { continuation in
            p2 = p2.finally { continuation.resume() }
        }
    }

    func testPromiseAndTimer() async throws {
        let start = JSDate().valueOf()
        let timeoutMilliseconds = 5.0
        var timer: JSTimer?

        var p3: JSPromise?
        await withCheckedContinuation { continuation in
            p3 = JSPromise { resolve in
                timer = JSTimer(millisecondsDelay: timeoutMilliseconds) {
                    continuation.resume()
                    resolve(.success(.undefined))
                }
            }
        }

        await withCheckedContinuation { continuation in
            p3?.then { _ in
                XCTAssertEqual(start + timeoutMilliseconds <= JSDate().valueOf(), true)
                continuation.resume()
                return JSValue.undefined
            }
        }

        // Ensure that users don't need to manage JSPromise lifetime
        await withCheckedContinuation { continuation in
            JSPromise.resolve(JSValue.boolean(true)).then { _ in
                continuation.resume()
                return JSValue.undefined
            }
        }
        withExtendedLifetime(timer) {}
    }
}
