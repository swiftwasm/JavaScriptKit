/** This timer is an abstraction over [`setInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval)
/ [`clearInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearInterval) and
[`setTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout)
/ [`clearTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout)
JavaScript functions. It intentionally doesn't match the JavaScript API, as a special care is
needed to hold a reference to the timer closure and to call `JSClosure.release()` on it when the
timer is deallocated. As a user, you have to hold a reference to a `JSTimer` instance for it to stay
valid. The `JSTimer` API is also intentionally trivial, the timer is started right away, and the
only way to invalidate the timer is to bring the reference count of the `JSTimer` instance to zero.
For invalidation you should either store the timer in an optional property and assign `nil` to it,
or deallocate the object that owns the timer.
*/
public final class JSTimer {
    /// Indicates whether this timer instance calls its callback repeatedly at a given delay.
    public let isRepeating: Bool

    #if hasFeature(Embedded)
    private let closure: JSClosure?
    private let oneShotClosure: JSOneshotClosure?
    #else
    private let closure: JSClosureProtocol
    #endif

    /** Node.js and browser APIs are slightly different. `setTimeout`/`setInterval` return an object
     in Node.js, while browsers return a number. Fortunately, clearTimeout and clearInterval take
     corresponding types as their arguments, and we can store either as JSValue, so we can treat both
     cases uniformly.
     */
    private let value: JSValue
    private let global = JSObject.global

    /**
     Creates a new timer instance that calls `setInterval` or `setTimeout` JavaScript functions for you
     under the hood.
     - Parameters:
     - millisecondsDelay: the amount of milliseconds before the `callback` closure is executed.
     - isRepeating: when `true` the `callback` closure is executed repeatedly at given
     `millisecondsDelay` intervals indefinitely until the timer is deallocated.
     - callback: the closure to be executed after a given `millisecondsDelay` interval.
     */
    public init(millisecondsDelay: Double, isRepeating: Bool = false, callback: @escaping () -> ()) {
        if isRepeating {
            let closure: JSClosure = JSClosure { _ in
                callback()
                return .undefined
            }
            #if hasFeature(Embedded)
            self.closure = closure
            self.oneShotClosure = nil
            self.value = JSObject.global.setInterval.function!(closure.jsValue, millisecondsDelay.jsValue)
            #else
            self.closure = closure
            self.value = global.setInterval.function!(closure, millisecondsDelay)
            #endif
        } else {
            let oneShotClosure: JSOneshotClosure = JSOneshotClosure { _ in
                callback()
                return .undefined
            }
            #if hasFeature(Embedded)
            self.closure = nil
            self.oneShotClosure = oneShotClosure
            self.value = JSObject.global.setTimeout.function!(oneShotClosure.jsValue, millisecondsDelay.jsValue)
            #else
            self.closure = oneShotClosure
            self.value = global.setTimeout.function!(oneShotClosure, millisecondsDelay)
            #endif
        }
        self.isRepeating = isRepeating
    }

    /** Makes a corresponding `clearTimeout` or `clearInterval` call, depending on whether this timer
     instance is repeating. The `closure` instance is released manually here, as it is required for
     bridged closure instances.
     */
    deinit {
        if isRepeating {
            global.clearInterval.function!(value)
            #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
            closure?.release()
           #endif
        } else {
            global.clearTimeout.function!(value)
            #if hasFeature(Embedded)
            oneShotClosure?.release()
            #else
            closure.release()
            #endif
        }
    }
}
