#ifndef _CJavaScriptEventLoop_h
#define _CJavaScriptEventLoop_h

#include <stdalign.h>
#include <stdint.h>

#define SWIFT_CC(CC) SWIFT_CC_##CC
#define SWIFT_CC_swift __attribute__((swiftcall))

#define SWIFT_EXPORT_FROM(LIBRARY) __attribute__((__visibility__("default")))

#define SWIFT_NONISOLATED_UNSAFE __attribute__((swift_attr("nonisolated(unsafe)")))

/// A schedulable unit
/// Note that this type layout is a part of public ABI, so we expect this field layout won't break in the future versions.
/// Current implementation refers the `swift-5.5-RELEASE` implementation.
/// https://github.com/apple/swift/blob/swift-5.5-RELEASE/include/swift/ABI/Task.h#L43-L129
/// This definition is used to retrieve priority value of a job. After custom-executor API will be introduced officially,
/// the job priority API will be provided in the Swift world.
typedef __attribute__((aligned(2 * alignof(void *)))) struct {
    void *_Nonnull Metadata;
    int32_t RefCounts;
    void *_Nullable SchedulerPrivate[2];
    uint32_t Flags;
} Job;

/// A hook to take over global enqueuing.
typedef SWIFT_CC(swift) void (*swift_task_enqueueGlobal_original)(
    Job *_Nonnull job);

SWIFT_EXPORT_FROM(swift_Concurrency)
extern void *_Nullable swift_task_enqueueGlobal_hook SWIFT_NONISOLATED_UNSAFE;

/// A hook to take over global enqueuing with delay.
typedef SWIFT_CC(swift) void (*swift_task_enqueueGlobalWithDelay_original)(
    unsigned long long delay, Job *_Nonnull job);
SWIFT_EXPORT_FROM(swift_Concurrency)
extern void *_Nullable swift_task_enqueueGlobalWithDelay_hook SWIFT_NONISOLATED_UNSAFE;

typedef SWIFT_CC(swift) void (*swift_task_enqueueGlobalWithDeadline_original)(
    long long sec,
    long long nsec,
    long long tsec,
    long long tnsec,
    int clock, Job *_Nonnull job);
SWIFT_EXPORT_FROM(swift_Concurrency)
extern void *_Nullable swift_task_enqueueGlobalWithDeadline_hook SWIFT_NONISOLATED_UNSAFE;

/// A hook to take over main executor enqueueing.
typedef SWIFT_CC(swift) void (*swift_task_enqueueMainExecutor_original)(
    Job *_Nonnull job);
SWIFT_EXPORT_FROM(swift_Concurrency)
extern void *_Nullable swift_task_enqueueMainExecutor_hook SWIFT_NONISOLATED_UNSAFE;

/// A hook to override the entrypoint to the main runloop used to drive the
/// concurrency runtime and drain the main queue. This function must not return.
/// Note: If the hook is wrapping the original function and the `compatOverride`
///       is passed in, the `original` function pointer must be passed into the
///       compatibility override function as the original function.
typedef SWIFT_CC(swift) void (*swift_task_asyncMainDrainQueue_original)();
typedef SWIFT_CC(swift) void (*swift_task_asyncMainDrainQueue_override)(
    swift_task_asyncMainDrainQueue_original _Nullable original);
SWIFT_EXPORT_FROM(swift_Concurrency)
extern void *_Nullable swift_task_asyncMainDrainQueue_hook SWIFT_NONISOLATED_UNSAFE;


/// MARK: - thread local storage

extern _Thread_local void * _Nullable swjs_thread_local_event_loop SWIFT_NONISOLATED_UNSAFE;

extern _Thread_local void * _Nullable swjs_thread_local_task_executor_worker SWIFT_NONISOLATED_UNSAFE;

#endif
