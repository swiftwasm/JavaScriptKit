import JavaScriptKit

@JS(as: PolygonReference.self) struct Polygon {
    var vertices: [Double]
    var label: String

    consuming func bridgeToJS() -> PolygonReference {
        return PolygonReference(underlying: self)
    }

    static func bridgeFromJS(_ value: consuming PolygonReference) -> Polygon {
        return value.underlying
    }
}

@JS final class PolygonReference {
    var underlying: Polygon

    @JS init(verticesData: [Double], label: String) {
        self.underlying = Polygon(vertices: verticesData, label: label)
    }

    init(underlying: Polygon) {
        self.underlying = underlying
    }

    @JS func vertexCount() -> Int {
        return underlying.vertices.count
    }

    @JS func summary() -> String {
        return "\(underlying.label)(\(underlying.vertices.count))"
    }

    @JS func snapshot() -> Polygon {
        return underlying
    }

    @JS func merge(_ other: Polygon) -> Polygon {
        var combined = underlying
        combined.vertices.append(contentsOf: other.vertices)
        return combined
    }

    @JS static func origin(label: String) -> Polygon {
        return Polygon(vertices: [], label: label)
    }
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

    init(underlying: Tag) {
        self.underlying = underlying
    }

    @JS func describe() -> String {
        return "tag:\(underlying.name)"
    }
}

@JS func makeTag(_ name: String) -> Tag {
    return Tag(name: name)
}

@JS func roundTripPolygon(_ polygon: Polygon) -> Polygon {
    return polygon
}

@JS func appendVertex(_ polygon: Polygon, _ value: Double) -> Polygon {
    var copy = polygon
    copy.vertices.append(value)
    return copy
}

@JS func optionalRoundTripPolygon(_ polygon: Polygon?) -> Polygon? {
    return polygon
}

@JS func polygonVertexCount(_ polygon: Polygon) -> Int {
    return polygon.vertices.count
}

@JS func roundTripPolygonArray(_ polygons: [Polygon]) -> [Polygon] {
    return polygons
}

@JS func concatPolygons(_ polygons: [Polygon]) -> Polygon {
    var combined = Polygon(vertices: [], label: "concat")
    for p in polygons {
        combined.vertices.append(contentsOf: p.vertices)
    }
    return combined
}

@JS func validatePolygon(_ polygon: Polygon) throws(JSException) -> Polygon {
    if polygon.vertices.isEmpty {
        throw JSException(JSError(message: "empty polygon").jsValue)
    }
    return polygon
}

@JS func splitPolygon(_ polygon: Polygon) -> [Polygon] {
    return polygon.vertices.map { Polygon(vertices: [$0], label: polygon.label) }
}

@JS(as: TokenReference.self) struct Token: ~Copyable {
    let value: Int

    consuming func bridgeToJS() -> TokenReference {
        return TokenReference(value: value)
    }

    static func bridgeFromJS(_ value: consuming TokenReference) -> Token {
        return Token(value: value.value)
    }
}

@JS final class TokenReference {
    let value: Int

    @JS init(value: Int) {
        self.value = value
    }

    @JS func read() -> Int {
        return value
    }
}

@JS func incrementToken(_ token: borrowing Token) -> Token {
    return Token(value: token.value + 1)
}

@JS func makeToken(_ value: Int) -> Token {
    return Token(value: value)
}

@JS func makePolygonInspector() -> (Polygon) -> Int {
    return { polygon in polygon.vertices.count }
}

@JS func asyncMakePolygon(_ label: String) async -> Polygon {
    return Polygon(vertices: [9, 9], label: label)
}

@JS func roundTripOptionalPolygonArray(_ polygons: [Polygon?]) -> [Polygon?] {
    return polygons
}

@JS(as: TagHolderReference.self) struct TagHolder {
    var tag: Tag
    var version: Int

    consuming func bridgeToJS() -> TagHolderReference {
        return TagHolderReference(tag: tag, version: version)
    }

    static func bridgeFromJS(_ value: consuming TagHolderReference) -> TagHolder {
        return TagHolder(tag: value.tag, version: value.version)
    }
}

@JS final class TagHolderReference {
    @JS var tag: Tag
    @JS var version: Int

    @JS init(tag: Tag, version: Int) {
        self.tag = tag
        self.version = version
    }

    @JS func describe() -> String {
        return "holder(\(tag.name), v\(version))"
    }
}

@JS func makeTagHolder(_ name: String, _ version: Int) -> TagHolder {
    return TagHolder(tag: Tag(name: name), version: version)
}

@JS(as: JSCoordinate.self) struct Coordinate {
    var latitude: Double
    var longitude: Double

    var hemisphere: String {
        latitude >= 0 ? "northern" : "southern"
    }

