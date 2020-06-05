//
//  JSEncoder.swift
//  
//
//  Created by Alsey Coleman Miller on 6/4/20.
//

import SwiftFoundation

/// JavaScript Encoder
public struct JSEncoder {
    
    // MARK: - Properties
    
    /// Any contextual information set by the user for encoding.
    public var userInfo = [CodingUserInfoKey : Any]()
    
    /// Logging handler
    public var log: ((String) -> ())?
    
    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Methods
    
    public func encode<T: Encodable>(_ value: T) throws -> JSValue {
        
        log?("Will encode \(T.self)")
        
        let encoder = Encoder(
            userInfo: userInfo,
            log: log
        )
        
        try value.encode(to: encoder)
        assert(encoder.stack.containers.count == 1)
        return encoder.stack.root.jsValue
    }
}

// MARK: - Encoder

internal extension JSEncoder {
    
    final class Encoder: Swift.Encoder {
        
        // MARK: - Properties
        
        /// The path of coding keys taken to get to this point in encoding.
        fileprivate(set) var codingPath: [CodingKey]
        
        /// Any contextual information set by the user for encoding.
        let userInfo: [CodingUserInfoKey : Any]
        
        /// Logger
        let log: ((String) -> ())?
        
        private(set) var stack: Stack
        
        // MARK: - Initialization
        
        fileprivate init(codingPath: [CodingKey] = [],
                         userInfo: [CodingUserInfoKey : Any],
                         log: ((String) -> ())?) {
            
            self.stack = Stack()
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.log = log
        }
        
        // MARK: - Encoder
        
        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
            
            log?("Requested container keyed by \(type.sanitizedName) for path \"\(codingPath.path)\"")
            let object = JSObject()
            self.stack.push(object)
            let keyedContainer = JSKeyedEncodingContainer<Key>(referencing: self, wrapping: object.jsObject)
            return KeyedEncodingContainer(keyedContainer)
        }
        
        func unkeyedContainer() -> UnkeyedEncodingContainer {
            
            log?("Requested unkeyed container for path \"\(codingPath.path)\"")
            let array = JSArray()
            self.stack.push(array)
            return JSUnkeyedEncodingContainer(referencing: self, wrapping: array.jsObject)
        }
        
        func singleValueContainer() -> SingleValueEncodingContainer {
            
            log?("Requested single value container for path \"\(codingPath.path)\"")
            let container = Container(.undefined)
            self.stack.push(container)
            defer { assert(container.jsValue != .undefined, "Did not set value") }
            return JSSingleValueEncodingContainer(referencing: self, wrapping: container)
        }
    }
}

// MARK: - Boxing Values

internal extension JSEncoder.Encoder {

    @inline(__always)
    func box <T: JSValueConvertible> (_ value: T) -> JSValue {
        return value.jsValue()
    }
    
    func boxEncodable <T: Encodable> (_ value: T) throws -> JSValue {
        
        if let data = value as? Data {
            return boxData(data)
        } else if let date = value as? Date {
            return boxDate(date)
        } else if let uuid = value as? UUID {
            return boxUUID(uuid)
        } else if let jsEncodable = value as? JSValueConvertible {
            return jsEncodable.jsValue()
        } else {
            // encode using Encodable, should push new container.
            try value.encode(to: self)
            let nestedContainer = stack.pop()
            return nestedContainer.jsValue
        }
    }
}

private extension JSEncoder.Encoder {
    
    func boxData(_ data: Data) -> JSValue {
        // TODO: Support different Data formatting
        //return JSArray(data).jsValue()
        return data.base64EncodedString().jsValue()
    }
    
    func boxUUID(_ uuid: UUID) -> JSValue {
        // TODO: Support different UUID formatting
        return uuid.uuidString.jsValue()
    }
    
    func boxDate(_ date: Date) -> JSValue {
        // TODO: Support different Date formatting
        /*
        switch options.dateFormatting {
        case .secondsSince1970:
            return boxDouble(date.timeIntervalSince1970)
        case .millisecondsSince1970:
            return boxDouble(date.timeIntervalSince1970 * 1000)
        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
                else { fatalError("ISO8601DateFormatter is unavailable on this platform.") }
            return boxDate(date, using: JSDateFormatting.iso8601Formatter)
        case let .formatted(formatter):
            return boxDate(date, using: formatter)
        }*/
        return JSDate(date).jsValue()
    }
    /*
    func boxDate <T: DateFormatterProtocol> (_ date: Date, using formatter: T) -> Data {
        return box(formatter.string(from: date))
    }*/
}

// MARK: - Stack

internal extension JSEncoder.Encoder {
    
    struct Stack {
                
        private(set) var containers = [Container]()
        
        fileprivate init() { }
        
        var top: Container {
            guard let container = containers.last
                else { fatalError("Empty container stack.") }
            return container
        }
        
        var root: Container {
            guard let container = containers.first
                else { fatalError("Empty container stack.") }
            return container
        }
        
        mutating func push(_ container: Container) {
            containers.append(container)
        }
        
        mutating func push(_ value: JSValueConvertible) {
            containers.append(.init(value.jsValue()))
        }
        
