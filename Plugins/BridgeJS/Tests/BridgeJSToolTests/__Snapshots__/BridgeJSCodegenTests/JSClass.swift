#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_returnAnimatable")
fileprivate func bjs_returnAnimatable() -> Int32
#else
fileprivate func bjs_returnAnimatable() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$returnAnimatable() throws(JSException) -> Animatable {
    let ret = bjs_returnAnimatable()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Animatable.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_init")
fileprivate func bjs_Greeter_init(_ name: Int32) -> Int32
#else
fileprivate func bjs_Greeter_init(_ name: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_name_get")
fileprivate func bjs_Greeter_name_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Greeter_name_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_age_get")
fileprivate func bjs_Greeter_age_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_Greeter_age_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_name_set")
fileprivate func bjs_Greeter_name_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Greeter_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_greet")
fileprivate func bjs_Greeter_greet(_ self: Int32) -> Int32
#else
fileprivate func bjs_Greeter_greet(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_changeName")
fileprivate func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) -> Void
#else
fileprivate func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Greeter_init(_ name: String) throws(JSException) -> JSObject {
    let nameValue = name.bridgeJSLowerParameter()
    let ret = bjs_Greeter_init(nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Greeter_name_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Greeter_name_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$Greeter_age_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Greeter_age_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$Greeter_name_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_Greeter_name_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$Greeter_greet(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Greeter_greet(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$Greeter_changeName(_ self: JSObject, _ name: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let nameValue = name.bridgeJSLowerParameter()
    bjs_Greeter_changeName(selfValue, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Animatable_animate")
fileprivate func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Animatable_getAnimations")
fileprivate func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Animatable_animate(_ self: JSObject, _ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let keyframesValue = keyframes.bridgeJSLowerParameter()
    let optionsValue = options.bridgeJSLowerParameter()
    let ret = bjs_Animatable_animate(selfValue, keyframesValue, optionsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Animatable_getAnimations(_ self: JSObject, _ options: JSObject) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let optionsValue = options.bridgeJSLowerParameter()
    let ret = bjs_Animatable_getAnimations(selfValue, optionsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}