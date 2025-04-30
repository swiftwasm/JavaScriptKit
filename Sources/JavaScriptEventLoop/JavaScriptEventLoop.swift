import JavaScriptKit
import _Concurrency
import _CJavaScriptEventLoop
import _CJavaScriptKit

// NOTE: `@available` annotations are semantically wrong, but they make it easier to develop applications targeting WebAssembly in Xcode.

#if compiler(>=5.5)

/// Singleton type responsible for integrating JavaScript event loop as a Swift concurrency executor, conforming to
/// `SerialExecutor` protocol from the standard library. To utilize it:
///
/// 1. Make sure that your target depends on `JavaScriptEventLoop` in your `Packages.swift`:
///
/// ```swift
/// .target(
///    name: "JavaScriptKitExample",
///    dependencies: [
///        "JavaScriptKit",
///        .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
///    ]
/// )
/// ```
///
/// 2. Add an explicit import in the code that executes **before* you start using `await` and/or `Task`
/// APIs (most likely in `main.swift`):
///
/// ```swift
/// import JavaScriptEventLoop
/// ```
///
/// 3. Run this function **before* you start using `await` and/or `Task` APIs (again, most likely in
/// `main.swift`):
///
/// ```swift
/// JavaScriptEventLoop.installGlobalExecutor()
/// ```
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public final class JavaScriptEventLoop: SerialExecutor, @unchecked Sendable {

    /// A function that queues a given closure as a microtask into JavaScript event loop.
    /// See also: https://developer.mozilla.org/en-US/docs/Web/API/HTML_DOM_API/Microtask_guide
    public var queueMicrotask: (@escaping () -> Void) -> Void
    /// A function that invokes a given closure after a specified number of milliseconds.
    public var setTimeout: (Double, @escaping () -> Void) -> Void

    /// A mutable state to manage internal job queue
    /// Note that this should be guarded atomically when supporting multi-threaded environment.
    var queueState = QueueState()

    private init(
        queueTask: @escaping (@escaping () -> Void) -> Void,
        setTimeout: @escaping (Double, @escaping () -> Void) -> Void
    ) {
        self.queueMicrotask = queueTask
        self.setTimeout = setTimeout
    }

    /// A per-thread singleton instance of the Executor
    public static var shared: JavaScriptEventLoop {
        return _shared
    }

    #if compiler(>=6.1) && _runtime(_multithreaded)
    // In multi-threaded environment, we have an event loop executor per
    // thread (per Web Worker). A job enqueued in one thread should be
    // executed in the same thread under this global executor.
    private static var _shared: JavaScriptEventLoop {
        if let tls = swjs_thread_local_event_loop {
            let eventLoop = Unmanaged<JavaScriptEventLoop>.fromOpaque(tls).takeUnretainedValue()
            return eventLoop
        }
        let eventLoop = create()
        swjs_thread_local_event_loop = Unmanaged.passRetained(eventLoop).toOpaque()
        return eventLoop
    }
    #else
    private static let _shared: JavaScriptEventLoop = create()
    #endif

    private static func create() -> JavaScriptEventLoop {
        let promise = JSPromise(resolver: { resolver -> Void in
            resolver(.success(.undefined))
        })
        let setTimeout = JSObject.global.setTimeout.function!
        let eventLoop = JavaScriptEventLoop(
            queueTask: { job in
                // TODO(katei): Should prefer `queueMicrotask` if available?
                // We should measure if there is performance advantage.
                promise.then { _ in
                    job()
                    return JSValue.undefined
                }
            },
            setTimeout: { delay, job in
                setTimeout(
                    JSOneshotClosure { _ in
                        job()
                        return JSValue.undefined
                    },
                    delay
                )
            }
        )
        return eventLoop
    }

    private nonisolated(unsafe) static var didInstallGlobalExecutor = false

    /// Set JavaScript event loop based executor to be the global executor
    /// Note that this should be called before any of the jobs are created.
    /// This installation step will be unnecessary after custom executor are
    /// introduced officially. See also [a draft proposal for custom
    /// executors](https://github.com/rjmccall/swift-evolution/blob/custom-executors/proposals/0000-custom-executors.md#the-default-global-concurrent-executor)
    public static func installGlobalExecutor() {
        Self.installGlobalExecutorIsolated()
    }

    private static func installGlobalExecutorIsolated() {
        guard !didInstallGlobalExecutor else { return }
        didInstallGlobalExecutor = true
        #if compiler(>=6.2)
        if #available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999, *) {
            // For Swift 6.2 and above, we can use the new `ExecutorFactory` API
            _Concurrency._createExecutors(factory: JavaScriptEventLoop.self)
        }
        #else
        // For Swift 6.1 and below, we need to install the global executor by hook API
        installByLegacyHook()
        #endif
    }

    internal func enqueue(_ job: UnownedJob, withDelay milliseconds: Double) {
        setTimeout(
            milliseconds,
            {
                #if compiler(>=5.9)
                job.runSynchronously(on: self.asUnownedSerialExecutor())
                #else
                job._runSynchronously(on: self.asUnownedSerialExecutor())
                #endif
            }
        )
    }

    internal func unsafeEnqueue(_ job: UnownedJob) {
        #if canImport(wasi_pthread) && compiler(>=6.1) && _runtime(_multithreaded)
        guard swjs_get_worker_thread_id_cached() == SWJS_MAIN_THREAD_ID else {
            // Notify the main thread to execute the job when a job is
            // enqueued from a Web Worker thread but without an executor preference.
            // This is usually the case when hopping back to the main thread
            // at the end of a task.
            let jobBitPattern = unsafeBitCast(job, to: UInt.self)
            swjs_send_job_to_main_thread(jobBitPattern)
            return
        }
        // If the current thread is the main thread, do nothing special.
        #endif
        insertJobQueue(job: job)
    }

    #if compiler(>=5.9)
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    public func enqueue(_ job: consuming ExecutorJob) {
        // NOTE: Converting a `ExecutorJob` to an ``UnownedJob`` and invoking
        // ``UnownedJob/runSynchronously(_:)` on it multiple times is undefined behavior.
        unsafeEnqueue(UnownedJob(job))
    }
    #else
    public func enqueue(_ job: UnownedJob) {
        unsafeEnqueue(job)
    }
    #endif

    public func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        return UnownedSerialExecutor(ordinary: self)
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension JSPromise {
    /// Wait for the promise to complete, returning (or throwing) its result.
    public var value: JSValue {
        get async throws(JSException) {
            try await withUnsafeContinuation { [self] continuation in
                self.then(
                    success: {
                        continuation.resume(returning: Swift.Result<JSValue, JSException>.success($0))
                        return JSValue.undefined
                    },
                    failure: {
                        continuation.resume(returning: Swift.Result<JSValue, JSException>.failure(.init($0)))
                        return JSValue.undefined
                    }
                )
            }.get()
        }
    }

    /// Wait for the promise to complete, returning its result or exception as a Result.
    ///
    /// - Note: Calling this function does not switch from the caller's isolation domain.
    public func value(isolation: isolated (any Actor)? = #isolation) async throws(JSException) -> JSValue {
        try await withUnsafeContinuation(isolation: isolation) { [self] continuation in
            self.then(
                success: {
                    continuation.resume(returning: Swift.Result<JSValue, JSException>.success($0))
                    return JSValue.undefined
                },
                failure: {
                    continuation.resume(returning: Swift.Result<JSValue, JSException>.failure(.init($0)))
                    return JSValue.undefined
                }
            )
        }.get()
    }

    /// Wait for the promise to complete, returning its result or exception as a Result.
    public var result: JSPromise.Result {
        get async {
            await withUnsafeContinuation { [self] continuation in
                self.then(
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
        }
    }
}

#endif
