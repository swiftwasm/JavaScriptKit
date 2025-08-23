// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func createTS2Skeleton() throws(JSException) -> TypeScriptProcessor {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_createTS2Skeleton")
    func bjs_createTS2Skeleton() -> Int32
    #else
    func bjs_createTS2Skeleton() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_createTS2Skeleton()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return TypeScriptProcessor(takingThis: ret)
}

func createCodeGenerator(_ format: String) throws(JSException) -> CodeGenerator {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_createCodeGenerator")
    func bjs_createCodeGenerator(_ format: Int32) -> Int32
    #else
    func bjs_createCodeGenerator(_ format: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_createCodeGenerator(format.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return CodeGenerator(takingThis: ret)
}

struct TypeScriptProcessor {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    var version: String {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_version_get")
            func bjs_TypeScriptProcessor_version_get(_ self: Int32) -> Int32
            #else
            func bjs_TypeScriptProcessor_version_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_TypeScriptProcessor_version_get(self.this.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func convert(_ ts: String) throws(JSException) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_convert")
        func bjs_TypeScriptProcessor_convert(_ self: Int32, _ ts: Int32) -> Int32
        #else
        func bjs_TypeScriptProcessor_convert(_ self: Int32, _ ts: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_TypeScriptProcessor_convert(self.this.bridgeJSLowerParameter(), ts.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return String.bridgeJSLiftReturn(ret)
    }

    func validate(_ ts: String) throws(JSException) -> Bool {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_TypeScriptProcessor_validate")
        func bjs_TypeScriptProcessor_validate(_ self: Int32, _ ts: Int32) -> Int32
        #else
        func bjs_TypeScriptProcessor_validate(_ self: Int32, _ ts: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_TypeScriptProcessor_validate(self.this.bridgeJSLowerParameter(), ts.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return Bool.bridgeJSLiftReturn(ret)
    }

}

struct CodeGenerator {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
    }

    var outputFormat: String {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_CodeGenerator_outputFormat_get")
            func bjs_CodeGenerator_outputFormat_get(_ self: Int32) -> Int32
            #else
            func bjs_CodeGenerator_outputFormat_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_CodeGenerator_outputFormat_get(self.this.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func generate(_ input: JSObject) throws(JSException) -> String {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_CodeGenerator_generate")
        func bjs_CodeGenerator_generate(_ self: Int32, _ input: Int32) -> Int32
        #else
        func bjs_CodeGenerator_generate(_ self: Int32, _ input: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_CodeGenerator_generate(self.this.bridgeJSLowerParameter(), input.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return String.bridgeJSLiftReturn(ret)
    }

}