        @discardableResult
        mutating func pop() -> Container {
            guard let container = containers.popLast()
                else { fatalError("Empty container stack.") }
            return container
        }
    }
}

internal extension JSEncoder.Encoder {
    
    final class Container {
        fileprivate(set) var jsValue: JSValue
        fileprivate init(_ jsValue: JSValue) {
            self.jsValue = jsValue
        }
    }
}

// MARK: - KeyedEncodingContainerProtocol

internal struct JSKeyedEncodingContainer <K : CodingKey> : KeyedEncodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: - Properties
    
    /// A reference to the encoder we're writing to.
    let encoder: JSEncoder.Encoder
    
    /// The path of coding keys taken to get to this point in encoding.
    let codingPath: [CodingKey]
    
    /// A reference to the container we're writing to.
    let container: JSObjectRef
    
    // MARK: - Initialization
    
    init(referencing encoder: JSEncoder.Encoder,
        wrapping container: JSObjectRef) {
        
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.container = container
    }
    
    // MARK: - Methods
    
    func encodeNil(forKey key: K) throws {
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        try setValue(.null, Any?.self, for: key)
    }
    
    func encode(_ value: Bool, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Int, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Int8, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Int16, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Int32, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Int64, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: UInt, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: UInt8, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: UInt16, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: UInt32, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: UInt64, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Float, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: Double, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode(_ value: String, forKey key: K) throws {
        try encodeRaw(value, forKey: key)
    }
    
    func encode <T: Encodable> (_ value: T, forKey key: K) throws {
        
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        let encodedValue = try encoder.boxEncodable(value)
        try setValue(encodedValue, T.self, for: key)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
    func superEncoder(forKey key: K) -> Encoder {
        fatalError()
    }
    
    // MARK: Private Methods
    
    private func encodeRaw <T: JSValueConvertible> (_ value: T, forKey key: K) throws {
        
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        let encodedValue = encoder.box(value)
        try setValue(encodedValue, T.self, for: key)
    }
    
    private func setValue <T> (_ encodedValue: JSValue, _ type: T.Type, for key: Key) throws {
        encoder.log?("Will encode \(type) at path \"\(encoder.codingPath.path)\"")
        container.set(key.stringValue, encodedValue)
    }
}

// MARK: - SingleValueEncodingContainer

internal final class JSSingleValueEncodingContainer: SingleValueEncodingContainer {
    
    // MARK: - Properties
    
    /// A reference to the encoder we're writing to.
    let encoder: JSEncoder.Encoder
    
    /// The path of coding keys taken to get to this point in encoding.
    let codingPath: [CodingKey]
    
    /// A reference to the container we're writing to.
    let container: JSEncoder.Encoder.Container
    
    /// Whether the data has been written
    private var didWrite = false
    
    // MARK: - Initialization
    
    init(referencing encoder: JSEncoder.Encoder,
         wrapping container: JSEncoder.Encoder.Container) {
        
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.container = container
    }
    
    // MARK: - Methods
    
    func encodeNil() throws {
        write(.null)
    }
    
    func encode(_ value: Bool) throws { write(encoder.box(value)) }
    
    func encode(_ value: String) throws { write(encoder.box(value)) }
    
    func encode(_ value: Double) throws { write(encoder.box(value)) }
    
    func encode(_ value: Float) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int8) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int16) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int32) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int64) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt8) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt16) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt32) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt64) throws { write(encoder.box(value)) }
    
    func encode <T: Encodable> (_ value: T) throws {
        write(try encoder.boxEncodable(value))
    }
    
    // MARK: - Private Methods
    
    private func write(_ value: JSValue) {
        
        precondition(didWrite == false, "Data already written")
        self.container.jsValue = value
        self.didWrite = true
    }
}

// MARK: - UnkeyedEncodingContainer

internal final class JSUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    
    // MARK: - Properties
    
    /// A reference to the encoder we're writing to.
    let encoder: JSEncoder.Encoder
    
    /// The path of coding keys taken to get to this point in encoding.
    let codingPath: [CodingKey]
    
    /// A reference to the container we're writing to.
    let container: JSObjectRef
    
    // MARK: - Initialization
    
    init(referencing encoder: JSEncoder.Encoder,
         wrapping container: JSObjectRef) {
        
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        self.container = container
    }
    
    // MARK: - Methods
    
    /// The number of elements encoded into the container.
    private(set) var count: Int = 0
    
    func encodeNil() throws {
        append(.null)
    }
    
    func encode(_ value: Bool) throws { append(encoder.box(value)) }
    
    func encode(_ value: String) throws { append(encoder.box(value)) }
    
    func encode(_ value: Double) throws { append(encoder.box(value)) }
    
    func encode(_ value: Float) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int8) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int16) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int32) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int64) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt8) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt16) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt32) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt64) throws { append(encoder.box(value)) }
    
    func encode <T: Encodable> (_ value: T) throws {
        append(try encoder.boxEncodable(value))
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
    // MARK: - Private Methods
    
    private func append(_ value: JSValue) {
        
        // write
        let index = self.count
        defer { self.count += 1 }
        self.container.set(index, value)
    }
}
