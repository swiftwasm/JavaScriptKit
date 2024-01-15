import JavaScriptEventLoop
import JavaScriptKit
#if canImport(WASILibc)
import WASILibc
#elseif canImport(Darwin)
import Darwin
#endif

#if compiler(>=5.5)

func performanceNow() -> Double {
    return JSObject.global.performance.now().number!
}

func measure(_ block: () async throws -> Void) async rethrows -> Double {
    let start = performanceNow()
    try await block()
    return performanceNow() - start
}

func entrypoint() async throws {
    struct E: Error, Equatable {
        let value: Int
    }

    try await asyncTest("Task.init value") {
        let handle = Task { 1 }
        try expectEqual(await handle.value, 1)
    }

    try await asyncTest("Task.init throws") {
        let handle = Task {
            throw E(value: 2)
        }
        let error = try await expectAsyncThrow(await handle.value)
        let e = try expectCast(error, to: E.self)
        try expectEqual(e, E(value: 2))
    }

    try await asyncTest("await resolved Promise") {
        let p = JSPromise(resolver: { resolve in
            resolve(.success(1))
        })
        try await expectEqual(p.value, 1)
        try await expectEqual(p.result, .success(.number(1)))
    }

    try await asyncTest("await rejected Promise") {
        let p = JSPromise(resolver: { resolve in
            resolve(.failure(.number(3)))
        })
        let error = try await expectAsyncThrow(await p.value)
        let jsValue = try expectCast(error, to: JSValue.self)
        try expectEqual(jsValue, 3)
        try await expectEqual(p.result, .failure(.number(3)))
    }

    try await asyncTest("Continuation") {
        let value = await withUnsafeContinuation { cont in
            cont.resume(returning: 1)
        }
        try expectEqual(value, 1)

        let error = try await expectAsyncThrow(
            try await withUnsafeThrowingContinuation { (cont: UnsafeContinuation<Never, Error>) in
                cont.resume(throwing: E(value: 2))
            }
        )
        let e = try expectCast(error, to: E.self)
        try expectEqual(e.value, 2)
    }

    try await asyncTest("Task.sleep(_:)") {
        let diff = try await measure {
            try await Task.sleep(nanoseconds: 200_000_000)
        }
        try expectGTE(diff, 200)
    }

    try await asyncTest("Job reordering based on priority") {
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
        try expectEqual(context.completed, ["t1", "t2"])

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
        try expectEqual(context.completed, ["t4", "t3", "t5"])
    }

    try await asyncTest("Async JSClosure") {
        let delayClosure = JSClosure.async { _ -> JSValue in
            try await Task.sleep(nanoseconds: 200_000_000)
            return JSValue.number(3)
        }
        let delayObject = JSObject.global.Object.function!.new()
        delayObject.closure = delayClosure.jsValue

        let diff = try await measure {
            let promise = JSPromise(from: delayObject.closure!())
            try expectNotNil(promise)
            let result = try await promise!.value
            try expectEqual(result, .number(3))
        }
        try expectGTE(diff, 200)
    }

    try await asyncTest("Async JSPromise: then") {
        let promise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _  in
                    resolve(.success(JSValue.number(3)))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let promise2 = promise.then { result in
            try await Task.sleep(nanoseconds: 100_000_000)
            return String(result.number!)
        }
        let diff = try await measure {
            let result = try await promise2.value
            try expectEqual(result, .string("3.0"))
        }
        try expectGTE(diff, 200)
    }

    try await asyncTest("Async JSPromise: then(success:failure:)") {
        let promise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _ in
                    resolve(.failure(JSError(message: "test").jsValue))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let promise2 = promise.then { _ in
            throw JSError(message: "should not succeed")
        } failure: { err in
            return err
        }
        let result = try await promise2.value
        try expectEqual(result.object?.message, .string("test"))
    }

    try await asyncTest("Async JSPromise: catch") {
        let promise = JSPromise { resolve in
            _ = JSObject.global.setTimeout!(
                JSClosure { _ in
                    resolve(.failure(JSError(message: "test").jsValue))
                    return .undefined
                }.jsValue,
                100
            )
        }
        let promise2 = promise.catch { err in
            try await Task.sleep(nanoseconds: 100_000_000)
            return err
        }
        let diff = try await measure {
            let result = try await promise2.value
            try expectEqual(result.object?.message, .string("test"))
        }
        try expectGTE(diff, 200)
    }

    try await asyncTest("Task.sleep(nanoseconds:)") {
        let diff = try await measure {
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        try expectGTE(diff, 100)
    }

    #if compiler(>=5.7)
    try await asyncTest("ContinuousClock.sleep") {
        let diff = try await measure {
            let c = ContinuousClock()
            try await c.sleep(until: .now + .milliseconds(100))
        }
        try expectGTE(diff, 99)
    }
    try await asyncTest("SuspendingClock.sleep") {
        let diff = try await measure {
            let c = SuspendingClock()
            try await c.sleep(until: .now + .milliseconds(100))
        }
        try expectGTE(diff, 99)
    }
    #endif
}


// Note: Please define `USE_SWIFT_TOOLS_VERSION_NEWER_THAN_5_5` if the swift-tools-version is newer
// than 5.5 to avoid the linking issue.
#if USE_SWIFT_TOOLS_VERSION_NEWER_THAN_5_5
// Workaround: The latest SwiftPM rename main entry point name of executable target
// to avoid conflicting "main" with test target since `swift-tools-version >= 5.5`.
// The main symbol is renamed to "{{module_name}}_main" and it's renamed again to be
// "main" when linking the executable target. The former renaming is done by Swift compiler,
// and the latter is done by linker, so SwiftPM passes some special linker flags for each platform.
// But SwiftPM assumes that wasm-ld supports it by returning an empty array instead of nil even though
// wasm-ld doesn't support it yet.
// ref: https://github.com/apple/swift-package-manager/blob/1be68e811d0d814ba7abbb8effee45f1e8e6ec0d/Sources/Build/BuildPlan.swift#L117-L126
// So define an explicit "main" by @_cdecl
@_cdecl("main")
func main(argc: Int32, argv: Int32) -> Int32 {
    JavaScriptEventLoop.installGlobalExecutor()
    Task {
        do {
            try await entrypoint()
        } catch {
            print(error)
        }
    }
    return 0
}
#else
JavaScriptEventLoop.installGlobalExecutor()
Task {
    do {
        try await entrypoint()
    } catch {
        print(error)
    }
}

#endif


#endif
