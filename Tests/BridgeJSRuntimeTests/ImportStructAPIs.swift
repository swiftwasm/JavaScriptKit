import JavaScriptKit

@JS
struct Point {
    var x: Int
    var y: Int
}

@JSFunction func jsTranslatePoint(_ point: Point, dx: Int, dy: Int) throws(JSException) -> Point

@JSFunction func jsRoundTripOptionalPoint(_ point: Point?) throws(JSException) -> Point?
