// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(Experimental) import JavaScriptKit

@JSFunction func createDatabaseConnection(_ config: JSObject) throws (JSException) -> DatabaseConnection

@JSClass struct DatabaseConnection: _JSBridgedClass {
    @JSFunction func connect(_ url: String) throws (JSException) -> Void
    @JSFunction func execute(_ query: String) throws (JSException) -> JSObject
    @JSGetter var isConnected: Bool
    @JSGetter var connectionTimeout: Double
    @JSSetter func setConnectionTimeout(_ value: Double) throws (JSException)
}

@JSFunction func createLogger(_ level: String) throws (JSException) -> Logger

@JSClass struct Logger: _JSBridgedClass {
    @JSFunction func log(_ message: String) throws (JSException) -> Void
    @JSFunction func error(_ message: String, _ error: JSObject) throws (JSException) -> Void
    @JSGetter var level: String
}

@JSFunction func getConfigManager() throws (JSException) -> ConfigManager

@JSClass struct ConfigManager: _JSBridgedClass {
    @JSFunction func get(_ key: String) throws (JSException) -> JSObject
    @JSFunction func set(_ key: String, _ value: JSObject) throws (JSException) -> Void
    @JSGetter var configPath: String
}
