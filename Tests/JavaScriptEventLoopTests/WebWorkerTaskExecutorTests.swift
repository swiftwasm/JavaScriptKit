#if compiler(>=6.1) && _runtime(_multithreaded)
import XCTest
import _CJavaScriptKit  // For swjs_get_worker_thread_id
@testable import JavaScriptKit
@testable import JavaScriptEventLoop

@_extern(wasm, module: "JavaScriptEventLoopTestSupportTests", name: "isMainThread")
func isMainThread() -> Bool

#if canImport(wasi_pthread)
import wasi_pthread
/// Trick to avoid blocking the main thread. pthread_mutex_lock function is used by
/// the Swift concurrency runtime.
@_cdecl("pthread_mutex_lock")
func pthread_mutex_lock(_ mutex: UnsafeMutablePointer<pthread_mutex_t>) -> Int32 {
    // DO NOT BLOCK MAIN THREAD
    var ret: Int32
    repeat {
        ret = pthread_mutex_trylock(mutex)
    } while ret == EBUSY
    return ret
}
#endif

final class WebWorkerTaskExecutorTests: XCTestCase {
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

    func testSendingWithoutReceiving() async throws {
        let object = JSObject.global.Object.function!.new()
        _ = JSSending.transfer(object)
        _ = JSSending(object)
    }

    func testTransferMainToWorker() async throws {
        let Uint8Array = JSObject.global.Uint8Array.function!
        let buffer = Uint8Array.new(100).buffer.object!
        let transferring = JSSending.transfer(buffer)
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let task = Task(executorPreference: executor) {
            let buffer = try await transferring.receive()
            return buffer.byteLength.number!
        }
        let byteLength = try await task.value
        XCTAssertEqual(byteLength, 100)

        // Transferred Uint8Array should have 0 byteLength
        XCTAssertEqual(buffer.byteLength.number!, 0)
    }

    func testTransferWorkerToMain() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let task = Task(executorPreference: executor) {
            let Uint8Array = JSObject.global.Uint8Array.function!
            let buffer = Uint8Array.new(100).buffer.object!
            let transferring = JSSending.transfer(buffer)
            return transferring
        }
        let transferring = await task.value
        let buffer = try await transferring.receive()
        XCTAssertEqual(buffer.byteLength.number!, 100)
    }

    func testTransferNonTransferable() async throws {
        let object = JSObject.global.Object.function!.new()
        let transferring = JSSending.transfer(object)
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let task = Task<String?, Error>(executorPreference: executor) {
            do {
                _ = try await transferring.receive()
                return nil
            } catch let error as JSException {
                return error.thrownValue.description
            }
        }
        guard let jsErrorMessage = try await task.value else {
            XCTFail("Should throw an error")
            return
        }
        XCTAssertTrue(jsErrorMessage.contains("Failed to serialize message"), jsErrorMessage)
    }

    // // Node.js 20 and below doesn't throw exception when transferring the same ArrayBuffer
    // // multiple times.
    // // See https://github.com/nodejs/node/commit/38dee8a1c04237bd231a01410f42e9d172f4c162
    // func testTransferMultipleTimes() async throws {
    //     let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
    //     let Uint8Array = JSObject.global.Uint8Array.function!
    //     let buffer = Uint8Array.new(100).buffer.object!
    //     let transferring = JSSending.transfer(buffer)
    //     let task1 = Task(executorPreference: executor) {
    //         let buffer = try await transferring.receive()
    //         return buffer.byteLength.number!
    //     }
    //     let byteLength1 = try await task1.value
    //     XCTAssertEqual(byteLength1, 100)
    //
    //     let task2 = Task<String?, Never>(executorPreference: executor) {
    //         do {
    //             _ = try await transferring.receive()
    //             return nil
    //         } catch {
    //             return String(describing: error)
    //         }
    //     }
    //     guard let jsErrorMessage = await task2.value else {
    //         XCTFail("Should throw an error")
    //         return
    //     }
    //     XCTAssertTrue(jsErrorMessage.contains("Failed to serialize message"))
    // }

    func testCloneMultipleTimes() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let object = JSObject.global.Object.function!.new()
        object["test"] = "Hello, World!"

        for _ in 0..<2 {
            let cloning = JSSending(object)
            let task = Task(executorPreference: executor) {
                let object = try await cloning.receive()
                return object["test"].string!
            }
            let result = try await task.value
            XCTAssertEqual(result, "Hello, World!")
        }
    }

    func testTransferBetweenWorkers() async throws {
        let executor1 = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let executor2 = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let task = Task(executorPreference: executor1) {
            let Uint8Array = JSObject.global.Uint8Array.function!
            let buffer = Uint8Array.new(100).buffer.object!
            let transferring = JSSending.transfer(buffer)
            return transferring
        }
        let transferring = await task.value
        let task2 = Task(executorPreference: executor2) {
            let buffer = try await transferring.receive()
            return buffer.byteLength.number!
        }
        let byteLength = try await task2.value
        XCTAssertEqual(byteLength, 100)
    }

    func testTransferMultipleItems() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let Uint8Array = JSObject.global.Uint8Array.function!
        let buffer1 = Uint8Array.new(10).buffer.object!
        let buffer2 = Uint8Array.new(11).buffer.object!
        let transferring1 = JSSending.transfer(buffer1)
        let transferring2 = JSSending.transfer(buffer2)
        let task = Task(executorPreference: executor) {
            let (buffer1, buffer2) = try await JSSending.receive(transferring1, transferring2)
            return (buffer1.byteLength.number!, buffer2.byteLength.number!)
        }
        let (byteLength1, byteLength2) = try await task.value
        XCTAssertEqual(byteLength1, 10)
        XCTAssertEqual(byteLength2, 11)
        XCTAssertEqual(buffer1.byteLength.number!, 0)
        XCTAssertEqual(buffer2.byteLength.number!, 0)

        // Mix transferring and cloning
        let buffer3 = Uint8Array.new(12).buffer.object!
        let buffer4 = Uint8Array.new(13).buffer.object!
        let transferring3 = JSSending.transfer(buffer3)
        let cloning4 = JSSending(buffer4)
        let task2 = Task(executorPreference: executor) {
            let (buffer3, buffer4) = try await JSSending.receive(transferring3, cloning4)
            return (buffer3.byteLength.number!, buffer4.byteLength.number!)
        }
        let (byteLength3, byteLength4) = try await task2.value
        XCTAssertEqual(byteLength3, 12)
        XCTAssertEqual(byteLength4, 13)
        XCTAssertEqual(buffer3.byteLength.number!, 0)
        XCTAssertEqual(buffer4.byteLength.number!, 13)
    }

    func testCloneObjectToWorker() async throws {
        let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        let object = JSObject.global.Object.function!.new()
        object["test"] = "Hello, World!"
        let cloning = JSSending(object)
        let task = Task(executorPreference: executor) {
            let object = try await cloning.receive()
            return object["test"].string!
        }
        let result = try await task.value
        XCTAssertEqual(result, "Hello, World!")

        // Further access to the original object is valid
        XCTAssertEqual(object["test"].string!, "Hello, World!")
    }

    // func testDeinitJSObjectOnDifferentThread() async throws {
    //     let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
    //
    //     var object: JSObject? = JSObject.global.Object.function!.new()
    //     let task = Task(executorPreference: executor) {
    //         object = nil
    //         _ = object
    //     }
    //     await task.value
    //     executor.terminate()
    // }
}
#endif
