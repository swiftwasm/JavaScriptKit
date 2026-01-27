@_spi(Experimental) import JavaScriptKit

@JS
struct Point {
    var x: Int
    var y: Int
}

@JSFunction func jsTranslatePoint(_ point: Point, dx: Int, dy: Int) throws(JSException) -> Point

// Lifetime tests (require Node.js `--expose-gc` in the test runner)
@JSFunction func jsObservePointLifetime(_ point: Point, _ token: Int) throws(JSException)
@JSFunction func jsStorePointStrong(_ point: Point, _ token: Int) throws(JSException) -> Int
@JSFunction func jsReleaseStoredPoint(_ handle: Int) throws(JSException)
@JSFunction func jsIsPointFinalized(_ token: Int) throws(JSException) -> Bool
@JSFunction func jsIsPointWeakAlive(_ token: Int) throws(JSException) -> Bool
@JSFunction func jsMakePoint(_ token: Int, x: Int, y: Int) throws(JSException) -> Point
