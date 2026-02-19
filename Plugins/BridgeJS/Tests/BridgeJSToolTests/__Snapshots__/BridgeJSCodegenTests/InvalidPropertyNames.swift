#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_createWeirdObject")
fileprivate func bjs_createWeirdObject_extern() -> Int32
#else
fileprivate func bjs_createWeirdObject_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_createWeirdObject() -> Int32 {
    return bjs_createWeirdObject_extern()
}

func _$createWeirdObject() throws(JSException) -> WeirdNaming {
    let ret = bjs_createWeirdObject()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return WeirdNaming.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_createWeirdClass")
fileprivate func bjs_createWeirdClass_extern() -> Int32
#else
fileprivate func bjs_createWeirdClass_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_createWeirdClass() -> Int32 {
    return bjs_createWeirdClass_extern()
}

func _$createWeirdClass() throws(JSException) -> _Weird {
    let ret = bjs_createWeirdClass()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _Weird.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_normalProperty_get")
fileprivate func bjs_WeirdNaming_normalProperty_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_normalProperty_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_normalProperty_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming_normalProperty_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_property_with_dashes_get")
fileprivate func bjs_WeirdNaming_property_with_dashes_get_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_WeirdNaming_property_with_dashes_get_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_property_with_dashes_get(_ self: Int32) -> Float64 {
    return bjs_WeirdNaming_property_with_dashes_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming__123invalidStart_get")
fileprivate func bjs_WeirdNaming__123invalidStart_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming__123invalidStart_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming__123invalidStart_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming__123invalidStart_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_property_with_spaces_get")
fileprivate func bjs_WeirdNaming_property_with_spaces_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_property_with_spaces_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_property_with_spaces_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming_property_with_spaces_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming__specialChar_get")
fileprivate func bjs_WeirdNaming__specialChar_get_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_WeirdNaming__specialChar_get_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming__specialChar_get(_ self: Int32) -> Float64 {
    return bjs_WeirdNaming__specialChar_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_constructor_get")
fileprivate func bjs_WeirdNaming_constructor_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_constructor_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_constructor_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming_constructor_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_for_get")
fileprivate func bjs_WeirdNaming_for_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_for_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_for_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming_for_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_Any_get")
fileprivate func bjs_WeirdNaming_Any_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_WeirdNaming_Any_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_Any_get(_ self: Int32) -> Int32 {
    return bjs_WeirdNaming_Any_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_normalProperty_set")
fileprivate func bjs_WeirdNaming_normalProperty_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_normalProperty_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_normalProperty_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming_normalProperty_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_property_with_dashes_set")
fileprivate func bjs_WeirdNaming_property_with_dashes_set_extern(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_WeirdNaming_property_with_dashes_set_extern(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_property_with_dashes_set(_ self: Int32, _ newValue: Float64) -> Void {
    return bjs_WeirdNaming_property_with_dashes_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming__123invalidStart_set")
fileprivate func bjs_WeirdNaming__123invalidStart_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming__123invalidStart_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming__123invalidStart_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming__123invalidStart_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_property_with_spaces_set")
fileprivate func bjs_WeirdNaming_property_with_spaces_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_property_with_spaces_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_property_with_spaces_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming_property_with_spaces_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming__specialChar_set")
fileprivate func bjs_WeirdNaming__specialChar_set_extern(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_WeirdNaming__specialChar_set_extern(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming__specialChar_set(_ self: Int32, _ newValue: Float64) -> Void {
    return bjs_WeirdNaming__specialChar_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_constructor_set")
fileprivate func bjs_WeirdNaming_constructor_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_constructor_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_constructor_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming_constructor_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_for_set")
fileprivate func bjs_WeirdNaming_for_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_for_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_for_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming_for_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_any_set")
fileprivate func bjs_WeirdNaming_any_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_any_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_any_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_WeirdNaming_any_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_as")
fileprivate func bjs_WeirdNaming_as_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_as_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_as(_ self: Int32) -> Void {
    return bjs_WeirdNaming_as_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WeirdNaming_try")
fileprivate func bjs_WeirdNaming_try_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_WeirdNaming_try_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WeirdNaming_try(_ self: Int32) -> Void {
    return bjs_WeirdNaming_try_extern(self)
}

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
@_extern(wasm, module: "TestModule", name: "bjs__Weird_init")
fileprivate func bjs__Weird_init_extern() -> Int32
#else
fileprivate func bjs__Weird_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs__Weird_init() -> Int32 {
    return bjs__Weird_init_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs__Weird_method_with_dashes")
fileprivate func bjs__Weird_method_with_dashes_extern(_ self: Int32) -> Void
#else
fileprivate func bjs__Weird_method_with_dashes_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs__Weird_method_with_dashes(_ self: Int32) -> Void {
    return bjs__Weird_method_with_dashes_extern(self)
}

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