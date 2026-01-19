#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createArrayBuffer")
fileprivate func bjs_createArrayBuffer() -> Int32
#else
fileprivate func bjs_createArrayBuffer() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createArrayBuffer() throws(JSException) -> ArrayBufferLike {
    let ret = bjs_createArrayBuffer()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ArrayBufferLike.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createWeirdObject")
fileprivate func bjs_createWeirdObject() -> Int32
#else
fileprivate func bjs_createWeirdObject() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createWeirdObject() throws(JSException) -> WeirdNaming {
    let ret = bjs_createWeirdObject()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return WeirdNaming.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ArrayBufferLike_byteLength_get")
fileprivate func bjs_ArrayBufferLike_byteLength_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_ArrayBufferLike_byteLength_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ArrayBufferLike_slice")
fileprivate func bjs_ArrayBufferLike_slice(_ self: Int32, _ begin: Float64, _ end: Float64) -> Int32
#else
fileprivate func bjs_ArrayBufferLike_slice(_ self: Int32, _ begin: Float64, _ end: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$ArrayBufferLike_byteLength_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ArrayBufferLike_byteLength_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$ArrayBufferLike_slice(_ self: JSObject, _ begin: Double, _ end: Double) throws(JSException) -> ArrayBufferLike {
    let selfValue = self.bridgeJSLowerParameter()
    let beginValue = begin.bridgeJSLowerParameter()
    let endValue = end.bridgeJSLowerParameter()
    let ret = bjs_ArrayBufferLike_slice(selfValue, beginValue, endValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ArrayBufferLike.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_normalProperty_get")
fileprivate func bjs_WeirdNaming_normalProperty_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_normalProperty_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_for_get")
fileprivate func bjs_WeirdNaming_for_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_for_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_Any_get")
fileprivate func bjs_WeirdNaming_Any_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_Any_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_normalProperty_set")
fileprivate func bjs_WeirdNaming_normalProperty_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_normalProperty_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_for_set")
fileprivate func bjs_WeirdNaming_for_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_for_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_any_set")
fileprivate func bjs_WeirdNaming_any_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_any_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_as")
fileprivate func bjs_WeirdNaming_as(_ self: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_as(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$WeirdNaming_normalProperty_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_normalProperty_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming_for_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_for_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming_Any_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_Any_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming_normalProperty_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_normalProperty_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming_for_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_for_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming_any_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_any_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming_as(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WeirdNaming_as(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}