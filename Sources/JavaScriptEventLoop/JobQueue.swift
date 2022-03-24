// This file contains the job queue implementation which re-order jobs based on their priority.
// The current implementation is much simple to be easily debugged, but should be re-implemented
// using priority queue ideally.

import _CJavaScriptEventLoop

#if compiler(>=5.5)

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
struct QueueState: Sendable {
    fileprivate var headJob: UnownedJob? = nil
    fileprivate var isSpinning: Bool = false
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
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

        while let job = self.claimNextFromQueue() {
            job._runSynchronously(on: self.asUnownedSerialExecutor())
        }

        queueState.isSpinning = false
    }

    func claimNextFromQueue() -> UnownedJob? {
        if let job = self.queueState.headJob {
            self.queueState.headJob = job.nextInQueue().pointee
            return job
        }
        return nil
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
fileprivate extension UnownedJob {
    private func asImpl() -> UnsafeMutablePointer<_CJavaScriptEventLoop.Job> {
        unsafeBitCast(self, to: UnsafeMutablePointer<_CJavaScriptEventLoop.Job>.self)
    }

    var flags: JobFlags {
        JobFlags(bits: asImpl().pointee.Flags)
    }

    var rawPriority: UInt32 { flags.priority }

    func nextInQueue() -> UnsafeMutablePointer<UnownedJob?> {
        return withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.0) { rawNextJobPtr in
            let nextJobPtr = UnsafeMutableRawPointer(rawNextJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
            return nextJobPtr
        }
    }

}

fileprivate struct JobFlags {
  var bits: UInt32 = 0

  var priority: UInt32 {
    get {
      (bits & 0xFF00) >> 8
    }
  }
}
#endif
