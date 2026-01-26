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
@_extern(wasm, module: "Check", name: "bjs_createWeirdClass")
fileprivate func bjs_createWeirdClass() -> Int32
#else
fileprivate func bjs_createWeirdClass() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createWeirdClass() throws(JSException) -> _Weird {
    let ret = bjs_createWeirdClass()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _Weird.bridgeJSLiftReturn(ret)
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
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_property_with_dashes_get")
fileprivate func bjs_WeirdNaming_property_with_dashes_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_WeirdNaming_property_with_dashes_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming__123invalidStart_get")
fileprivate func bjs_WeirdNaming__123invalidStart_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming__123invalidStart_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_property_with_spaces_get")
fileprivate func bjs_WeirdNaming_property_with_spaces_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_property_with_spaces_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming__specialChar_get")
fileprivate func bjs_WeirdNaming__specialChar_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_WeirdNaming__specialChar_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_constructor_get")
fileprivate func bjs_WeirdNaming_constructor_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_constructor_get(_ self: Int32) -> Int32 {
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
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_property_with_dashes_set")
fileprivate func bjs_WeirdNaming_property_with_dashes_set(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_WeirdNaming_property_with_dashes_set(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming__123invalidStart_set")
fileprivate func bjs_WeirdNaming__123invalidStart_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming__123invalidStart_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_property_with_spaces_set")
fileprivate func bjs_WeirdNaming_property_with_spaces_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_property_with_spaces_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming__specialChar_set")
fileprivate func bjs_WeirdNaming__specialChar_set(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_WeirdNaming__specialChar_set(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_constructor_set")
fileprivate func bjs_WeirdNaming_constructor_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_constructor_set(_ self: Int32, _ newValue: Int32) -> Void {
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

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_WeirdNaming_try")
fileprivate func bjs_WeirdNaming_try(_ self: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_try(_ self: Int32) -> Void {
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

func _$WeirdNaming_property_with_dashes_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_property_with_dashes_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming__123invalidStart_get(_ self: JSObject) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming__123invalidStart_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming_property_with_spaces_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_property_with_spaces_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming__specialChar_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming__specialChar_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$WeirdNaming_constructor_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_WeirdNaming_constructor_get(selfValue)
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

func _$WeirdNaming_property_with_dashes_set(_ self: JSObject, _ newValue: Double) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_property_with_dashes_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming__123invalidStart_set(_ self: JSObject, _ newValue: Bool) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming__123invalidStart_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming_property_with_spaces_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_property_with_spaces_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming__specialChar_set(_ self: JSObject, _ newValue: Double) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming__specialChar_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$WeirdNaming_constructor_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_WeirdNaming_constructor_set(selfValue, newValueValue)
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

func _$WeirdNaming_try(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_WeirdNaming_try(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs__Weird_init")
fileprivate func bjs__Weird_init() -> Int32
#else
fileprivate func bjs__Weird_init() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs__Weird_method_with_dashes")
fileprivate func bjs__Weird_method_with_dashes(_ self: Int32) -> Void
#else
fileprivate func bjs__Weird_method_with_dashes(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$_Weird_init() throws(JSException) -> JSObject {
    let ret = bjs__Weird_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$_Weird_method_with_dashes(_ self: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    bjs__Weird_method_with_dashes(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}