    consuming func bridgeToJS() -> JSCoordinate {
        return JSCoordinate(latitude: latitude, longitude: longitude)
    }

    static func bridgeFromJS(_ value: consuming JSCoordinate) -> Coordinate {
        return Coordinate(latitude: value.latitude, longitude: value.longitude)
    }
}

@JS struct JSCoordinate {
    var latitude: Double
    var longitude: Double

    @JS init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

@JS func roundTripCoordinate(_ coordinate: Coordinate) -> Coordinate {
    return coordinate
}

@JS(as: PriorityReference.self) enum Priority {
    case low, medium, high

    consuming func bridgeToJS() -> PriorityReference {
        return PriorityReference(underlying: self)
    }

    static func bridgeFromJS(_ value: consuming PriorityReference) -> Priority {
        return value.underlying
    }
}

@JS final class PriorityReference {
    let underlying: Priority

    init(underlying: Priority) {
        self.underlying = underlying
    }

    @JS func describe() -> String {
        switch underlying {
        case .low: return "low"
        case .medium: return "medium"
        case .high: return "high"
        }
    }

    @JS func weight() -> Int {
        switch underlying {
        case .low: return 1
        case .medium: return 5
        case .high: return 10
        }
    }

    @JS static func low() -> Priority { return .low }
    @JS static func medium() -> Priority { return .medium }
    @JS static func high() -> Priority { return .high }
}

@JS func roundTripPriority(_ priority: Priority) -> Priority {
    return priority
}

@JS(as: Severity.self) struct Alert {
    let level: Severity

    var requiresImmediateAction: Bool {
        level == .error
    }

    consuming func bridgeToJS() -> Severity {
        return level
    }

    static func bridgeFromJS(_ value: consuming Severity) -> Alert {
        return Alert(level: value)
    }
}

@JS enum Severity {
    case notice, warning, error
}

@JS func roundTripAlert(_ alert: Alert) -> Alert {
    return alert
}

@JS func makeAlert(_ level: Severity) -> Alert {
    return Alert(level: level)
}

@JS(as: SessionState.self) class Session {
    var token: String

    init(token: String) {
        self.token = token
    }

    consuming func bridgeToJS() -> SessionState {
        return SessionState(token: token)
    }

    static func bridgeFromJS(_ value: consuming SessionState) -> Session {
        return Session(token: value.token)
    }
}

@JS struct SessionState {
    var token: String

    @JS init(token: String) {
        self.token = token
    }
}

@JS func roundTripSession(_ session: Session) -> Session {
    return session
}

@JS func makeSession(_ token: String) -> Session {
    return Session(token: token)
}

@JS enum Shape {
    case polygon(Polygon)
    case empty
}

@JS func roundTripShape(_ s: Shape) -> Shape {
    return s
}

@JS func makeShapePolygon(_ polygon: Polygon) -> Shape {
    return .polygon(polygon)
}

@JS func makeShapeEmpty() -> Shape {
    return .empty
}

// MARK: - Imports

@JS(as: String.self) struct Tagged {
    var raw: String

    consuming func bridgeToJS() -> String {
        return raw
    }

    static func bridgeFromJS(_ value: consuming String) -> Tagged {
        return Tagged(raw: value)
    }
}

@JSClass struct Surface {
    @JSFunction init(_ label: String) throws(JSException)
    @JSGetter var label: String
}

@JS(as: Surface.self) struct Canvas {
    var label: String

    consuming func bridgeToJS() -> Surface {
        return try! Surface(label)
    }

    static func bridgeFromJS(_ value: consuming Surface) -> Canvas {
        return Canvas(label: (try? value.label) ?? "")
    }
}

@JS enum InnerTag {
    case payload(Int)
    case empty
}

@JS(as: InnerTag.self) struct AliasedTag {
    var underlying: InnerTag

    consuming func bridgeToJS() -> InnerTag {
        return underlying
    }

    static func bridgeFromJS(_ value: consuming InnerTag) -> AliasedTag {
        return AliasedTag(underlying: value)
    }
}

@JSClass struct AliasImports {
    @JSFunction static func jsRoundTripTagged(_ value: Tagged) throws(JSException) -> Tagged
    @JSFunction static func jsRoundTripOptionalTagged(_ value: Tagged?) throws(JSException) -> Tagged?
    @JSFunction static func jsProduceOptionalCanvas(_ label: String?) throws(JSException) -> Canvas?
    @JSFunction static func jsRoundTripAliasedTags(_ values: [AliasedTag?]) throws(JSException) -> [AliasedTag?]
    @JSFunction static func jsRoundTripPolygon(_ value: Polygon) throws(JSException) -> Polygon
    @JSFunction static func jsRoundTripCoordinate(_ value: Coordinate) throws(JSException) -> Coordinate
}
