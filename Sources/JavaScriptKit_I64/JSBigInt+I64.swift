@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit_I64

public extension JSBigInt {
    var int64Value: Int64 {
        _bigint_to_i64(id, true)
    }

    var uInt64Value: UInt64 {
        UInt64(bitPattern: _bigint_to_i64(id, false))
    }

    convenience init(_ value: Int64) {
        self.init(id: _i64_to_bigint(value, true))
    }

    convenience init(unsigned value: UInt64) {
        self.init(id: _i64_to_bigint(Int64(bitPattern: value), false))
    }
}
