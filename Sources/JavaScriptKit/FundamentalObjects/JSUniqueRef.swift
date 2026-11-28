import _CJavaScriptKit

/// Owns one reference to a JavaScript value and releases it when destroyed.
///
/// Unlike ``JSObject``, a `JSUniqueRef` is a noncopyable value, so owning a reference
/// costs no Swift heap allocation or reference counting.
@frozen public struct JSUniqueRef: ~Copyable {
    @usableFromInline
    internal let _id: JavaScriptObjectRef

    #if _runtime(_multithreaded)
    @usableFromInline
    internal let ownerTid: Int32
    #endif

    @_spi(BridgeJS)
    @inlinable
    public var id: JavaScriptObjectRef {
        #if _runtime(_multithreaded)
        precondition(
            ownerTid == swjs_get_worker_thread_id_cached(),
            "JSUniqueRef is being used on a thread other than the one that created it"
        )
        #endif
        return _id
    }

    /// Takes over a reference the caller owns.
    @_spi(BridgeJS)
    @inlinable
    public init(adopting id: JavaScriptObjectRef) {
        self._id = id
        #if _runtime(_multithreaded)
        self.ownerTid = swjs_get_worker_thread_id_cached()
        #endif
    }

    /// Returns the reference without releasing it. The caller becomes its owner.
    @_spi(BridgeJS)
    @inlinable
    public consuming func unsafeTake() -> JavaScriptObjectRef {
        let id = self.id
        discard self
        return id
    }

    deinit {
        #if _runtime(_multithreaded)
        if ownerTid != swjs_get_worker_thread_id_cached() {
            swjs_release_remote(ownerTid, _id)
            return
        }
        #endif
        swjs_release(_id)
    }
}

/// The reference is valid only on the thread that created it.
@available(*, unavailable)
extension JSUniqueRef: Sendable {}
