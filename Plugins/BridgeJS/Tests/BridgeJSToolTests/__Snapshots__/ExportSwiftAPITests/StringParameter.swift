@_extern(wasm, module: "bjs", name: "return_string")
private func _return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
@_extern(wasm, module: "bjs", name: "init_memory")
private func _init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)

@_expose(wasm, "bjs_checkString")
@_cdecl("bjs_checkString")
public func _bjs_checkString(aBytes: Int32, aLen: Int32) -> Void {
    let a = String(unsafeUninitializedCapacity: Int(aLen)) { b in
        _init_memory(aBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(aLen)
    }
    checkString(a: a)
}