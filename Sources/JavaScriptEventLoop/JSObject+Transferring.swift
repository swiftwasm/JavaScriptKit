@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

#if canImport(Synchronization)
    import Synchronization
#endif

extension JSObject {

    /// A temporary object intended to transfer a ``JSObject`` from one thread to another.
    ///
    /// ``JSObject`` itself is not `Sendable`, but ``Transferring`` is `Sendable` because it's
    /// intended to be shared across threads.
    public struct Transferring: @unchecked Sendable {
        fileprivate struct CriticalState {
            var continuation: CheckedContinuation<JSObject, Error>?
        }
        fileprivate class Storage {
            let sourceTid: Int32
            let idInSource: JavaScriptObjectRef
            #if compiler(>=6.1) && _runtime(_multithreaded)
            let criticalState: Mutex<CriticalState> = .init(CriticalState())
            #endif

            init(sourceTid: Int32, id: JavaScriptObjectRef) {
                self.sourceTid = sourceTid
                self.idInSource = id
            }
        }

        private let storage: Storage

        fileprivate init(sourceTid: Int32, id: JavaScriptObjectRef) {
            self.init(storage: Storage(sourceTid: sourceTid, id: id))
        }

        fileprivate init(storage: Storage) {
            self.storage = storage
        }

        /// Receives a transferred ``JSObject`` from a thread.
        ///
        /// The original ``JSObject`` is ["Transferred"](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Transferable_objects)
        /// to the receiving thread.
        ///
        /// Note that this method should be called only once for each ``Transferring`` instance
        /// on the receiving thread.
        ///
        /// ### Example
        ///
        /// ```swift
        /// let canvas = JSObject.global.document.createElement("canvas").object!
        /// let transferring = JSObject.transfer(canvas.transferControlToOffscreen().object!)
        /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
        /// Task(executorPreference: executor) {
        ///     let canvas = try await transferring.receive()
        /// }
        /// ```
        public func receive(isolation: isolated (any Actor)? = #isolation, file: StaticString = #file, line: UInt = #line) async throws -> JSObject {
            #if compiler(>=6.1) && _runtime(_multithreaded)
            swjs_request_transferring_object(
                self.storage.idInSource,
                self.storage.sourceTid,
                Unmanaged.passRetained(self.storage).toOpaque()
            )
            return try await withCheckedThrowingContinuation { continuation in
                self.storage.criticalState.withLock { criticalState in
                    guard criticalState.continuation == nil else {
                        // This is a programming error, `receive` should be called only once.
                        fatalError("JSObject.Transferring object is already received", file: file, line: line)
                    }
                    criticalState.continuation = continuation
                }
            }
            #else
            return JSObject(id: storage.idInSource)
            #endif
        }
    }

    /// Transfers the ownership of a `JSObject` to be sent to another thread.
    ///
    /// Note that the original ``JSObject`` should not be accessed after calling this method.
    ///
    /// - Parameter object: The ``JSObject`` to be transferred.
    /// - Returns: A ``Transferring`` instance that can be shared across threads.
    public static func transfer(_ object: JSObject) -> Transferring {
        #if compiler(>=6.1) && _runtime(_multithreaded)
            Transferring(sourceTid: object.ownerTid, id: object.id)
        #else
            // On single-threaded runtime, source and destination threads are always the main thread (TID = -1).
            Transferring(sourceTid: -1, id: object.id)
        #endif
    }
}


/// A function that should be called when an object source thread sends an object to a
/// destination thread.
///
/// - Parameters:
///   - object: The `JSObject` to be received.
///   - transferring: A pointer to the `Transferring.Storage` instance.
#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_receive_object")
@_cdecl("swjs_receive_object")
#endif
func _swjs_receive_object(_ object: JavaScriptObjectRef, _ transferring: UnsafeRawPointer) {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    let storage = Unmanaged<JSObject.Transferring.Storage>.fromOpaque(transferring).takeRetainedValue()
    storage.criticalState.withLock { criticalState in
        assert(criticalState.continuation != nil, "JSObject.Transferring object is not yet received!?")
        criticalState.continuation?.resume(returning: JSObject(id: object))
    }
    #endif
}
