//
//  JSEncoder.swift
//  
//
//  Created by Alsey Coleman Miller on 6/4/20.
//

#if arch(wasm32)
import SwiftFoundation
#else
import Foundation
#endif

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
    
    public func encode<T: Encodable>(_ encodable: T) throws -> JSValue {
        
        log?("Will encode \(T.self)")
        
        if let value = encodable as? JSValueConvertible {
            return value.jsValue()
        } else {
            /*
            let encoder = Encoder(
                userInfo: userInfo,
                log: log
            )
            try encodable.encode(to: encoder)
            return encoder.object.jsValue()
            */
            fatalError()
        }
    }
}
/*
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
        
        /// Output
        internal let object = JSObject()
        
        // MARK: - Initialization
        
        fileprivate init(codingPath: [CodingKey] = [],
                         userInfo: [CodingUserInfoKey : Any],
                         log: ((String) -> ())?) {
            
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.log = log
        }
        
        // MARK: - Encoder
        
        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
            
            log?("Requested container keyed by \(type.sanitizedName) for path \"\(codingPath.path)\"")
            let keyedContainer = JSKeyedEncodingContainer<Key>(referencing: self)
            return KeyedEncodingContainer(keyedContainer)
        }
        
        func unkeyedContainer() -> UnkeyedEncodingContainer {
            
            log?("Requested unkeyed container for path \"\(codingPath.path)\"")
            return JSUnkeyedEncodingContainer(referencing: self)
        }
        
        func singleValueContainer() -> SingleValueEncodingContainer {
            
            log?("Requested single value container for path \"\(codingPath.path)\"")
            return JSSingleValueEncodingContainer(referencing: self)
        }
    }
}

internal extension JSEncoder.Encoder {

    @inline(__always)
    func box <T: JSValueConvertible> (_ value: T) -> JSValue {
        return value.jsValue()
    }
    
    func boxEncodable <T: Encodable> (_ value: T) throws -> JSValue {
        
        if let data = value as? Data {
            return data
        } else if let uuid = value as? UUID {
            return boxUUID(uuid)
        } else if let date = value as? Date {
            return boxDate(date)
        } else if let tlvEncodable = value as? JSValueConvertible {
            return tlvEncodable.jsValue()
        } else {
            // encode using Encodable, should push new container.
            try value.encode(to: self)
            let nestedContainer = stack.pop()
            return nestedContainer.data
        }
    }
}

private extension JSEncoder.Encoder {
    
    func boxData(_ data: Data) -> JSValue {
        return uuid.uuidString
    }
    
    func boxUUID(_ uuid: UUID) -> JSValue {
        return uuid.uuidString
    }
    
    func boxDate(_ date: Date) -> Data {
        
        switch options.dateFormatting {
        case .secondsSince1970:
            return boxDouble(date.timeIntervalSince1970)
        case .millisecondsSince1970:
            return boxDouble(date.timeIntervalSince1970 * 1000)
        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
                else { fatalError("ISO8601DateFormatter is unavailable on this platform.") }
            return boxDate(date, using: TLVDateFormatting.iso8601Formatter)
        case let .formatted(formatter):
            return boxDate(date, using: formatter)
        }
    }
    
    func boxDate <T: DateFormatterProtocol> (_ date: Date, using formatter: T) -> Data {
        return box(formatter.string(from: date))
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
    
    // MARK: - Initialization
    
    init(referencing encoder: JSEncoder.Encoder) {
        
        self.encoder = encoder
        self.codingPath = encoder.codingPath
    }
    
    // MARK: - Methods
    
    func encodeNil(forKey key: K) throws {
        // do nothing
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
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        let data = try encoder.boxString(value)
        try setValue(value, data: data, for: key)
    }
    
    func encode <T: Encodable> (_ value: T, forKey key: K) throws {
        
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        encoder.log?("Will encode \(T.self) at path \"\(encoder.codingPath.path)\"")
        try encoder.writeEncodable(value)
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
        try setValue(value, value.jsValue(), for: key)
    }
    
    private func setValue <T> (_ value: T, _ encodedValue: JSValue, for key: Key) throws {
        encoder.log?("Will encode \(T.self) at path \"\(encoder.codingPath.path)\"")
        self.encoder.write(data)
    }
}

// MARK: - SingleValueEncodingContainer

internal final class JSSingleValueEncodingContainer: SingleValueEncodingContainer {
    
    // MARK: - Properties
    
    /// A reference to the encoder we're writing to.
    let encoder: JSEncoder.Encoder
    
    /// The path of coding keys taken to get to this point in encoding.
    let codingPath: [CodingKey]
    
    /// Whether the data has been written
    private var didWrite = false
    
    // MARK: - Initialization
    
    init(referencing encoder: JSEncoder.Encoder) {
        
        self.encoder = encoder
        self.codingPath = encoder.codingPath
    }
    
    // MARK: - Methods
    
    func encodeNil() throws {
        // do nothing
    }
    
    func encode(_ value: Bool) throws { write(encoder.box(value)) }
    
    func encode(_ value: String) throws { try write(encoder.boxString(value)) }
    
    func encode(_ value: Double) throws { write(encoder.boxDouble(value)) }
    
    func encode(_ value: Float) throws { write(encoder.boxFloat(value)) }
    
    func encode(_ value: Int) throws { write(encoder.boxNumeric(Int32(value))) }
    
    func encode(_ value: Int8) throws { write(encoder.box(value)) }
    
    func encode(_ value: Int16) throws { write(encoder.boxNumeric(value)) }
    
    func encode(_ value: Int32) throws { write(encoder.boxNumeric(value)) }
    
    func encode(_ value: Int64) throws { write(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt) throws { write(encoder.boxNumeric(UInt32(value))) }
    
    func encode(_ value: UInt8) throws { write(encoder.box(value)) }
    
    func encode(_ value: UInt16) throws { write(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt32) throws { write(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt64) throws { write(encoder.boxNumeric(value)) }
    
    func encode <T: Encodable> (_ value: T) throws {
        precondition(didWrite == false, "Data already written")
        try encoder.writeEncodable(value)
        self.didWrite = true
    }
    
    // MARK: - Private Methods
    
    private func write(_ data: Data) {
        
        precondition(didWrite == false, "Data already written")
        self.encoder.write(data)
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
        
    private var countOffset: Int?
        
    /// The number of elements encoded into the container.
    private(set) var count: Int = 0
    
    // MARK: - Initialization
    
    deinit {
        // update count byte
        self.countOffset.flatMap { self.encoder.data[$0] = UInt8(self.count) }
    }
    
    init(referencing encoder: JSEncoder.Encoder) {
        self.encoder = encoder
        self.codingPath = encoder.codingPath
        let formatting = encoder.formatting.array
        switch formatting {
        case .lengthPrefix:
            // write count byte
            self.countOffset = self.encoder.data.count
            self.encoder.write(Data([0]))
        case .remainder:
            self.countOffset = nil
        }
    }
    
    // MARK: - Methods
    
    func encodeNil() throws {
        throw EncodingError.invalidValue(Optional<Any>.self, EncodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot encode nil in an array"))
    }
    
    func encode(_ value: Bool) throws { append(encoder.box(value)) }
    
    func encode(_ value: String) throws { try append(encoder.boxString(value)) }
    
    func encode(_ value: Double) throws { append(encoder.boxNumeric(value.bitPattern)) }
    
    func encode(_ value: Float) throws { append(encoder.boxNumeric(value.bitPattern)) }
    
    func encode(_ value: Int) throws { append(encoder.boxNumeric(Int32(value))) }
    
    func encode(_ value: Int8) throws { append(encoder.box(value)) }
    
    func encode(_ value: Int16) throws { append(encoder.boxNumeric(value)) }
    
    func encode(_ value: Int32) throws { append(encoder.boxNumeric(value)) }
    
    func encode(_ value: Int64) throws { append(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt) throws { append(encoder.boxNumeric(UInt32(value))) }
    
    func encode(_ value: UInt8) throws { append(encoder.box(value)) }
    
    func encode(_ value: UInt16) throws { append(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt32) throws { append(encoder.boxNumeric(value)) }
    
    func encode(_ value: UInt64) throws { append(encoder.boxNumeric(value)) }
    
    func encode <T: Encodable> (_ value: T) throws {
        assert(count < Int(UInt8.max), "Cannot encode more than \(UInt8.max) elements")
        try encoder.writeEncodable(value)
        count += 1
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
    
    private func append(_ data: Data) {
        assert(count < Int(UInt8.max), "Cannot encode more than \(UInt8.max) elements")
        // write element data
        encoder.write(data)
        count += 1
    }
}
*/
