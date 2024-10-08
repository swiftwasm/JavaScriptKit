#if compiler(>=6.1) && _runtime(_multithreaded)
import XCTest
import JavaScriptKit
import _CJavaScriptKit // For swjs_get_worker_thread_id
@testable import JavaScriptEventLoop

@_extern(wasm, module: "JavaScriptEventLoopTestSupportTests", name: "isMainThread")
func isMainThread() -> Bool

final class WebWorkerTaskExecutorTests: XCTestCase {
    override func setUp() {
        WebWorkerTaskExecutor.installGlobalExecutor()
    }

    func testTaskRunOnMainThread() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)

        XCTAssertTrue(isMainThread())

        let task = Task(executorPreference: executor) {
            return isMainThread()
        }
        let taskRunOnMainThread = await task.value
        // The task should run on the worker thread
        XCTAssertFalse(taskRunOnMainThread)
        // After the task is done, back to the main thread
        XCTAssertTrue(isMainThread())

        executor.terminate()
    }

    func testWithPreferenceBlock() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        await withTaskExecutorPreference(executor) {
            XCTAssertFalse(isMainThread())
        }
    }

    func testAwaitInsideTask() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)

        let task = Task(executorPreference: executor) {
            await Task.yield()
            _ = try await JSPromise.resolve(1).value
            return isMainThread()
        }
        let taskRunOnMainThread = try await task.value
        XCTAssertFalse(taskRunOnMainThread)

        executor.terminate()
    }

    func testSleepInsideTask() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)

        let task = Task(executorPreference: executor) {
            XCTAssertFalse(isMainThread())
            try await Task.sleep(nanoseconds: 10)
            XCTAssertFalse(isMainThread())
            try await Task.sleep(nanoseconds: 100)
            XCTAssertFalse(isMainThread())
            let clock = ContinuousClock()
            try await clock.sleep(for: .milliseconds(10))
            return isMainThread()
        }
        let taskRunOnMainThread = try await task.value
        XCTAssertFalse(taskRunOnMainThread)

        executor.terminate()
    }

    func testMainActorRun() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)

        let task = Task(executorPreference: executor) {
            await MainActor.run {
                return isMainThread()
            }
        }
        let taskRunOnMainThread = await task.value
        // FIXME: The block passed to `MainActor.run` should run on the main thread
        // XCTAssertTrue(taskRunOnMainThread)
        XCTAssertFalse(taskRunOnMainThread)
        // After the task is done, back to the main thread
        XCTAssertTrue(isMainThread())

        executor.terminate()
    }

    func testTaskGroupRunOnSameThread() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 3)

        let mainTid = swjs_get_worker_thread_id()
        await withTaskExecutorPreference(executor) {
            let tid = swjs_get_worker_thread_id()
            await withTaskGroup(of: Int32.self) { group in
                group.addTask {
                    return swjs_get_worker_thread_id()
                }

                group.addTask {
                    return swjs_get_worker_thread_id()
                }

                for await id in group {
                    XCTAssertEqual(id, tid)
                    XCTAssertNotEqual(id, mainTid)
                }
            }
        }

        executor.terminate()
    }

    func testTaskGroupRunOnDifferentThreads() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 2)

        struct Item: Hashable {
            let type: String
            let tid: Int32
            let value: Int
            init(_ type: String, _ tid: Int32, _ value: Int) {
                self.type = type
                self.tid = tid
                self.value = value
            }
        }

        await withTaskGroup(of: Item.self) { group in
            group.addTask {
                let tid = swjs_get_worker_thread_id()
                return Item("main", tid, 0)
            }

            let numberOffloadedTasks = 10
            for i in 0..<numberOffloadedTasks {
                group.addTask(executorPreference: executor) {
                    let tid = swjs_get_worker_thread_id()
                    return Item("worker", tid, i)
                }
            }

            var items: [Item] = []
            for await item in group {
                items.append(item)
            }
            XCTAssertFalse(Task.isCancelled)
            XCTAssertEqual(items.count, numberOffloadedTasks + 1)
            XCTAssertEqual(items.map(\.value).sorted(), [0] + Array(0..<numberOffloadedTasks))
        }
        executor.terminate()
    }
}
#endif
