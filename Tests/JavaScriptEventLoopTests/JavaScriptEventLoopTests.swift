import JavaScriptEventLoop
import JavaScriptKit
import XCTest

final class JavaScriptEventLoopTests: XCTestCase {
    // Helper utilities for testing
    struct MessageError: Error {
        let message: String
        let file: StaticString
        let line: UInt
        let column: UInt
        init(_ message: String, file: StaticString, line: UInt, column: UInt) {
            self.message = message
            self.file = file
            self.line = line
            self.column = column
        }
    }

    func expectAsyncThrow<T>(
        _ body: @autoclosure () async throws -> T,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Error {
        do {
            _ = try await body()
        } catch {
            return error
        }
        throw MessageError("Expect to throw an exception", file: file, line: line, column: column)
    }

    func performanceNow() -> Double {
        return JSObject.global.performance.now().number!
    }

    func measureTime(_ block: () async throws -> Void) async rethrows -> Double {
        let start = performanceNow()
        try await block()
        return performanceNow() - start
    }

    // Error type used in tests
    struct E: Error, Equatable {
        let value: Int
    }

    // MARK: - Task Tests

    func testTaskInit() async throws {
        // Test Task.init value
        let handle = Task { 1 }
        let value = await handle.value
        XCTAssertEqual(value, 1)
    }

    func testTaskInitThrows() async throws {
        // Test Task.init throws
        let throwingHandle = Task {
            throw E(value: 2)
        }
        let error = try await expectAsyncThrow(await throwingHandle.value)
        let e = try XCTUnwrap(error as? E)
        XCTAssertEqual(e, E(value: 2))
    }

    func testTaskSleep() async throws {
        // Test Task.sleep(_:)
        let sleepDiff = try await measureTime {
            try await Task.sleep(nanoseconds: 200_000_000)
        }
        XCTAssertGreaterThanOrEqual(sleepDiff, 150)

        // Test shorter sleep duration
        let shortSleepDiff = try await measureTime {
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        XCTAssertGreaterThanOrEqual(shortSleepDiff, 50)
    }

    func testTaskPriority() async throws {
        // Test Job reordering based on priority
        class Context: @unchecked Sendable {
            var completed: [String] = []
        }
        let context = Context()

        // When no priority, they should be ordered by the enqueued order
        let t1 = Task(priority: nil) {
            context.completed.append("t1")
        }
        let t2 = Task(priority: nil) {
            context.completed.append("t2")
        }

        _ = await (t1.value, t2.value)
        XCTAssertEqual(context.completed, ["t1", "t2"])

        context.completed = []
        // When high priority is enqueued after a low one, they should be re-ordered
        let t3 = Task(priority: .low) {
            context.completed.append("t3")
        }
        let t4 = Task(priority: .high) {
            context.completed.append("t4")
        }
        let t5 = Task(priority: .low) {
            context.completed.append("t5")
        }

        _ = await (t3.value, t4.value, t5.value)
        XCTAssertEqual(context.completed, ["t4", "t3", "t5"])
    }

    final class OrderContext: @unchecked Sendable {
        var completed: [String] = []
        var expectedCount = 0
        var continuation: CheckedContinuation<Void, Never>?

        func record(_ name: String) {
            completed.append(name)
            if completed.count == expectedCount {
                continuation?.resume()
                continuation = nil
            }
        }
    }

    /// Starts tasks without awaiting them, so no await raises the priority of a queued task.
    func runUnawaited(expectedCount: Int, _ start: (OrderContext) -> Void) async -> [String] {
        let context = OrderContext()
        context.expectedCount = expectedCount
        await withCheckedContinuation { continuation in
            context.continuation = continuation
            start(context)
        }
        return context.completed
    }

    func testTaskPriorityOrderWithMixedPriorities() async throws {
        let burst: [(String, TaskPriority)] = [
            ("low1", .low), ("medium1", .medium), ("low2", .low), ("high1", .high),
            ("medium2", .medium), ("low3", .low), ("high2", .high), ("medium3", .medium),
        ]
        let burstOrder = await runUnawaited(expectedCount: burst.count) { context in
            for (name, priority) in burst {
                Task(priority: priority) { context.record(name) }
            }
        }
        XCTAssertEqual(burstOrder, ["high1", "high2", "medium1", "medium2", "medium3", "low1", "low2", "low3"])

        let nestedOrder = await runUnawaited(expectedCount: 7) { context in
            Task(priority: .medium) {
                context.record("outer")
                let nested: [(String, TaskPriority)] = [
                    ("nestedLow1", .low), ("nestedHigh", .high), ("nestedMedium", .medium), ("nestedLow2", .low),
                ]
                for (name, priority) in nested {
                    Task(priority: priority) { context.record(name) }
                }
            }
            Task(priority: .medium) { context.record("medium") }
            Task(priority: .low) { context.record("low") }
        }
        XCTAssertEqual(
            nestedOrder,
            ["outer", "nestedHigh", "medium", "nestedMedium", "low", "nestedLow1", "nestedLow2"]
        )

        let priorities: [TaskPriority] = [
            .low, .high, .background, .medium, TaskPriority(rawValue: 22), TaskPriority(rawValue: 5),
        ]
        let many = (0..<600).map { index in ("\(index)", priorities[index % priorities.count]) }
        let manyOrder = await runUnawaited(expectedCount: many.count) { context in
            for (name, priority) in many {
                Task(priority: priority) { context.record(name) }
            }
        }
        let expectedManyOrder = many.enumerated()
            .sorted { lhs, rhs in
                lhs.element.1.rawValue != rhs.element.1.rawValue
                    ? lhs.element.1.rawValue > rhs.element.1.rawValue
                    : lhs.offset < rhs.offset
            }
            .map(\.element.0)
        XCTAssertEqual(manyOrder, expectedManyOrder)
    }

    func testTaskPriorityOrderAfterQueueEmpties() async throws {
        let rounds: [[(String, TaskPriority)]] = [
            [("low1", .low), ("low2", .low), ("high1", .high), ("low3", .low)],
            [("high1", .high), ("medium1", .medium), ("high2", .high), ("low1", .low)],
            [("medium1", .medium), ("medium2", .medium), ("medium3", .medium)],
        ]
        let expectedOrders = [
            ["high1", "low1", "low2", "low3"],
            ["high1", "high2", "medium1", "low1"],
            ["medium1", "medium2", "medium3"],
        ]
        for (round, expectedOrder) in zip(rounds, expectedOrders) {
            let order = await runUnawaited(expectedCount: round.count) { context in
                for (name, priority) in round {
                    Task(priority: priority) { context.record(name) }
                }
            }
            XCTAssertEqual(order, expectedOrder)
        }
    }

    func testTaskPriorityOrderAfterSingleJobRunIsClaimed() async throws {
        let order = await runUnawaited(expectedCount: 4) { context in
            Task(priority: .low) { context.record("low1") }
            Task(priority: .low) { context.record("low2") }
            Task(priority: .high) {
                context.record("high")
                Task(priority: .low) { context.record("low3") }
            }
        }
        XCTAssertEqual(order, ["high", "low1", "low2", "low3"])
    }

    // MARK: - Promise Tests

    func testPromiseResolution() async throws {
        // Test await resolved Promise
        let p = JSPromise(resolver: { resolve in
            resolve(.success(1))
        })
        let resolutionValue = try await p.value
        XCTAssertEqual(resolutionValue, .number(1))
        let resolutionResult = await p.result
        XCTAssertEqual(resolutionResult, .success(.number(1)))
    }

    func testPromiseRejection() async throws {
        // Test await rejected Promise
        let rejectedPromise = JSPromise(resolver: { resolve in
            resolve(.failure(.number(3)))
        })
        let promiseError = try await expectAsyncThrow(try await rejectedPromise.value)
        let jsValue = try XCTUnwrap(promiseError as? JSException).thrownValue
        XCTAssertEqual(jsValue, .number(3))
        let rejectionResult = await rejectedPromise.result
        XCTAssertEqual(rejectionResult, .failure(.number(3)))
    }

    func testPromiseThen() async throws {
        // Test Async JSPromise: then
        let promise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _ in
                    resolve(.success(JSValue.number(3)))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let promise2 = promise.then { result in
            try! await Task.sleep(nanoseconds: 100_000_000)
            return .string(String(result.number!))
        }
        let thenDiff = try await measureTime {
            let result = try await promise2.value
            XCTAssertEqual(result, .string("3.0"))
        }
        XCTAssertGreaterThanOrEqual(thenDiff, 150)
    }

    func testPromiseThenWithFailure() async throws {
        // Test Async JSPromise: then(success:failure:)
        let failingPromise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _ in
                    resolve(.failure(JSError(message: "test").jsValue))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let failingPromise2 = failingPromise.then { _ -> JSValue in
            fatalError("Should not be called")
        } failure: { err in
            return err
        }
        let failingResult = try await failingPromise2.value
        XCTAssertEqual(failingResult.object?.message, .string("test"))
    }

    func testPromiseCatch() async throws {
        // Test Async JSPromise: catch
        let catchPromise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _ in
                    resolve(.failure(JSError(message: "test").jsValue))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let catchPromise2 = catchPromise.catch { err in
            try! await Task.sleep(nanoseconds: 100_000_000)
            return err
        }
        let catchDiff = try await measureTime {
            let result = try await catchPromise2.value
            XCTAssertEqual(result.object?.message, .string("test"))
        }
        XCTAssertGreaterThanOrEqual(catchDiff, 150)
    }

    // MARK: - Continuation Tests

    func testContinuation() async throws {
        // Test Continuation
        let continuationValue = await withUnsafeContinuation { cont in
            cont.resume(returning: 1)
        }
        XCTAssertEqual(continuationValue, 1)

        let continuationError = try await expectAsyncThrow(
            try await withUnsafeThrowingContinuation { (cont: UnsafeContinuation<Never, Error>) in
                cont.resume(throwing: E(value: 2))
            }
        )
        let errorValue = try XCTUnwrap(continuationError as? E)
        XCTAssertEqual(errorValue.value, 2)
    }

    // MARK: - JSClosure Tests

    func testAsyncJSClosure() async throws {
        // Test Async JSClosure
        let delayClosure = JSClosure.async { _ -> JSValue in
            try! await Task.sleep(nanoseconds: 200_000_000)
            return JSValue.number(3)
        }
        let delayObject = JSObject.global.Object.function!.new()
        delayObject.closure = delayClosure.jsValue

        let closureDiff = try await measureTime {
            let promise = JSPromise(from: delayObject.closure!())
            XCTAssertNotNil(promise)
            let result = try await promise!.value
            XCTAssertEqual(result, .number(3))
        }
        XCTAssertGreaterThanOrEqual(closureDiff, 150)
    }

    // MARK: - Clock Tests

    #if compiler(>=5.7)
    func testClockSleep() async throws {
        // Test ContinuousClock.sleep
        let continuousClockDiff = try await measureTime {
            let c = ContinuousClock()
            try await c.sleep(until: .now + .milliseconds(100))
        }
        XCTAssertGreaterThanOrEqual(continuousClockDiff, 50)

        // Test SuspendingClock.sleep
        let suspendingClockDiff = try await measureTime {
            let c = SuspendingClock()
            try await c.sleep(until: .now + .milliseconds(100))
        }
        XCTAssertGreaterThanOrEqual(suspendingClockDiff, 50)
    }
    #endif
}
