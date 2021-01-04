import _CJavaScriptEventLoop
import JavaScriptKit

public enum JavaScriptEventLoop {
    public static func install() {
        installTaskEnqueueHook()
    }
    public static func runAsync(_ asyncFun: @escaping () async throws -> ()) rethrows {
        try _runAsync(asyncFun)
    }
}

public extension JSPromise {
    func await() async throws -> JSValue {
        await try withUnsafeThrowingContinuation { [self] continuation in
            self.then(
                success: {
                    continuation.resume(returning: $0)
                    return .undefined
                },
                failure: {
                    continuation.resume(throwing: $0)
                    return .undefined
                }
            )
        }
    }
}

@_silgen_name("swift_run_async")
func _runAsync(_ asyncFun: @escaping () async throws -> ()) rethrows

private func getPromise(from context: UnsafeMutablePointer<EventLoopContext>) -> JSPromise {
    let promise: JSPromise
    if let cached = context.pointee.Promise {
        promise = Unmanaged.fromOpaque(cached).takeUnretainedValue()
    } else {
        promise = JSPromise(resolver: { resolver -> Void in
            resolver(.success(.undefined))
        })
        let pointer = Unmanaged.passRetained(promise).retain().toOpaque()
        context.pointee.Promise = pointer
    }
    return promise
}

#if arch(wasm32)
@_cdecl("registerEventLoopHook")
func registerEventLoopHook(
    _ callback: @convention(c) @escaping (UnsafeMutablePointer<EventLoopContext>) -> Void,
    _ context: UnsafeMutablePointer<EventLoopContext>
) {
    getPromise(from: context).then { _ in
        callback(context)
        return .undefined
    }
}

#endif
