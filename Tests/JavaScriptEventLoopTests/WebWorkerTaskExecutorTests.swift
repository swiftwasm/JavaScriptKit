#if compiler(>=6.1) && _runtime(_multithreaded)
import XCTest
import _CJavaScriptKit // For swjs_get_worker_thread_id
@testable import JavaScriptKit
@testable import JavaScriptEventLoop

@_extern(wasm, module: "JavaScriptEventLoopTestSupportTests", name: "isMainThread")
func isMainThread() -> Bool

final class WebWorkerTaskExecutorTests: XCTestCase {
    override func setUp() async {
        await WebWorkerTaskExecutor.installGlobalExecutor()
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
        defer { executor.terminate() }

        let task = Task(executorPreference: executor) {
            await Task.yield()
            _ = try await JSPromise.resolve(1).value
            return isMainThread()
        }
        let taskRunOnMainThread = try await task.value
        XCTAssertFalse(taskRunOnMainThread)
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

    func testThreadLocalPerThreadValues() async throws {
        struct Check {
            static let value = ThreadLocal<Int>(boxing: ())
        }
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        XCTAssertNil(Check.value.wrappedValue)
        Check.value.wrappedValue = 42
        XCTAssertEqual(Check.value.wrappedValue, 42)

        let task = Task(executorPreference: executor) {
            XCTAssertNil(Check.value.wrappedValue)
            Check.value.wrappedValue = 100
            XCTAssertEqual(Check.value.wrappedValue, 100)
            return Check.value.wrappedValue
        }
        let result = await task.value
        XCTAssertEqual(result, 100)
        XCTAssertEqual(Check.value.wrappedValue, 42)
        executor.terminate()
    }

    func testLazyThreadLocalPerThreadInitialization() async throws {
        struct Check {
            nonisolated(unsafe) static var valueToInitialize = 42
            nonisolated(unsafe) static var countOfInitialization = 0
            static let value = LazyThreadLocal<Int>(initialize: {
                countOfInitialization += 1
                return valueToInitialize
            })
        }
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        XCTAssertEqual(Check.countOfInitialization, 0)
        XCTAssertEqual(Check.value.wrappedValue, 42)
        XCTAssertEqual(Check.countOfInitialization, 1)

        Check.valueToInitialize = 100

        let task = Task(executorPreference: executor) {
            XCTAssertEqual(Check.countOfInitialization, 1)
            XCTAssertEqual(Check.value.wrappedValue, 100)
            XCTAssertEqual(Check.countOfInitialization, 2)
            return Check.value.wrappedValue
        }
        let result = await task.value
        XCTAssertEqual(result, 100)
        XCTAssertEqual(Check.countOfInitialization, 2)
        executor.terminate()
    }

    func testJSValueDecoderOnWorker() async throws {
        struct DecodeMe: Codable {
            struct Prop1: Codable {
                let nested_prop: Int
            }

            let prop_1: Prop1
            let prop_2: Int
            let prop_3: Bool
            let prop_7: Float
            let prop_8: String
            let prop_9: [String]
        }

        func decodeJob() throws {
            let json = """
            {
                "prop_1": {
                    "nested_prop": 42
                },
                "prop_2": 100,
                "prop_3": true,
                "prop_7": 3.14,
                "prop_8": "Hello, World!",
                "prop_9": ["a", "b", "c"]
            }
            """
            let object = JSObject.global.JSON.parse(json)
            let decoder = JSValueDecoder()
            let result = try decoder.decode(DecodeMe.self, from: object)
            XCTAssertEqual(result.prop_1.nested_prop, 42)
            XCTAssertEqual(result.prop_2, 100)
            XCTAssertEqual(result.prop_3, true)
            XCTAssertEqual(result.prop_7, 3.14)
            XCTAssertEqual(result.prop_8, "Hello, World!")
            XCTAssertEqual(result.prop_9, ["a", "b", "c"])
        }
        // Run the job on the main thread first to initialize the object cache
        try decodeJob()

        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        defer { executor.terminate() }
        let task = Task(executorPreference: executor) {
            // Run the job on the worker thread to test the object cache
            // is not shared with the main thread
            try decodeJob()
        }
        try await task.value
    }

    func testJSArrayCountOnWorker() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        func check() {
            let object = JSObject.global.Array.function!.new(1, 2, 3, 4, 5)
            let array = JSArray(object)!
            XCTAssertEqual(array.count, 5)
        }
        check()
        let task = Task(executorPreference: executor) {
            check()
        }
        await task.value
        executor.terminate()
    }

/*
    func testDeinitJSObjectOnDifferentThread() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)

        var object: JSObject? = JSObject.global.Object.function!.new()
        let task = Task(executorPreference: executor) {
            object = nil
            _ = object
        }
        await task.value
        executor.terminate()
    }
*/
}
#endif
