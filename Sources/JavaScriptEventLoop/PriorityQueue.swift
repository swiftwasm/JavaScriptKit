import _Concurrency

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct PriorityQueue: Sendable {
    private var headJob: UnownedJob? = nil

    mutating func enqueue(_ newJob: UnownedJob) {
        withUnsafeMutablePointer(to: &headJob) { headJobPtr in
            var position: UnsafeMutablePointer<UnownedJob?> = headJobPtr
            while let current = position.pointee {
                if current.rawPriority < newJob.rawPriority {
                    newJob.nextInQueue().pointee = current
                    position.pointee = newJob
                    return
                }
                position = current.nextInQueue()
            }
            newJob.nextInQueue().pointee = nil
            position.pointee = newJob
        }
    }

    mutating func dequeue() -> UnownedJob? {
        guard let job = headJob else { return nil }
        headJob = job.nextInQueue().pointee
        return job
    }

    var isEmpty: Bool {
        headJob == nil
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct QueueState: Sendable {
    fileprivate var jobQueue = PriorityQueue()
    fileprivate var isSpinning: Bool = false
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {

    func insertJobQueue(job newJob: UnownedJob) {
        queueState.jobQueue.enqueue(newJob)

        // TODO: use CAS when supporting multi-threaded environment
        if !queueState.isSpinning {
            queueState.isSpinning = true
            JavaScriptEventLoop.shared.queueMicrotask {
                self.runAllJobs()
            }
        }
    }

    func runAllJobs() {
        assert(queueState.isSpinning)

        while let job = claimNextFromQueue() {
            #if compiler(>=5.9)
            job.runSynchronously(on: asUnownedSerialExecutor())
            #else
            job._runSynchronously(on: asUnownedSerialExecutor())
            #endif
        }

        queueState.isSpinning = false
    }

    func claimNextFromQueue() -> UnownedJob? {
        queueState.jobQueue.dequeue()
    }
}
#endif
