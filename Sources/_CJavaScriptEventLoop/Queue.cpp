#include "Queue.h"
#include "_CJavaScriptEventLoop.h"

using namespace swift;

/// Get the next-in-queue storage slot.
static Job *&nextInQueue(Job *cur) {
  return reinterpret_cast<Job*&>(cur->SchedulerPrivate);
}

Job *Queue::claimNext() {
  if (auto job = this->HeadJob) {
    this->HeadJob = nextInQueue(job);
    return job;
  }
  return nullptr;
}

Queue::Queue() : HeadJob(nullptr), isSpinning(false) {
  this->Context = (EventLoopContext) {
    .Queue = this,
    .Promise = nullptr,
  };
}

void runEnqueuedJobs(EventLoopContext *context) {
  Queue *queue = (Queue *)(context->Queue);
  assert(queue->isSpinning);
  
  while (auto *job = queue->claimNext()) {
    job->run(ExecutorRef::generic());
  }

  queue->isSpinning = false;
}

#ifndef __wasm32__
void registerEventLoopHook(void callback(EventLoopContext *context),
                           EventLoopContext *context) {
    // dummy implementation
}
#endif

void Queue::insertJob(swift::Job *newJob) {
  Job **position = &HeadJob;
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

  if (!isSpinning) {
    isSpinning = true;
    registerEventLoopHook(runEnqueuedJobs, &this->Context);
  }
}
