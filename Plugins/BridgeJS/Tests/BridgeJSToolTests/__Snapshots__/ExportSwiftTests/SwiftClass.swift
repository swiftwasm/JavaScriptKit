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
    takeGreeter(greeter: Greeter.bridgeJSLiftParameter(greeter))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PublicGreeter_deinit")
@_cdecl("bjs_PublicGreeter_deinit")
public func _bjs_PublicGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PublicGreeter>.fromOpaque(pointer).release()
}

extension PublicGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_PublicGreeter_wrap")
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PublicGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PackageGreeter_deinit")
@_cdecl("bjs_PackageGreeter_deinit")
public func _bjs_PackageGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PackageGreeter>.fromOpaque(pointer).release()
}

extension PackageGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    package var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_PackageGreeter_wrap")
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PackageGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}