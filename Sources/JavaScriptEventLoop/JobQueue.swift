// This file contains the job queue implementation which re-order jobs based on their priority.

import _CJavaScriptEventLoop

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct QueueState: Sendable {
    fileprivate var headJob: UnownedJob? = nil
    fileprivate var isSpinning: Bool = false
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {
    private var queueLock: NSLock {
        NSLock()
    }

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

    func runAllJobs() {
        assert(queueState.isSpinning)

        while let job = claimNextFromQueue() {
            executeJob(job)
        }

        queueState.isSpinning = false
    }

    private func executeJob(_ job: UnownedJob) {
        #if compiler(>=5.9)
        job.runSynchronously(on: self.asUnownedSerialExecutor())
        #else
        job._runSynchronously(on: self.asUnownedSerialExecutor())
        #endif
    }

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
    private func asImpl() -> UnsafeMutablePointer<_CJavaScriptEventLoop.Job> {
        unsafeBitCast(self, to: UnsafeMutablePointer<_CJavaScriptEventLoop.Job>.self)
    }

    var flags: JobFlags {
        JobFlags(bits: asImpl().pointee.Flags)
    }

    var rawPriority: UInt32 { flags.priority }

    func nextInQueue() -> UnsafeMutablePointer<UnownedJob?> {
        withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.0) { rawNextJobPtr in
            UnsafeMutableRawPointer(rawNextJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
        }
    }
}

fileprivate struct JobFlags {
  var bits: UInt32 = 0

    var priority: UInt32 {
        (bits & 0xFF00) >> 8
    }
}
#endif