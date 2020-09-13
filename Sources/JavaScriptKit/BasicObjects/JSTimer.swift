/** This timer type hides `setInterval`/`clearInterval` and `setTimeout`/`clearTimeout`
pairs of calls for you, and also holds a reference to an underlying `JSClosure` instance.
To invalidate a timer you should deallocate your corresponding `JSTimer` instance.
*/
public final class JSTimer {
  private let closure: JSClosure
  private let isRepeating: Bool
  private let value: JSValue
  private let global = JSObject.global

  public init(millisecondsDelay: Double, isRepeating: Bool, callback: @escaping () -> ()) {
    closure = JSClosure { _ in callback() }
    self.isRepeating = isRepeating
    if isRepeating {
      value = global.setInterval.function!(closure, millisecondsDelay)
    } else {
      value = global.setTimeout.function!(closure, millisecondsDelay)
    }
  }

  deinit {
    if isRepeating {
      global.clearInterval.function!(value)
    } else {
      global.clearTimeout.function!(value)
    }
    closure.release()
  }
}
