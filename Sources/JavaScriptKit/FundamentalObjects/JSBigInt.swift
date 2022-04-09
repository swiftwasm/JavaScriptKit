import _CJavaScriptKit

public class JSBigInt: JSObject {
    var int64Value: Int64 { _bigint_to_i64(id, true) }
    var uInt64Value: UInt64 {
        UInt64(bitPattern: _bigint_to_i64(id, false))
    }

    public convenience init(_ value: Int64) {
        self.init(id: _i64_to_bigint(value, true))
    }
    public convenience init(_ value: UInt64) {
        self.init(id: _i64_to_bigint(Int64(bitPattern: value), false))
    }

    public override init(id: JavaScriptObjectRef) {
        super.init(id: id)
    }

    override public class func construct(from value: JSValue) -> Self? {
        return value.bigInt as? Self
    }

    override public var jsValue: JSValue {
        .bigInt(self)
    }
}
