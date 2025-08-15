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
    let ret = bjs_createDatabaseConnection(Int32(bitPattern: config.id))
    if let error = _swift_js_take_exception() {
        throw error
    }
    return DatabaseConnection(takingThis: ret)
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
    var level = level
    let levelId = level.withUTF8 { b in
        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
    }
    let ret = bjs_createLogger(levelId)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Logger(takingThis: ret)
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
    return ConfigManager(takingThis: ret)
}

struct DatabaseConnection {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
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
            let ret = bjs_DatabaseConnection_isConnected_get(Int32(bitPattern: self.this.id))
            if let error = _swift_js_take_exception() {
                throw error
            }
            return ret == 1
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
            let ret = bjs_DatabaseConnection_connectionTimeout_get(Int32(bitPattern: self.this.id))
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Double(ret)
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
        bjs_DatabaseConnection_connectionTimeout_set(Int32(bitPattern: self.this.id), newValue)
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
        var url = url
        let urlId = url.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_DatabaseConnection_connect(Int32(bitPattern: self.this.id), urlId)
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
        var query = query
        let queryId = query.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_DatabaseConnection_execute(Int32(bitPattern: self.this.id), queryId)
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject(id: UInt32(bitPattern: ret))
    }

}

struct Logger {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
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
            let ret = bjs_Logger_level_get(Int32(bitPattern: self.this.id))
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
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
        var message = message
        let messageId = message.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_Logger_log(Int32(bitPattern: self.this.id), messageId)
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
        var message = message
        let messageId = message.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_Logger_error(Int32(bitPattern: self.this.id), messageId, Int32(bitPattern: error.id))
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}

struct ConfigManager {
    let this: JSObject

    init(this: JSObject) {
        self.this = this
    }

    init(takingThis this: Int32) {
        self.this = JSObject(id: UInt32(bitPattern: this))
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
            let ret = bjs_ConfigManager_configPath_get(Int32(bitPattern: self.this.id))
            if let error = _swift_js_take_exception() {
                throw error
            }
            return String(unsafeUninitializedCapacity: Int(ret)) { b in
                _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                return Int(ret)
            }
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
        var key = key
        let keyId = key.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        let ret = bjs_ConfigManager_get(Int32(bitPattern: self.this.id), keyId)
        if let error = _swift_js_take_exception() {
            throw error
        }
        return JSObject(id: UInt32(bitPattern: ret))
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
        var key = key
        let keyId = key.withUTF8 { b in
            _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
        }
        bjs_ConfigManager_set(Int32(bitPattern: self.this.id), keyId, Int32(bitPattern: value.id))
        if let error = _swift_js_take_exception() {
            throw error
        }
    }

}