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

    fileprivate init(sourceObject: JSObject, sourceTid: Int32) {
        self.storage = Storage(sourceObject: sourceObject, sourceTid: sourceTid)
    }
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
        #if compiler(>=6.1) && _runtime(_multithreaded)
        self.init(sourceObject: object, sourceTid: object.ownerTid)
        #else
        self.init(sourceObject: object, sourceTid: -1)
        #endif
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
        #if compiler(>=6.1) && _runtime(_multithreaded)
        if storage.sourceTid == swjs_get_worker_thread_id_cached() {
            return try body(storage.sourceObject)
        }
        let result: Result<R, E> = await withCheckedContinuation { continuation in
            let context = _JSRemoteContext(
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
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private final class _JSRemoteContext: @unchecked Sendable {
    let invokeBody: () -> Bool

    init<R: Sendable, E: Error>(
        sourceObject: JSObject,
        body: @escaping @Sendable (JSObject) throws(E) -> R,
        continuation: CheckedContinuation<Result<R, E>, Never>
    ) {
        self.invokeBody = {
            // NOTE: Sendability violation here for `sourceObject`
            // Even though `JSObject` is not Sendable, it is safe to access it here
            // because this invokeBody closure will only be executed on the owning thread.
            do throws(E) {
                continuation.resume(returning: .success(try body(sourceObject)))
            } catch {
                continuation.resume(returning: .failure(error))
            }
            return false
        }
    }
}

#if compiler(>=6.1)
@_expose(wasm, "swjs_invoke_remote_jsobject_body")
@_cdecl("swjs_invoke_remote_jsobject_body")
#endif
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
func _swjs_invoke_remote_jsobject_body(_ contextPtr: UnsafeRawPointer?) -> Bool {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    guard let contextPtr else { return true }
    let context = Unmanaged<_JSRemoteContext>.fromOpaque(contextPtr).takeRetainedValue()

    return context.invokeBody()
    #else
    _ = contextPtr
    return true
    #endif
}
