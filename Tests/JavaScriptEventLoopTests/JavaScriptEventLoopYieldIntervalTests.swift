import JavaScriptEventLoop
import JavaScriptKit
import XCTest

final class JavaScriptEventLoopYieldIntervalTests: XCTestCase {
    final class Box<Value>: @unchecked Sendable {
        var value: Value
        init(_ value: Value) { self.value = value }
    }

    override func tearDown() {
        JavaScriptEventLoop.shared.yieldInterval = nil
        super.tearDown()
    }

    static func busyWait(milliseconds: Int) {
        let end = ContinuousClock.now + .milliseconds(milliseconds)
        while ContinuousClock.now < end {}
    }

    /// Returns, for each busy task, whether a JavaScript timer scheduled before them had fired.
    func timerRanAfterEachTask(count: Int, milliseconds: Int) async -> [Bool] {
        let timerRan = Box(false)
        _ = JSObject.global.setTimeout!(
            JSOneshotClosure { _ in
                timerRan.value = true
                return .undefined
            },
            0
        )
        let observed = Box([Bool]())
        let tasks = (0..<count).map { _ in
            Task {
                Self.busyWait(milliseconds: milliseconds)
                observed.value.append(timerRan.value)
            }
        }
        for task in tasks { await task.value }
        return observed.value
    }

    func testYieldIntervalIsNilByDefault() {
        XCTAssertNil(JavaScriptEventLoop.shared.yieldInterval)
    }

    func testJobsRunInOneDrainWithoutYieldInterval() async {
        let observed = await timerRanAfterEachTask(count: 20, milliseconds: 2)
        XCTAssertEqual(observed, Array(repeating: false, count: 20))
    }

    func testJavaScriptTasksRunBetweenJobsWithYieldInterval() async {
        JavaScriptEventLoop.shared.yieldInterval = .milliseconds(5)
        let observed = await timerRanAfterEachTask(count: 20, milliseconds: 2)
        XCTAssertEqual(observed.first, false)
        XCTAssertEqual(observed.last, true)
    }

    func testYieldIntervalAppliesToALaterDrain() async throws {
        JavaScriptEventLoop.shared.yieldInterval = .milliseconds(5)
        // Start a new drain.
        try await Task.sleep(nanoseconds: 1_000_000)
        let observed = await timerRanAfterEachTask(count: 20, milliseconds: 2)
        XCTAssertEqual(observed.first, false)
        XCTAssertEqual(observed.last, true)
    }

    func testJobsKeepTheirOrderAcrossYields() async {
        JavaScriptEventLoop.shared.yieldInterval = .milliseconds(1)
        let order = Box([Int]())
        let tasks = (0..<20).map { index in
            Task {
                Self.busyWait(milliseconds: 1)
                order.value.append(index)
            }
        }
        for task in tasks { await task.value }
        XCTAssertEqual(order.value, Array(0..<20))
    }
}
