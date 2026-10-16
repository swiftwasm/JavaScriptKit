// Clock and host task scheduling for `JavaScriptEventLoop.yieldInterval`.

import JavaScriptKit
import _Concurrency

#if compiler(>=5.5)

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension JavaScriptEventLoop {

    #if hasFeature(Embedded)
    // `ContinuousClock` is unavailable in Embedded Swift; use `performance.now()` in milliseconds.
    typealias DrainInstant = Double

    func drainClockNow() -> DrainInstant {
        if performanceNow == nil {
            let performance = JSObject.global.performance.object!
            performanceNow = (performance, performance.now.function!)
        }
        return performanceNow!.now(this: performanceNow!.performance).number!
    }

    func drainElapsed(since start: DrainInstant) -> Duration {
        .milliseconds(drainClockNow() - start)
    }
    #else
    typealias DrainInstant = ContinuousClock.Instant

    func drainClockNow() -> DrainInstant {
        ContinuousClock.now
    }

    func drainElapsed(since start: DrainInstant) -> Duration {
        start.duration(to: .now)
    }
    #endif

    /// Runs `body` in a new JavaScript task via `setImmediate`, `MessageChannel`, or `setTimeout`.
    func queueHostTask(_ body: @escaping () -> Void) {
        if hostTaskScheduler == nil {
            hostTaskScheduler = Self.makeHostTaskScheduler()
        }
        hostTaskScheduler!(body)
    }

    private static func makeHostTaskScheduler() -> (@escaping () -> Void) -> Void {
        let global = JSObject.global
        if let setImmediate = global.setImmediate.function {
            return { body in
                _ = setImmediate(
                    JSOneshotClosure { _ in
                        body()
                        return .undefined
                    }
                )
            }
        }
        if let messageChannel = global.MessageChannel.function {
            // Unlike nested `setTimeout` calls, messages are not clamped to 4 ms.
            let channel = messageChannel.new(arguments: [JSValue]())
            let sender = channel.port1.object!
            let postMessage = sender.postMessage.function!
            let pending = PendingHostTasks()
            let receiver = JSClosure { _ in
                pending.runAll()
                return .undefined
            }
            channel.port2.object!.onmessage = .object(receiver)
            return { body in
                pending.bodies.append(body)
                // Keep `receiver` alive as long as the scheduler.
                withExtendedLifetime(receiver) {
                    _ = postMessage(this: sender, JSValue.undefined)
                }
            }
        }
        let setTimeout = global.setTimeout.function!
        return { body in
            _ = setTimeout(
                JSOneshotClosure { _ in
                    body()
                    return .undefined
                },
                0
            )
        }
    }
}

/// Bodies waiting for the next `MessageChannel` message.
private final class PendingHostTasks {
    var bodies: [() -> Void] = []

    func runAll() {
        let bodies = self.bodies
        self.bodies = []
        for body in bodies {
            body()
        }
    }
}

#endif
