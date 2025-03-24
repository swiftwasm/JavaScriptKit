@_extern(wasm, module: "bjs", name: "return_string")
private func _return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
@_extern(wasm, module: "bjs", name: "init_memory")
private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)

@_expose(wasm, "bjs_hello")
@_cdecl("bjs_hello")
public func _bjs_hello() -> Void {
    var ret = hello()
    return ret.withUTF8 { ptr in
        _return_string(ptr.baseAddress, Int32(ptr.count))
    }
}

@_expose(wasm, "bjs_twice")
@_cdecl("bjs_twice")
public func _bjs_twice(x: Int32) -> Int32 {
    let ret = twice(x: Int(x))
    return Int32(ret)
}