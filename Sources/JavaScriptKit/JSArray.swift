
public class JSArray {

    static let classObject = JSObjectRef.global.Array.object!

    static func isArray(_ object: JSObjectRef) -> Bool {
        classObject.isArray.function!(object).boolean!
    }

    let ref: JSObjectRef

    public init?(_ ref: JSObjectRef) {
        guard Self.isArray(ref) else { return nil }
        self.ref = ref
    }
}


extension JSArray: Sequence {
    public typealias Element = JSValue

    public func makeIterator() -> Iterator {
        Iterator(ref: ref)
    }

    public class Iterator: IteratorProtocol {
        let ref: JSObjectRef
        var index = 0
        init(ref: JSObjectRef) {
            self.ref = ref
        }
        public func next() -> Element? {
            defer { index += 1 }
            guard index < Int(ref.length.number!) else {
                return nil
            }
            let value = ref.get(index)
            return value.isNull ? nil : value
        }
    }
}
