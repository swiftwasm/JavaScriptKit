#if compiler(>=6.0) && !hasFeature(Embedded)  // `TaskExecutor` is available since Swift 6.0, no multi-threading for embedded Wasm yet.

import JavaScriptKit
import _CJavaScriptKit
import _CJavaScriptEventLoop

#if canImport(Synchronization)
import Synchronization
#endif
#if canImport(wasi_pthread)
import wasi_pthread
import WASILibc
#endif

// MARK: - Web Worker Task Executor

/// A task executor that runs tasks on Web Worker threads.
///
/// The `WebWorkerTaskExecutor` provides a way to execute Swift tasks in parallel across multiple
/// Web Worker threads, enabling true multi-threaded execution in WebAssembly environments.
/// This allows CPU-intensive tasks to be offloaded from the main thread, keeping the user
/// interface responsive.
///
/// ## Multithreading Model
///
/// Each task submitted to the executor runs on one of the available worker threads. By default,
/// child tasks created within a worker thread continue to run on the same worker thread,
/// maintaining thread locality and avoiding excessive context switching.
///
/// ## Object Sharing Between Threads
///
/// When working with JavaScript objects across threads, you must use the `JSSending` API to
/// explicitly transfer or clone objects:
///
/// ```swift
/// // Create and transfer an object to a worker thread
/// let buffer = JSObject.global.ArrayBuffer.object!.new(1024).object!
/// let transferring = JSSending.transfer(buffer)
///
/// let task = Task(executorPreference: executor) {
///     // Receive the transferred buffer in the worker
///     let workerBuffer = try await transferring.receive()
///     // Use the buffer in the worker thread
/// }
/// ```
///
/// ## Prerequisites
///
/// This task executor is designed to work with [wasi-threads](https://github.com/WebAssembly/wasi-threads)
/// but it requires the following single extension:
/// The wasi-threads implementation should listen to the `message` event
/// from spawned Web Workers, and forward the message to the main thread
/// by calling `_swjs_enqueue_main_job_from_worker`.
///
/// ## Basic Usage
///
/// ```swift
/// // Create an executor with 4 worker threads
/// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 4)
/// defer { executor.terminate() }
///
/// // Execute a task on a worker thread
/// let task = Task(executorPreference: executor) {
///     // This runs on a worker thread
///     return performHeavyComputation()
/// }
/// let result = await task.value
///
/// // Run a block on a worker thread
/// await withTaskExecutorPreference(executor) {
///     // This entire block runs on a worker thread
///     performHeavyComputation()
/// }
///
/// // Execute multiple tasks in parallel
/// await withTaskGroup(of: Int.self) { group in
///     for i in 0..<10 {
///         group.addTask(executorPreference: executor) {
///             // Each task runs on a worker thread
///             return fibonacci(i)
///         }
///     }
///
///     for await result in group {
///         // Process results as they complete
///     }
/// }
/// ```
///
/// ## Scheduling invariants
///
/// * Jobs enqueued on a worker are guaranteed to run within the same macrotask in which they were scheduled.
///
/// ## Known limitations
///
/// Currently, the Cooperative Global Executor of Swift runtime has a bug around
/// main executor detection. The issue leads to ignoring the `@MainActor`
/// attribute, which is supposed to run tasks on the main thread, when this web
/// worker executor is preferred.
///
/// ```swift
/// func run(executor: WebWorkerTaskExecutor) async {
///   await withTaskExecutorPreference(executor) {
///     // This block runs on the Web Worker thread.
///     await MainActor.run {
///         // This block should run on the main thread, but it runs on
///         // the Web Worker thread.
///     }
///   }
///   // Back to the main thread.
/// }
/// ````
///
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)  // For `Atomic` and `TaskExecutor` types
public final class WebWorkerTaskExecutor: TaskExecutor {

    /// An error that occurs when spawning a worker thread fails.
    public struct SpawnError: Error {
        /// The reason for the error.
        public let reason: String

        internal init(reason: String) {
            self.reason = reason
        }
    }

