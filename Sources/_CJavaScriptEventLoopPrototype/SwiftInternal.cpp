#include "swift/Runtime/Concurrency.h"
#include <iostream>

using namespace swift;
void insertIntoJobQueue(Job *newJob);

SWIFT_CC(swift)
static void enqueueGlobal(Job *job) {
    printf("enqueueGlobal\n");
    insertIntoJobQueue(job);
}

extern "C" void swiftInstallConcurrencyEnqueueHook(void) {
    swift_task_enqueueGlobal_hook = enqueueGlobal;
}

