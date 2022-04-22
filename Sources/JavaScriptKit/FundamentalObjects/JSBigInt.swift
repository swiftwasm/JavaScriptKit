import _CJavaScriptKit

private let constructor = JSObject.global.BigInt.function!

public final class JSBigInt: JSObject {
    @_spi(JSObject_id)
    override public init(id: JavaScriptObjectRef) {
        super.init(id: id)
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
