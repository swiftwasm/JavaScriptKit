import _CJavaScriptKit

/// `JSClosureProtocol` wraps Swift closure objects for use in JavaScript. Conforming types
/// are responsible for managing the lifetime of the closure they wrap, but can delegate that
/// task to the user by requiring an explicit `release()` call.
public protocol JSClosureProtocol: JSValueCompatible {

    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    func release()
}

/// `JSOneshotClosure` is a JavaScript function that can be called only once. This class can be used
/// for optimized memory management when compared to the common `JSClosure`.
public class JSOneshotClosure: JSObject, JSClosureProtocol {
    private var hostFuncRef: JavaScriptHostFuncRef = 0

    public init(_ body: @escaping ([JSValue]) -> JSValue, file: String = #fileID, line: UInt32 = #line) {
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)

        // 2. Retain the given body in static storage
        hostFuncRef = JSClosure.sharedClosures.register(ObjectIdentifier(self), object: self, body: {
            defer { self.release() }
            return body($0)
        })
        id = withExtendedLifetime(JSString(file)) { file in
          _create_function(hostFuncRef, line, file.asInternalJSRef())
        }
    }

    #if compiler(>=5.5)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public static func async(_ body: @escaping ([JSValue]) async throws -> JSValue) -> JSOneshotClosure {
        JSOneshotClosure(makeAsyncClosure(body))
    }
    #endif

    /// Release this function resource.
    /// After calling `release`, calling this function from JavaScript will fail.
    public func release() {
        JSClosure.sharedClosures.unregister(hostFuncRef)
    }
}

/// `JSClosure` represents a JavaScript function the body of which is written in Swift.
/// This type can be passed as a callback handler to JavaScript functions.
///
/// e.g.
/// ```swift
/// let eventListenter = JSClosure { _ in
///     ...
///     return JSValue.undefined
/// }
///
/// button.addEventListener!("click", JSValue.function(eventListenter))
/// ...
/// button.removeEventListener!("click", JSValue.function(eventListenter))
/// ```
///
public class JSClosure: JSFunction, JSClosureProtocol {
    fileprivate static var sharedClosures = SharedJSClosureRegistry()

    private var hostFuncRef: JavaScriptHostFuncRef = 0

    #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
    private let file: String
    private let line: UInt32
    private var isReleased: Bool = false
    #endif

    @available(*, deprecated, message: "This initializer will be removed in the next minor version update. Please use `init(_ body: @escaping ([JSValue]) -> JSValue)` and add `return .undefined` to the end of your closure")
    @_disfavoredOverload
    public convenience init(_ body: @escaping ([JSValue]) -> ()) {
        self.init({
            body($0)
            return .undefined
        })
    }

    public init(_ body: @escaping ([JSValue]) -> JSValue, file: String = #fileID, line: UInt32 = #line) {
        #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
        self.file = file
        self.line = line
        #endif
        // 1. Fill `id` as zero at first to access `self` to get `ObjectIdentifier`.
        super.init(id: 0)

        // 2. Retain the given body in static storage
        let objectHolder = SharedJSClosureRegistry.WeakBox(underlying: self)
        hostFuncRef = Self.sharedClosures.register(
            ObjectIdentifier(self), object: objectHolder, body: body
        )

        id = withExtendedLifetime(JSString(file)) { file in
          _create_function(hostFuncRef, line, file.asInternalJSRef())
        }

    }

    #if compiler(>=5.5)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public static func async(_ body: @escaping ([JSValue]) async throws -> JSValue, file: String = #fileID, line: UInt32 = #line) -> JSClosure {
        JSClosure(makeAsyncClosure(body), file: file, line: line)
    }
    #endif

    #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
    deinit {
        guard isReleased else {
            fatalError("release() must be called on JSClosure object (\(file):\(line)) manually before they are deallocated")
        }
    }
    #endif
}

#if compiler(>=5.5)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
private func makeAsyncClosure(_ body: @escaping ([JSValue]) async throws -> JSValue) -> (([JSValue]) -> JSValue) {
    { arguments in
        JSPromise { resolver in
            Task {
                do {
                    let result = try await body(arguments)
                    resolver(.success(result))
                } catch {
                    if let jsError = error as? JSError {
                        resolver(.failure(jsError.jsValue))
                    } else {
                        resolver(.failure(JSError(message: String(describing: error)).jsValue))
                    }
                }
            }
        }.jsValue()
    }
}
#endif

/// Registry for Swift closures that are referenced from JavaScript.
private struct SharedJSClosureRegistry {
    class ClosureEntry {
        // Note: Retain the closure object itself also to avoid funcRef conflicts.
        var object: AnyObject
        var body: ([JSValue]) -> JSValue

        init(object: AnyObject, body: @escaping ([JSValue]) -> JSValue) {
            self.object = object
            self.body = body
        }
    }
    class WeakBox {
        weak var underlying: AnyObject?
        init(underlying: AnyObject) {
            self.underlying = underlying
        }
    }
    private var closures: [JavaScriptHostFuncRef: ClosureEntry] = [:]

    /// Register a Swift closure to be called from JavaScript.
    /// - Parameters:
    ///   - hint: A hint to identify the closure.
    ///   - object: The object should be retained until the closure is released from JavaScript.
    ///   - body: The closure to be called from JavaScript.
    /// - Returns: An unique identifier for the registered closure.
    mutating func register(
        _ hint: ObjectIdentifier,
        object: AnyObject, body: @escaping ([JSValue]) -> JSValue
    ) -> JavaScriptHostFuncRef {
        let ref = JavaScriptHostFuncRef(bitPattern: hint)
        closures[ref] = ClosureEntry(object: object, body: body)
        return ref
    }

    /// Unregister a Swift closure from the registry.
    mutating func unregister(_ ref: JavaScriptHostFuncRef) {
        closures[ref] = nil
    }

    /// Get the Swift closure from the registry.
    subscript(_ ref: JavaScriptHostFuncRef) -> (([JSValue]) -> JSValue)? {
        closures[ref]?.body
    }
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
    _ argv: UnsafePointer<RawJSValue>, _ argc: Int32,
    _ callbackFuncRef: JavaScriptObjectRef
) -> Bool {
    guard let hostFunc = JSClosure.sharedClosures[hostFuncRef] else {
        return true
    }
    let arguments = UnsafeBufferPointer(start: argv, count: Int(argc)).map(\.jsValue)
    let result = hostFunc(arguments)
    let callbackFuncRef = JSFunction(id: callbackFuncRef)
    _ = callbackFuncRef(result)
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
        Self.sharedClosures.unregister(hostFuncRef)
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
    JSClosure.sharedClosures.unregister(hostFuncRef)
}
#endif
