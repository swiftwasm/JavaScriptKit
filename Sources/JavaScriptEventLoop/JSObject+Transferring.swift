@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

#if canImport(Synchronization)
    import Synchronization
#endif

/// A temporary object intended to send a JavaScript object from one thread to another.
///
/// `JSSending` provides a way to safely transfer or clone JavaScript objects between threads
/// in a multi-threaded WebAssembly environment.
///
/// There are two primary ways to use `JSSending`:
/// 1. Transfer an object (`JSSending.transfer`) - The original object becomes unusable
/// 2. Clone an object (`JSSending.init`) - Creates a copy, original remains usable
///
/// To receive a sent object on the destination thread, call the `receive()` method.
///
/// - Note: `JSSending` is `Sendable` and can be safely shared across thread boundaries.
///
/// ## Example
///
/// ```swift
/// // Transfer an object to another thread
/// let buffer = JSObject.global.Uint8Array.function!.new(100).buffer.object!
/// let transferring = JSSending.transfer(buffer)
///
/// // Receive the object on a worker thread
/// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
/// Task(executorPreference: executor) {
///     let receivedBuffer = try await transferring.receive()
///     // Use the received buffer
/// }
///
/// // Clone an object for use in another thread
/// let object = JSObject.global.Object.function!.new()
/// object["test"] = "Hello, World!"
/// let cloning = JSSending(object)
///
/// Task(executorPreference: executor) {
///     let receivedObject = try await cloning.receive()
///     // Use the received object
/// }
/// ```
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct JSSending<T>: @unchecked Sendable {
    fileprivate struct Storage {
        /// The original object that is sent.
        ///
        /// Retain it here to prevent it from being released before the sending is complete.
        let sourceObject: JSObject
        /// A function that constructs an object from a JavaScript object reference.
        let construct: (_ object: JSObject) -> T
        /// The JavaScript object reference of the original object.
        let idInSource: JavaScriptObjectRef
        /// The TID of the thread that owns the original object.
        let sourceTid: Int32
        /// Whether the object should be "transferred" or "cloned".
        let transferring: Bool
    }

    private let storage: Storage

    fileprivate init(
        sourceObject: T,
        construct: @escaping (_ object: JSObject) -> T,
        deconstruct: @escaping (_ object: T) -> JSObject,
        getSourceTid: @escaping (_ object: T) -> Int32,
        transferring: Bool
    ) {
        let object = deconstruct(sourceObject)
        self.storage = Storage(
            sourceObject: object,
            construct: construct,
            idInSource: object.id,
            sourceTid: getSourceTid(sourceObject),
            transferring: transferring
        )
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension JSSending where T == JSObject {
    private init(_ object: JSObject, transferring: Bool) {
        self.init(
            sourceObject: object,
            construct: { $0 },
            deconstruct: { $0 },
            getSourceTid: {
                #if compiler(>=6.1) && _runtime(_multithreaded)
                    return $0.ownerTid
                #else
                    _ = $0
                    // On single-threaded runtime, source and destination threads are always the main thread (TID = -1).
                    return -1
                #endif
            },
            transferring: transferring
        )
    }

    /// Transfers a `JSObject` to another thread.
    ///
    /// The original `JSObject` is ["transferred"](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Transferable_objects)
    /// to the receiving thread, which means its ownership is completely moved. After transferring,
    /// the original object becomes neutered (unusable) in the source thread.
    ///
    /// This is more efficient than cloning for large objects like `ArrayBuffer` because no copying
    /// is involved, but the original object can no longer be accessed.
    ///
    /// Only objects that implement the JavaScript [Transferable](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Transferable_objects)
    /// interface can be transferred. Common transferable objects include:
    /// - `ArrayBuffer`
    /// - `MessagePort`
    /// - `ImageBitmap`
    /// - `OffscreenCanvas`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let buffer = JSObject.global.Uint8Array.function!.new(100).buffer.object!
    /// let transferring = JSSending.transfer(buffer)
    ///
    /// // After transfer, the original buffer is neutered
    /// // buffer.byteLength.number! will be 0
    /// ```
    ///
    /// - Precondition: The thread calling this method should have the ownership of the `JSObject`.
    /// - Postcondition: The original `JSObject` is no longer owned by the thread, further access to it
    ///   on the thread that called this method is invalid and will result in undefined behavior.
    ///
    /// - Parameter object: The `JSObject` to be transferred.
    /// - Returns: A `JSSending` instance that can be shared across threads.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public static func transfer(_ object: JSObject) -> JSSending {
        JSSending(object, transferring: true)
    }

    /// Clones a `JSObject` to another thread.
    ///
    /// Creates a copy of the object that can be sent to another thread. The original object
    /// remains usable in the source thread. This is safer than transferring when you need
    /// to continue using the original object, but has higher memory overhead since it creates
    /// a complete copy.
    ///
    /// Most JavaScript objects can be cloned, but some complex objects including closures may
    /// not be clonable.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let object = JSObject.global.Object.function!.new()
    /// object["test"] = "Hello, World!"
    /// let cloning = JSSending(object)
    ///
    /// // Original object is still valid and usable
    /// // object["test"].string! is still "Hello, World!"
    /// ```
    ///
    /// - Precondition: The thread calling this method should have the ownership of the `JSObject`.
    /// - Parameter object: The `JSObject` to be cloned.
    /// - Returns: A `JSSending` instance that can be shared across threads.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public init(_ object: JSObject) {
        self.init(object, transferring: false)
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension JSSending {

    /// Receives a sent `JSObject` from a thread.
    ///
    /// This method completes the transfer or clone operation, making the object available
    /// in the receiving thread. It must be called on the destination thread where you want
    /// to use the object.
    ///
    /// - Important: This method should be called only once for each `JSSending` instance.
    ///   Attempting to receive the same object multiple times will result in an error.
    ///
    /// ## Example - Transferring
    ///
    /// ```swift
    /// let canvas = JSObject.global.document.createElement("canvas").object!
    /// let transferring = JSSending.transfer(canvas.transferControlToOffscreen().object!)
    ///
    /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
    /// Task(executorPreference: executor) {
    ///     let canvas = try await transferring.receive()
    ///     // Use the canvas in the worker thread
    /// }
    /// ```
    ///
    /// ## Example - Cloning
    ///
    /// ```swift
    /// let data = JSObject.global.Object.function!.new()
    /// data["value"] = 42
    /// let cloning = JSSending(data)
    ///
    /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
    /// Task(executorPreference: executor) {
    ///     let data = try await cloning.receive()
    ///     print(data["value"].number!) // 42
    /// }
    /// ```
    ///
    /// - Parameter isolation: The actor isolation context for this call, used in Swift concurrency.
    /// - Returns: The received object of type `T`.
    /// - Throws: `JSSendingError` if the sending operation fails, or `JSException` if a JavaScript error occurs.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func receive(isolation: isolated (any Actor)? = #isolation, file: StaticString = #file, line: UInt = #line) async throws -> T {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        let idInDestination = try await withCheckedThrowingContinuation { continuation in
            let context = _JSSendingContext(continuation: continuation)
            let idInSource = self.storage.idInSource
            let transferring = self.storage.transferring ? [idInSource] : []
            swjs_request_sending_object(
                idInSource,
                transferring,
                Int32(transferring.count),
                self.storage.sourceTid,
                Unmanaged.passRetained(context).toOpaque()
            )
        }
        return storage.construct(JSObject(id: idInDestination))
        #else
        return storage.construct(storage.sourceObject)
        #endif
    }

    // 6.0 and below can't compile the following without a compiler crash.
    #if compiler(>=6.1)
    /// Receives multiple `JSSending` instances from a thread in a single operation.
    ///
    /// This method is more efficient than receiving multiple objects individually, as it
    /// batches the receive operations. It's especially useful when transferring or cloning
    /// multiple related objects that need to be received together.
    ///
    /// - Important: All objects being received must come from the same source thread.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Create and transfer multiple objects
    /// let buffer1 = Uint8Array.new(10).buffer.object!
    /// let buffer2 = Uint8Array.new(20).buffer.object!
    /// let transferring1 = JSSending.transfer(buffer1)
    /// let transferring2 = JSSending.transfer(buffer2)
    ///
    /// // Receive both objects in a single operation
    /// let executor = try await WebWorkerTaskExecutor(numberOfThreads: 1)
    /// Task(executorPreference: executor) {
    ///     let (receivedBuffer1, receivedBuffer2) = try await JSSending.receive(transferring1, transferring2)
    ///     // Use both buffers in the worker thread
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - sendings: The `JSSending` instances to receive.
    ///   - isolation: The actor isolation context for this call, used in Swift concurrency.
    /// - Returns: A tuple containing the received objects.
    /// - Throws: `JSSendingError` if any sending operation fails, or `JSException` if a JavaScript error occurs.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public static func receive<each U>(
        _ sendings: repeat JSSending<each U>,
        isolation: isolated (any Actor)? = #isolation, file: StaticString = #file, line: UInt = #line
    ) async throws -> (repeat each U) where T == (repeat each U) {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        var sendingObjects: [JavaScriptObjectRef] = []
        var transferringObjects: [JavaScriptObjectRef] = []
        var sourceTid: Int32?
        for object in repeat each sendings {
            sendingObjects.append(object.storage.idInSource)
            if object.storage.transferring {
                transferringObjects.append(object.storage.idInSource)
            }
            if sourceTid == nil {
                sourceTid = object.storage.sourceTid
            } else {
                guard sourceTid == object.storage.sourceTid else {
                    throw JSSendingError("All objects sent at once must be from the same thread")
                }
            }
        }
        let objects = try await withCheckedThrowingContinuation { continuation in
            let context = _JSSendingContext(continuation: continuation)
            sendingObjects.withUnsafeBufferPointer { sendingObjects in
                transferringObjects.withUnsafeBufferPointer { transferringObjects in
                    swjs_request_sending_objects(
                        sendingObjects.baseAddress!,
                        Int32(sendingObjects.count),
                        transferringObjects.baseAddress!,
                        Int32(transferringObjects.count),
                        sourceTid!,
                        Unmanaged.passRetained(context).toOpaque()
                    )
                }
            }
        }
        guard let objectsArray = JSArray(JSObject(id: objects)) else {
            fatalError("Non-array object received!?")
        }
        var index = 0
        func extract<R>(_ sending: JSSending<R>) -> R {
            let result = objectsArray[index]
            index += 1
            return sending.storage.construct(result.object!)
        }
        return (repeat extract(each sendings))
        #else
        return try await (repeat (each sendings).receive())
        #endif
    }
    #endif // compiler(>=6.1)
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
fileprivate final class _JSSendingContext: Sendable {
    let continuation: CheckedContinuation<JavaScriptObjectRef, Error>

    init(continuation: CheckedContinuation<JavaScriptObjectRef, Error>) {
        self.continuation = continuation
    }
}

/// Error type representing failures during JavaScript object sending operations.
///
/// This error is thrown when a problem occurs during object transfer or cloning
/// between threads, such as attempting to send objects from different threads
/// in a batch operation or other sending-related failures.
public struct JSSendingError: Error, CustomStringConvertible {
    /// A description of the error that occurred.
    public let description: String

    init(_ message: String) {
        self.description = message
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
func _swjs_receive_response(_ object: JavaScriptObjectRef, _ contextPtr: UnsafeRawPointer?) {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    guard let contextPtr = contextPtr else { return }
    let context = Unmanaged<_JSSendingContext>.fromOpaque(contextPtr).takeRetainedValue()
    context.continuation.resume(returning: object)
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
func _swjs_receive_error(_ error: JavaScriptObjectRef, _ contextPtr: UnsafeRawPointer?) {
    #if compiler(>=6.1) && _runtime(_multithreaded)
    guard let contextPtr = contextPtr else { return }
    let context = Unmanaged<_JSSendingContext>.fromOpaque(contextPtr).takeRetainedValue()
    context.continuation.resume(throwing: JSException(JSObject(id: error).jsValue))
    #endif
}
