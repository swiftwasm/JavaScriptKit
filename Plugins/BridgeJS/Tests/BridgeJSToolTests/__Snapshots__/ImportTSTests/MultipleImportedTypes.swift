#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createDatabaseConnection")
fileprivate func bjs_createDatabaseConnection(_ config: Int32) -> Int32
#else
fileprivate func bjs_createDatabaseConnection(_ config: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createDatabaseConnection(_ config: JSObject) throws(JSException) -> DatabaseConnection {
    let configValue = config.bridgeJSLowerParameter()
    let ret = bjs_createDatabaseConnection(configValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return DatabaseConnection.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createLogger")
fileprivate func bjs_createLogger(_ level: Int32) -> Int32
#else
fileprivate func bjs_createLogger(_ level: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$createLogger(_ level: String) throws(JSException) -> Logger {
    let levelValue = level.bridgeJSLowerParameter()
    let ret = bjs_createLogger(levelValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Logger.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_getConfigManager")
fileprivate func bjs_getConfigManager() -> Int32
#else
fileprivate func bjs_getConfigManager() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$getConfigManager() throws(JSException) -> ConfigManager {
    let ret = bjs_getConfigManager()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ConfigManager.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_isConnected_get")
fileprivate func bjs_DatabaseConnection_isConnected_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_DatabaseConnection_isConnected_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connectionTimeout_get")
fileprivate func bjs_DatabaseConnection_connectionTimeout_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_DatabaseConnection_connectionTimeout_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connectionTimeout_set")
fileprivate func bjs_DatabaseConnection_connectionTimeout_set(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_DatabaseConnection_connectionTimeout_set(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connect")
fileprivate func bjs_DatabaseConnection_connect(_ self: Int32, _ url: Int32) -> Void
#else
fileprivate func bjs_DatabaseConnection_connect(_ self: Int32, _ url: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_execute")
fileprivate func bjs_DatabaseConnection_execute(_ self: Int32, _ query: Int32) -> Int32
#else
fileprivate func bjs_DatabaseConnection_execute(_ self: Int32, _ query: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$DatabaseConnection_isConnected_get(_ self: JSObject) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_DatabaseConnection_isConnected_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

func _$DatabaseConnection_connectionTimeout_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_DatabaseConnection_connectionTimeout_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$DatabaseConnection_connectionTimeout_set(_ self: JSObject, _ newValue: Double) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_DatabaseConnection_connectionTimeout_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$DatabaseConnection_connect(_ self: JSObject, _ url: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let urlValue = url.bridgeJSLowerParameter()
    bjs_DatabaseConnection_connect(selfValue, urlValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$DatabaseConnection_execute(_ self: JSObject, _ query: String) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let queryValue = query.bridgeJSLowerParameter()
    let ret = bjs_DatabaseConnection_execute(selfValue, queryValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Logger_level_get")
fileprivate func bjs_Logger_level_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Logger_level_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Logger_log")
fileprivate func bjs_Logger_log(_ self: Int32, _ message: Int32) -> Void
#else
fileprivate func bjs_Logger_log(_ self: Int32, _ message: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_Logger_error")
fileprivate func bjs_Logger_error(_ self: Int32, _ message: Int32, _ error: Int32) -> Void
#else
fileprivate func bjs_Logger_error(_ self: Int32, _ message: Int32, _ error: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Logger_level_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Logger_level_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$Logger_log(_ self: JSObject, _ message: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let messageValue = message.bridgeJSLowerParameter()
    bjs_Logger_log(selfValue, messageValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$Logger_error(_ self: JSObject, _ message: String, _ error: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let messageValue = message.bridgeJSLowerParameter()
    let errorValue = error.bridgeJSLowerParameter()
    bjs_Logger_error(selfValue, messageValue, errorValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ConfigManager_configPath_get")
fileprivate func bjs_ConfigManager_configPath_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_ConfigManager_configPath_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ConfigManager_get")
fileprivate func bjs_ConfigManager_get(_ self: Int32, _ key: Int32) -> Int32
#else
fileprivate func bjs_ConfigManager_get(_ self: Int32, _ key: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_ConfigManager_set")
fileprivate func bjs_ConfigManager_set(_ self: Int32, _ key: Int32, _ value: Int32) -> Void
#else
fileprivate func bjs_ConfigManager_set(_ self: Int32, _ key: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$ConfigManager_configPath_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ConfigManager_configPath_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$ConfigManager_get(_ self: JSObject, _ key: String) throws(JSException) -> JSObject {
    let selfValue = self.bridgeJSLowerParameter()
    let keyValue = key.bridgeJSLowerParameter()
    let ret = bjs_ConfigManager_get(selfValue, keyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ConfigManager_set(_ self: JSObject, _ key: String, _ value: JSObject) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let keyValue = key.bridgeJSLowerParameter()
    let valueValue = value.bridgeJSLowerParameter()
    bjs_ConfigManager_set(selfValue, keyValue, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}