import _CJavaScriptEventLoop
import _CJavaScriptKit

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {
    
    static func installByLegacyHook() {
#if compiler(>=5.9)
        typealias swift_task_asyncMainDrainQueue_hook_Fn = @convention(thin) (
            swift_task_asyncMainDrainQueue_original, swift_task_asyncMainDrainQueue_override
        ) -> Void
        let swift_task_asyncMainDrainQueue_hook_impl: swift_task_asyncMainDrainQueue_hook_Fn = { _, _ in
            swjs_unsafe_event_loop_yield()
        }
        swift_task_asyncMainDrainQueue_hook = unsafeBitCast(
            swift_task_asyncMainDrainQueue_hook_impl,
            to: UnsafeMutableRawPointer?.self
        )
#endif

        typealias swift_task_enqueueGlobal_hook_Fn = @convention(thin) (UnownedJob, swift_task_enqueueGlobal_original)
        -> Void
        let swift_task_enqueueGlobal_hook_impl: swift_task_enqueueGlobal_hook_Fn = { job, original in
            JavaScriptEventLoop.shared.unsafeEnqueue(job)
        }
        swift_task_enqueueGlobal_hook = unsafeBitCast(
            swift_task_enqueueGlobal_hook_impl,
            to: UnsafeMutableRawPointer?.self
        )

        typealias swift_task_enqueueGlobalWithDelay_hook_Fn = @convention(thin) (
            UInt64, UnownedJob, swift_task_enqueueGlobalWithDelay_original
        ) -> Void
        let swift_task_enqueueGlobalWithDelay_hook_impl: swift_task_enqueueGlobalWithDelay_hook_Fn = {
            delay,
            job,
            original in
            JavaScriptEventLoop.shared.enqueue(job, withDelay: delay)
        }
        swift_task_enqueueGlobalWithDelay_hook = unsafeBitCast(
            swift_task_enqueueGlobalWithDelay_hook_impl,
            to: UnsafeMutableRawPointer?.self
        )
        
#if compiler(>=5.7)
        typealias swift_task_enqueueGlobalWithDeadline_hook_Fn = @convention(thin) (
            Int64, Int64, Int64, Int64, Int32, UnownedJob, swift_task_enqueueGlobalWithDelay_original
        ) -> Void
        let swift_task_enqueueGlobalWithDeadline_hook_impl: swift_task_enqueueGlobalWithDeadline_hook_Fn = {
            sec,
            nsec,
            tsec,
            tnsec,
            clock,
            job,
            original in
            JavaScriptEventLoop.shared.enqueue(job, withDelay: sec, nsec, tsec, tnsec, clock)
        }
        swift_task_enqueueGlobalWithDeadline_hook = unsafeBitCast(
            swift_task_enqueueGlobalWithDeadline_hook_impl,
            to: UnsafeMutableRawPointer?.self
        )
#endif
        
        typealias swift_task_enqueueMainExecutor_hook_Fn = @convention(thin) (
            UnownedJob, swift_task_enqueueMainExecutor_original
        ) -> Void
        let swift_task_enqueueMainExecutor_hook_impl: swift_task_enqueueMainExecutor_hook_Fn = { job, original in
            JavaScriptEventLoop.shared.unsafeEnqueue(job)
        }
        swift_task_enqueueMainExecutor_hook = unsafeBitCast(
            swift_task_enqueueMainExecutor_hook_impl,
            to: UnsafeMutableRawPointer?.self
        )

    }
}


#if compiler(>=5.7)
/// Taken from https://github.com/apple/swift/blob/d375c972f12128ec6055ed5f5337bfcae3ec67d8/stdlib/public/Concurrency/Clock.swift#L84-L88
@_silgen_name("swift_get_time")
internal func swift_get_time(
    _ seconds: UnsafeMutablePointer<Int64>,
    _ nanoseconds: UnsafeMutablePointer<Int64>,
    _ clock: CInt
)

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {
    fileprivate func enqueue(
        _ job: UnownedJob,
        withDelay seconds: Int64,
        _ nanoseconds: Int64,
        _ toleranceSec: Int64,
        _ toleranceNSec: Int64,
        _ clock: Int32
    ) {
        var nowSec: Int64 = 0
        var nowNSec: Int64 = 0
        swift_get_time(&nowSec, &nowNSec, clock)
        let delayNanosec = (seconds - nowSec) * 1_000_000_000 + (nanoseconds - nowNSec)
        enqueue(job, withDelay: delayNanosec <= 0 ? 0 : UInt64(delayNanosec))
    }
}
#endif

