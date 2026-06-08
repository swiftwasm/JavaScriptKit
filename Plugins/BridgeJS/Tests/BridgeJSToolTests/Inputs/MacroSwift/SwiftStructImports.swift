@JS
struct Point {
    var x: Int
    var y: Int
}

@JSFunction func translate(_ point: Point, dx: Int, dy: Int) throws(JSException) -> Point

@JSFunction func roundTripOptional(_ point: Point?) throws(JSException) -> Point?
