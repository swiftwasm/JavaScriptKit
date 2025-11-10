import _Concurrency

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct PriorityQueue: Sendable {
    private struct Bucket: Sendable {
        var storage: [UnownedJob] = []
        var head: Int = 0

        var isEmpty: Bool {
            head >= storage.count
        }

        mutating func enqueue(_ job: UnownedJob) {
            storage.append(job)
        }

        mutating func dequeue() -> UnownedJob? {
            guard head < storage.count else { return nil }
            let job = storage[head]
            head += 1
            if head >= 32 && head * 2 >= storage.count {
                storage.removeFirst(head)
                head = 0
            }
            return job
        }
    }

    private static let maxPriority = Int(UInt8.max)
    private var buckets: [Bucket] = Array(repeating: Bucket(), count: maxPriority + 1)
    private var highestNonEmpty: Int? = nil

    mutating func enqueue(_ newJob: UnownedJob) {
        let index = bucketIndex(for: newJob)
        buckets[index].enqueue(newJob)
        if let current = highestNonEmpty {
            if index > current {
                highestNonEmpty = index
            }
        } else {
            highestNonEmpty = index
        }
    }

    mutating func dequeue() -> UnownedJob? {
        guard var index = highestNonEmpty else { return nil }
        while index >= 0 {
            if let job = buckets[index].dequeue() {
                highestNonEmpty = buckets[index].isEmpty ? nextNonEmptyBucket(from: index - 1) : index
                return job
            }
            index -= 1
        }
        highestNonEmpty = nil
        return nil
    }

    var isEmpty: Bool {
        highestNonEmpty == nil
    }

    private func bucketIndex(for job: UnownedJob) -> Int {
        let priority = Int(job.rawPriority)
        if priority > PriorityQueue.maxPriority {
            return PriorityQueue.maxPriority
        } else if priority < 0 {
            return 0
        }
        return priority
    }

    private mutating func nextNonEmptyBucket(from start: Int) -> Int? {
        var index = start
        while index >= 0 {
            if !buckets[index].isEmpty {
                return index
            }
            index -= 1
        }
        return nil
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