    /// A job worker dedicated to a single Web Worker thread.
    ///
    /// ## Lifetime
    /// The worker instance in Swift world lives as long as the
    /// `WebWorkerTaskExecutor` instance that spawned it lives. Thus, the worker
    /// instance may outlive the underlying Web Worker thread.
    fileprivate final class Worker: Sendable {

        /// The state of the worker.
        ///
        /// State transition:
        ///
        ///              +---------+                +------------+
        ///       +----->|  Idle   |--[terminate]-->| Terminated |
        ///       |      +---+-----+                +------------+
        ///       |          |  \
        ///       |          |   \------------------+
        ///       |          |                      |
        ///       |      [enqueue]              [enqueue] (on other thread)
        ///       |          |                      |
        ///  [no more job]   |                      |
        ///       |          v                      v
        ///       |      +---------+           +---------+
        ///       +------| Running |<--[wake]--|  Ready  |
        ///              +---------+           +---------+
        ///
        enum State: UInt32, AtomicRepresentable {
            /// The worker is idle and waiting for a new job.
            case idle = 0
            /// A wake message is sent to the worker, but it has not been received it yet
            case ready = 1
            /// The worker is processing a job.
            case running = 2
            /// The worker is terminated.
            case terminated = 3
        }
        let state: Atomic<State> = Atomic(.idle)
        /// TODO: Rewrite it to use real queue :-)
        let jobQueue: Mutex<[UnownedJob]> = Mutex([])
        /// The TaskExecutor that spawned this worker.
        /// This variable must be set only once when the worker is started.
        nonisolated(unsafe) weak var parentTaskExecutor: WebWorkerTaskExecutor.Executor?
        /// The thread ID of this worker.
        let tid: Atomic<pid_t> = Atomic(0)

        /// A trace statistics
        struct TraceStats: CustomStringConvertible {
            var enqueuedJobs: Int = 0
            var dequeuedJobs: Int = 0
            var processedJobs: Int = 0

            var description: String {
                "TraceStats(E: \(enqueuedJobs), D: \(dequeuedJobs), P: \(processedJobs))"
            }
        }
        #if JAVASCRIPTKIT_STATS
        private let traceStats = Mutex(TraceStats())
        private func statsIncrement(_ keyPath: WritableKeyPath<TraceStats, Int>) {
            traceStats.withLock { stats in
                stats[keyPath: keyPath] += 1
            }
        }
        #else
        private func statsIncrement(_ keyPath: WritableKeyPath<TraceStats, Int>) {}
        #endif

        /// The worker bound to the current thread.
        /// Returns `nil` if the current thread is not a worker thread.
        static var currentThread: Worker? {
            guard let ptr = swjs_thread_local_task_executor_worker else {
                return nil
            }
            return Unmanaged<Worker>.fromOpaque(ptr).takeUnretainedValue()
        }

        init() {}

        /// Enqueue a job to the worker.
        func enqueue(_ job: UnownedJob) {
            statsIncrement(\.enqueuedJobs)
            var locked: Bool
            let onTargetThread = Self.currentThread === self
            // If it's on the thread and it's idle, we can directly schedule a `Worker/run` microtask.
            let desiredState: State = onTargetThread ? .running : .ready
            repeat {
                let result: Void? = jobQueue.withLockIfAvailable { queue in
                    queue.append(job)
                    trace("Worker.enqueue idle -> running")
                    // Wake up the worker to process a job.
                    trace("Worker.enqueue idle -> \(desiredState)")
                    switch state.compareExchange(
                        expected: .idle,
                        desired: desiredState,
                        ordering: .sequentiallyConsistent
                    ) {
                    case (true, _):
                        if onTargetThread {
                            // Enqueueing a new job to the current worker thread, but it's idle now.
                            // This is usually the case when a continuation is resumed by JS events
                            // like `setTimeout` or `addEventListener`.
                            // We can run the job and subsequently spawned jobs immediately.
                            scheduleRunWithinMacroTask()
                        } else {
                            let tid = self.tid.load(ordering: .sequentiallyConsistent)
                            swjs_wake_up_worker_thread(tid)
                        }
                    case (false, .idle):
                        preconditionFailure("unreachable: idle -> \(desiredState) should return exchanged=true")
                    case (false, .ready):
                        // A wake message is sent to the worker, but it has not been received it yet
                        if onTargetThread {
                            // This means the job is enqueued outside of `Worker/run` (typically triggered
                            // JS microtasks not awaited by Swift), then schedule a `Worker/run` within
                            // the same macrotask.
                            state.store(.running, ordering: .sequentiallyConsistent)
                            scheduleRunWithinMacroTask()
                        }
                    case (false, .running):
                        // The worker is already running, no need to wake up.
                        break
                    case (false, .terminated):
                        // Will not wake up the worker because it's already terminated.
                        break
                    }
                }
                locked = result != nil
            } while !locked
        }

        func scheduleRunWithinMacroTask() {
            _ = JSObject.global.queueMicrotask!(
                JSOneshotClosure { _ in
                    self.run()
                    return JSValue.undefined
                }
            )
        }

        /// Run the worker
        ///
        /// NOTE: This function must be called from the worker thread.
        /// It will return when the worker is terminated.
        func start(executor: WebWorkerTaskExecutor.Executor) {
            // Get the thread ID of the current worker thread from the JS side.
            // NOTE: Unfortunately even though `pthread_self` internally holds the thread ID,
            // there is no public API to get it because it's a part of implementation details
            // of wasi-libc. So we need to get it from the JS side.
            let tid = swjs_get_worker_thread_id()
            // Set the thread-local variable to the current worker.
            // `self` outlives the worker thread because `Executor` retains the worker.
            // Thus it's safe to store the reference without extra retain.
            swjs_thread_local_task_executor_worker = Unmanaged.passUnretained(self).toOpaque()
            // Start listening events from the main thread.
            // This must be called after setting the swjs_thread_local_task_executor_worker
            // because the event listener enqueues jobs to the TLS worker.
            swjs_listen_message_from_main_thread()
            // Set the parent executor.
            parentTaskExecutor = executor
            // Store the thread ID to the worker. This notifies the main thread that the worker is started.
            self.tid.store(tid, ordering: .sequentiallyConsistent)
            trace("Worker.start tid=\(tid)")
        }

        /// On receiving a wake-up message from other thread
        func wakeUpFromOtherThread() {
            let (exchanged, _) = state.compareExchange(
                expected: .ready,
                desired: .running,
                ordering: .sequentiallyConsistent
            )
            guard exchanged else {
                // `Worker/run` was scheduled on the thread before JS event loop starts
                // a macrotask handling wake-up message.
                return
            }
            run()
        }

        /// Process jobs in the queue.
        ///
        /// Return when the worker has no more jobs to run or terminated.
        /// This method must be called from the worker thread after the worker
        /// is started by `start(executor:)`.
        private func run() {
            trace("Worker.run")
            guard let executor = parentTaskExecutor else {
                preconditionFailure("The worker must be started with a parent executor.")
            }
            do {
                // Assert the state at the beginning of the run.
                let state = state.load(ordering: .sequentiallyConsistent)
                assert(
                    state == .running || state == .terminated,
                    "Invalid state: not running (tid=\(self.tid.load(ordering: .sequentiallyConsistent)), \(state))"
                )
            }
            while true {
                // Pop a job from the queue.
                let job = jobQueue.withLock { queue -> UnownedJob? in
                    if let job = queue.first {
                        queue.removeFirst()
                        return job
                    }
                    // No more jobs to run now.
                    let (exchanged, original) = state.compareExchange(
                        expected: .running,
                        desired: .idle,
                        ordering: .sequentiallyConsistent
                    )

                    switch (exchanged, original) {
                    case (true, _):
                        trace("Worker.run exited \(original) -> idle")
                        return nil  // Regular case
                    case (false, .idle), (false, .ready):
                        preconditionFailure("unreachable: Worker/run running in multiple threads!?")
                    case (false, .running):
                        preconditionFailure("unreachable: running -> idle should return exchanged=true")
                    case (false, .terminated):
                        return nil  // The worker is terminated, exit the loop.
                    }
                }
                guard let job else { return }
                statsIncrement(\.dequeuedJobs)
                job.runSynchronously(
                    on: executor.asUnownedTaskExecutor()
                )
                statsIncrement(\.processedJobs)
                // The job is done. Continue to the next job.
            }
        }

        /// Terminate the worker.
        func terminate() {
            trace("Worker.terminate tid=\(tid.load(ordering: .sequentiallyConsistent))")
            state.store(.terminated, ordering: .sequentiallyConsistent)
            let tid = self.tid.load(ordering: .sequentiallyConsistent)
            guard tid != 0 else {
                // The worker is not started yet.
                return
            }
            swjs_terminate_worker_thread(tid)
        }
    }

