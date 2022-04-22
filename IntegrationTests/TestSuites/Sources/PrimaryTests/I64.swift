import JavaScriptBigIntSupport
import JavaScriptKit

func testI64() throws {
    try test("BigInt") {
        func expectPassesThrough(signed value: Int64) throws {
            let bigInt = JSBigInt(value)
            try expectEqual(bigInt.description, value.description)
        }

        func expectPassesThrough(unsigned value: UInt64) throws {
            let bigInt = JSBigInt(unsigned: value)
            try expectEqual(bigInt.description, value.description)
        }

        try expectPassesThrough(signed: 0)
        try expectPassesThrough(signed: 1 << 62)
        try expectPassesThrough(signed: -2305)
        for _ in 0 ..< 100 {
            try expectPassesThrough(signed: .random(in: .min ... .max))
        }
        try expectPassesThrough(signed: .min)
        try expectPassesThrough(signed: .max)

        try expectPassesThrough(unsigned: 0)
        try expectPassesThrough(unsigned: 1 << 62)
        try expectPassesThrough(unsigned: 1 << 63)
        try expectPassesThrough(unsigned: .min)
        try expectPassesThrough(unsigned: .max)
        try expectPassesThrough(unsigned: ~0)
        for _ in 0 ..< 100 {
            try expectPassesThrough(unsigned: .random(in: .min ... .max))
        }
    }
}
