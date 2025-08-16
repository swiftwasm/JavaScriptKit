// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

@_expose(wasm, "bjs_roundTripVoid")
@_cdecl("bjs_roundTripVoid")
public func _bjs_roundTripVoid() -> Void {
    #if arch(wasm32)
    roundTripVoid()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt")
@_cdecl("bjs_roundTripInt")
public func _bjs_roundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt(v: Int(v))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(v: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = roundTripFloat(v: v)
    return Float32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(v: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = roundTripDouble(v: v)
    return Float64(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripBool(v: v == 1)
    return Int32(ret ? 1 : 0)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(vBytes: Int32, vLen: Int32) -> Void {
    #if arch(wasm32)
    let v = String(unsafeUninitializedCapacity: Int(vLen)) { b in
        _swift_js_init_memory(vBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(vLen)
    }
    var ret = roundTripString(v: v)
    return ret.withUTF8 { ptr in
        _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftHeapObject")
@_cdecl("bjs_roundTripSwiftHeapObject")
public func _bjs_roundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripSwiftHeapObject(v: Unmanaged<Greeter>.fromOpaque(v).takeUnretainedValue())
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObject")
@_cdecl("bjs_roundTripJSObject")
public func _bjs_roundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSObject(v: JSObject(id: UInt32(bitPattern: v)))
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsSwiftError")
@_cdecl("bjs_throwsSwiftError")
public func _bjs_throwsSwiftError(shouldThrow: Int32) -> Void {
    #if arch(wasm32)
    do {
        try throwsSwiftError(shouldThrow: shouldThrow == 1)
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithIntResult")
@_cdecl("bjs_throwsWithIntResult")
public func _bjs_throwsWithIntResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithIntResult()
        return Int32(ret)
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithStringResult")
@_cdecl("bjs_throwsWithStringResult")
public func _bjs_throwsWithStringResult() -> Void {
    #if arch(wasm32)
    do {
        var ret = try throwsWithStringResult()
        return ret.withUTF8 { ptr in
            _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
        }
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithBoolResult")
@_cdecl("bjs_throwsWithBoolResult")
public func _bjs_throwsWithBoolResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithBoolResult()
        return Int32(ret ? 1 : 0)
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithFloatResult")
@_cdecl("bjs_throwsWithFloatResult")
public func _bjs_throwsWithFloatResult() -> Float32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithFloatResult()
        return Float32(ret)
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithDoubleResult")
@_cdecl("bjs_throwsWithDoubleResult")
public func _bjs_throwsWithDoubleResult() -> Float64 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithDoubleResult()
        return Float64(ret)
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithSwiftHeapObjectResult")
@_cdecl("bjs_throwsWithSwiftHeapObjectResult")
public func _bjs_throwsWithSwiftHeapObjectResult() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let ret = try throwsWithSwiftHeapObjectResult()
        return Unmanaged.passRetained(ret).toOpaque()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithJSObjectResult")
@_cdecl("bjs_throwsWithJSObjectResult")
public func _bjs_throwsWithJSObjectResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithJSObjectResult()
        return _swift_js_retain(Int32(bitPattern: ret.id))
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripVoid")
@_cdecl("bjs_asyncRoundTripVoid")
public func _bjs_asyncRoundTripVoid() -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        await asyncRoundTripVoid()
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripInt")
@_cdecl("bjs_asyncRoundTripInt")
public func _bjs_asyncRoundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripInt(v: Int(v)).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripFloat")
@_cdecl("bjs_asyncRoundTripFloat")
public func _bjs_asyncRoundTripFloat(v: Float32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripFloat(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripDouble")
@_cdecl("bjs_asyncRoundTripDouble")
public func _bjs_asyncRoundTripDouble(v: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripDouble(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripBool")
@_cdecl("bjs_asyncRoundTripBool")
public func _bjs_asyncRoundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripBool(v: v == 1).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripString")
@_cdecl("bjs_asyncRoundTripString")
public func _bjs_asyncRoundTripString(vBytes: Int32, vLen: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        let v = String(unsafeUninitializedCapacity: Int(vLen)) { b in
            _swift_js_init_memory(vBytes, b.baseAddress.unsafelyUnwrapped)
            return Int(vLen)
        }
        return await asyncRoundTripString(v: v).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripSwiftHeapObject")
@_cdecl("bjs_asyncRoundTripSwiftHeapObject")
public func _bjs_asyncRoundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripSwiftHeapObject(v: Unmanaged<Greeter>.fromOpaque(v).takeUnretainedValue()).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripJSObject")
@_cdecl("bjs_asyncRoundTripJSObject")
public func _bjs_asyncRoundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripJSObject(v: JSObject(id: UInt32(bitPattern: v))).jsValue
    } .jsObject
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeGreeter")
@_cdecl("bjs_takeGreeter")
public func _bjs_takeGreeter(g: UnsafeMutableRawPointer, nameBytes: Int32, nameLen: Int32) -> Void {
    #if arch(wasm32)
    let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
        _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
        return Int(nameLen)
    }
    takeGreeter(g: Unmanaged<Greeter>.fromOpaque(g).takeUnretainedValue(), name: name)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createCalculator")
@_cdecl("bjs_createCalculator")
public func _bjs_createCalculator() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createCalculator()
    return Unmanaged.passRetained(ret).toOpaque()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_useCalculator")
@_cdecl("bjs_useCalculator")
public func _bjs_useCalculator(calc: UnsafeMutableRawPointer, x: Int32, y: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = useCalculator(calc: Unmanaged<Calculator>.fromOpaque(calc).takeUnretainedValue(), x: Int(x), y: Int(y))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testGreeterToJSValue")
@_cdecl("bjs_testGreeterToJSValue")
public func _bjs_testGreeterToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testGreeterToJSValue()
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testCalculatorToJSValue")
@_cdecl("bjs_testCalculatorToJSValue")
public func _bjs_testCalculatorToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testCalculatorToJSValue()
    return _swift_js_retain(Int32(bitPattern: ret.id))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSwiftClassAsJSValue")
@_cdecl("bjs_testSwiftClassAsJSValue")
public func _bjs_testSwiftClassAsJSValue(greeter: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = testSwiftClassAsJSValue(greeter: Unmanaged<Greeter>.fromOpaque(greeter).takeUnretainedValue())
    return _swift_js_retain(Int32(bitPattern: ret.id))
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

extension Greeter: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Calculator_square")
@_cdecl("bjs_Calculator_square")
public func _bjs_Calculator_square(_self: UnsafeMutableRawPointer, value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<Calculator>.fromOpaque(_self).takeUnretainedValue().square(value: Int(value))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_add")
@_cdecl("bjs_Calculator_add")
public func _bjs_Calculator_add(_self: UnsafeMutableRawPointer, a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Unmanaged<Calculator>.fromOpaque(_self).takeUnretainedValue().add(a: Int(a), b: Int(b))
    return Int32(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_deinit")
@_cdecl("bjs_Calculator_deinit")
public func _bjs_Calculator_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Calculator>.fromOpaque(pointer).release()
}

extension Calculator: ConvertibleToJSValue {
    var jsValue: JSValue {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Calculator_wrap")
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Calculator_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}