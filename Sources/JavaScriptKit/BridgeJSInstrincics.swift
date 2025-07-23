#if !arch(wasm32)
private func _onlyAvailableOnWasm() -> Never {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_return_string")
@_spi(BridgeJS) public func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
@_spi(BridgeJS) public func _swift_js_return_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_init_memory")
@_spi(BridgeJS) public func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?)
#else
@_spi(BridgeJS) public func _swift_js_init_memory(_ sourceId: Int32, _ ptr: UnsafeMutablePointer<UInt8>?) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_retain")
@_spi(BridgeJS) public func _swift_js_retain(_ ptr: Int32) -> Int32
#else
@_spi(BridgeJS) public func _swift_js_retain(_ ptr: Int32) -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_throw")
@_spi(BridgeJS) public func _swift_js_throw(_ id: Int32)
#else
@_spi(BridgeJS) public func _swift_js_throw(_ id: Int32) {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_make_js_string")
@_spi(BridgeJS) public func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32
#else
@_spi(BridgeJS) public func _swift_js_make_js_string(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) -> Int32 {
    _onlyAvailableOnWasm()
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_init_memory_with_result")
@_spi(BridgeJS) public func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32)
#else
@_spi(BridgeJS) public func _swift_js_init_memory_with_result(_ ptr: UnsafePointer<UInt8>?, _ len: Int32) {
    _onlyAvailableOnWasm()
}
#endif
