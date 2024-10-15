import JavaScriptKit

// NOTE: it seems the embedded tree shaker gets rid of these exports if they are not used somewhere
func _i_need_to_be_here_for_wasm_exports_to_work() {
    _ = _swjs_library_features
    _ = _swjs_call_host_function
    _ = _swjs_free_host_function
}

// TODO: why do I need this? and surely this is not ideal... figure this out, or at least have this come from a C lib
@_cdecl("strlen")
func strlen(_ s: UnsafePointer<Int8>) -> Int {
    var p = s
    while p.pointee != 0 {
        p += 1
    }
    return p - s
}

@_cdecl("arc4random_buf")
public func arc4random_buf(_ buffer: UnsafeMutableRawPointer, _ size: Int) {
    for i in 0..<size {
        buffer.storeBytes(of: UInt8.random(in: 0...255), toByteOffset: i, as: UInt8.self)
    }
}
