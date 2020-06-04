//
//  JSError
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

/// JavaScript Error
///
/// Error objects are thrown when runtime errors occur.
/// The Error object can also be used as a base object for user-defined exceptions.
public class JSError: JSType, Error {
    
    // MARK: - Properties
    
    public let jsObject: JSObjectRef
    
    // MARK: - Initialization

    public required init?(_ jsObject: JSObjectRef) {
        self.jsObject = jsObject
    }
    
    public init() {
        // TODO: Implement initializer
        self.jsObject = Self.classObject.new()
    }
    
    // MARK: - Accessors
    
    /// The name property represents a name for the type of error. The initial value is "Error".
    public lazy var name: String = self.jsObject.name.string ?? ""
    
    /// The message property is a human-readable description of the error.
    public lazy var message: String = self.jsObject.message.string ?? ""
}

internal extension JSError {
    
    static let classObject = JSObjectRef.global.Error.function!
}

// MARK: - CustomStringConvertible

extension JSError: CustomStringConvertible { }
