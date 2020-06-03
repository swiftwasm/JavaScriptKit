/// JavaScript Array
public final class JSArray: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init?(_ jsObject: JSObjectRef) {
        guard Self.isArray(jsObject)
            else { return nil }
        self.jsObject = jsObject
    }
    
    public init(count: Int = 0) {
        self.jsObject = Self.classObject.new(count)
        assert(Self.isArray(jsObject))
    }
    
    public convenience init<C>(_ collection: C) where C: Collection, C.Element == JSValue {
        self.init(count: collection.count)
        collection.enumerated().forEach { self[$0.offset] = $0.element }
    }
    
    public convenience init<C>(_ collection: C) where C: Collection, C.Element == JSValueConvertible {
        self.init(collection.map({ $0.jsValue() }))
    }
}

internal extension JSArray {
    
    static let classObject = JSObjectRef.global.Array.function!

    static func isArray(_ object: JSObjectRef) -> Bool {
        classObject.isArray.function?(object).boolean ?? false
    }
}

// MARK: - Deprecated

@available(*, renamed: "JSArray")
public typealias JSArrayRef = JSArray

// MARK: - ExpressibleByArrayLiteral

extension JSArray: ExpressibleByArrayLiteral {
    
    public convenience init(arrayLiteral elements: JSValueConvertible...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible

extension JSArray: CustomStringConvertible {
    
    public var description: String {
        return toString() ?? ""
    }
}

// MARK: - Sequence

extension JSArray: Sequence {
    
    public typealias Element = JSValue

    public func makeIterator() -> IndexingIterator<JSArray> {
        return IndexingIterator(_elements: self)
    }
}

// MARK: - Collection

extension JSArray: RandomAccessCollection {
    
    public var count: Int {
        return Int(jsObject.length.number ?? 0)
    }
    
    public subscript (index: Int) -> JSValue {
        get { return jsObject.get(index) }
        set { jsObject.set(index, newValue) }
    }
    
    /// The start `Index`.
    public var startIndex: Int {
        return 0
    }
    
    /// The end `Index`.
    ///
    /// This is the "one-past-the-end" position, and will always be equal to the `count`.
    public var endIndex: Int {
        return count
    }
    
    public func index(before i: Int) -> Int {
        return i - 1
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
}
