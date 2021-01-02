import _CJavaScriptEventLoop
import JavaScriptKit

public enum JavaScriptEventLoop {
    public static func install() {
        installTaskEnqueueHook()
    }
}

private func getPromise(from context: UnsafeMutablePointer<EventLoopContext>) -> JSPromise<JSValue, JSValue> {
    let promise: JSPromise<JSValue, JSValue>
    if let cached = context.pointee.Promise {
        promise = cached.assumingMemoryBound(to: JSPromise.self).pointee
    } else {
        promise = JSPromise(resolver: { _ -> Void in })
        context.pointee.Promise = Unmanaged.passRetained(promise).toOpaque()
    }
    return promise
}

@_cdecl("registerEventLoopHook")
func registerEventLoopHook(
    _ callback: @convention(c) @escaping (UnsafeMutablePointer<EventLoopContext>) -> Void,
    _ context: UnsafeMutablePointer<EventLoopContext>
) {
    getPromise(from: context).then {
        callback(context)
    }
}
