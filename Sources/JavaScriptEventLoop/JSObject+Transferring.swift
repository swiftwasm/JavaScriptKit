@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

extension JSObject {
    public class Transferring: @unchecked Sendable {
        fileprivate let sourceTid: Int32
        fileprivate let idInSource: JavaScriptObjectRef
        fileprivate var continuation: CheckedContinuation<JSObject, Error>? = nil

        init(sourceTid: Int32, id: JavaScriptObjectRef) {
            self.sourceTid = sourceTid
            self.idInSource = id
        }

        func receive(isolation: isolated (any Actor)?) async throws -> JSObject {
            #if compiler(>=6.1) && _runtime(_multithreaded)
            swjs_request_transferring_object(
                idInSource,
                sourceTid,
                Unmanaged.passRetained(self).toOpaque()
            )
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
            }
            #else
            return JSObject(id: idInSource)
            #endif
        }
    }

    /// Transfers the ownership of a `JSObject` to be sent to another Worker.
    ///
    /// - Parameter object: The `JSObject` to be transferred.
    /// - Returns: A `JSTransferring` instance that can be shared across worker threads.
    /// - Note: The original `JSObject` should not be accessed after calling this method.
    public static func transfer(_ object: JSObject) -> Transferring {
        #if compiler(>=6.1) && _runtime(_multithreaded)
            Transferring(sourceTid: object.ownerTid, id: object.id)
        #else
            Transferring(sourceTid: -1, id: object.id)
        #endif
    }

    /// Receives a transferred `JSObject` from a Worker.
    ///
    /// - Parameter transferring: The `JSTransferring` instance received from other worker threads.
    /// - Returns: The reconstructed `JSObject` that can be used in the receiving Worker.
    public static func receive(_ transferring: Transferring, isolation: isolated (any Actor)? = #isolation) async throws -> JSObject {
        try await transferring.receive(isolation: isolation)
    }
}

#if compiler(>=6.1)  // @_expose and @_extern are only available in Swift 6.1+
@_expose(wasm, "swjs_receive_object")
@_cdecl("swjs_receive_object")
#endif
func _swjs_receive_object(_ object: JavaScriptObjectRef, _ transferring: UnsafeRawPointer) {
    let transferring = Unmanaged<JSObject.Transferring>.fromOpaque(transferring).takeRetainedValue()
    transferring.continuation?.resume(returning: JSObject(id: object))
}
