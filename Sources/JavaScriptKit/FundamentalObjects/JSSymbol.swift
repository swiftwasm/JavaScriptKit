import _CJavaScriptKit

private let _Symbol = LazyThreadLocal(initialize: { JSObject.global.Symbol.object! })
private var Symbol: JSObject { _Symbol.wrappedValue }

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
        fatalError("Not implemented")
    }

    @_disfavoredOverload
    public static func `for`(key: String) -> JSSymbol {
        fatalError("Not implemented")
    }

    public static func key(for symbol: JSSymbol) -> JSString? {
        // Symbol.keyFor!(symbol).jsString
        nil
    }

    @_disfavoredOverload
    public static func key(for symbol: JSSymbol) -> String? {
        // Symbol.keyFor!(symbol).string
        nil
    }

    override public var jsValue: JSValue {
        .symbol(self)
    }
}

extension JSSymbol {
}
