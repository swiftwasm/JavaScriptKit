#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_StaticBox_create_static")
fileprivate func bjs_StaticBox_create_static_extern(_ value: Float64) -> Int32
#else
fileprivate func bjs_StaticBox_create_static_extern(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_create_static(_ value: Float64) -> Int32 {
    return bjs_StaticBox_create_static_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_StaticBox_value_static")
fileprivate func bjs_StaticBox_value_static_extern() -> Float64
#else
fileprivate func bjs_StaticBox_value_static_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_value_static() -> Float64 {
    return bjs_StaticBox_value_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_StaticBox_makeDefault_static")
fileprivate func bjs_StaticBox_makeDefault_static_extern() -> Int32
#else
fileprivate func bjs_StaticBox_makeDefault_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_makeDefault_static() -> Int32 {
    return bjs_StaticBox_makeDefault_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_StaticBox_dashed_static")
fileprivate func bjs_StaticBox_dashed_static_extern() -> Int32
#else
fileprivate func bjs_StaticBox_dashed_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_dashed_static() -> Int32 {
    return bjs_StaticBox_dashed_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_StaticBox_value")
fileprivate func bjs_StaticBox_value_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_StaticBox_value_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_value(_ self: Int32) -> Float64 {
    return bjs_StaticBox_value_extern(self)
}

func _$StaticBox_create(_ value: Double) throws(JSException) -> StaticBox {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_StaticBox_create_static(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_value() throws(JSException) -> Double {
    let ret = bjs_StaticBox_value_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$StaticBox_makeDefault() throws(JSException) -> StaticBox {
    let ret = bjs_StaticBox_makeDefault_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_dashed() throws(JSException) -> StaticBox {
    let ret = bjs_StaticBox_dashed_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_value(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_StaticBox_value(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithCtor_init")
fileprivate func bjs_WithCtor_init_extern(_ value: Float64) -> Int32
#else
fileprivate func bjs_WithCtor_init_extern(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithCtor_init(_ value: Float64) -> Int32 {
    return bjs_WithCtor_init_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_WithCtor_create_static")
fileprivate func bjs_WithCtor_create_static_extern(_ value: Float64) -> Int32
#else
fileprivate func bjs_WithCtor_create_static_extern(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_WithCtor_create_static(_ value: Float64) -> Int32 {
    return bjs_WithCtor_create_static_extern(value)
}

func _$WithCtor_init(_ value: Double) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_WithCtor_init(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$WithCtor_create(_ value: Double) throws(JSException) -> WithCtor {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_WithCtor_create_static(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return WithCtor.bridgeJSLiftReturn(ret)
}