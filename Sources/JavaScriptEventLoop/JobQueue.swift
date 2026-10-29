// This file contains the job queue implementation which re-order jobs based on their priority.
// Jobs form runs, one per priority in descending order, FIFO within a run. The first job of each
// run points to its last job, so an insert steps over whole runs.

import _Concurrency
import _CJavaScriptEventLoop

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
struct QueueState: Sendable {
    fileprivate var headJob: UnownedJob? = nil
    fileprivate var isSpinning: Bool = false
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {

    func insertJobQueue(job newJob: UnownedJob) {
        withUnsafeMutablePointer(to: &queueState.headJob) { headJobPtr in
            var position: UnsafeMutablePointer<UnownedJob?> = headJobPtr
            while let runHead = position.pointee, runHead.rawPriority >= newJob.rawPriority {
                let runTail = runHead.lastInRun().pointee!
                if runHead.rawPriority == newJob.rawPriority {
                    newJob.nextInQueue().pointee = runTail.nextInQueue().pointee
                    runTail.nextInQueue().pointee = newJob
                    runHead.lastInRun().pointee = newJob
                    return
                }
                position = runTail.nextInQueue()
            }
            newJob.nextInQueue().pointee = position.pointee
            newJob.lastInRun().pointee = newJob
            position.pointee = newJob
        }

        // TODO: use CAS when supporting multi-threaded environment
        if !queueState.isSpinning {
            self.queueState.isSpinning = true
            JavaScriptEventLoop.shared.queueMicrotask {
                self.runAllJobs()
            }
        }
    }

    func runAllJobs() {
        assert(queueState.isSpinning)

        // The clock is only read while `yieldInterval` is set.
        var start: DrainInstant? = yieldInterval == nil ? nil : drainClockNow()
        // A clock read costs more than a small job. Read it every `clockStride` jobs, and double
        // the stride (up to 256) while the drain is far from the interval.
        var clockStride = 1
        var jobsUntilClockRead = 1
        while let job = self.claimNextFromQueue() {
            #if compiler(>=5.9)
            job.runSynchronously(on: self.asUnownedSerialExecutor())
            #else
            job._runSynchronously(on: self.asUnownedSerialExecutor())
            #endif

            if let yieldInterval, queueState.headJob != nil {
                if let start {
                    jobsUntilClockRead -= 1
                    if jobsUntilClockRead > 0 { continue }
                    let elapsed = drainElapsed(since: start)
                    if elapsed >= yieldInterval {
                        // Keep `isSpinning` set so new jobs wait for the continuation.
                        queueHostTask { self.runAllJobs() }
                        return
                    }
                    if elapsed * 4 < yieldInterval {
                        clockStride = min(clockStride * 2, 256)
                    }
                    jobsUntilClockRead = clockStride
                } else {
                    start = drainClockNow()
                }
            }
        }

        queueState.isSpinning = false
    }

    func claimNextFromQueue() -> UnownedJob? {
        if let job = self.queueState.headJob {
            let nextJob = job.nextInQueue().pointee
            if let nextJob {
                let runTail = job.lastInRun().pointee!
                if !runTail.isSameJob(as: job) {
                    nextJob.lastInRun().pointee = runTail
                }
            }
            self.queueState.headJob = nextJob
            return job
        }
        return nil
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension UnownedJob {
    private func asImpl() -> UnsafeMutablePointer<_CJavaScriptEventLoop.Job> {
        unsafeBitCast(self, to: UnsafeMutablePointer<_CJavaScriptEventLoop.Job>.self)
    }

    fileprivate var flags: JobFlags {
        JobFlags(bits: asImpl().pointee.Flags)
    }

    fileprivate var rawPriority: UInt32 { flags.priority }

    fileprivate func nextInQueue() -> UnsafeMutablePointer<UnownedJob?> {
        return withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.0) { rawNextJobPtr in
            let nextJobPtr = UnsafeMutableRawPointer(rawNextJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
            return nextJobPtr
        }
    }

    /// The last job of the run. Valid only on the first job of a run.
    fileprivate func lastInRun() -> UnsafeMutablePointer<UnownedJob?> {
        return withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.1) { rawLastJobPtr in
            UnsafeMutableRawPointer(rawLastJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
        }
    }

    fileprivate func isSameJob(as other: UnownedJob) -> Bool {
        asImpl() == other.asImpl()
    }
}

private struct JobFlags {
    var bits: UInt32 = 0

    var priority: UInt32 {
        (bits & 0xFF00) >> 8
    }
}
#endif
