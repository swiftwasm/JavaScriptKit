#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncReturnVoid")
fileprivate func bjs_asyncReturnVoid_extern() -> Int32
#else
fileprivate func bjs_asyncReturnVoid_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncReturnVoid() -> Int32 {
    return bjs_asyncReturnVoid_extern()
}

func _$asyncReturnVoid() async throws(JSException) -> Void {
    let ret = bjs_asyncReturnVoid()
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    _ = try await promise.value
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripInt")
fileprivate func bjs_asyncRoundTripInt_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripInt_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripInt(_ v: Int32) -> Int32 {
    return bjs_asyncRoundTripInt_extern(v)
}

func _$asyncRoundTripInt(_ v: Int) async throws(JSException) -> Int {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripInt(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    let resolved = try await promise.value
    return Int(resolved.number!)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripString")
fileprivate func bjs_asyncRoundTripString_extern(_ vBytes: Int32, _ vLength: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripString_extern(_ vBytes: Int32, _ vLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripString(_ vBytes: Int32, _ vLength: Int32) -> Int32 {
    return bjs_asyncRoundTripString_extern(vBytes, vLength)
}

func _$asyncRoundTripString(_ v: String) async throws(JSException) -> String {
    let ret0 = v.bridgeJSWithLoweredParameter { (vBytes, vLength) in
        let ret = bjs_asyncRoundTripString(vBytes, vLength)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    let resolved = try await promise.value
    return resolved.string!
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripBool")
fileprivate func bjs_asyncRoundTripBool_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripBool_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
    return bjs_asyncRoundTripBool_extern(v)
}

func _$asyncRoundTripBool(_ v: Bool) async throws(JSException) -> Bool {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripBool(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    let resolved = try await promise.value
    return resolved.boolean!
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripDouble")
fileprivate func bjs_asyncRoundTripDouble_extern(_ v: Float64) -> Int32
#else
fileprivate func bjs_asyncRoundTripDouble_extern(_ v: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
    return bjs_asyncRoundTripDouble_extern(v)
}

func _$asyncRoundTripDouble(_ v: Double) async throws(JSException) -> Double {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripDouble(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    let resolved = try await promise.value
    return Double(resolved.number!)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripJSObject")
fileprivate func bjs_asyncRoundTripJSObject_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_asyncRoundTripJSObject_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
    return bjs_asyncRoundTripJSObject_extern(v)
}

func _$asyncRoundTripJSObject(_ v: JSObject) async throws(JSException) -> JSObject {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_asyncRoundTripJSObject(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    let promise = JSPromise(unsafelyWrapping: JSObject(id: UInt32(bitPattern: ret)))
    let resolved = try await promise.value
    return resolved.object!
}