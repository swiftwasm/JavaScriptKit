import _CJavaScriptKit

/// Owns one reference to a JavaScript value and releases it when destroyed.
@frozen public struct JSUniqueRef: ~Copyable {
    @usableFromInline
    internal let _id: Int32

    #if _runtime(_multithreaded)
    @usableFromInline
    internal let ownerTid: Int32
    #endif

    @_spi(BridgeJS)
    @inlinable
    public var id: Int32 {
        #if _runtime(_multithreaded)
        precondition(
            ownerTid == swjs_get_worker_thread_id_cached(),
            "JSUniqueRef is being used on a thread other than the one that created it"
        )
        #endif
        return _id
    }

    /// Takes over a reference the caller owns.
    @_spi(BridgeJS) public init(adopting id: Int32) {
        self._id = id
        #if _runtime(_multithreaded)
        self.ownerTid = swjs_get_worker_thread_id_cached()
        #endif
    }

    /// Takes a reference of its own to the value `object` holds.
    public init(retaining object: JSObject) {
        #if _runtime(_multithreaded)
        precondition(
            object.ownerTid == swjs_get_worker_thread_id_cached(),
            "JSUniqueRef(retaining:) is called on a thread other than the one that owns the JSObject"
        )
        #endif
        self.init(adopting: _swift_js_retain(Int32(bitPattern: object.id)))
    }

    /// Takes over `object`'s reference when no other Swift reference to `object` exists, and otherwise takes a
    /// reference of its own.
    public init(taking object: consuming JSObject) {
        #if _runtime(_multithreaded)
        precondition(
            object.ownerTid == swjs_get_worker_thread_id_cached(),
            "JSUniqueRef(taking:) is called on a thread other than the one that owns the JSObject"
        )
        #endif
        if isKnownUniquelyReferenced(&object) {
            self.init(adopting: Int32(bitPattern: object._id))
            object._id = 0
        } else {
            self.init(adopting: _swift_js_retain(Int32(bitPattern: object.id)))
        }
    }

    /// Returns the reference without releasing it.
    @_spi(BridgeJS) public consuming func relinquish() -> Int32 {
        let id = _id
        discard self
        return id
    }

    deinit {
        #if _runtime(_multithreaded)
        if ownerTid != swjs_get_worker_thread_id_cached() {
            swjs_release_remote(ownerTid, JavaScriptObjectRef(bitPattern: _id))
            return
        }
        #endif
        swjs_release(JavaScriptObjectRef(bitPattern: _id))
    }
}

/// The id is valid only on the thread that created it.
@available(*, unavailable)
extension JSUniqueRef: Sendable {}

/// Lets BridgeJS bridge `JSUniqueRef`, and optionals of it, as it bridges noncopyable `@JSClass` wrappers.
extension JSUniqueRef: _JSUniqueBridgedClass {
    public var jsID: Int32 { id }

    public init(unsafelyAdopting jsRef: consuming JSUniqueRef) {
        self = jsRef
    }

    public consuming func takeJSRef() -> JSUniqueRef { self }
}
