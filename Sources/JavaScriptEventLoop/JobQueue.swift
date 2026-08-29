// This file contains the job queue implementation which re-order jobs based on their priority.
// The current implementation is much simple to be easily debugged, but should be re-implemented
// using priority queue ideally.

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
            while let cur = position.pointee {
                if cur.rawPriority < newJob.rawPriority {
                    newJob.nextInQueue().pointee = cur
                    position.pointee = newJob
                    return
                }
                position = cur.nextInQueue()
            }
            newJob.nextInQueue().pointee = nil
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
        // Release the latch BEFORE running any job, so `isSpinning` means "a
        // drain microtask is pending" rather than "a drain is in progress".
        //
        // `runSynchronously` can unwind without running Swift cleanup — a
        // runtime trap lowers to `unreachable`, and a JS exception crossing
        // back into wasm unwinds the frames outright. Neither runs a `defer`.
        // Clearing the latch only after the loop therefore leaves it stuck at
        // `true` on those paths, and `insertJobQueue` never schedules another
        // drain: the executor is dead for the lifetime of the process,
        // silently. Clearing it up front costs one extra drain microtask per
        // batch that enqueues, and an unwinding job leaves the queue merely
        // undrained rather than unreachable — the next enqueue picks it up.
        queueState.isSpinning = false

        while let job = self.claimNextFromQueue() {
            #if compiler(>=5.9)
            job.runSynchronously(on: self.asUnownedSerialExecutor())
            #else
            job._runSynchronously(on: self.asUnownedSerialExecutor())
            #endif
        }
    }

    func claimNextFromQueue() -> UnownedJob? {
        if let job = self.queueState.headJob {
            self.queueState.headJob = job.nextInQueue().pointee
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

}

private struct JobFlags {
    var bits: UInt32 = 0

    var priority: UInt32 {
        (bits & 0xFF00) >> 8
    }
}
#endif
