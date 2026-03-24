#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncReturnVoid")
fileprivate func bjs_asyncReturnVoid_extern(_ continuationPtr: Int32) -> Void
#else
fileprivate func bjs_asyncReturnVoid_extern(_ continuationPtr: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncReturnVoid(_ continuationPtr: Int32) -> Void {
    return bjs_asyncReturnVoid_extern(continuationPtr)
}

func _$asyncReturnVoid() async throws(JSException) -> Void {
    _ = try await _bjs_awaitPromise { continuationPtr in
        bjs_asyncReturnVoid(continuationPtr)
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripInt")
fileprivate func bjs_asyncRoundTripInt_extern(_ continuationPtr: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripInt_extern(_ continuationPtr: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripInt(_ continuationPtr: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripInt_extern(continuationPtr, v)
}

func _$asyncRoundTripInt(_ v: Int) async throws(JSException) -> Int {
    let resolved = try await _bjs_awaitPromise { continuationPtr in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripInt(continuationPtr, vValue)
    }
    return Int(resolved.number!)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripString")
fileprivate func bjs_asyncRoundTripString_extern(_ continuationPtr: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripString_extern(_ continuationPtr: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripString(_ continuationPtr: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    return bjs_asyncRoundTripString_extern(continuationPtr, vBytes, vLength)
}

func _$asyncRoundTripString(_ v: String) async throws(JSException) -> String {
    let resolved = try await _bjs_awaitPromise { continuationPtr in
        v.bridgeJSWithLoweredParameter { (vBytes, vLength) in
            bjs_asyncRoundTripString(continuationPtr, vBytes, vLength)
        }
    }
    return resolved.string!
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripBool")
fileprivate func bjs_asyncRoundTripBool_extern(_ continuationPtr: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripBool_extern(_ continuationPtr: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripBool(_ continuationPtr: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripBool_extern(continuationPtr, v)
}

func _$asyncRoundTripBool(_ v: Bool) async throws(JSException) -> Bool {
    let resolved = try await _bjs_awaitPromise { continuationPtr in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripBool(continuationPtr, vValue)
    }
    return resolved.boolean!
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripDouble")
fileprivate func bjs_asyncRoundTripDouble_extern(_ continuationPtr: Int32, _ v: Float64) -> Void
#else
fileprivate func bjs_asyncRoundTripDouble_extern(_ continuationPtr: Int32, _ v: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripDouble(_ continuationPtr: Int32, _ v: Float64) -> Void {
    return bjs_asyncRoundTripDouble_extern(continuationPtr, v)
}

func _$asyncRoundTripDouble(_ v: Double) async throws(JSException) -> Double {
    let resolved = try await _bjs_awaitPromise { continuationPtr in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripDouble(continuationPtr, vValue)
    }
    return Double(resolved.number!)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_asyncRoundTripJSObject")
fileprivate func bjs_asyncRoundTripJSObject_extern(_ continuationPtr: Int32, _ v: Int32) -> Void
#else
fileprivate func bjs_asyncRoundTripJSObject_extern(_ continuationPtr: Int32, _ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_asyncRoundTripJSObject(_ continuationPtr: Int32, _ v: Int32) -> Void {
    return bjs_asyncRoundTripJSObject_extern(continuationPtr, v)
}

func _$asyncRoundTripJSObject(_ v: JSObject) async throws(JSException) -> JSObject {
    let resolved = try await _bjs_awaitPromise { continuationPtr in
        let vValue = v.bridgeJSLowerParameter()
        bjs_asyncRoundTripJSObject(continuationPtr, vValue)
    }
    return resolved.object!
}