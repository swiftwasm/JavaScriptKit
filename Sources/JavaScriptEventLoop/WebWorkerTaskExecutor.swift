#if compiler(>=6.0) && _runtime(_multithreaded) // @_expose and @_extern are only available in Swift 6.0+

import JavaScriptKit
import _CJavaScriptKit
import _CJavaScriptEventLoop

import Synchronization
#if canImport(wasi_pthread)
    import wasi_pthread
    import WASILibc
#endif

// MARK: - Web Worker Task Executor

/// A task executor that runs tasks on Web Worker threads.
///
/// ## Prerequisites
///
/// This task executor is designed to work with [wasi-threads](https://github.com/WebAssembly/wasi-threads)
/// but it requires the following single extension:
/// The wasi-threads implementation should listen to the `message` event
/// from spawned Web Workers, and forward the message to the main thread
/// by calling `_swjs_enqueue_main_job_from_worker`.
///
/// ## Usage
///
/// ```swift
/// let executor = WebWorkerTaskExecutor(numberOfThreads: 4)
/// defer { executor.terminate() }
///
/// await withTaskExecutorPreference(executor) {
///   // This block runs on the Web Worker thread.
///   await withTaskGroup(of: Int.self) { group in
///     for i in 0..<10 {
///       // Structured child works are executed on the Web Worker thread.
///       group.addTask { fibonacci(of: i) }
///     }
///   }
/// }
/// ````
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
public final class WebWorkerTaskExecutor: TaskExecutor {

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
        ///       |          |
        ///       |      [enqueue]
        ///       |          |
        ///  [no more job]   |
        ///       |          v
        ///       |      +---------+
        ///       +------| Running |
        ///              +---------+
        ///
        enum State: UInt32, AtomicRepresentable {
            /// The worker is idle and waiting for a new job.
            case idle = 0
            /// The worker is processing a job.
            case running = 1
            /// The worker is terminated.
            case terminated = 2
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
            jobQueue.withLock { queue in
                queue.append(job)

                // Wake up the worker to process a job.
                switch state.exchange(.running, ordering: .sequentiallyConsistent) {
                case .idle:
                    if Self.currentThread === self {
                        // Enqueueing a new job to the current worker thread, but it's idle now.
                        // This is usually the case when a continuation is resumed by JS events
                        // like `setTimeout` or `addEventListener`.
                        // We can run the job and subsequently spawned jobs immediately.
                        // JSPromise.resolve(JSValue.undefined).then { _ in
                        _ = JSObject.global.queueMicrotask!(JSOneshotClosure { _ in
                            self.run()
                            return JSValue.undefined
                        })
                    } else {
                        let tid = self.tid.load(ordering: .sequentiallyConsistent)
                        swjs_wake_up_worker_thread(tid)
                    }
                case .running:
                    // The worker is already running, no need to wake up.
                    break
                case .terminated:
                    // Will not wake up the worker because it's already terminated.
                    break
                }
            }
        }

        func scheduleNextRun() {
            _ = JSObject.global.queueMicrotask!(JSOneshotClosure { _ in
                self.run()
                return JSValue.undefined
            })
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
            // Start listening wake-up events from the main thread.
            // This must be called after setting the swjs_thread_local_task_executor_worker
            // because the event listener enqueues jobs to the TLS worker.
            swjs_listen_wake_event_from_main_thread()
            // Set the parent executor.
            parentTaskExecutor = executor
            // Store the thread ID to the worker. This notifies the main thread that the worker is started.
            self.tid.store(tid, ordering: .sequentiallyConsistent)
        }

