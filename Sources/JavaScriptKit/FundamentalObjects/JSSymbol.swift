import _CJavaScriptKit

private let Symbol = JSObject.global.Symbol.function!

public class JSSymbol: JSObject {
    public var name: String? { self["description"].string }

    public init(_ description: JSString) {
        // can’t do `self =` so we have to get the ID manually
        let result = invokeNonThrowingJSFunction(Symbol, arguments: [description], this: nil)
        precondition(result.kind == .symbol)
        super.init(id: UInt32(result.payload1))
    }
    @_disfavoredOverload
    public convenience init(_ description: String) {
        self.init(JSString(description))
    }

    override init(id: JavaScriptObjectRef) {
        super.init(id: id)
    }

    public static func `for`(key: JSString) -> JSSymbol {
        Symbol.for!(key).symbol!
    }

    @_disfavoredOverload
    public static func `for`(key: String) -> JSSymbol {
        Symbol.for!(key).symbol!
    }

    public static func key(for symbol: JSSymbol) -> JSString? {
        Symbol.keyFor!(symbol).jsString
    }

    @_disfavoredOverload
    public static func key(for symbol: JSSymbol) -> String? {
        Symbol.keyFor!(symbol).string
    }

    override public class func construct(from value: JSValue) -> Self? {
        return value.symbol as? Self
    }

    override public var jsValue: JSValue {
        .symbol(self)
    }
}

extension JSSymbol {
    public static let asyncIterator: JSSymbol! = Symbol.asyncIterator.symbol
    public static let hasInstance: JSSymbol! = Symbol.hasInstance.symbol
    public static let isConcatSpreadable: JSSymbol! = Symbol.isConcatSpreadable.symbol
    public static let iterator: JSSymbol! = Symbol.iterator.symbol
    public static let match: JSSymbol! = Symbol.match.symbol
    public static let matchAll: JSSymbol! = Symbol.matchAll.symbol
    public static let replace: JSSymbol! = Symbol.replace.symbol
    public static let search: JSSymbol! = Symbol.search.symbol
    public static let species: JSSymbol! = Symbol.species.symbol
    public static let split: JSSymbol! = Symbol.split.symbol
    public static let toPrimitive: JSSymbol! = Symbol.toPrimitive.symbol
    public static let toStringTag: JSSymbol! = Symbol.toStringTag.symbol
    public static let unscopables: JSSymbol! = Symbol.unscopables.symbol
}
