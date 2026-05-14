@_expose(wasm, "bjs_asyncThrowsVoid")
@_cdecl("bjs_asyncThrowsVoid")
public func _bjs_asyncThrowsVoid() -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async { () async throws(JSException) in
        do {
            try await asyncThrowsVoid()
        } catch let error {
            throw error.bridgeJSLowerThrowAsync()
        }
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncThrowsWithResult")
@_cdecl("bjs_asyncThrowsWithResult")
public func _bjs_asyncThrowsWithResult() -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async { () async throws(JSException) -> JSValue in
        do {
            return try await asyncThrowsWithResult().jsValue
        } catch let error {
            throw error.bridgeJSLowerThrowAsync()
        }
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}