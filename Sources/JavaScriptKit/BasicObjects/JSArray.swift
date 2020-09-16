/// A wrapper around [the JavaScript Array class](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Array)
/// that exposes its properties in a type-safe and Swifty way.
public class JSArray {
    static let classObject = JSObject.global.Array.function!

    static func isArray(_ object: JSObject) -> Bool {
        classObject.isArray!(object).boolean!
    }

    let ref: JSObject
    
    /// Construct a `JSArray` from Array `JSObject`.
    /// Return `nil` if the object is not an Array.
    ///
    /// - Parameter object: A `JSObject` expected to be a JavaScript Array
    public init?(_ ref: JSObject) {
        guard Self.isArray(ref) else { return nil }
        self.ref = ref
    }
}

extension JSArray: RandomAccessCollection {
    public typealias Element = JSValue

    public func makeIterator() -> Iterator {
        Iterator(ref: ref)
    }

    public class Iterator: IteratorProtocol {
        let ref: JSObject
        var index = 0
        init(ref: JSObject) {
            self.ref = ref
        }

        public func next() -> Element? {
            let currentIndex = index
            guard currentIndex < Int(ref.length.number!) else {
                return nil
            }
            index += 1
            guard ref.hasOwnProperty!(currentIndex).boolean! else {
                return next()
            }
            let value = ref[currentIndex]
            return value
        }
    }

    public subscript(position: Int) -> JSValue {
        ref[position]
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
        return Int(ref.length.number!)
    }

    /// The number of elements in that array **not** including empty hole.
    /// Note that `count` syncs with the number that `Iterator` can iterate.
    /// See also: `JSArray.length`
    public var count: Int {
        return getObjectValuesLength(ref)
    }
}

private let alwaysTrue = JSClosure { _ in .boolean(true) }
private func getObjectValuesLength(_ object: JSObject) -> Int {
    let values = object.filter!(alwaysTrue).object!
    return Int(values.length.number!)
}

extension JSValue {
    public var array: JSArray? {
        object.flatMap(JSArray.init)
    }
}
