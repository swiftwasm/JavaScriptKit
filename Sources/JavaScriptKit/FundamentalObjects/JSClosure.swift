import _CJavaScriptKit
#if hasFeature(Embedded) && os(WASI)
import _Concurrency
#endif

/// `JSClosureProtocol` wraps Swift closure objects for use in JavaScript. Conforming types
/// are responsible for managing the lifetime of the closure they wrap, but can delegate that
/// task to the user by requiring an explicit `release()` call.
public protocol JSClosureProtocol {

    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    func release()
}

/// `JSOneshotClosure` is a JavaScript function that can be called only once. This class can be used
/// for optimized memory management when compared to the common `JSClosure`.
public class JSOneshotClosure: JSObject, JSClosureProtocol {
    private var hostFuncRef: JavaScriptHostFuncRef = 0

    public init(file: String = #fileID, line: UInt32 = #line, _ body: @escaping (sending [JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)

        // 2. Create a new JavaScript function which calls the given Swift function.
        hostFuncRef = JavaScriptHostFuncRef(bitPattern: ObjectIdentifier(self))
        _id = withExtendedLifetime(JSString(file)) { file in
            swjs_create_oneshot_function(hostFuncRef, line, file.asInternalJSRef())
        }
    }

    @available(*, unavailable, message: "JSOneshotClosure does not support dictionary literal initialization")
    public required init(dictionaryLiteral elements: (String, JSValue)...) {
        fatalError("JSOneshotClosure does not support dictionary literal initialization")
    }

    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    public func release() {
        // JSClosure.sharedClosures.wrappedValue[hostFuncRef] = nil
    }
}

/// `JSClosure` represents a JavaScript function the body of which is written in Swift.
/// This type can be passed as a callback handler to JavaScript functions.
///
/// e.g.
/// ```swift
/// let eventListener = JSClosure { _ in
///     ...
///     return JSValue.undefined
/// }
///
/// button.addEventListener!("click", JSValue.function(eventListener))
/// ...
/// button.removeEventListener!("click", JSValue.function(eventListener))
/// ```
///
public class JSClosure: JSObject, JSClosureProtocol {

    class SharedJSClosure {
        // Note: 6.0 compilers built with assertions enabled crash when calling
        // `removeValue(forKey:)` on a dictionary with value type containing
        // `sending`. Wrap the value type with a struct to avoid the crash.
        struct Entry {
            let item: (object: JSObject, body: (sending [JSValue]) -> JSValue)
        }
        private var storage: [JavaScriptHostFuncRef: Entry] = [:]
        init() {}

        subscript(_ key: JavaScriptHostFuncRef) -> (object: JSObject, body: (sending [JSValue]) -> JSValue)? {
            get { storage[key]?.item }
            set { storage[key] = newValue.map { Entry(item: $0) } }
        }
    }

    // Note: Retain the closure object itself also to avoid funcRef conflicts
    fileprivate static let sharedClosures = LazyThreadLocal(initialize: SharedJSClosure())

    private var hostFuncRef: JavaScriptHostFuncRef = 0

    #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
    private var isReleased: Bool = false
    #endif

    @available(
        *,
        deprecated,
        message:
            "This initializer will be removed in the next minor version update. Please use `init(_ body: @escaping ([JSValue]) -> JSValue)` and add `return .undefined` to the end of your closure"
    )
    @_disfavoredOverload
    public convenience init(_ body: @escaping ([JSValue]) -> Void) {
        self.init({
            body($0)
            return .undefined
        })
    }

    public init(file: String = #fileID, line: UInt32 = #line, _ body: @escaping (sending [JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)

        // 2. Create a new JavaScript function which calls the given Swift function.
        hostFuncRef = JavaScriptHostFuncRef(bitPattern: ObjectIdentifier(self))
        _id = withExtendedLifetime(JSString(file)) { file in
            swjs_create_function(hostFuncRef, line, file.asInternalJSRef())
        }

        // 3. Retain the given body in static storage by `funcRef`.
        // Self.sharedClosures.wrappedValue[hostFuncRef] = (self, body)
    }

