@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

#if canImport(Synchronization)
    import Synchronization
#endif

/// A temporary object intended to transfer an object from one thread to another.
///
/// ``JSTransferring`` is `Sendable` and it's intended to be shared across threads.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct JSTransferring<T>: @unchecked Sendable {
    fileprivate struct Storage {
        /// The original object that is transferred.
        ///
        /// Retain it here to prevent it from being released before the transfer is complete.
        let sourceObject: T
        /// A function that constructs an object from a JavaScript object reference.
        let construct: (_ id: JavaScriptObjectRef) -> T
        /// The JavaScript object reference of the original object.
        let idInSource: JavaScriptObjectRef
        /// The TID of the thread that owns the original object.
        let sourceTid: Int32

        #if compiler(>=6.1) && _runtime(_multithreaded)
        /// A shared context for transferring objects across threads.
        let context: _JSTransferringContext = _JSTransferringContext()
        #endif
    }

    private let storage: Storage

    fileprivate init(
        sourceObject: T,
        construct: @escaping (_ id: JavaScriptObjectRef) -> T,
        deconstruct: @escaping (_ object: T) -> JavaScriptObjectRef,
        getSourceTid: @escaping (_ object: T) -> Int32
    ) {
        self.storage = Storage(
            sourceObject: sourceObject,
            construct: construct,
            idInSource: deconstruct(sourceObject),
            sourceTid: getSourceTid(sourceObject)
        )
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
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func receive(isolation: isolated (any Actor)? = #isolation, file: StaticString = #file, line: UInt = #line) async throws -> T {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        // The following sequence of events happens when a `JSObject` is transferred from
        // the owner thread to the receiver thread:
        //
        // [Owner Thread]               [Receiver Thread]
        //        <-----requestTransfer------ swjs_request_transferring_object    
        //        ---------transfer---------> swjs_receive_object
        let idInDestination = try await withCheckedThrowingContinuation { continuation in
            self.storage.context.withLock { context in
                guard context.continuation == nil else {
                    // This is a programming error, `receive` should be called only once.
                    fatalError("JSObject.Transferring object is already received", file: file, line: line)
                }
                // The continuation will be resumed by `swjs_receive_object`.
                context.continuation = continuation
            }
            swjs_request_transferring_object(
                self.storage.idInSource,
                self.storage.sourceTid,
                Unmanaged.passRetained(self.storage.context).toOpaque()
            )
        }
        return storage.construct(idInDestination)
        #else
        return storage.construct(storage.idInSource)
        #endif
    }
}

fileprivate final class _JSTransferringContext: Sendable {
    struct State {
        var continuation: CheckedContinuation<JavaScriptObjectRef, Error>?
    }
    private let state: Mutex<State> = .init(State())

    func withLock<R>(_ body: (inout State) -> R) -> R {
        return state.withLock { state in
            body(&state)
        }
    }
}


extension JSTransferring where T == JSObject {

    /// Transfers the ownership of a `JSObject` to be sent to another thread.
    ///
    /// - Precondition: The thread calling this method should have the ownership of the `JSObject`.
    /// - Postcondition: The original `JSObject` is no longer owned by the thread, further access to it
    ///   on the thread that called this method is invalid and will result in undefined behavior.
    ///
    /// - Parameter object: The ``JSObject`` to be transferred.
    /// - Returns: A ``Transferring`` instance that can be shared across threads.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public init(_ object: JSObject) {
        self.init(
            sourceObject: object,
            construct: { JSObject(id: $0) },
            deconstruct: { $0.id },
            getSourceTid: {
                #if compiler(>=6.1) && _runtime(_multithreaded)
                    return $0.ownerTid
                #else
                    _ = $0
                    // On single-threaded runtime, source and destination threads are always the main thread (TID = -1).
                    return -1
                #endif
            }
        )
    }
}


/// A function that should be called when an object source thread sends an object to a
/// destination thread.
///
/// - Parameters:
///   - object: The `JSObject` to be received.
///   - transferring: A pointer to the `Transferring.Storage` instance.
#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_receive_response")
@_cdecl("swjs_receive_response")
#endif
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
func _swjs_receive_response(_ object: JavaScriptObjectRef, _ transferring: UnsafeRawPointer) {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    let context = Unmanaged<_JSTransferringContext>.fromOpaque(transferring).takeRetainedValue()
    context.withLock { state in
        assert(state.continuation != nil, "JSObject.Transferring object is not yet received!?")
        state.continuation?.resume(returning: object)
    }
    #endif
}

/// A function that should be called when an object source thread sends an error to a
/// destination thread.
///
/// - Parameters:
///   - error: The error to be received.
///   - transferring: A pointer to the `Transferring.Storage` instance.
#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_receive_error")
@_cdecl("swjs_receive_error")
#endif
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
func _swjs_receive_error(_ error: JavaScriptObjectRef, _ transferring: UnsafeRawPointer) {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    let context = Unmanaged<_JSTransferringContext>.fromOpaque(transferring).takeRetainedValue()
    context.withLock { state in
        assert(state.continuation != nil, "JSObject.Transferring object is not yet received!?")
        state.continuation?.resume(throwing: JSException(JSObject(id: error).jsValue))
    }
    #endif
}
