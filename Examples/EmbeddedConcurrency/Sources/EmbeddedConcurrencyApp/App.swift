@preconcurrency import JavaScriptKit
@preconcurrency import JavaScriptEventLoop
import _Concurrency

#if compiler(>=6.3)
typealias DefaultExecutorFactory = JavaScriptEventLoop
#endif

nonisolated(unsafe) var testsPassed = 0
nonisolated(unsafe) var testsFailed = 0

@MainActor
func check(_ condition: Bool, _ message: String) {
    let console = JSObject.global.console
    if condition {
        testsPassed += 1
        _ = console.log("PASS: \(message)")
    } else {
        testsFailed += 1
        _ = console.log("FAIL: \(message)")
    }
}

@main
struct App {
    static func main() async throws(JSException) {
        JavaScriptEventLoop.installGlobalExecutor()

        // Test 1: Basic async/await with checked continuation
        let value: Int = await withCheckedContinuation { cont in
            cont.resume(returning: 42)
        }
        check(value == 42, "withCheckedContinuation returns correct value")

        // Test 2: Unsafe continuation
        let value2: Int = await withUnsafeContinuation { cont in
            cont.resume(returning: 7)
        }
        check(value2 == 7, "withUnsafeContinuation returns correct value")

        // Test 3: JSPromise creation and .value await
        let promise = JSPromise(resolver: { resolve in
            resolve(.success(JSValue.number(123)))
        })
        let result: JSPromise.Result = await withUnsafeContinuation { continuation in
            promise.then(
                success: {
                    continuation.resume(returning: .success($0))
                    return JSValue.undefined
                },
                failure: {
                    continuation.resume(returning: .failure($0))
                    return JSValue.undefined
                }
            )
        }
        if case .success(let val) = result {
            check(val.number == 123, "JSPromise.value resolves correctly")
        } else {
            check(false, "JSPromise.value resolves correctly")
        }

        // Test 4: setTimeout-based delay via JSPromise
        let startTime = JSObject.global.Date.now().number!
        let delayValue: Int = await withUnsafeContinuation { cont in
            _ = JSObject.global.setTimeout!(
                JSOneshotClosure { _ in
                    cont.resume(returning: 42)
                    return .undefined
                },
                100
            )
        }
        let elapsed = JSObject.global.Date.now().number! - startTime
        check(delayValue == 42 && elapsed >= 90, "setTimeout delay works (\(elapsed)ms elapsed)")

        // Test 5: Multiple concurrent tasks (using withUnsafeContinuation to avoid nonisolated hop)
        var results: [Int] = []
        let task1 = Task { return 1 }
        let task2 = Task { return 2 }
        let task3 = Task { return 3 }
        let r1: Int = await withUnsafeContinuation { cont in
            Task { cont.resume(returning: await task1.value) }
        }
        let r2: Int = await withUnsafeContinuation { cont in
            Task { cont.resume(returning: await task2.value) }
        }
        let r3: Int = await withUnsafeContinuation { cont in
            Task { cont.resume(returning: await task3.value) }
        }
        results.append(r1)
        results.append(r2)
        results.append(r3)
        results.sort()
        check(results == [1, 2, 3], "Concurrent tasks all complete")

        // Test 6: Promise chaining with .then
        let chained = JSPromise(resolver: { resolve in
            resolve(.success(JSValue.number(10)))
        }).then(success: { value in
            return JSValue.number(value.number! * 2)
        }).then(success: { value in
            return JSValue.number(value.number! + 5)
        })
        let chainedResult: JSPromise.Result = await withUnsafeContinuation { continuation in
            chained.then(
                success: {
                    continuation.resume(returning: .success($0))
                    return JSValue.undefined
                },
                failure: {
                    continuation.resume(returning: .failure($0))
                    return JSValue.undefined
                }
            )
        }
        if case .success(let val) = chainedResult {
            check(val.number == 25, "Promise chaining works (10 * 2 + 5 = 25)")
        } else {
            check(false, "Promise chaining should succeed")
        }

        // Summary
        let console = JSObject.global.console
        let totalTests = testsPassed + testsFailed
        _ = console.log("TOTAL: \(totalTests) tests, \(testsPassed) passed, \(testsFailed) failed")
        if testsFailed > 0 {
            fatalError("\(testsFailed) test(s) failed")
        }
    }
}