    fileprivate final class Executor: TaskExecutor {
        let numberOfThreads: Int
        let workers: [Worker]
        let roundRobinIndex: Mutex<Int> = Mutex(0)

        init(numberOfThreads: Int) {
            self.numberOfThreads = numberOfThreads
            var workers = [Worker]()
            for _ in 0..<numberOfThreads {
                let worker = Worker()
                workers.append(worker)
            }
            self.workers = workers
        }

        func start(timeout: Duration, checkInterval: Duration) async throws {
            #if canImport(wasi_pthread) && compiler(>=6.1) && _runtime(_multithreaded)
            class Context: @unchecked Sendable {
                let executor: WebWorkerTaskExecutor.Executor
                let worker: Worker
                init(executor: WebWorkerTaskExecutor.Executor, worker: Worker) {
                    self.executor = executor
                    self.worker = worker
                }
            }
            trace("Executor.start")

            // Hold over-retained contexts until all worker threads are started.
            var contexts: [Unmanaged<Context>] = []
            defer {
                for context in contexts {
                    context.release()
                }
            }
            // Start worker threads via pthread_create.
            for worker in workers {
                // NOTE: The context must be allocated on the heap because
                // `pthread_create` on WASI does not guarantee the thread is started
                // immediately. The context must be retained until the thread is started.
                let context = Context(executor: self, worker: worker)
                let unmanagedContext = Unmanaged.passRetained(context)
                contexts.append(unmanagedContext)
                let ptr = unmanagedContext.toOpaque()
                var thread = pthread_t(bitPattern: 0)
                let ret = pthread_create(
                    &thread,
                    nil,
                    { ptr in
                        // Cast to a optional pointer to absorb nullability variations between platforms.
                        let ptr: UnsafeMutableRawPointer? = ptr
                        let context = Unmanaged<Context>.fromOpaque(ptr!).takeUnretainedValue()
                        context.worker.start(executor: context.executor)
                        // The worker is started. Throw JS exception to unwind the call stack without
                        // reaching the `pthread_exit`, which is called immediately after this block.
                        swjs_unsafe_event_loop_yield()
                        return nil
                    },
                    ptr
                )
                guard ret == 0 else {
                    let strerror = String(cString: strerror(ret))
                    throw SpawnError(reason: "Failed to create a thread (\(ret): \(strerror))")
                }
            }
            // Wait until all worker threads are started and wire up messaging channels
            // between the main thread and workers to notify job enqueuing events each other.
            let clock = ContinuousClock()
            let workerInitStarted = clock.now
            for worker in workers {
                var tid: pid_t
                repeat {
                    if workerInitStarted.duration(to: .now) > timeout {
                        throw SpawnError(
                            reason: "Worker thread initialization timeout exceeded (\(timeout))"
                        )
                    }
                    tid = worker.tid.load(ordering: .sequentiallyConsistent)
                    try await clock.sleep(for: checkInterval)
                } while tid == 0
                swjs_listen_message_from_worker_thread(tid)
            }
            #else
            fatalError("Unsupported platform. WebWorkerTaskExecutor requires Swift SDK for wasip1-threads target.")
            #endif
        }

        func terminate() {
            for worker in workers {
                worker.terminate()
            }
        }

        func enqueue(_ job: UnownedJob) {
            precondition(!workers.isEmpty, "No worker threads are available")

            // If the current thread is a worker thread, enqueue the job to the current worker.
            if let worker = Worker.currentThread {
                worker.enqueue(job)
                return
            }
            // Otherwise (main thread), enqueue the job to the worker with round-robin scheduling.
            // TODO: Use a more sophisticated scheduling algorithm with priority.
            roundRobinIndex.withLock { index in
                let worker = workers[index]
                worker.enqueue(job)
                index = (index + 1) % numberOfThreads
            }
        }
    }

