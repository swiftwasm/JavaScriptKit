#if JAVASCRIPTKIT_ENABLE_TRACING

/// Hooks for tracing Swift <-> JavaScript bridge calls.
public struct JSTracing {
    public static let `default` = JSTracing()

    public enum JSCallInfo {
        case function(function: JSObject, arguments: [JSValue])
        case method(receiver: JSObject, methodName: String, arguments: [JSValue])
    }

    /// Register a hook for Swift to JavaScript calls.
    ///
    /// The hook is invoked at the start of the call. Return a closure to run when
    /// the call finishes, or `nil` to skip the end hook.
    ///
    /// - Returns: A cleanup closure that unregisters the hook.
    @discardableResult
    public func addJSCallHook(
        _ hook: @escaping (_ info: JSCallInfo) -> (() -> Void)?
    ) -> () -> Void {
        JSTracingHooks.addJSCallHook(hook)
    }

    public struct JSClosureCallInfo {
        /// The file identifier where the called `JSClosure` was created.
        public let fileID: StaticString
        /// The line number where the called `JSClosure` was created.
        public let line: UInt
    }

    /// Register a hook for JavaScript to Swift calls via `JSClosure`.
    ///
    /// The hook is invoked at the start of the call. Return a closure to run when
    /// the call finishes, or `nil` to skip the end hook.
    ///
    /// - Returns: A cleanup closure that unregisters the hook.
    @discardableResult
    public func addJSClosureCallHook(
        _ hook: @escaping (_ info: JSClosureCallInfo) -> (() -> Void)?
    ) -> () -> Void {
        JSTracingHooks.addJSClosureCallHook(hook)
    }
}

enum JSTracingHooks {
    typealias HookEnd = () -> Void
    typealias JSCallHook = (JSTracing.JSCallInfo) -> HookEnd?
    typealias JSClosureCallHook = (JSTracing.JSClosureCallInfo) -> HookEnd?

    private final class HookList<Hook> {
        private var hooks: [(id: UInt, hook: Hook)] = []
        private var nextID: UInt = 0

        var isEmpty: Bool { hooks.isEmpty }

        func add(_ hook: Hook) -> UInt {
            let id = nextID
            nextID &+= 1
            hooks.append((id, hook))
            return id
        }

        func remove(id: UInt) {
            hooks.removeAll { $0.id == id }
        }

        func forEach(_ body: (Hook) -> Void) {
            for entry in hooks {
                body(entry.hook)
            }
        }
    }

    private final class Storage {
        let jsCallHooks = HookList<JSCallHook>()
        let jsClosureCallHooks = HookList<JSClosureCallHook>()
    }

    private static let storage = LazyThreadLocal(initialize: Storage.init)

    static func addJSCallHook(_ hook: @escaping JSCallHook) -> () -> Void {
        let storage = storage.wrappedValue
        let id = storage.jsCallHooks.add(hook)
        return { storage.jsCallHooks.remove(id: id) }
    }

    static func addJSClosureCallHook(_ hook: @escaping JSClosureCallHook) -> () -> Void {
        let storage = storage.wrappedValue
        let id = storage.jsClosureCallHooks.add(hook)
        return { storage.jsClosureCallHooks.remove(id: id) }
    }

    static func beginJSCall(_ info: JSTracing.JSCallInfo) -> HookEnd? {
        let storage = storage.wrappedValue
        guard !storage.jsCallHooks.isEmpty else { return nil }

        var callbacks: [HookEnd] = []
        storage.jsCallHooks.forEach { hook in
            if let callback = hook(info) {
                callbacks.append(callback)
            }
        }

        guard !callbacks.isEmpty else { return nil }
        return {
            for callback in callbacks.reversed() {
                callback()
            }
        }
    }

    static func beginJSClosureCall(_ info: JSTracing.JSClosureCallInfo) -> HookEnd? {
        let storage = storage.wrappedValue
        guard !storage.jsClosureCallHooks.isEmpty else { return nil }

        var callbacks: [HookEnd] = []
        storage.jsClosureCallHooks.forEach { hook in
            if let callback = hook(info) {
                callbacks.append(callback)
            }
        }

        guard !callbacks.isEmpty else { return nil }
        return {
            for callback in callbacks.reversed() {
                callback()
            }
        }
    }
}

#endif
