#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_returnAnimatable")
fileprivate func bjs_returnAnimatable_extern() -> Int32
#else
fileprivate func bjs_returnAnimatable_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_returnAnimatable() -> Int32 {
    return bjs_returnAnimatable_extern()
}

func _$returnAnimatable() throws(JSException) -> Animatable {
    let ret = bjs_returnAnimatable()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Animatable.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_init")
fileprivate func bjs_Greeter_init_extern(_ name: Int32) -> Int32
#else
fileprivate func bjs_Greeter_init_extern(_ name: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_init(_ name: Int32) -> Int32 {
    return bjs_Greeter_init_extern(name)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_name_get")
fileprivate func bjs_Greeter_name_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Greeter_name_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_name_get(_ self: Int32) -> Int32 {
    return bjs_Greeter_name_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_age_get")
fileprivate func bjs_Greeter_age_get_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_Greeter_age_get_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_age_get(_ self: Int32) -> Float64 {
    return bjs_Greeter_age_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_name_set")
fileprivate func bjs_Greeter_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Greeter_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_Greeter_name_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_greet")
fileprivate func bjs_Greeter_greet_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Greeter_greet_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_greet(_ self: Int32) -> Int32 {
    return bjs_Greeter_greet_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Greeter_changeName")
fileprivate func bjs_Greeter_changeName_extern(_ self: Int32, _ name: Int32) -> Void
#else
fileprivate func bjs_Greeter_changeName_extern(_ self: Int32, _ name: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Greeter_changeName(_ self: Int32, _ name: Int32) -> Void {
    return bjs_Greeter_changeName_extern(self, name)
}

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
fileprivate func bjs_Animatable_animate_extern(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_animate_extern(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animatable_animate(_ self: Int32, _ keyframes: Int32, _ options: Int32) -> Int32 {
    return bjs_Animatable_animate_extern(self, keyframes, options)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Animatable_getAnimations")
fileprivate func bjs_Animatable_getAnimations_extern(_ self: Int32, _ options: Int32) -> Int32
#else
fileprivate func bjs_Animatable_getAnimations_extern(_ self: Int32, _ options: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animatable_getAnimations(_ self: Int32, _ options: Int32) -> Int32 {
    return bjs_Animatable_getAnimations_extern(self, options)
}

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