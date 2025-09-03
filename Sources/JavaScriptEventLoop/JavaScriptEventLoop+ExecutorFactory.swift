// Implementation of custom executors for JavaScript event loop
// This file implements the ExecutorFactory protocol to provide custom main and global executors
// for Swift concurrency in JavaScript environment.
// See: https://github.com/swiftlang/swift/pull/80266
// See: https://forums.swift.org/t/pitch-2-custom-main-and-global-executors/78437

import _Concurrency
import _CJavaScriptKit

#if compiler(>=6.2)

// MARK: - MainExecutor Implementation
// MainExecutor is used by the main actor to execute tasks on the main thread
@available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999, *)
extension JavaScriptEventLoop: MainExecutor {
    public func run() throws {
        // This method is called from `swift_task_asyncMainDrainQueueImpl`.
        // https://github.com/swiftlang/swift/blob/swift-DEVELOPMENT-SNAPSHOT-2025-04-12-a/stdlib/public/Concurrency/ExecutorImpl.swift#L28
        // Yield control to the JavaScript event loop to skip the `exit(0)`
        // call by `swift_task_asyncMainDrainQueueImpl`.
        swjs_unsafe_event_loop_yield()
    }
    public func stop() {}
}

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension JavaScriptEventLoop: TaskExecutor {}

@available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999, *)
extension JavaScriptEventLoop: SchedulingExecutor {
    public func enqueue<C: Clock>(
        _ job: consuming ExecutorJob,
        after delay: C.Duration,
        tolerance: C.Duration?,
        clock: C
    ) {
        let duration: Duration
        // Handle clocks we know
        if let _ = clock as? ContinuousClock {
            duration = delay as! ContinuousClock.Duration
        } else if let _ = clock as? SuspendingClock {
            duration = delay as! SuspendingClock.Duration
        } else {
            // Hand-off the scheduling work to Clock implementation for unknown clocks
            clock.enqueue(
                job,
                on: self,
                at: clock.now.advanced(by: delay),
                tolerance: tolerance
            )
            return
        }
        let milliseconds = Self.delayInMilliseconds(from: duration)
        self.enqueue(
            UnownedJob(job),
            withDelay: milliseconds
        )
    }

    private static func delayInMilliseconds(from swiftDuration: Duration) -> Double {
        let (seconds, attoseconds) = swiftDuration.components
        return Double(seconds) * 1_000 + (Double(attoseconds) / 1_000_000_000_000_000)
    }
}

// MARK: - ExecutorFactory Implementation
@available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999, *)
extension JavaScriptEventLoop: ExecutorFactory {
    // Forward all operations to the current thread's JavaScriptEventLoop instance
    final class CurrentThread: TaskExecutor, SchedulingExecutor, MainExecutor, SerialExecutor {
        func checkIsolated() {}

        func enqueue(_ job: consuming ExecutorJob) {
            JavaScriptEventLoop.shared.enqueue(job)
        }

        func enqueue<C: Clock>(
            _ job: consuming ExecutorJob,
            after delay: C.Duration,
            tolerance: C.Duration?,
            clock: C
        ) {
            JavaScriptEventLoop.shared.enqueue(
                job,
                after: delay,
                tolerance: tolerance,
                clock: clock
            )
        }
        func run() throws {
            try JavaScriptEventLoop.shared.run()
        }
        func stop() {
            JavaScriptEventLoop.shared.stop()
        }
    }

    public static var mainExecutor: any MainExecutor {
        CurrentThread()
    }

    public static var defaultExecutor: any TaskExecutor {
        CurrentThread()
    }
}

#endif  // compiler(>=6.2)