        /// Process jobs in the queue.
        ///
        /// Return when the worker has no more jobs to run or terminated.
        /// This method must be called from the worker thread after the worker
        /// is started by `start(executor:)`.
        func run() {
            trace("Worker.run")
            guard let executor = parentTaskExecutor else {
                preconditionFailure("The worker must be started with a parent executor.")
            }
            assert(state.load(ordering: .sequentiallyConsistent) == .running, "Invalid state: not running")
            while true {
                // Pop a job from the queue.
                let job = jobQueue.withLock { queue -> UnownedJob? in
                    if let job = queue.first {
                        queue.removeFirst()
                        return job
                    }
                    // No more jobs to run now. Wait for a new job to be enqueued.
                    let (exchanged, original) = state.compareExchange(expected: .running, desired: .idle, ordering: .sequentiallyConsistent)

                    switch (exchanged, original) {
                    case (true, _):
                        trace("Worker.run exited \(original) -> idle")
                        return nil // Regular case
                    case (false, .idle):
                        preconditionFailure("unreachable: Worker/run running in multiple threads!?")
                    case (false, .running):
                        preconditionFailure("unreachable: running -> idle should return exchanged=true")
                    case (false, .terminated):
                        return nil // The worker is terminated, exit the loop.
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
            trace("Worker.terminate")
            state.store(.terminated, ordering: .sequentiallyConsistent)
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

        func start() {
            class Context: @unchecked Sendable {
                let executor: WebWorkerTaskExecutor.Executor
                let worker: Worker
                init(executor: WebWorkerTaskExecutor.Executor, worker: Worker) {
                    self.executor = executor
                    self.worker = worker
                }
            }
            // Start worker threads via pthread_create.
            for worker in workers {
                // NOTE: The context must be allocated on the heap because
                // `pthread_create` on WASI does not guarantee the thread is started
                // immediately. The context must be retained until the thread is started.
                let context = Context(executor: self, worker: worker)
                let ptr = Unmanaged.passRetained(context).toOpaque()
                let ret = pthread_create(nil, nil, { ptr in
                    // Cast to a optional pointer to absorb nullability variations between platforms.
                    let ptr: UnsafeMutableRawPointer? = ptr
                    let context = Unmanaged<Context>.fromOpaque(ptr!).takeRetainedValue()
                    context.worker.start(executor: context.executor)
                    // The worker is started. Throw JS exception to unwind the call stack without
                    // reaching the `pthread_exit`, which is called immediately after this block.
                    swjs_unsafe_event_loop_yield()
                    return nil
                }, ptr)
                precondition(ret == 0, "Failed to create a thread")
            }
            // Wait until all worker threads are started and wire up messaging channels
            // between the main thread and workers to notify job enqueuing events each other.
            for worker in workers {
                var tid: pid_t
                repeat {
                    tid = worker.tid.load(ordering: .sequentiallyConsistent)
                } while tid == 0
                swjs_listen_main_job_from_worker_thread(tid)
            }
        }

        func terminate() {
            for worker in workers {
                worker.terminate()
            }
        }

        func enqueue(_ job: consuming ExecutorJob) {
            precondition(!workers.isEmpty, "No worker threads are available")

            let job = UnownedJob(job)
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

    /// Create a new Web Worker task executor.
    ///
    /// - Parameter numberOfThreads: The number of Web Worker threads to spawn.
    public init(numberOfThreads: Int) {
        self.executor = Executor(numberOfThreads: numberOfThreads)
        self.executor.start()
    }

    /// Terminate child Web Worker threads.
    /// Jobs enqueued to the executor after calling this method will be ignored.
    ///
    /// NOTE: This method must be called after all tasks that prefer this executor are done.
    /// Otherwise, the tasks may stuck forever.
    public func terminate() {
        executor.terminate()
    }

    /// The number of Web Worker threads.
    public var numberOfThreads: Int {
        executor.numberOfThreads
    }

    // MARK: TaskExecutor conformance

    /// Enqueue a job to the executor.
    ///
    /// NOTE: Called from the Swift Concurrency runtime.
    public func enqueue(_ job: consuming ExecutorJob) {
        Self.traceStatsIncrement(\.enqueueExecutor)
        executor.enqueue(job)
    }

    // MARK: Statistics

    /// Executor global statistics
    internal struct ExecutorStats: CustomStringConvertible {
        var sendJobToMainThread: Int = 0
        var recieveJobFromWorkerThread: Int = 0
        var enqueueGlobal: Int = 0
        var enqueueExecutor: Int = 0

        var description: String {
            "ExecutorStats(sendWtoM: \(sendJobToMainThread), recvWfromM: \(recieveJobFromWorkerThread)), enqueueGlobal: \(enqueueGlobal), enqueueExecutor: \(enqueueExecutor)"
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

    // MARK: Global Executor hack

    private static var _mainThread: pthread_t?
    private static var _swift_task_enqueueGlobal_hook_original: UnsafeMutableRawPointer?
    private static var _swift_task_enqueueGlobalWithDelay_hook_original: UnsafeMutableRawPointer?
    private static var _swift_task_enqueueGlobalWithDeadline_hook_original: UnsafeMutableRawPointer?

    /// Install a global executor that forwards jobs from Web Worker threads to the main thread.
    ///
    /// This function must be called once before using the Web Worker task executor.
    public static func installGlobalExecutor() {
        // Ensure this function is called only once.
        guard _mainThread == nil else { return }

        _mainThread = pthread_self()
        assert(swjs_get_worker_thread_id() == -1, "\(#function) must be called on the main thread")

        _swift_task_enqueueGlobal_hook_original = swift_task_enqueueGlobal_hook

        typealias swift_task_enqueueGlobal_hook_Fn = @convention(thin) (UnownedJob, swift_task_enqueueGlobal_original) -> Void
        let swift_task_enqueueGlobal_hook_impl: swift_task_enqueueGlobal_hook_Fn = { job, base in
            WebWorkerTaskExecutor.traceStatsIncrement(\.enqueueGlobal)
            // Enter this block only if the current Task has no executor preference.
            if pthread_equal(pthread_self(), WebWorkerTaskExecutor._mainThread) != 0 {
                // If the current thread is the main thread, delegate the job
                // execution to the original hook of JavaScriptEventLoop.
                let original = unsafeBitCast(WebWorkerTaskExecutor._swift_task_enqueueGlobal_hook_original, to: swift_task_enqueueGlobal_hook_Fn.self)
                original(job, base)
            } else {
                // Notify the main thread to execute the job when a job is
                // enqueued from a Web Worker thread but without an executor preference.
                // This is usually the case when hopping back to the main thread
                // at the end of a task.
                WebWorkerTaskExecutor.traceStatsIncrement(\.sendJobToMainThread)
                let jobBitPattern = unsafeBitCast(job, to: UInt.self)
                swjs_send_job_to_main_thread(jobBitPattern)
            }
        }
        swift_task_enqueueGlobal_hook = unsafeBitCast(swift_task_enqueueGlobal_hook_impl, to: UnsafeMutableRawPointer?.self)
    }
}

/// Enqueue a job scheduled from a Web Worker thread to the main thread.
/// This function is called when a job is enqueued from a Web Worker thread.
@_expose(wasm, "swjs_enqueue_main_job_from_worker")
func _swjs_enqueue_main_job_from_worker(_ job: UnownedJob) {
    WebWorkerTaskExecutor.traceStatsIncrement(\.recieveJobFromWorkerThread)
    JavaScriptEventLoop.shared.enqueue(ExecutorJob(job))
}

/// Wake up the worker thread.
/// This function is called when a job is enqueued from the main thread to a worker thread.
@_expose(wasm, "swjs_wake_worker_thread")
func _swjs_wake_worker_thread() {
    WebWorkerTaskExecutor.Worker.currentThread!.run()
}

#endif

fileprivate func trace(_ message: String) {
#if JAVASCRIPTKIT_TRACE
    JSObject.global.process.stdout.write("[trace tid=\(swjs_get_worker_thread_id())] \(message)\n")
#endif
}
