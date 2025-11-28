/// A wrapper around [the JavaScript `Array`
/// class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)
/// that exposes its properties in a type-safe and Swifty way.
public class JSArray: JSBridgedClass {
    public static var constructor: JSObject? { _constructor.wrappedValue }
    private static let _constructor = LazyThreadLocal(initialize: { JSObject.global.Array.object })

    static func isArray(_ object: JSObject) -> Bool {
        constructor!.isArray!(object).boolean!
    }

    public let jsObject: JSObject

    public required convenience init?(from value: JSValue) {
        guard let object = value.object else { return nil }
        self.init(object)
    }

    /// Construct a `JSArray` from Array `JSObject`.
    /// Return `nil` if the object is not an Array.
    ///
    /// - Parameter jsObject: A `JSObject` expected to be a JavaScript Array
    public convenience init?(_ jsObject: JSObject) {
        guard Self.isArray(jsObject) else { return nil }
        self.init(unsafelyWrapping: jsObject)
    }

    public required init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }
}

extension JSArray: RandomAccessCollection {
    public typealias Element = JSValue

    public func makeIterator() -> Iterator {
        Iterator(jsObject: jsObject)
    }

    /// Iterator type for `JSArray`, conforming to `IteratorProtocol` from the standard library, which allows
    /// easy iteration over elements of `JSArray` instances.
    public class Iterator: IteratorProtocol {
        private let jsObject: JSObject
        private var index = 0
        init(jsObject: JSObject) {
            self.jsObject = jsObject
        }

        public func next() -> Element? {
            let currentIndex = index
            guard currentIndex < Int(jsObject.length.number!) else {
                return nil
            }
            index += 1
            guard jsObject.hasOwnProperty!(currentIndex).boolean! else {
                return next()
            }
            let value = jsObject[currentIndex]
            return value
        }
    }

    public subscript(position: Int) -> JSValue {
        jsObject[position]
    }

    public var startIndex: Int { 0 }

    public var endIndex: Int { length }

    /// The number of elements in that array including empty hole.
    /// Note that `length` respects JavaScript's `Array.prototype.length`
    ///
    /// e.g.
    /// ```javascript
    /// const array = [1, , 3];
    /// ```
    /// ```swift
    /// let array: JSArray = ...
    /// array.length // 3
    /// array.count  // 2
    /// ```
    public var length: Int {
        Int(jsObject.length.number!)
    }

    /// The number of elements in that array **not** including empty hole.
    /// Note that `count` syncs with the number that `Iterator` can iterate.
    /// See also: `JSArray.length`
    public var count: Int {
        getObjectValuesLength(jsObject)
    }
}

private let alwaysTrue = LazyThreadLocal(initialize: { JSClosure { _ in .boolean(true) } })
private func getObjectValuesLength(_ object: JSObject) -> Int {
    let values = object.filter!(alwaysTrue.wrappedValue).object!
    return Int(values.length.number!)
}

extension JSValue {
    public var array: JSArray? {
        object.flatMap(JSArray.init)
    }
}
