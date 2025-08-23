// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

func createDatabaseConnection(_ config: JSObject) throws(JSException) -> DatabaseConnection {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_createDatabaseConnection")
    func bjs_createDatabaseConnection(_ config: Int32) -> Int32
    #else
    func bjs_createDatabaseConnection(_ config: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_createDatabaseConnection(config.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return DatabaseConnection.bridgeJSLiftReturn(ret)
}

func createLogger(_ level: String) throws(JSException) -> Logger {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_createLogger")
    func bjs_createLogger(_ level: Int32) -> Int32
    #else
    func bjs_createLogger(_ level: Int32) -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_createLogger(level.bridgeJSLowerParameter())
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Logger.bridgeJSLiftReturn(ret)
}

func getConfigManager() throws(JSException) -> ConfigManager {
    #if arch(wasm32)
    @_extern(wasm, module: "Check", name: "bjs_getConfigManager")
    func bjs_getConfigManager() -> Int32
    #else
    func bjs_getConfigManager() -> Int32 {
        fatalError("Only available on WebAssembly")
    }
    #endif
    let ret = bjs_getConfigManager()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ConfigManager.bridgeJSLiftReturn(ret)
}

struct DatabaseConnection: _BridgedJSClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var isConnected: Bool {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_isConnected_get")
            func bjs_DatabaseConnection_isConnected_get(_ self: Int32) -> Int32
            #else
            func bjs_DatabaseConnection_isConnected_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_DatabaseConnection_isConnected_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Bool.bridgeJSLiftReturn(ret)
        }
    }

    var connectionTimeout: Double {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connectionTimeout_get")
            func bjs_DatabaseConnection_connectionTimeout_get(_ self: Int32) -> Float64
            #else
            func bjs_DatabaseConnection_connectionTimeout_get(_ self: Int32) -> Float64 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_DatabaseConnection_connectionTimeout_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Double.bridgeJSLiftReturn(ret)
        }
    }

    func setConnectionTimeout(_ newValue: Double) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connectionTimeout_set")
        func bjs_DatabaseConnection_connectionTimeout_set(_ self: Int32, _ newValue: Float64) -> Void
        #else
        func bjs_DatabaseConnection_connectionTimeout_set(_ self: Int32, _ newValue: Float64) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_DatabaseConnection_connectionTimeout_set(self.bridgeJSLowerParameter(), newValue.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func connect(_ url: String) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_connect")
        func bjs_DatabaseConnection_connect(_ self: Int32, _ url: Int32) -> Void
        #else
        func bjs_DatabaseConnection_connect(_ self: Int32, _ url: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_DatabaseConnection_connect(self.bridgeJSLowerParameter(), url.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func execute(_ query: String) throws(JSException) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_DatabaseConnection_execute")
        func bjs_DatabaseConnection_execute(_ self: Int32, _ query: Int32) -> Int32
        #else
        func bjs_DatabaseConnection_execute(_ self: Int32, _ query: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_DatabaseConnection_execute(self.bridgeJSLowerParameter(), query.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

}

struct Logger: _BridgedJSClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var level: String {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_Logger_level_get")
            func bjs_Logger_level_get(_ self: Int32) -> Int32
            #else
            func bjs_Logger_level_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_Logger_level_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func log(_ message: String) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Logger_log")
        func bjs_Logger_log(_ self: Int32, _ message: Int32) -> Void
        #else
        func bjs_Logger_log(_ self: Int32, _ message: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_Logger_log(self.bridgeJSLowerParameter(), message.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

    func error(_ message: String, _ error: JSObject) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_Logger_error")
        func bjs_Logger_error(_ self: Int32, _ message: Int32, _ error: Int32) -> Void
        #else
        func bjs_Logger_error(_ self: Int32, _ message: Int32, _ error: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_Logger_error(self.bridgeJSLowerParameter(), message.bridgeJSLowerParameter(), error.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}

struct ConfigManager: _BridgedJSClass {
    let jsObject: JSObject

    init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    var configPath: String {
        get throws(JSException) {
            #if arch(wasm32)
            @_extern(wasm, module: "Check", name: "bjs_ConfigManager_configPath_get")
            func bjs_ConfigManager_configPath_get(_ self: Int32) -> Int32
            #else
            func bjs_ConfigManager_configPath_get(_ self: Int32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            let ret = bjs_ConfigManager_configPath_get(self.bridgeJSLowerParameter())
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String.bridgeJSLiftReturn(ret)
        }
    }

    func get(_ key: String) throws(JSException) -> JSObject {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_ConfigManager_get")
        func bjs_ConfigManager_get(_ self: Int32, _ key: Int32) -> Int32
        #else
        func bjs_ConfigManager_get(_ self: Int32, _ key: Int32) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        let ret = bjs_ConfigManager_get(self.bridgeJSLowerParameter(), key.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject.bridgeJSLiftReturn(ret)
    }

    func set(_ key: String, _ value: JSObject) throws(JSException) -> Void {
        #if arch(wasm32)
        @_extern(wasm, module: "Check", name: "bjs_ConfigManager_set")
        func bjs_ConfigManager_set(_ self: Int32, _ key: Int32, _ value: Int32) -> Void
        #else
        func bjs_ConfigManager_set(_ self: Int32, _ key: Int32, _ value: Int32) -> Void {
            fatalError("Only available on WebAssembly")
        }
        #endif
        bjs_ConfigManager_set(self.bridgeJSLowerParameter(), key.bridgeJSLowerParameter(), value.bridgeJSLowerParameter())
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}