import _CJavaScriptKit
#if hasFeature(Embedded) && os(WASI)
import _Concurrency
#endif

/// `JSClosureProtocol` wraps Swift closure objects for use in JavaScript. Conforming types
/// are responsible for managing the lifetime of the closure they wrap, but can delegate that
/// task to the user by requiring an explicit `release()` call.
public protocol JSClosureProtocol {
}

/// `JSOneshotClosure` is a JavaScript function that can be called only once. This class can be used
/// for optimized memory management when compared to the common `JSClosure`.
public class JSOneshotClosure: JSObject, JSClosureProtocol {
    private var hostFuncRef: JavaScriptHostFuncRef = 0

    public init(_ body: @escaping (sending [JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)
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
    public init(_ body: @escaping (sending [JSValue]) -> JSValue) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)
    }
}
