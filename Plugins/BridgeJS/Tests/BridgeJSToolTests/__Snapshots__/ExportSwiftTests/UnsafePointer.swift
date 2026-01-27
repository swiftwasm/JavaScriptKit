extension PointerFields: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> PointerFields {
        let mutPtr = UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let ptr = UnsafePointer<UInt8>.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let opaque = OpaquePointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let mutRaw = UnsafeMutableRawPointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let raw = UnsafeRawPointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        return PointerFields(raw: raw, mutRaw: mutRaw, opaque: opaque, ptr: ptr, mutPtr: mutPtr)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_pointer(self.raw.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.mutRaw.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.opaque.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.ptr.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.mutPtr.bridgeJSLowerReturn())
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_PointerFields(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        var __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_raise_PointerFields()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PointerFields")
fileprivate func _bjs_struct_lower_PointerFields(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_PointerFields(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_raise_PointerFields")
fileprivate func _bjs_struct_raise_PointerFields() -> Int32
#else
fileprivate func _bjs_struct_raise_PointerFields() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_PointerFields_init")
@_cdecl("bjs_PointerFields_init")
public func _bjs_PointerFields_init(_ raw: UnsafeMutableRawPointer, _ mutRaw: UnsafeMutableRawPointer, _ opaque: UnsafeMutableRawPointer, _ ptr: UnsafeMutableRawPointer, _ mutPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PointerFields(raw: UnsafeRawPointer.bridgeJSLiftParameter(raw), mutRaw: UnsafeMutableRawPointer.bridgeJSLiftParameter(mutRaw), opaque: OpaquePointer.bridgeJSLiftParameter(opaque), ptr: UnsafePointer<UInt8>.bridgeJSLiftParameter(ptr), mutPtr: UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(mutPtr))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeUnsafeRawPointer")
@_cdecl("bjs_takeUnsafeRawPointer")
public func _bjs_takeUnsafeRawPointer(_ p: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeUnsafeRawPointer(_: UnsafeRawPointer.bridgeJSLiftParameter(p))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeUnsafeMutableRawPointer")
@_cdecl("bjs_takeUnsafeMutableRawPointer")
public func _bjs_takeUnsafeMutableRawPointer(_ p: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeUnsafeMutableRawPointer(_: UnsafeMutableRawPointer.bridgeJSLiftParameter(p))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeOpaquePointer")
@_cdecl("bjs_takeOpaquePointer")
public func _bjs_takeOpaquePointer(_ p: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeOpaquePointer(_: OpaquePointer.bridgeJSLiftParameter(p))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeUnsafePointer")
@_cdecl("bjs_takeUnsafePointer")
public func _bjs_takeUnsafePointer(_ p: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeUnsafePointer(_: UnsafePointer<UInt8>.bridgeJSLiftParameter(p))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeUnsafeMutablePointer")
@_cdecl("bjs_takeUnsafeMutablePointer")
public func _bjs_takeUnsafeMutablePointer(_ p: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeUnsafeMutablePointer(_: UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(p))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_returnUnsafeRawPointer")
@_cdecl("bjs_returnUnsafeRawPointer")
public func _bjs_returnUnsafeRawPointer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = returnUnsafeRawPointer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_returnUnsafeMutableRawPointer")
@_cdecl("bjs_returnUnsafeMutableRawPointer")
public func _bjs_returnUnsafeMutableRawPointer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = returnUnsafeMutableRawPointer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_returnOpaquePointer")
@_cdecl("bjs_returnOpaquePointer")
public func _bjs_returnOpaquePointer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = returnOpaquePointer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_returnUnsafePointer")
@_cdecl("bjs_returnUnsafePointer")
public func _bjs_returnUnsafePointer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = returnUnsafePointer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_returnUnsafeMutablePointer")
@_cdecl("bjs_returnUnsafeMutablePointer")
public func _bjs_returnUnsafeMutablePointer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = returnUnsafeMutablePointer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripPointerFields")
@_cdecl("bjs_roundTripPointerFields")
public func _bjs_roundTripPointerFields() -> Void {
    #if arch(wasm32)
    let ret = roundTripPointerFields(_: PointerFields.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}