import _Concurrency
@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

/// A sendable handle for temporarily accessing a `JSObject` on its owning thread.
///
/// `JSRemote` lets you share a reference to a JavaScript object across Swift concurrency
/// domains without transferring or cloning the object itself. Instead, the object stays
/// owned by its original JavaScript thread, and `withJSObject(_:)` schedules a closure to
/// run on that owner when needed.
///
/// This is useful when you need occasional coordinated access to a JavaScript object from
/// another thread, but cannot or should not move the object with `JSSending`.
///
/// - Note: `JSRemote` does not make the underlying `JSObject` itself thread-safe. The object
///   may only be touched inside `withJSObject(_:)`.
///
/// ## Example
///
/// ```swift
/// let document = JSObject.global.document.object!
/// let remoteDocument = JSRemote(document)
///
/// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
/// let title = try await Task(executorPreference: executor) {
///     try await remoteDocument.withJSObject { document in
///         document.title.string ?? ""
///     }
/// }.value
/// ```
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct JSRemote<T>: @unchecked Sendable {
    private final class Storage {
        let sourceObject: JSObject
        let sourceTid: Int32

        init(sourceObject: JSObject, sourceTid: Int32) {
            self.sourceObject = sourceObject
            self.sourceTid = sourceTid
        }
    }

    private let storage: Storage

    fileprivate init(sourceObject: JSObject) {
        let sourceTid: Int32
        #if compiler(>=6.1) && _runtime(_multithreaded)
        sourceTid = sourceObject.ownerTid
        #else
        sourceTid = -1
        #endif
        self.storage = Storage(sourceObject: sourceObject, sourceTid: sourceTid)
    }

    fileprivate func _withJSObject<R: Sendable, E: Error>(
        _ body: @Sendable @escaping (JSObject) throws(E) -> R
    ) async throws(E) -> sending R {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        if storage.sourceTid == swjs_get_worker_thread_id_cached() {
            return try body(storage.sourceObject)
        }
        let result: Result<R, E> = await withCheckedContinuation { continuation in
            let context = _JSRemoteSyncContext(
                sourceObject: storage.sourceObject,
                body: body,
                continuation: continuation
            )
            swjs_request_remote_jsobject_body(
                storage.sourceTid,
                Unmanaged.passRetained(context).toOpaque()
            )
        }
        return try result.get()
        #else
        return try body(storage.sourceObject)
        #endif
    }

    #if compiler(>=6.1) && hasFeature(Embedded) && _runtime(_multithreaded)
    #else
        fileprivate func _withJSObject<R: Sendable, E: Error>(
            _ body: @Sendable @escaping (JSObject) async throws(E) -> R
        ) async throws(E) -> sending R {
            #if compiler(>=6.1) && _runtime(_multithreaded)
            if storage.sourceTid == swjs_get_worker_thread_id_cached() {
                return try await body(storage.sourceObject)
            }
            let result: Result<R, E> = await withCheckedContinuation { continuation in
                let context = _JSRemoteAsyncContext(
                    sourceObject: storage.sourceObject,
                    body: body,
                    continuation: continuation
                )
                swjs_request_remote_jsobject_body(
                    storage.sourceTid,
                    Unmanaged.passRetained(context).toOpaque()
                )
            }
            return try result.get()
            #else
            return try await body(storage.sourceObject)
            #endif
        }
    #endif
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension JSRemote where T == JSObject {
    /// Creates a remote handle for a `JSObject`.
    ///
    /// The object remains owned by its current JavaScript thread. Access it later by calling
    /// `withJSObject(_:)`, which executes the closure on the owning thread when necessary.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let remoteWindow = JSRemote(JSObject.global)
    /// ```
    ///
    /// - Parameter object: The JavaScript object to reference remotely.
    public init(_ object: JSObject) {
        self.init(sourceObject: object)
    }

    /// Performs an operation with the underlying `JSObject` on its owning thread.
    ///
    /// If the caller is already running on the thread that owns the object, `body` executes
    /// immediately. Otherwise, this method asynchronously requests execution on the owner and
    /// resumes when the closure completes.
    ///
    /// Use this API when the object must stay on its original thread but a result derived from
    /// that object needs to be produced in another Swift concurrency context.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let location = try await remoteWindow.withJSObject { window in
    ///     window.location.href.string ?? ""
    /// }
    /// ```
    ///
    /// - Parameter body: A sendable closure that receives the owned `JSObject`.
    /// - Returns: The value produced by `body`.
    /// - Throws: Any error thrown by `body`.
    public func withJSObject<R: Sendable, E: Error>(
        _ body: @Sendable @escaping (JSObject) throws(E) -> R
    ) async throws(E) -> sending R {
        try await _withJSObject(body)
    }

    #if compiler(>=6.1) && hasFeature(Embedded) && _runtime(_multithreaded)
    #else
        /// Performs an asynchronous operation with the underlying `JSObject` on its owning thread.
        ///
        /// If the caller is already running on the thread that owns the object, `body` executes
        /// immediately. Otherwise, this method asynchronously requests execution on the owner and
        /// resumes when the closure completes.
        ///
        /// Use this API when the object must stay on its original thread but producing a result
        /// requires suspending, such as awaiting a JavaScript promise.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let value = try await remoteWindow.withJSObject { window in
        ///     try await JSPromise(from: window.fetch!("/api").object!)!.value
        /// }
        /// ```
        ///
        /// - Parameter body: A sendable asynchronous closure that receives the owned `JSObject`.
        /// - Returns: The value produced by `body`.
        /// - Throws: Any error thrown by `body`.
        public func withJSObject<R: Sendable, E: Error>(
            _ body: @Sendable @escaping (JSObject) async throws(E) -> R
        ) async throws(E) -> sending R {
            try await _withJSObject(body)
        }
    #endif
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension JSRemote where T: _JSBridgedClass {
    /// Creates a remote handle for a `@JSClass`-imported object.
    ///
    /// The object remains owned by its current JavaScript thread. Access it later by calling
    /// `withJSObject(_:)`, which executes the closure on the owning thread when necessary.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @JSClass struct Window {
    ///     @JSGetter var location: Location
    /// }
    /// let remoteWindow = JSRemote(Window(unsafelyWrapping: JSObject.global))
    /// remoteWindow.withJSObject { window in
    ///     print(window.location.href.string ?? "")
    /// }
    /// ```
    ///
    /// - Parameter object: The JavaScript object to reference remotely.
    public init(_ object: T) {
        self.init(sourceObject: object.jsObject)
    }


    /// Performs an operation with the underlying `T` object on its owning thread.
    ///
    /// If the caller is already running on the thread that owns the object, `body` executes
    /// immediately. Otherwise, this method asynchronously requests execution on the owner and
    /// resumes when the closure completes.
    ///
    /// Use this API when the object must stay on its original thread but a result derived from
    /// that object needs to be produced in another Swift concurrency context.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let location = try await remoteWindow.withJSObject { window in
    ///     window.location.href.string ?? ""
    /// }
    /// ```
    ///
    /// - Parameter body: A sendable closure that receives the owned `T` object.
    /// - Returns: The value produced by `body`.
    /// - Throws: Any error thrown by `body`.
    #if compiler(>=6.2)
        public func withJSObject<R: Sendable, E: Error>(
            _ body: @Sendable @escaping (T) throws(E) -> R
        ) async throws(E) -> sending R where T: SendableMetatype {
            try await _withJSObject { jsObject throws(E) -> R in
                let object = T(unsafelyWrapping: jsObject)
                return try body(object)
            }
        }
    #else
        public func withJSObject<R: Sendable, E: Error>(
            _ body: @Sendable @escaping (T) throws(E) -> R
        ) async throws(E) -> sending R {
            try await _withJSObject { jsObject throws(E) -> R in
                let object = T(unsafelyWrapping: jsObject)
                return try body(object)
            }
        }
    #endif

    #if compiler(>=6.1) && hasFeature(Embedded) && _runtime(_multithreaded)
    #else
        /// Performs an asynchronous operation with the underlying `T` object on its owning thread.
        ///
        /// If the caller is already running on the thread that owns the object, `body` executes
        /// immediately. Otherwise, this method asynchronously requests execution on the owner and
        /// resumes when the closure completes.
        ///
        /// Use this API when the object must stay on its original thread but producing a result
        /// requires suspending, such as awaiting a JavaScript promise.
        ///
        /// ## Example
        ///
        /// ```swift
        /// let response = try await remoteWindow.withJSObject { window in
        ///     try await window.fetch("/api").value
        /// }
        /// ```
        ///
        /// - Parameter body: A sendable asynchronous closure that receives the owned `T` object.
        /// - Returns: The value produced by `body`.
        /// - Throws: Any error thrown by `body`.
        #if compiler(>=6.2)
            public func withJSObject<R: Sendable, E: Error>(
                _ body: @Sendable @escaping (T) async throws(E) -> R
            ) async throws(E) -> sending R where T: SendableMetatype {
                try await _withJSObject { jsObject async throws(E) -> R in
                    let object = T(unsafelyWrapping: jsObject)
                    return try await body(object)
                }
            }
        #else
            public func withJSObject<R: Sendable, E: Error>(
                _ body: @Sendable @escaping (T) async throws(E) -> R
            ) async throws(E) -> sending R {
                try await _withJSObject { jsObject async throws(E) -> R in
                    let object = T(unsafelyWrapping: jsObject)
                    return try await body(object)
                }
            }
        #endif
    #endif
}


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private class _JSRemoteContext: @unchecked Sendable {
    fileprivate func invoke() {
        preconditionFailure("JSRemote context subclasses must override invoke()")
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private final class _JSRemoteSyncContext<R: Sendable, E: Error>: _JSRemoteContext, @unchecked Sendable {
    let sourceObject: JSObject
    let body: @Sendable (JSObject) throws(E) -> R
    let continuation: CheckedContinuation<Result<R, E>, Never>

    init(
        sourceObject: JSObject,
        body: @escaping @Sendable (JSObject) throws(E) -> R,
        continuation: CheckedContinuation<Result<R, E>, Never>
    ) {
        self.sourceObject = sourceObject
        self.body = body
        self.continuation = continuation
    }

    override fileprivate func invoke() {
        // NOTE: Sendability violation here for `sourceObject`.
        // Even though `JSObject` is not Sendable, it is safe to access it here
        // because this method will only be executed on the owning thread.
        do throws(E) {
            continuation.resume(returning: .success(try body(sourceObject)))
        } catch {
            continuation.resume(returning: .failure(error))
        }
    }
}

#if compiler(>=6.1) && hasFeature(Embedded) && _runtime(_multithreaded)
#else
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private final class _JSRemoteAsyncContext<R: Sendable, E: Error>: _JSRemoteContext, @unchecked Sendable {
        let sourceObject: JSObject
        let body: @Sendable (JSObject) async throws(E) -> R
        let continuation: CheckedContinuation<Result<R, E>, Never>

        init(
            sourceObject: JSObject,
            body: @escaping @Sendable (JSObject) async throws(E) -> R,
            continuation: CheckedContinuation<Result<R, E>, Never>
        ) {
            self.sourceObject = sourceObject
            self.body = body
            self.continuation = continuation
        }

        override fileprivate func invoke() {
            _runJSRemoteBody {
                await self.invokeAsync()
            }
        }

        private func invokeAsync() async {
            // NOTE: Sendability violation here for `sourceObject`.
            // Even though `JSObject` is not Sendable, it is safe to access it here
            // because this method will only be executed on the owning thread.
            do throws(E) {
                continuation.resume(returning: .success(try await body(sourceObject)))
            } catch {
                continuation.resume(returning: .failure(error))
            }
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private func _runJSRemoteBody(_ body: @escaping @Sendable () async -> Void) {
        #if compiler(>=6.0) && !hasFeature(Embedded)
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *) {
            Task(executorPreference: WebWorkerTaskExecutor.currentExecutorPreference) {
                await body()
            }
            return
        }
        #endif
        Task {
            await body()
        }
    }
#endif

#if compiler(>=6.1)
@_expose(wasm, "swjs_invoke_remote_jsobject_body")
@_cdecl("swjs_invoke_remote_jsobject_body")
#endif
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
func _swjs_invoke_remote_jsobject_body(_ contextPtr: UnsafeRawPointer?) -> Bool {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    guard let contextPtr else { return true }
    let context = Unmanaged<_JSRemoteContext>.fromOpaque(contextPtr).takeRetainedValue()

    context.invoke()
    return false
    #else
    _ = contextPtr
    return true
    #endif
}
