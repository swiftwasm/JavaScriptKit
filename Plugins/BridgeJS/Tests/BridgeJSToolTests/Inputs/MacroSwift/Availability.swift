@available(macOS 14.0, *)
@JS struct Point {
    var x: Int
}

@available(macOS 14.0, iOS 17.0, *)
@JS enum Direction {
    case north
    case south
}

@available(macOS 15.0, *)
@JS enum Level: String {
    case low
    case high
}

@available(macOS 14.0, *)
@JS enum Shape {
    case circle(Double)
    case square(Int)
}

@available(macOS 14.0, *)
@JS final class Counter {
    @JS init() {}
}

@available(macOS 14.0, *)
@JS protocol Source {
    func value() -> Int
}

@JS protocol PointSource {
    @available(macOS 14.0, *)
    func point() -> Point
    @available(macOS 14.0, *)
    var origin: Point { get }
}

@available(macOS 14.0, *)
@JSClass struct Element {
    @JSFunction func id() throws(JSException) -> Int
}

@JSClass struct Canvas {
    @available(macOS 14.0, *)
    @JSFunction func element() throws(JSException) -> Element
}

@available(macOS 15.0, *)
@JS func mix(_ point: Point, _ body: (Point, Level) -> Direction) -> Int

@available(macOS 14.0, *)
@JS func loadPoint() async -> Point

@available(macOS 14.0, *)
@JS enum Geometry {
    @JS struct Box {
        var side: Int
    }
}

@JS class Library {
    @JS init() {}
}

@available(macOS 14.0, *)
extension Library {
    @JS struct Shelf {
        var label: String
    }
}

@available(macOS 14.0, *)
@JS(as: TagReference.self) struct Tag {
    var name: String
}

@available(macOS 14.0, *)
@JS final class TagReference {
    @JS init(name: String) {}
}

@JSClass struct NoncopyableObject: ~Copyable {
    @JSFunction func id() throws(JSException) -> Int
}

@available(macOS 27.0, *)
@JS func countObjects(_ body: (borrowing UniqueArray<NoncopyableObject>, Point) -> Int) -> Int