    @available(*, unavailable, message: "JSClosure does not support dictionary literal initialization")
    public required init(dictionaryLiteral elements: (String, JSValue)...) {
        fatalError("JSClosure does not support dictionary literal initialization")
    }

    #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
    deinit {
        guard isReleased else {
            fatalError("release() must be called on JSClosure objects manually before they are deallocated")
        }
    }
    #endif
}

// MARK: - `JSClosure` mechanism note
//
// 1. Create a thunk in the JavaScript world, which has a reference
//    to a Swift closure.
// ┌─────────────────────┬──────────────────────────┐
// │     Swift side      │   JavaScript side        │
// │                     │                          │
// │                     │                          │
// │                     │   ┌──────[Thunk]───────┐ │
// │          ┌ ─ ─ ─ ─ ─│─ ─│─ ─ ─ ─ ─ ┐         │ │
// │          ↓          │   │          │         │ │
// │  [Swift Closure]    │   │  Host Function ID  │ │
// │                     │   │                    │ │
// │                     │   └────────────────────┘ │
// └─────────────────────┴──────────────────────────┘
//
// 2. When the thunk function is invoked, it calls the Swift closure via
//    `_call_host_function` and receives the result through a callback.
// ┌─────────────────────┬──────────────────────────┐
// │     Swift side      │   JavaScript side        │
// │                     │                          │
// │                     │                          │
// │                   Apply ┌──────[Thunk]───────┐ │
// │          ┌ ─ ─ ─ ─ ─│─ ─│─ ─ ─ ─ ─ ┐         │ │
// │          ↓          │   │          │         │ │
// │  [Swift Closure]    │   │  Host Function ID  │ │
// │          │          │   │                    │ │
// │          │          │   └────────────────────┘ │
// │          │          │                    ↑     │
// │          │        Apply                  │     │
// │          └─[Result]─┼───>[Callback func]─┘     │
// │                     │                          │
// └─────────────────────┴──────────────────────────┘

/// Returns true if the host function has been already released, otherwise false.
@_cdecl("_call_host_function_impl")
func _call_host_function_impl(
    _ hostFuncRef: JavaScriptHostFuncRef,
    _ argv: UnsafePointer<RawJSValue>,
    _ argc: Int32,
    _ callbackFuncRef: JavaScriptObjectRef
) -> Bool {
    return false
}

/// [WeakRefs](https://github.com/tc39/proposal-weakrefs) are already Stage 4,
/// but was added recently enough that older browser versions don’t support it.
/// Build with `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS` to disable the relevant behavior.
#if JAVASCRIPTKIT_WITHOUT_WEAKREFS

// MARK: - Legacy Closure Types

extension JSClosure {
    public func release() {
        isReleased = true
        Self.sharedClosures.wrappedValue[hostFuncRef] = nil
    }
}

@_cdecl("_free_host_function_impl")
func _free_host_function_impl(_ hostFuncRef: JavaScriptHostFuncRef) {}

#else

extension JSClosure {

    @available(*, deprecated, message: "JSClosure.release() is no longer necessary")
    public func release() {}

}

@_cdecl("_free_host_function_impl")
func _free_host_function_impl(_ hostFuncRef: JavaScriptHostFuncRef) {
}
#endif

#if compiler(>=6.0) && hasFeature(Embedded)
// cdecls currently don't work in embedded, and expose for wasm only works >=6.0
@_expose(wasm, "swjs_call_host_function")
public func _swjs_call_host_function(
    _ hostFuncRef: JavaScriptHostFuncRef,
    _ argv: UnsafePointer<RawJSValue>,
    _ argc: Int32,
    _ callbackFuncRef: JavaScriptObjectRef
) -> Bool {

    _call_host_function_impl(hostFuncRef, argv, argc, callbackFuncRef)
}

@_expose(wasm, "swjs_free_host_function")
public func _swjs_free_host_function(_ hostFuncRef: JavaScriptHostFuncRef) {
    _free_host_function_impl(hostFuncRef)
}
#endif
