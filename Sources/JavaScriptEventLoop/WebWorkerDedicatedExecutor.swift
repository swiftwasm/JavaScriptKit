#if !hasFeature(Embedded)
import JavaScriptKit
import _CJavaScriptEventLoop
import _Concurrency

#if canImport(Synchronization)
import Synchronization
#endif
#if canImport(wasi_pthread)
import wasi_pthread
import WASILibc
#endif

/// A serial executor that runs on a dedicated web worker thread.
///
/// This executor is useful for running actors on a dedicated web worker thread.
///
/// ## Usage
///
/// ```swift
/// actor MyActor {
///     let executor: WebWorkerDedicatedExecutor
///     nonisolated var unownedExecutor: UnownedSerialExecutor {
///         self.executor.asUnownedSerialExecutor()
///     }
///     init(executor: WebWorkerDedicatedExecutor) {
///         self.executor = executor
///     }
/// }
///
/// let executor = try await WebWorkerDedicatedExecutor()
/// let actor = MyActor(executor: executor)
/// ```
///
/// - SeeAlso: ``WebWorkerTaskExecutor``
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
public final class WebWorkerDedicatedExecutor: SerialExecutor {

    private let underlying: WebWorkerTaskExecutor

    /// - Parameters:
    ///   - timeout: The maximum time to wait for all worker threads to be started. Default is 3 seconds.
    ///   - checkInterval: The interval to check if all worker threads are started. Default is 5 microseconds.
    /// - Throws: An error if any worker thread fails to initialize within the timeout period.
    public init(timeout: Duration = .seconds(3), checkInterval: Duration = .microseconds(5)) async throws {
        let underlying = try await WebWorkerTaskExecutor(
            numberOfThreads: 1,
            timeout: timeout,
            checkInterval: checkInterval
        )
        self.underlying = underlying
    }

    /// Terminates the worker thread.
    public func terminate() {
        self.underlying.terminate()
    }

    // MARK: - SerialExecutor conformance

    public func enqueue(_ job: consuming ExecutorJob) {
        self.underlying.enqueue(job)
    }
}
#endif
