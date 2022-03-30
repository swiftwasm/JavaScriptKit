import JavaScriptKit
import _CJavaScriptEventLoop

// NOTE: `@available` annotations are semantically wrong, but they make it easier to develop applications targeting WebAssembly in Xcode.

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public final class JavaScriptEventLoop: SerialExecutor, @unchecked Sendable {

    /// A function that queues a given closure as a microtask into JavaScript event loop.
    /// See also: https://developer.mozilla.org/en-US/docs/Web/API/HTML_DOM_API/Microtask_guide
    let queueMicrotask: @Sendable (@escaping () -> Void) -> Void
    /// A function that invokes a given closure after a specified number of milliseconds.
    let setTimeout: @Sendable (UInt64, @escaping () -> Void) -> Void

    /// A mutable state to manage internal job queue
    /// Note that this should be guarded atomically when supporting multi-threaded environment.
    var queueState = QueueState()

    private init(
        queueTask: @Sendable @escaping (@escaping () -> Void) -> Void,
        setTimeout: @Sendable @escaping (UInt64, @escaping () -> Void) -> Void
    ) {
        self.queueMicrotask = queueTask
        self.setTimeout = setTimeout
    }

    /// A singleton instance of the Executor
    public static let shared: JavaScriptEventLoop = {
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
                setTimeout(JSOneshotClosure { _ in
                    job()
                    return JSValue.undefined
                }, delay)
            }
        )
        return eventLoop
    }()

    private static var didInstallGlobalExecutor = false

    /// Set JavaScript event loop based executor to be the global executor
    /// Note that this should be called before any of the jobs are created.
    /// This installation step will be unnecessary after the custom-executor will be introduced officially.
    /// See also: https://github.com/rjmccall/swift-evolution/blob/custom-executors/proposals/0000-custom-executors.md#the-default-global-concurrent-executor
    public static func installGlobalExecutor() {
        guard !didInstallGlobalExecutor else { return }

        typealias swift_task_enqueueGlobal_hook_Fn = @convention(thin) (UnownedJob, swift_task_enqueueGlobal_original) -> Void
        let swift_task_enqueueGlobal_hook_impl: swift_task_enqueueGlobal_hook_Fn = { job, original in
            JavaScriptEventLoop.shared.enqueue(job)
        }
        swift_task_enqueueGlobal_hook = unsafeBitCast(swift_task_enqueueGlobal_hook_impl, to: UnsafeMutableRawPointer?.self)

        typealias swift_task_enqueueGlobalWithDelay_hook_Fn = @convention(thin) (UInt64, UnownedJob, swift_task_enqueueGlobalWithDelay_original) -> Void
        let swift_task_enqueueGlobalWithDelay_hook_impl: swift_task_enqueueGlobalWithDelay_hook_Fn = { delay, job, original in
            JavaScriptEventLoop.shared.enqueue(job, withDelay: delay)
        }
        swift_task_enqueueGlobalWithDelay_hook = unsafeBitCast(swift_task_enqueueGlobalWithDelay_hook_impl, to: UnsafeMutableRawPointer?.self)

        typealias swift_task_enqueueMainExecutor_hook_Fn = @convention(thin) (UnownedJob, swift_task_enqueueMainExecutor_original) -> Void
        let swift_task_enqueueMainExecutor_hook_impl: swift_task_enqueueMainExecutor_hook_Fn = { job, original in
            JavaScriptEventLoop.shared.enqueue(job)
        }
        swift_task_enqueueMainExecutor_hook = unsafeBitCast(swift_task_enqueueMainExecutor_hook_impl, to: UnsafeMutableRawPointer?.self)
        
        didInstallGlobalExecutor = true
    }

    private func enqueue(_ job: UnownedJob, withDelay nanoseconds: UInt64) {
        let milliseconds = nanoseconds / 1_000_000
        setTimeout(milliseconds, {
            job._runSynchronously(on: self.asUnownedSerialExecutor())
        })
    }

    public func enqueue(_ job: UnownedJob) {
        insertJobQueue(job: job)
    }

    public func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        return UnownedSerialExecutor(ordinary: self)
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension JSPromise {
    /// Wait for the promise to complete, returning (or throwing) its result.
    func get() async throws -> JSValue {
        try await withUnsafeThrowingContinuation { [self] continuation in
            self.then(
                success: {
                    continuation.resume(returning: $0)
                    return JSValue.undefined
                },
                failure: {
                    continuation.resume(throwing: $0)
                    return JSValue.undefined
                }
            )
        }
    }
}

#endif
