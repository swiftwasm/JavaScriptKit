#include "Queue.h"
#include "AsyncCall.h"
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

struct ThickAsyncFunctionContext: HeapObject {
  uint32_t ExpectedContextSize;
};



using RunAndBlockSignature =
  AsyncSignature<void(HeapObject*), /*throws*/ false>;
struct RunAndBlockContext: AsyncContext {
  const void *Function;
  HeapObject *FunctionContext;
};
using RunAndBlockCalleeContext =
  AsyncCalleeContext<RunAndBlockContext, RunAndBlockSignature>;

/// Second half of the runAndBlock async function.
SWIFT_CC(swiftasync)
static void runAndBlock_finish(AsyncTask *task, ExecutorRef executor,
                               AsyncContext *_context) {
  auto calleeContext = static_cast<RunAndBlockCalleeContext*>(_context);
  auto context = popAsyncContext(task, calleeContext);
  return context->ResumeParent(task, executor, context);
}

/// First half of the runAndBlock async function.
SWIFT_CC(swiftasync)
static void runAndBlock_start(AsyncTask *task, ExecutorRef executor,
                              AsyncContext *_context) {
  auto callerContext = static_cast<RunAndBlockContext*>(_context);

  size_t calleeContextSize;
  RunAndBlockSignature::FunctionType *function;

  // If the function context is non-null, then the function pointer is
  // an ordinary function pointer.
  auto functionContext = callerContext->FunctionContext;
  if (functionContext) {
    function = reinterpret_cast<RunAndBlockSignature::FunctionType*>(
                   const_cast<void*>(callerContext->Function));
    calleeContextSize =
      static_cast<ThickAsyncFunctionContext*>(functionContext)
        ->ExpectedContextSize;

  // Otherwise, the function pointer is an async function pointer.
  } else {
    auto fnPtr = reinterpret_cast<const RunAndBlockSignature::FunctionPointer*>(
                   callerContext->Function);
    function = fnPtr->Function;
    calleeContextSize = fnPtr->ExpectedContextSize;
  }

  auto calleeContext =
    pushAsyncContext<RunAndBlockSignature>(task, executor, callerContext,
                                           calleeContextSize,
                                           &runAndBlock_finish,
                                           functionContext);
  return function(task, executor, calleeContext);
}

SWIFT_CC(swift)
extern "C" void swift_run_async(const void *function, HeapObject *functionContext) {
  auto pair = swift_task_create_f(JobFlags(JobKind::Task,
                                           JobPriority::Default),
                                  /*parent*/ nullptr,
                                  &runAndBlock_start,
                                  sizeof(RunAndBlockContext));
  auto context = static_cast<RunAndBlockContext*>(pair.InitialContext);
  context->Function = function;
  context->FunctionContext = functionContext;
  swift_task_enqueueGlobal(pair.Task);
}

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

#endif
