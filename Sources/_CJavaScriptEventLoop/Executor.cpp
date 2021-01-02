#include "Queue.h"
#include <swift/ABI/Executor.h>
#include <swift/Runtime/Concurrency.h>
#include <iostream>

using namespace swift;

static Queue GlobalQueue;

SWIFT_CC(swift)
static void enqueueGlobal(Job *job) {
    GlobalQueue.insertJob(job);
}

extern "C" void installTaskEnqueueHook(void) {
    swift_task_enqueueGlobal_hook = enqueueGlobal;
}
