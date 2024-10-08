import JavaScriptKit

// NOTE: it seems the embedded tree shaker gets rid of these exports if they are not used somewhere
func _i_need_to_be_here_for_wasm_exports_to_work() {
    _ = _library_features
    _ = _call_host_function_impl
    _ = _free_host_function_impl
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

// TODO: why do I need this? and surely this is not ideal... figure this out, or at least have this come from a C lib
@_cdecl("memmove")
func memmove(_ dest: UnsafeMutableRawPointer, _ src: UnsafeRawPointer, _ n: Int) -> UnsafeMutableRawPointer {
    let d = dest.assumingMemoryBound(to: UInt8.self)
    let s = src.assumingMemoryBound(to: UInt8.self)
    for i in 0..<n {
        d[i] = s[i]
    }
    return dest
}