#if compiler(>=6.1) && _runtime(_multithreaded)
import XCTest
@testable import JavaScriptEventLoop

final class WebWorkerDedicatedExecutorTests: XCTestCase {
    actor MyActor {
        let executor: WebWorkerDedicatedExecutor
        nonisolated var unownedExecutor: UnownedSerialExecutor {
            self.executor.asUnownedSerialExecutor()
        }

        init(executor: WebWorkerDedicatedExecutor) {
            self.executor = executor
            XCTAssertTrue(isMainThread())
        }

        func onWorkerThread() async {
            XCTAssertFalse(isMainThread())
            await Task.detached {}.value
            // Should keep on the thread after back from the other isolation domain
            XCTAssertFalse(isMainThread())
        }
    }

    func testEnqueue() async throws {
        let executor = try await WebWorkerDedicatedExecutor()
        defer { executor.terminate() }
        let actor = MyActor(executor: executor)
        XCTAssertTrue(isMainThread())
        await actor.onWorkerThread()
        XCTAssertTrue(isMainThread())
    }
}
#endif
