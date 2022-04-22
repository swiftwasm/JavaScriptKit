import _CJavaScriptBigIntSupport
@_spi(JSObject_id) import JavaScriptKit

extension JSBigInt: JSBigIntExtended {
    public var int64Value: Int64 {
        _bigint_to_i64(id, true)
    }

    public var uInt64Value: UInt64 {
        UInt64(bitPattern: _bigint_to_i64(id, false))
    }

    public convenience init(_ value: Int64) {
        self.init(id: _i64_to_bigint(value, true))
    }

    public convenience init(unsigned value: UInt64) {
        self.init(id: _i64_to_bigint(Int64(bitPattern: value), false))
    }
}
