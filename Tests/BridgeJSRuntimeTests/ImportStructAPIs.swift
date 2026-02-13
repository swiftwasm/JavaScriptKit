import JavaScriptKit

@JS
struct Point {
    var x: Int
    var y: Int
}

@JSFunction func jsTranslatePoint(_ point: Point, dx: Int, dy: Int) throws(JSException) -> Point
