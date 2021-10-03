#ifndef _CJavaScriptEventLoop_h
#define _CJavaScriptEventLoop_h

#include <stdalign.h>
#include <stdint.h>

#define SWIFT_CC(CC) SWIFT_CC_##CC
#define SWIFT_CC_swift __attribute__((swiftcall))

#define SWIFT_EXPORT_FROM(LIBRARY) __attribute__((__visibility__("default")))

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
void *_Nullable swift_task_enqueueGlobal_hook;

/// A hook to take over global enqueuing with delay.
typedef SWIFT_CC(swift) void (*swift_task_enqueueGlobalWithDelay_original)(
    unsigned long long delay, Job *_Nonnull job);
SWIFT_EXPORT_FROM(swift_Concurrency)
void *_Nullable swift_task_enqueueGlobalWithDelay_hook;

unsigned long long foo;

/// A hook to take over main executor enqueueing.
typedef SWIFT_CC(swift) void (*swift_task_enqueueMainExecutor_original)(
    Job *_Nonnull job);
SWIFT_EXPORT_FROM(swift_Concurrency)
void *_Nullable swift_task_enqueueMainExecutor_hook;

#endif
