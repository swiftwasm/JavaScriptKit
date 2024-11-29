// This file contains the job queue implementation for JavaScriptEventLoop.
// It manages job insertion and execution based on priority.

import _CJavaScriptEventLoop
import Foundation

/// Represents the state of the job queue.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct QueueState: Sendable {
    /// The head of the job queue.
    fileprivate var headJob: UnownedJob? = nil
    /// Indicates if the queue is actively processing jobs.
    fileprivate var isSpinning: Bool = false
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {
    /// A lock to synchronize queue access.
    private var queueLock: NSLock {
        NSLock()
    }

    /// Inserts a job into the queue and ensures jobs are processed.
    /// - Parameter job: The job to add to the queue.
    func insertJobQueue(job newJob: UnownedJob) {
        queueLock.lock()
        defer { queueLock.unlock() }

        insertJob(newJob)

        if !queueState.isSpinning {
            queueState.isSpinning = true
            JavaScriptEventLoop.shared.queueMicrotask {
                self.runAllJobs()
            }
        }
    }

    /// Inserts a job into the queue at the correct priority position.
    /// - Parameter job: The job to insert into the queue.
    private func insertJob(_ newJob: UnownedJob) {
        var current = queueState.headJob
        var previous: UnownedJob? = nil

        while let cur = current, cur.rawPriority >= newJob.rawPriority {
            previous = cur
            current = cur.nextInQueue().pointee
        }

        newJob.nextInQueue().pointee = current
        if let prev = previous {
            prev.nextInQueue().pointee = newJob
        } else {
            queueState.headJob = newJob
        }
    }

    /// Processes all jobs in the queue until it is empty.
    func runAllJobs() {
        assert(queueState.isSpinning, "runAllJobs called while queueState.isSpinning is false.")

        while let job = claimNextFromQueue() {
            executeJob(job)
        }

        queueState.isSpinning = false
    }

    /// Executes a specific job.
    /// - Parameter job: The job to execute.
    private func executeJob(_ job: UnownedJob) {
        #if compiler(>=5.9)
        job.runSynchronously(on: self.asUnownedSerialExecutor())
        #else
        job._runSynchronously(on: self.asUnownedSerialExecutor())
        #endif
    }

    /// Removes and returns the next job from the queue.
    /// - Returns: The next job in the queue, or `nil` if the queue is empty.
    func claimNextFromQueue() -> UnownedJob? {
        queueLock.lock()
        defer { queueLock.unlock() }

        guard let job = queueState.headJob else { return nil }
        queueState.headJob = job.nextInQueue().pointee
        return job
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
fileprivate extension UnownedJob {
    /// Converts the job to its internal implementation.
    /// - Returns: A raw pointer to the job's internal structure.
    private func asImpl() -> UnsafeMutablePointer<_CJavaScriptEventLoop.Job> {
        unsafeBitCast(self, to: UnsafeMutablePointer<_CJavaScriptEventLoop.Job>.self)
    }

    /// The job's priority flags.
    var flags: JobFlags {
        JobFlags(bits: asImpl().pointee.Flags)
    }

    /// The raw priority value of the job.
    var rawPriority: UInt32 {
        flags.priority
    }

    /// Retrieves a pointer to the next job in the queue.
    /// - Returns: A pointer to the next job, or `nil` if there are no further jobs.
    func nextInQueue() -> UnsafeMutablePointer<UnownedJob?> {
        withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.0) { rawNextJobPtr in
            UnsafeMutableRawPointer(rawNextJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
        }
    }
}

/// Represents job flags including priority.
fileprivate struct JobFlags {
    /// The raw bit representation of the flags.
    var bits: UInt32 = 0

    /// Extracts the priority value from the flags.
    var priority: UInt32 {
        (bits & 0xFF00) >> 8
    }
}