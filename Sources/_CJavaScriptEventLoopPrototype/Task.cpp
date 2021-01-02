//===--- Task.cpp - Task object and management ----------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
// Object management routines for asynchronous task objects.
//
//===----------------------------------------------------------------------===//

#include "swift/Runtime/Concurrency.h"
#include "swift/ABI/Task.h"
#include "swift/ABI/Metadata.h"
#include "swift/Runtime/Mutex.h"
#include "swift/Runtime/HeapObject.h"
#include "TaskPrivate.h"
#include "AsyncCall.h"

using namespace swift;


namespace {
/// The header of a function context (closure captures) of
/// a thick async function with a non-null context.
struct ThickAsyncFunctionContext: HeapObject {
  uint32_t ExpectedContextSize;
};


#if SWIFT_CONCURRENCY_COOPERATIVE_GLOBAL_EXECUTOR

class RunAndBlockSemaphore {
  bool Finished = false;
public:
  void wait() {
    my_swift::donateThreadToGlobalExecutorUntil([](void *context) {
      return *reinterpret_cast<bool*>(context);
    }, &Finished);

    assert(Finished && "ran out of tasks before we were signalled");
  }

  void signal() {
    Finished = true;
  }
};

#else

class RunAndBlockSemaphore {
  ConditionVariable Queue;
  ConditionVariable::Mutex Lock;
  bool Finished = false;
public:
  /// Wait for a signal.
  void wait() {
    Lock.withLockOrWait(Queue, [&] {
      return Finished;
    });
  }

  void signal() {
    Lock.withLockThenNotifyAll(Queue, [&]{
      Finished = true;
    });
  }
};

#endif

using RunAndBlockSignature =
  AsyncSignature<void(HeapObject*), /*throws*/ false>;
struct RunAndBlockContext: AsyncContext {
  const void *Function;
  HeapObject *FunctionContext;
  RunAndBlockSemaphore *Semaphore;
};
using RunAndBlockCalleeContext =
  AsyncCalleeContext<RunAndBlockContext, RunAndBlockSignature>;

} // end anonymous namespace

/// Second half of the runAndBlock async function.
SWIFT_CC(swiftasync)
static void runAndBlock_finish(AsyncTask *task, ExecutorRef executor,
                               AsyncContext *_context) {
  auto calleeContext = static_cast<RunAndBlockCalleeContext*>(_context);
  auto context = popAsyncContext(task, calleeContext);

  context->Semaphore->signal();

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

// TODO: Remove this hack.
SWIFT_CC(swift)
extern "C" void my_task_runAndBlockThread(const void *function,
                                          HeapObject *functionContext) {
  RunAndBlockSemaphore semaphore;

  // Set up a task that runs the runAndBlock async function above.
  auto pair = swift_task_create_f(JobFlags(JobKind::Task,
                                           JobPriority::Default),
                                  /*parent*/ nullptr,
                                  &runAndBlock_start,
                                  sizeof(RunAndBlockContext));
  auto context = static_cast<RunAndBlockContext*>(pair.InitialContext);
  context->Function = function;
  context->FunctionContext = functionContext;
  context->Semaphore = &semaphore;

  // Enqueue the task.
  swift_task_enqueueGlobal(pair.Task);

  // Wait until the task completes.
  semaphore.wait();
}
