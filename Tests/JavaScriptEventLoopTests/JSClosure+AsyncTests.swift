import JavaScriptKit
import XCTest

class JSClosureAsyncTests: XCTestCase {
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    final class AnyTaskExecutor: TaskExecutor {
        func enqueue(_ job: UnownedJob) {
            job.runSynchronously(on: asUnownedTaskExecutor())
        }
    }

    final class UnsafeSendableBox<T>: @unchecked Sendable {
        var value: T
        init(_ value: T) {
            self.value = value
        }
    }

    func testAsyncClosure() async throws {
        let closure = JSClosure.async { _ in
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
    }

    func testAsyncClosureWithPriority() async throws {
        let priority = UnsafeSendableBox<TaskPriority?>(nil)
        let closure = JSClosure.async(priority: .high) { _ in
            priority.value = Task.currentPriority
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
        XCTAssertEqual(priority.value, .high)
    }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func testAsyncClosureWithTaskExecutor() async throws {
        let executor = AnyTaskExecutor()
        let closure = JSClosure.async(executorPreference: executor) { _ in
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
    }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func testAsyncClosureWithTaskExecutorPreference() async throws {
        let executor = AnyTaskExecutor()
        let priority = UnsafeSendableBox<TaskPriority?>(nil)
        let closure = JSClosure.async(executorPreference: executor, priority: .high) { _ in
            priority.value = Task.currentPriority
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
        XCTAssertEqual(priority.value, .high)
    }

    // TODO: Enable the following tests once:
    // - Make JSObject a final-class
    // - Unify JSFunction and JSObject into JSValue
    // - Make JS(Oneshot)Closure as a wrapper of JSObject, not a subclass
    /*
    func testAsyncOneshotClosure() async throws {
        let closure = JSOneshotClosure.async { _ in
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(
            from: closure.function!()
        )!.value()
        XCTAssertEqual(result, 42.0)
    }

    func testAsyncOneshotClosureWithPriority() async throws {
        let priority = UnsafeSendableBox<TaskPriority?>(nil)
        let closure = JSOneshotClosure.async(priority: .high) { _ in
            priority.value = Task.currentPriority
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
        XCTAssertEqual(priority.value, .high)
    }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func testAsyncOneshotClosureWithTaskExecutor() async throws {
        let executor = AnyTaskExecutor()
        let closure = JSOneshotClosure.async(executorPreference: executor) { _ in
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
    }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func testAsyncOneshotClosureWithTaskExecutorPreference() async throws {
        let executor = AnyTaskExecutor()
        let priority = UnsafeSendableBox<TaskPriority?>(nil)
        let closure = JSOneshotClosure.async(executorPreference: executor, priority: .high) { _ in
            priority.value = Task.currentPriority
            return (42.0).jsValue
        }.jsValue
        let result = try await JSPromise(from: closure.function!())!.value()
        XCTAssertEqual(result, 42.0)
        XCTAssertEqual(priority.value, .high)
    }
    */
}
