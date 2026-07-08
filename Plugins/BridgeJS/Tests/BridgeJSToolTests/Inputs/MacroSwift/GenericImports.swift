@JS
struct GenericPoint {
    var x: Int
    var y: Int
}

@JS enum GenericColor {
    case red
    case green
}

@JS enum GenericMode: String {
    case light
    case dark
}

@JS enum GenericTagged {
    case number(value: Int)
    case text(value: String)
}

@JS final class GenericImportBox {
    @JS var value: Int
    @JS init(value: Int) {
        self.value = value
    }
    @JS func get() -> Int {
        value
    }
}

@JSFunction func genericRoundTrip<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T

@JSFunction func genericParse<T: _BridgedSwiftGenericBridgeable>(_ json: String) throws(JSException) -> T

@JSFunction func importGenericCombine<T: _BridgedSwiftGenericBridgeable, U: _BridgedSwiftGenericBridgeable>(
    _ a: T,
    _ b: U
) throws(JSException) -> U

@JSFunction func importGenericCaseDistinct<T: _BridgedSwiftGenericBridgeable, t: _BridgedSwiftGenericBridgeable>(
    _ a: T,
    _ b: t
) throws(JSException) -> T

@JSFunction func importGenericArray<T: _BridgedSwiftGenericBridgeable>(_ values: [T]) throws(JSException) -> [T]

@JSFunction func importGenericOptional<T: _BridgedSwiftGenericBridgeable>(_ value: T?) throws(JSException) -> T?

@JSFunction func importGenericDictionary<T: _BridgedSwiftGenericBridgeable>(
    _ values: [String: T]
) throws(JSException) -> [String: T]

@JSClass struct GenericConsumer {
    @JSFunction func accept<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException)
    @JSFunction func identity<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
    @JSFunction static func box<T: _BridgedSwiftGenericBridgeable>(_ value: T) throws(JSException) -> T
}
