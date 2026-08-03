#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_packageVersion_get")
fileprivate func bjs_packageVersion_get_extern() -> Int32
#else
fileprivate func bjs_packageVersion_get_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_packageVersion_get() -> Int32 {
    return bjs_packageVersion_get_extern()
}

func _$packageVersion_get() throws(JSException) -> String {
    let ret = bjs_packageVersion_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_localDefaultExport_get")
fileprivate func bjs_localDefaultExport_get_extern() -> Int32
#else
fileprivate func bjs_localDefaultExport_get_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_localDefaultExport_get() -> Int32 {
    return bjs_localDefaultExport_get_extern()
}

func _$localDefaultExport_get() throws(JSException) -> JSObject {
    let ret = bjs_localDefaultExport_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_nodeBasename")
fileprivate func bjs_nodeBasename_extern(_ pathBytes: Int32, _ pathLength: Int32) -> Int32
#else
fileprivate func bjs_nodeBasename_extern(_ pathBytes: Int32, _ pathLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_nodeBasename(_ pathBytes: Int32, _ pathLength: Int32) -> Int32 {
    return bjs_nodeBasename_extern(pathBytes, pathLength)
}

func _$nodeBasename(_ path: String) throws(JSException) -> String {
    let ret0 = path.bridgeJSWithLoweredParameter { (pathBytes, pathLength) in
        let ret = bjs_nodeBasename(pathBytes, pathLength)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_nodeDirname")
fileprivate func bjs_nodeDirname_extern(_ pathBytes: Int32, _ pathLength: Int32) -> Int32
#else
fileprivate func bjs_nodeDirname_extern(_ pathBytes: Int32, _ pathLength: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_nodeDirname(_ pathBytes: Int32, _ pathLength: Int32) -> Int32 {
    return bjs_nodeDirname_extern(pathBytes, pathLength)
}

func _$nodeDirname(_ path: String) throws(JSException) -> String {
    let ret0 = path.bridgeJSWithLoweredParameter { (pathBytes, pathLength) in
        let ret = bjs_nodeDirname(pathBytes, pathLength)
        return ret
    }
    let ret = ret0
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_callDefaultExport")
fileprivate func bjs_callDefaultExport_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_callDefaultExport_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_callDefaultExport(_ value: Int32) -> Int32 {
    return bjs_callDefaultExport_extern(value)
}

func _$callDefaultExport(_ value: Int) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_callDefaultExport(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ScopedFile_init")
fileprivate func bjs_ScopedFile_init_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_ScopedFile_init_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ScopedFile_init(_ value: Int32) -> Int32 {
    return bjs_ScopedFile_init_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ScopedFile_create_static")
fileprivate func bjs_ScopedFile_create_static_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_ScopedFile_create_static_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ScopedFile_create_static(_ value: Int32) -> Int32 {
    return bjs_ScopedFile_create_static_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ScopedFile_size_get")
fileprivate func bjs_ScopedFile_size_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_ScopedFile_size_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ScopedFile_size_get(_ self: Int32) -> Int32 {
    return bjs_ScopedFile_size_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ScopedFile_read")
fileprivate func bjs_ScopedFile_read_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_ScopedFile_read_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ScopedFile_read(_ self: Int32) -> Int32 {
    return bjs_ScopedFile_read_extern(self)
}

func _$ScopedFile_init(_ value: Int) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_ScopedFile_init(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ScopedFile_create(_ value: Int) throws(JSException) -> ScopedFile {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_ScopedFile_create_static(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ScopedFile.bridgeJSLiftReturn(ret)
}

func _$ScopedFile_size_get(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ScopedFile_size_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ScopedFile_read(_ self: JSObject) throws(JSException) -> Int {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ScopedFile_read(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}