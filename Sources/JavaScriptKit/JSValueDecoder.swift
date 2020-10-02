private struct _Decoder: Decoder {
    fileprivate let node: JSValue

    init(referencing node: JSValue, userInfo: [CodingUserInfoKey: Any], codingPath: [CodingKey] = []) {
        self.node = node
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        guard let ref = node.object else { throw _typeMismatch(at: codingPath, JSObject.self, reality: node) }
        return KeyedDecodingContainer(_KeyedDecodingContainer(decoder: self, ref: ref))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let ref = node.object else { throw _typeMismatch(at: codingPath, JSObject.self, reality: node) }
        return _UnkeyedDecodingContainer(decoder: self, ref: ref)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        self
    }

    func decoder(referencing node: JSValue, with key: CodingKey) -> _Decoder {
        _Decoder(referencing: node, userInfo: userInfo, codingPath: codingPath + [key])
    }

    func superDecoder(referencing node: JSValue) -> _Decoder {
        _Decoder(referencing: node, userInfo: userInfo, codingPath: codingPath.dropLast())
    }
}

private enum Object {
    static let ref = JSObject.global.Object.object!
    static func keys(_ object: JSObject) -> [String] {
        let keys = ref.keys!(object).array!
        return keys.map { $0.string! }
    }
}

private func _keyNotFound(at codingPath: [CodingKey], _ key: CodingKey) -> DecodingError {
    let description = "No value associated with key \(key) (\"\(key.stringValue)\")."
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
    return .keyNotFound(key, context)
}

private func _typeMismatch(at codingPath: [CodingKey], _ type: Any.Type, reality: Any) -> DecodingError {
    let description = "Expected to decode \(type) but found \(reality) instead."
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
    return .typeMismatch(type, context)
}

struct _JSCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    init?(intValue: Int) {
        stringValue = "\(intValue)"
        self.intValue = intValue
    }

    init(index: Int) {
        stringValue = "Index \(index)"
        intValue = index
    }

    static let `super` = _JSCodingKey(stringValue: "super")!
}

private struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    private let decoder: _Decoder
    private let ref: JSObject

    var codingPath: [CodingKey] { return decoder.codingPath }
    var allKeys: [Key] {
        Object.keys(ref).compactMap(Key.init(stringValue:))
    }

    init(decoder: _Decoder, ref: JSObject) {
        self.decoder = decoder
        self.ref = ref
    }

    func _decode(forKey key: CodingKey) throws -> JSValue {
        let result = ref[key.stringValue]
        guard !result.isUndefined else {
            throw _keyNotFound(at: codingPath, key)
        }
        return result
    }

    func _throwTypeMismatchIfNil<T>(forKey key: CodingKey, _ transform: (JSValue) -> T?) throws -> T {
        let jsValue = try _decode(forKey: key)
        guard let value = transform(jsValue) else {
            throw _typeMismatch(at: codingPath, T.self, reality: jsValue)
        }
        return value
    }

    func contains(_ key: Key) -> Bool {
        !ref[key.stringValue].isUndefined
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        try _decode(forKey: key).isNull
    }

    func decode<T>(_: T.Type, forKey key: Key) throws -> T where T: ConstructibleFromJSValue & Decodable {
        return try _throwTypeMismatchIfNil(forKey: key) { T.construct(from: $0) }
    }

    func decode<T>(_: T.Type, forKey key: Key) throws -> T where T: Decodable {
        return try T(from: _decoder(forKey: key))
    }

    func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        try _decoder(forKey: key).container(keyedBy: NestedKey.self)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        try _decoder(forKey: key).unkeyedContainer()
    }

    func superDecoder() throws -> Decoder {
        try _decoder(forKey: _JSCodingKey.super)
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        try _decoder(forKey: key)
    }

    func _decoder(forKey key: CodingKey) throws -> Decoder {
        let value = try _decode(forKey: key)
        return decoder.decoder(referencing: value, with: key)
    }
}

private struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey] { decoder.codingPath }
    let count: Int?
    var isAtEnd: Bool { currentIndex >= count ?? 0 }
    var currentIndex: Int = 0

    private var currentKey: CodingKey { return _JSCodingKey(index: currentIndex) }

    let decoder: _Decoder
    let ref: JSObject

    init(decoder: _Decoder, ref: JSObject) {
        self.decoder = decoder
        count = ref.length.number.map(Int.init)
        self.ref = ref
    }

    mutating func _currentValue() -> JSValue {
        defer { currentIndex += 1 }
        return ref[currentIndex]
    }

    mutating func _throwTypeMismatchIfNil<T>(_ transform: (JSValue) -> T?) throws -> T {
        let value = _currentValue()
        guard let jsValue = transform(value) else {
            throw _typeMismatch(at: codingPath, T.self, reality: value)
        }
        return jsValue
    }

    mutating func decodeNil() throws -> Bool {
        return _currentValue().isNull
    }

    mutating func decode<T>(_: T.Type) throws -> T where T: ConstructibleFromJSValue & Decodable {
        try _throwTypeMismatchIfNil { T.construct(from: $0) }
    }

    mutating func decode<T>(_: T.Type) throws -> T where T: Decodable {
        return try T(from: _decoder())
    }

    mutating func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        return try _decoder().container(keyedBy: NestedKey.self)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try _decoder().unkeyedContainer()
    }

    mutating func superDecoder() throws -> Decoder {
        _decoder()
    }

    mutating func _decoder() -> Decoder {
        decoder.decoder(referencing: _currentValue(), with: currentKey)
    }
}

extension _Decoder: SingleValueDecodingContainer {
    func _throwTypeMismatchIfNil<T>(_ transform: (JSValue) -> T?) throws -> T {
        guard let jsValue = transform(node) else {
            throw _typeMismatch(at: codingPath, T.self, reality: node)
        }
        return jsValue
    }

    func decodeNil() -> Bool {
        node.isNull
    }

    func decode<T>(_: T.Type) throws -> T where T: ConstructibleFromJSValue & Decodable {
        try _throwTypeMismatchIfNil { T.construct(from: $0) }
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let primitive = { (node: JSValue) -> T? in
            guard let constructibleType = type as? ConstructibleFromJSValue.Type else {
                return nil
            }
            return constructibleType.construct(from: node) as? T
        }
        return try primitive(node) ?? type.init(from: self)
    }
}

/// `JSValueDecoder` facilitates the decoding of JavaScript value into semantic `Decodable` types.
public class JSValueDecoder {

    /// Initializes a new `JSValueDecoder`.
    public init() {}

    /// Decodes a top-level value of the given type from the given JavaScript value representation.
    ///
    /// - Parameter T: The type of the value to decode.
    /// - Parameter value: The `JSValue` to decode from.
    public func decode<T>(
        _: T.Type = T.self,
        from value: JSValue,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) throws -> T where T: Decodable {
        let decoder = _Decoder(referencing: value, userInfo: userInfo)
        return try T(from: decoder)
    }
}
