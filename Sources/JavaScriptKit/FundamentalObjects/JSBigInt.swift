import _CJavaScriptKit

private var constructor: JSFunction { JSObject.global.BigInt.function! }

/// A wrapper around [the JavaScript `BigInt`
/// class](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)
/// that exposes its properties in a type-safe and Swifty way.
public final class JSBigInt: JSObject {
    @_spi(JSObject_id)
    override public init(id: JavaScriptObjectRef) {
        super.init(id: id)
    }

    /// Instantiate a new `JSBigInt` with given Int64 value in a slow path
    /// This doesn't require [JS-BigInt-integration](https://github.com/WebAssembly/JS-BigInt-integration) feature.
    public init(_slowBridge value: Int64) {
        let value = UInt64(bitPattern: value)
        super.init(id: swjs_i64_to_bigint_slow(UInt32(value & 0xffff_ffff), UInt32(value >> 32), true))
    }

    /// Instantiate a new `JSBigInt` with given UInt64 value in a slow path
    /// This doesn't require [JS-BigInt-integration](https://github.com/WebAssembly/JS-BigInt-integration) feature.
    public init(_slowBridge value: UInt64) {
        super.init(id: swjs_i64_to_bigint_slow(UInt32(value & 0xffff_ffff), UInt32(value >> 32), false))
    }

    override public var jsValue: JSValue {
        .bigInt(self)
    }

    public func clamped(bitSize: Int, signed: Bool) -> JSBigInt {
        if signed {
            return constructor.asIntN(bitSize, self).bigInt!
        } else {
            return constructor.asUintN(bitSize, self).bigInt!
        }
    }
}

public protocol JSBigIntExtended: JSBigInt {
    var int64Value: Int64 { get }
    var uInt64Value: UInt64 { get }

    init(_ value: Int64)
    init(unsigned value: UInt64)
}
