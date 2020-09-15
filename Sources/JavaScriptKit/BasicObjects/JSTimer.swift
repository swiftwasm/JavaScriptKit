/** This timer type hides [`setInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval)
/ [`clearInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearInterval) and 
[`setTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout)
/ [`clearTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout)
pairs of calls for you, and also holds a reference to an underlying `JSClosure` instance.
To invalidate a timer you should deallocate your corresponding `JSTimer` instance.
*/
public final class JSTimer {
  /// Indicates whether this timer instance calls its callback repeatedly at a given delay.
  public let isRepeating: Bool

  private let closure: JSClosure

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
    closure = JSClosure { _ in callback() }
    self.isRepeating = isRepeating
    if isRepeating {
      value = global.setInterval.function!(closure, millisecondsDelay)
    } else {
      value = global.setTimeout.function!(closure, millisecondsDelay)
    }
  }

  /** Makes a corresponding `clearTimeout` or `clearInterval` call, depending on whether this timer
  instance is repeating. The `closure` instance is released manually here, as it is required for
  bridged closure instances.
  */
  deinit {
    if isRepeating {
      global.clearInterval.function!(value)
    } else {
      global.clearTimeout.function!(value)
    }
    closure.release()
  }
}
