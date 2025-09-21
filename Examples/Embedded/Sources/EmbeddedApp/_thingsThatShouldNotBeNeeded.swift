import JavaScriptKit

// TODO: why do I need this? and surely this is not ideal... figure this out, or at least have this come from a C lib
@_cdecl("strlen")
func strlen(_ s: UnsafePointer<Int8>) -> Int {
    var p = s
    while p.pointee != 0 {
        p += 1
    }
    return p - s
}

enum LCG {
    static var x: UInt8 = 0
    static let a: UInt8 = 0x05
    static let c: UInt8 = 0x0b

    static func next() -> UInt8 {
        x = a &* x &+ c
        return x
    }
}

@_cdecl("arc4random_buf")
public func arc4random_buf(_ buffer: UnsafeMutableRawPointer, _ size: Int) {
    for i in 0..<size {
        buffer.storeBytes(of: LCG.next(), toByteOffset: i, as: UInt8.self)
    }
}
