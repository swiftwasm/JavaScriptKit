import _CJavaScriptKit

private let constructor = JSObject.global.BigInt.function!

public final class JSBigInt: JSObject {
    @_spi(JSObject_id)
    override public init(id: JavaScriptObjectRef) {
        super.init(id: id)
    }
    
    /// Instantiate a new `JSBigInt` with given Int64 value in a slow path
    /// This doesn't require [JS-BigInt-integration](https://github.com/WebAssembly/JS-BigInt-integration) feature.
    public init(_slowBridge value: Int64) {
        let value = UInt64(bitPattern: value)
        super.init(id: _i64_to_bigint_slow(UInt32(value & 0xffffffff), UInt32(value >> 32), true))
    }

    /// Instantiate a new `JSBigInt` with given UInt64 value in a slow path
    /// This doesn't require [JS-BigInt-integration](https://github.com/WebAssembly/JS-BigInt-integration) feature.
    public init(_slowBridge value: UInt64) {
        super.init(id: _i64_to_bigint_slow(UInt32(value & 0xffffffff), UInt32(value >> 32), false))
    }

    override public class func construct(from value: JSValue) -> Self? {
        value.bigInt as? Self
    }

    override public var jsValue: JSValue {
        .bigInt(self)
    }

    public func clamped(bitSize: Int, signed: Bool) -> JSBigInt {
        if signed {
            return constructor.asIntN!(bitSize, self).bigInt!
        } else {
            return constructor.asUintN!(bitSize, self).bigInt!
        }
    }
}

public protocol JSBigIntExtended: JSBigInt {
    var int64Value: Int64 { get }
    var uInt64Value: UInt64 { get }

    init(_ value: Int64)
    init(unsigned value: UInt64)
}
