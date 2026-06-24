@JS(as: PolygonReference.self) struct Polygon {
    var vertices: [Double]

    consuming func bridgeToJS() -> PolygonReference {
        return PolygonReference(underlying: self)
    }

    static func bridgeFromJS(_ value: consuming PolygonReference) -> Polygon {
        return value.underlying
    }
}

@JS final class PolygonReference {
    var underlying: Polygon

    @JS init(underlying: Polygon) {
        self.underlying = underlying
    }

    @JS func snapshot() -> Polygon
    @JS func merge(_ other: Polygon) -> Polygon
    @JS static func origin() -> Polygon
}

@JS(as: TagReference.self) struct Tag {
    var name: String

    consuming func bridgeToJS() -> TagReference {
        return TagReference(underlying: self)
    }

    static func bridgeFromJS(_ value: consuming TagReference) -> Tag {
        return value.underlying
    }
}

@JS final class TagReference {
    var underlying: Tag

    @JS init(underlying: Tag) {
        self.underlying = underlying
    }
}

@JS func roundtripPolygon(_ polygon: Polygon) -> Polygon

@JS func optionalPolygon(_ polygon: Polygon?) -> Polygon?

@JS func polygonArray(_ polygons: [Polygon]) -> [Polygon]

@JS func validatePolygon(_ polygon: Polygon) throws(JSException) -> Polygon

@JS func makeTag(_ name: String) -> Tag

@JS(as: String.self) struct Tagged {
    var raw: String

    consuming func bridgeToJS() -> String {
        return raw
    }

    static func bridgeFromJS(_ value: consuming String) -> Tagged {
        return Tagged(raw: value)
    }
}

@JSFunction func acceptTagged(_ tagged: Tagged) throws(JSException) -> Void
@JSFunction func acceptOptionalTagged(_ tagged: Tagged?) throws(JSException) -> Void
@JSFunction func roundtripTagged(_ tagged: Tagged) throws(JSException) -> Tagged

@JSClass class Surface {
    @JSFunction init() throws(JSException)
    @JSGetter var label: String
}

@JS(as: Surface.self) struct Canvas {
    consuming func bridgeToJS() -> Surface {
        fatalError("test stub")
    }

    static func bridgeFromJS(_ value: consuming Surface) -> Canvas {
        return Canvas()
    }
}

@JSFunction func produceOptionalCanvas() throws(JSException) -> Canvas?

@JS enum InnerTag {
    case payload(Int)
    case empty
}

@JS(as: InnerTag.self) struct AliasedTag {
    consuming func bridgeToJS() -> InnerTag {
        return .empty
    }

    static func bridgeFromJS(_ value: consuming InnerTag) -> AliasedTag {
        return AliasedTag()
    }
}

@JS func roundtripTags(_ xs: [AliasedTag?]) -> [AliasedTag?]

@JS(as: Int.self) struct UserId {
    var rawValue: Int

    consuming func bridgeToJS() -> Int {
        return rawValue
    }

    static func bridgeFromJS(_ value: consuming Int) -> UserId {
        return UserId(rawValue: value)
    }
}

@JS protocol HasOptionalUserId {
    var userId: UserId? { get }
}

@JS func describeUser(_ owner: HasOptionalUserId) -> HasOptionalUserId