    private let executor: Executor

    /// Creates a new Web Worker task executor with the specified number of worker threads.
    ///
    /// This initializer creates a pool of Web Worker threads that can execute Swift tasks
    /// in parallel. The initialization is asynchronous because it waits for all worker
    /// threads to be properly initialized before returning.
    ///
    /// The number of threads should typically match the number of available CPU cores
    /// for CPU-bound workloads. For I/O-bound workloads, you might benefit from more
    /// threads than CPU cores.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Create an executor with 4 worker threads
    /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 4)
    ///
    /// // Always terminate the executor when you're done with it
    /// defer { executor.terminate() }
    ///
    /// // Use the executor...
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfThreads: The number of Web Worker threads to spawn.
    ///   - timeout: The maximum time to wait for all worker threads to be started. Default is 3 seconds.
    ///   - checkInterval: The interval to check if all worker threads are started. Default is 5 microseconds.
    /// - Throws: An error if any worker thread fails to initialize within the timeout period.
    public init(
        numberOfThreads: Int,
        timeout: Duration = .seconds(3),
        checkInterval: Duration = .microseconds(5)
    ) async throws {
        self.executor = Executor(numberOfThreads: numberOfThreads)
        try await self.executor.start(timeout: timeout, checkInterval: checkInterval)
    }

    /// Terminates all worker threads managed by this executor.
    ///
    /// This method should be called when the executor is no longer needed to free up
    /// resources. After calling this method, any tasks enqueued to this executor will
    /// be ignored and may never complete.
    ///
    /// It's recommended to use a `defer` statement immediately after creating the executor
    /// to ensure it's properly terminated when it goes out of scope.
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let executor = try await WebWorkerTaskExecutor(numberOfThreads: 4)
    ///     defer { executor.terminate() }
    ///
    ///     // Use the executor...
    /// }
    /// // Executor is automatically terminated when exiting the scope
    /// ```
    ///
    /// - Important: This method must be called after all tasks that prefer this executor are done.
    ///   Otherwise, the tasks may stuck forever.
    public func terminate() {
        executor.terminate()
    }

    /// Returns the number of worker threads managed by this executor.
    ///
    /// This property reflects the value provided during initialization and doesn't change
    /// during the lifetime of the executor.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 4)
    /// print("Executor is running with \(executor.numberOfThreads) threads")
    /// // Prints: "Executor is running with 4 threads"
    /// ```
    public var numberOfThreads: Int {
        executor.numberOfThreads
    }

    // MARK: TaskExecutor conformance

    /// Enqueues a job to be executed by one of the worker threads.
    ///
    /// This method is part of the `TaskExecutor` protocol and is called by the Swift
    /// Concurrency runtime. You typically don't need to call this method directly.
    ///
    /// - Parameter job: The job to enqueue.
    public func enqueue(_ job: UnownedJob) {
        Self.traceStatsIncrement(\.enqueueExecutor)
        executor.enqueue(job)
    }

    // MARK: Statistics

    /// Executor global statistics
    internal struct ExecutorStats: CustomStringConvertible {
        var sendJobToMainThread: Int = 0
        var receiveJobFromWorkerThread: Int = 0
        var enqueueGlobal: Int = 0
        var enqueueExecutor: Int = 0

        var description: String {
            "ExecutorStats(sendWtoM: \(sendJobToMainThread), recvWfromM: \(receiveJobFromWorkerThread)), enqueueGlobal: \(enqueueGlobal), enqueueExecutor: \(enqueueExecutor)"
        }
    }
    #if JAVASCRIPTKIT_STATS
    private static let stats = Mutex(ExecutorStats())
    fileprivate static func traceStatsIncrement(_ keyPath: WritableKeyPath<ExecutorStats, Int>) {
        stats.withLock { stats in
            stats[keyPath: keyPath] += 1
        }
    }
    internal func dumpStats() {
        Self.stats.withLock { stats in
            print("WebWorkerTaskExecutor stats: \(stats)")
        }
    }
    #else
    fileprivate static func traceStatsIncrement(_ keyPath: WritableKeyPath<ExecutorStats, Int>) {}
    internal func dumpStats() {}
    #endif

    @available(*, deprecated, message: "Not needed anymore, just use `JavaScriptEventLoop.installGlobalExecutor()`.")
    public static func installGlobalExecutor() {}
}

/// Enqueue a job scheduled from a Web Worker thread to the main thread.
/// This function is called when a job is enqueued from a Web Worker thread.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_enqueue_main_job_from_worker")
#endif
func _swjs_enqueue_main_job_from_worker(_ job: UnownedJob) {
    WebWorkerTaskExecutor.traceStatsIncrement(\.receiveJobFromWorkerThread)
    JavaScriptEventLoop.shared.enqueue(ExecutorJob(job))
}

/// Wake up the worker thread.
/// This function is called when a job is enqueued from the main thread to a worker thread.
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_wake_worker_thread")
#endif
func _swjs_wake_worker_thread() {
    WebWorkerTaskExecutor.Worker.currentThread!.wakeUpFromOtherThread()
}

@inline(__always)
private func trace(_ message: @autoclosure () -> String) {
    #if JAVASCRIPTKIT_TRACE
    _ = JSObject.global.console.warn("[trace tid=\(swjs_get_worker_thread_id())] \(message())\n")
    #endif
}

#endif  // compiler(>=6.0)
