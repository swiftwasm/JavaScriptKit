@JS(as: PolygonReference.self) struct Polygon {
    var sides: Int

    consuming func bridgeToJS() -> PolygonReference {
        return PolygonReference(sides: sides)
    }

    static func bridgeFromJS(_ value: consuming PolygonReference) -> Polygon {
        return Polygon(sides: value.sides)
    }
}

@JS final class PolygonReference {
    var sides: Int

    @JS init(sides: Int) {
        self.sides = sides
    }
}

@JS func makePolygonFactory() -> () -> Polygon
@JS func makePolygonInspector() -> (Polygon) -> Int
