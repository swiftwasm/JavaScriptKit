#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_moduleVersion_get")
fileprivate func bjs_moduleVersion_get_extern() -> Int32
#else
fileprivate func bjs_moduleVersion_get_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_moduleVersion_get() -> Int32 {
    return bjs_moduleVersion_get_extern()
}

func _$moduleVersion_get() throws(JSException) -> String {
    let ret = bjs_moduleVersion_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_moduleAdd")
fileprivate func bjs_moduleAdd_extern(_ lhs: Int32, _ rhs: Int32) -> Int32
#else
fileprivate func bjs_moduleAdd_extern(_ lhs: Int32, _ rhs: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_moduleAdd(_ lhs: Int32, _ rhs: Int32) -> Int32 {
    return bjs_moduleAdd_extern(lhs, rhs)
}

func _$moduleAdd(_ lhs: Int, _ rhs: Int) throws(JSException) -> Int {
    let lhsValue = lhs.bridgeJSLowerParameter()
    let rhsValue = rhs.bridgeJSLowerParameter()
    let ret = bjs_moduleAdd(lhsValue, rhsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_moduleRenamed")
fileprivate func bjs_moduleRenamed_extern() -> Int32
#else
fileprivate func bjs_moduleRenamed_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_moduleRenamed() -> Int32 {
    return bjs_moduleRenamed_extern()
}

func _$moduleRenamed() throws(JSException) -> String {
    let ret = bjs_moduleRenamed()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ModuleCounter_init")
fileprivate func bjs_ModuleCounter_init_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_ModuleCounter_init_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ModuleCounter_init(_ value: Int32) -> Int32 {
    return bjs_ModuleCounter_init_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ModuleCounter_create_static")
fileprivate func bjs_ModuleCounter_create_static_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_ModuleCounter_create_static_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ModuleCounter_create_static(_ value: Int32) -> Int32 {
    return bjs_ModuleCounter_create_static_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ModuleCounter_value_get")
fileprivate func bjs_ModuleCounter_value_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_ModuleCounter_value_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ModuleCounter_value_get(_ self: Int32) -> Int32 {
    return bjs_ModuleCounter_value_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ModuleCounter_value_set")
fileprivate func bjs_ModuleCounter_value_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_ModuleCounter_value_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ModuleCounter_value_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_ModuleCounter_value_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ModuleCounter_increment")
fileprivate func bjs_ModuleCounter_increment_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_ModuleCounter_increment_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ModuleCounter_increment(_ self: Int32) -> Int32 {
    return bjs_ModuleCounter_increment_extern(self)
}

func _$ModuleCounter_init(_ value: Int) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_ModuleCounter_init(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ModuleCounter_create(_ value: Int) throws(JSException) -> ModuleCounter {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_ModuleCounter_create_static(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ModuleCounter.bridgeJSLiftReturn(ret)
}

func _$ModuleCounter_value_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ModuleCounter_value_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ModuleCounter_value_set(_ self: JSObject, _ newValue: Int) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_ModuleCounter_value_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ModuleCounter_increment(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ModuleCounter_increment(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}