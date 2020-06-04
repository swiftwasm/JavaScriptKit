//
//  JSConsole.swift
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

public final class JSConsole: JSType {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public init(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    // MARK: - Methods
    
    /**
     The Console method `log()` outputs a message to the web console. The message may be a single string (with optional substitution values), or it may be any one or more JavaScript objects.
     */
    public static func log(_ message: String) {
        logFunction(message)
    }
    
    /**
     The `console.info()` method outputs an informational message to the Web Console. In Firefox, a small "i" icon is displayed next to these items in the Web Console's log.
     */
    public static func info(_ message: String) {
        infoFunction(message)
    }
    
    /**
     The console method `debug()` outputs a message to the web console at the "debug" log level. The message is only displayed to the user if the console is configured to display debug output.
     */
    public static func debug(_ message: String) {
        debugFunction(message)
    }
    
    /**
     Outputs an error message to the Web Console.
     */
    public static func error(_ message: String) {
        errorFunction(message)
    }
    
    /**
     The `console.assert()` method writes an error message to the console if the assertion is false. If the assertion is true, nothing happens.
     */
    public static func assert(_ condition: @autoclosure () -> (Bool), _ message: String) {
        assertFunction(condition(), message)
    }
}

internal extension JSConsole {
    
    static let classObject = JSObjectRef.global.console.object!
    
    static let logFunction = classObject.log.function!
    
    static let infoFunction = classObject.info.function!
    
    static let debugFunction = classObject.debug.function!
    
    static let errorFunction = classObject.error.function!
    
    static let assertFunction = classObject.assert.function!
}
