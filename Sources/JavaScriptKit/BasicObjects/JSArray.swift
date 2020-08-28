public class JSArray {
    static let classObject = JSObject.global.Array.function!

    static func isArray(_ object: JSObject) -> Bool {
        classObject.isArray!(object).boolean!
    }

    let ref: JSObject

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
            defer { index += 1 }
            guard index < Int(ref.length.number!) else {
                return nil
            }
            let value = ref[index]
            return value
        }
    }

    public subscript(position: Int) -> JSValue {
        ref[position]
    }

    public var startIndex: Int { 0 }

    public var endIndex: Int { ref.length.number.map(Int.init) ?? 0 }
}

extension JSValue {
    public var array: JSArray? {
        object.flatMap(JSArray.init)
    }
}
