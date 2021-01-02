///===--- GlobalExecutor.cpp - Global concurrent executor ------------------===///
///
/// This source file is part of the Swift.org open source project
///
/// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
/// Licensed under Apache License v2.0 with Runtime Library Exception
///
/// See https:///swift.org/LICENSE.txt for license information
/// See https:///swift.org/CONTRIBUTORS.txt for the list of Swift project authors
///
///===----------------------------------------------------------------------===///
///
/// Routines related to the global concurrent execution service.
///
/// The execution side of Swift's concurrency model centers around
/// scheduling work onto various execution services ("executors").
/// Executors vary in several different dimensions:
///
/// First, executors may be exclusive or concurrent.  An exclusive
/// executor can only execute one job at once; a concurrent executor
/// can execute many.  Exclusive executors are usually used to achieve
/// some higher-level requirement, like exclusive access to some
/// resource or memory.  Concurrent executors are usually used to
/// manage a pool of threads and prevent the number of allocated
/// threads from growing without limit.
///
/// Second, executors may own dedicated threads, or they may schedule
/// work onto some some underlying executor.  Dedicated threads can
/// improve the responsiveness of a subsystem *locally*, but they impose
/// substantial costs which can drive down performance *globally*
/// if not used carefully.  When an executor relies on running work
/// on its own dedicated threads, jobs that need to run briefly on
/// that executor may need to suspend and restart.  Dedicating threads
/// to an executor is a decision that should be made carefully
/// and holistically.
///
/// If most executors should not have dedicated threads, they must
/// be backed by some underlying executor, typically a concurrent
/// executor.  The purpose of most concurrent executors is to
/// manage threads and prevent excessive growth in the number
/// of threads.  Having multiple independent concurrent executors
/// with their own dedicated threads would undermine that.
/// Therefore, it is sensible to have a single, global executor
/// that will ultimately schedule most of the work in the system.
/// With that as a baseline, special needs can be recognized and
/// carved out from the global executor with its cooperation.
///
/// This file defines Swift's interface to that global executor.
///
/// The default implementation is backed by libdispatch, but there
/// may be good reasons to provide alternatives (e.g. when building
/// a single-threaded runtime).
///
///===----------------------------------------------------------------------===///

#include "swift/Runtime/Concurrency.h"
#include "TaskPrivate.h"

#if !SWIFT_CONCURRENCY_COOPERATIVE_GLOBAL_EXECUTOR
#include <dispatch/dispatch.h>
#endif

using namespace swift;

static Job *JobQueue = nullptr;

/// Get the next-in-queue storage slot.
static Job *&nextInQueue(Job *cur) {
  return reinterpret_cast<Job*&>(cur->SchedulerPrivate);
}

/// Insert a job into the cooperative global queue.
void insertIntoJobQueue(Job *newJob) {
  Job **position = &JobQueue;
  while (auto cur = *position) {
    // If we find a job with lower priority, insert here.
    if (cur->getPriority() < newJob->getPriority()) {
      nextInQueue(newJob) = cur;
      *position = newJob;
      return;
    }

    // Otherwise, keep advancing through the queue.
    position = &nextInQueue(cur);
  }
  nextInQueue(newJob) = nullptr;
  *position = newJob;
}

/// Claim the next job from the cooperative global queue.
static Job *claimNextFromJobQueue() {
  if (auto job = JobQueue) {
    JobQueue = nextInQueue(job);
    return job;
  }
  return nullptr;
}

void my_swift::donateThreadToGlobalExecutorUntil(bool (*condition)(void *),
                                              void *conditionContext) {
  while (!condition(conditionContext)) {
    auto job = claimNextFromJobQueue();
    if (!job) return;
    job->run(ExecutorRef::generic());
  }
}
