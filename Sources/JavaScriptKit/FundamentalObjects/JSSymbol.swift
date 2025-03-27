import _CJavaScriptKit

private let _Symbol = LazyThreadLocal(initialize: { JSObject.global.Symbol.function! })
private var Symbol: JSFunction { _Symbol.wrappedValue }

/// A wrapper around [the JavaScript `Symbol`
/// class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
/// that exposes its properties in a type-safe and Swifty way.
public class JSSymbol: JSObject {
    public var name: String? { self["description"].string }

    public init(_ description: JSString) {
        // can’t do `self =` so we have to get the ID manually
        let result = Symbol.invokeNonThrowingJSFunction(arguments: [description.jsValue])
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

    @available(*, unavailable, message: "JSSymbol does not support dictionary literal initialization")
    public required init(dictionaryLiteral elements: (String, JSValue)...) {
        fatalError("JSSymbol does not support dictionary literal initialization")
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

    override public var jsValue: JSValue {
        .symbol(self)
    }
}

extension JSSymbol {
    public static var asyncIterator: JSSymbol! { Symbol.asyncIterator.symbol }
    public static var hasInstance: JSSymbol! { Symbol.hasInstance.symbol }
    public static var isConcatSpreadable: JSSymbol! { Symbol.isConcatSpreadable.symbol }
    public static var iterator: JSSymbol! { Symbol.iterator.symbol }
    public static var match: JSSymbol! { Symbol.match.symbol }
    public static var matchAll: JSSymbol! { Symbol.matchAll.symbol }
    public static var replace: JSSymbol! { Symbol.replace.symbol }
    public static var search: JSSymbol! { Symbol.search.symbol }
    public static var species: JSSymbol! { Symbol.species.symbol }
    public static var split: JSSymbol! { Symbol.split.symbol }
    public static var toPrimitive: JSSymbol! { Symbol.toPrimitive.symbol }
    public static var toStringTag: JSSymbol! { Symbol.toStringTag.symbol }
    public static var unscopables: JSSymbol! { Symbol.unscopables.symbol }
}
