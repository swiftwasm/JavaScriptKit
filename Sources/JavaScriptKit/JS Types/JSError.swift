//
//  JSError
//  
//
//  Created by Alsey Coleman Miller on 6/3/20.
//

public extension JSValue {
    
    /// Cast error to JavaScript value.
    init(error: Error) {
        if let value = error as? JSValueConvertible {
            // convert to JavaScript value if supported.
            self = value.jsValue()
        } else if let stringConvertible = error as? CustomStringConvertible {
            // use decription for error
            self = stringConvertible.description.jsValue()
        } else {
            // default to printing description
            self = String(reflecting: error).jsValue()
        }
    }
}
