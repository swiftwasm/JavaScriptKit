// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_takeGreeter")
@_cdecl("bjs_takeGreeter")
public func _bjs_takeGreeter(greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    takeGreeter(greeter: Unmanaged<Greeter>.fromOpaque(greeter).takeUnretainedValue())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLen: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    let ret = Greeter(name: name)
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    var ret = Unmanaged<Greeter>.fromOpaque(_self).takeUnretainedValue().greet()
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameBytes: Int32, nameLen: Int32) -> Void {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    Unmanaged<Greeter>.fromOpaque(_self).takeUnretainedValue().changeName(name: name)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}