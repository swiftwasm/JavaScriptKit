#include "stdlib/public/SwiftShims/Visibility.h"
#include <swift/Runtime/Config.h>
#include <swift/Runtime/Concurrency.h>
#include "_CJavaScriptEventLoop.h"

using namespace swift;

#ifndef __wasm32__

SWIFT_CC(swift)
void (*swift::swift_task_enqueueGlobal_hook)(Job *job) = nullptr;

SWIFT_EXPORT_FROM(swift_Concurrency) SWIFT_CC(swift)
void *swift_task_alloc(AsyncTask *task, size_t size) {}

SWIFT_EXPORT_FROM(swift_Concurrency) SWIFT_CC(swift)
AsyncTaskAndContext swift_task_create_f(JobFlags flags,
                                        AsyncTask *parent,
                                        ThinNullaryAsyncSignature::FunctionType *function,
                                        size_t initialContextSize) {}

SWIFT_EXPORT_FROM(swift_Concurrency) SWIFT_CC(swift)
void swift_task_dealloc(AsyncTask *task, void *ptr) {}

SWIFT_EXPORT_FROM(swift_Concurrency) SWIFT_CC(swift)
void swift_task_enqueueGlobal(Job *job) {}


void registerEventLoopHook(void callback(EventLoopContext *context),
                           EventLoopContext *context) {
    // dummy implementation
}
#endif
