#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createTS2Skeleton")
fileprivate func bjs_createTS2Skeleton() -> Int32
#else
fileprivate func bjs_createTS2Skeleton() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createTS2Skeleton() throws(JSException) -> TypeScriptProcessor {
    let ret = bjs_createTS2Skeleton()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return TypeScriptProcessor.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createCodeGenerator")
fileprivate func bjs_createCodeGenerator(_ format: Int32) -> Int32
#else
fileprivate func bjs_createCodeGenerator(_ format: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createCodeGenerator(_ format: String) throws(JSException) -> CodeGenerator {
    let formatValue = format.bridgeJSLowerParameter()
    let ret = bjs_createCodeGenerator(formatValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return CodeGenerator.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_version_get")
fileprivate func bjs_TypeScriptProcessor_version_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_TypeScriptProcessor_version_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_convert")
fileprivate func bjs_TypeScriptProcessor_convert(_ self: Int32, _ ts: Int32) -> Int32
#else
fileprivate func bjs_TypeScriptProcessor_convert(_ self: Int32, _ ts: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_validate")
fileprivate func bjs_TypeScriptProcessor_validate(_ self: Int32, _ ts: Int32) -> Int32
#else
fileprivate func bjs_TypeScriptProcessor_validate(_ self: Int32, _ ts: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$TypeScriptProcessor_version_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_TypeScriptProcessor_version_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$TypeScriptProcessor_convert(_ self: JSObject, _ ts: String) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let tsValue = ts.bridgeJSLowerParameter()
    let ret = bjs_TypeScriptProcessor_convert(selfValue, tsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$TypeScriptProcessor_validate(_ self: JSObject, _ ts: String) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let tsValue = ts.bridgeJSLowerParameter()
    let ret = bjs_TypeScriptProcessor_validate(selfValue, tsValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_CodeGenerator_outputFormat_get")
fileprivate func bjs_CodeGenerator_outputFormat_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_CodeGenerator_outputFormat_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_CodeGenerator_generate")
fileprivate func bjs_CodeGenerator_generate(_ self: Int32, _ input: Int32) -> Int32
#else
fileprivate func bjs_CodeGenerator_generate(_ self: Int32, _ input: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$CodeGenerator_outputFormat_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_CodeGenerator_outputFormat_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$CodeGenerator_generate(_ self: JSObject, _ input: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let inputValue = input.bridgeJSLowerParameter()
    let ret = bjs_CodeGenerator_generate(selfValue, inputValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}