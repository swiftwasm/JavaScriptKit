@_expose(wasm, "bjs_check")
@_cdecl("bjs_check")
public func _bjs_check() -> Void {
    #if arch(wasm32)
    check()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}