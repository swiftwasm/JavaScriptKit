import _CJavaScriptKit
#if hasFeature(Embedded)
import String16
#endif

private let Symbol = JSObject.global.Symbol.function!

/// A wrapper around [the JavaScript `Symbol`
/// class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
/// that exposes its properties in a type-safe and Swifty way.
public class JSSymbol: JSObject {
    #if hasFeature(Embedded)
    public var name: String16? { self["description"].string }
    #else
    public var name: String? { self["description"].string }
    #endif

    #if hasFeature(Embedded)
    public init(_ description: JSString) {
        // can’t do `self =` so we have to get the ID manually
        let result = Symbol.invokeNonThrowingJSFunction(arguments: [description.jsValue])
        precondition(result.kind == 7)
        super.init(id: UInt32(result.payload1))
    }
    #else
    public init(_ description: JSString) {
        // can’t do `self =` so we have to get the ID manually
        let result = Symbol.invokeNonThrowingJSFunction(arguments: [description])
        precondition(result.kind == .symbol)
        super.init(id: UInt32(result.payload1))
    }
    #endif
    #if hasFeature(Embedded)
    @_disfavoredOverload
    public convenience init(_ description: String16) {
        self.init(JSString(description))
    }
    #else
    @_disfavoredOverload
    public convenience init(_ description: String) {
        self.init(JSString(description))
    }
    #endif

    override init(id: JavaScriptObjectRef) {
        super.init(id: id)
    }

    public static func `for`(key: JSString) -> JSSymbol {
        #if hasFeature(Embedded)
        Symbol.for!(key.jsValue).symbol!
        #else
        Symbol.for!(key).symbol!
        #endif
    }
    #if hasFeature(Embedded)
    @_disfavoredOverload
    public static func `for`(key: String16) -> JSSymbol {
        Symbol.for!(key.jsValue).symbol!
    }
    #else
    @_disfavoredOverload
    public static func `for`(key: String) -> JSSymbol {
        Symbol.for!(key).symbol!
    }
    #endif

    public static func key(for symbol: JSSymbol) -> JSString? {
        #if hasFeature(Embedded)
        Symbol.keyFor!(symbol.jsValue).jsString
        #else
        Symbol.keyFor!(symbol).jsString
        #endif
    }

    #if hasFeature(Embedded)
    @_disfavoredOverload
    public static func key(for symbol: JSSymbol) -> String16? {
        Symbol.keyFor!(symbol.jsValue).string
    }
    #else
    @_disfavoredOverload
    public static func key(for symbol: JSSymbol) -> String? {
        Symbol.keyFor!(symbol).string
    }
    #endif

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
