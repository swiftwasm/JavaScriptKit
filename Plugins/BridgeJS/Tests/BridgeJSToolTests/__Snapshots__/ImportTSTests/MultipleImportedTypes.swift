// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "Check", name: "bjs_createDatabaseConnection")
fileprivate func bjs_createDatabaseConnection(_ config: Int32) -> Int32
#else
fileprivate func bjs_createDatabaseConnection(_ config: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func createDatabaseConnection(_ config: JSObject) throws(JSException) -> DatabaseConnection {
    let ret = bjs_createDatabaseConnection(config.bridgeJSLowerParameter())
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

func createLogger(_ level: String) throws(JSException) -> Logger {
    let ret = bjs_createLogger(level.bridgeJSLowerParameter())
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

func getConfigManager() throws(JSException) -> ConfigManager {
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

struct DatabaseConnection: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var isConnected: Bool {
        get throws(JSException) {
            let ret = bjs_DatabaseConnection_isConnected_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Bool.bridgeJSLiftReturn(ret)
        }
    }

    var connectionTimeout: Double {
        get throws(JSException) {
            let ret = bjs_DatabaseConnection_connectionTimeout_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Double.bridgeJSLiftReturn(ret)
        }
    }

    func setConnectionTimeout(_ newValue: Double) throws(JSException) -> Void {
        bjs_DatabaseConnection_connectionTimeout_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func connect(_ url: String) throws(JSException) -> Void {
        bjs_DatabaseConnection_connect(self.bridgeJSLowerParameter(), url.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func execute(_ query: String) throws(JSException) -> JSObject {
        let ret = bjs_DatabaseConnection_execute(self.bridgeJSLowerParameter(), query.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

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

struct Logger: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var level: String {
        get throws(JSException) {
            let ret = bjs_Logger_level_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func log(_ message: String) throws(JSException) -> Void {
        bjs_Logger_log(self.bridgeJSLowerParameter(), message.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func error(_ message: String, _ error: JSObject) throws(JSException) -> Void {
        bjs_Logger_error(self.bridgeJSLowerParameter(), message.bridgeJSLowerParameter(), error.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
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

struct ConfigManager: _JSBridgedClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var configPath: String {
        get throws(JSException) {
            let ret = bjs_ConfigManager_configPath_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func get(_ key: String) throws(JSException) -> JSObject {
        let ret = bjs_ConfigManager_get(self.bridgeJSLowerParameter(), key.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

    func set(_ key: String, _ value: JSObject) throws(JSException) -> Void {
        bjs_ConfigManager_set(self.bridgeJSLowerParameter(), key.bridgeJSLowerParameter(), value.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}