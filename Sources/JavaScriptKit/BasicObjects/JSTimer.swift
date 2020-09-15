/** This timer type hides `setInterval`/`clearInterval` and `setTimeout`/`clearTimeout`
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
