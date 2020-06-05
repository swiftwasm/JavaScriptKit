//
//  Date.swift
//  JavaScriptKit
//
//  Created by Alsey Coleman Miller on 6/4/20.
//

import SwiftFoundation

#if arch(wasm32)

// MARK: - Time

internal extension JSDate {
    
    /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
    static var timeIntervalSinceReferenceDate: SwiftFoundation.TimeInterval {
        return JSDate.now - Date.timeIntervalBetween1970AndReferenceDate
    }
}

public extension SwiftFoundation.Date {
    
    /// Returns a `Date` initialized to the current date and time.
    init() {
        self.init(timeIntervalSinceReferenceDate: JSDate.timeIntervalSinceReferenceDate)
    }
    
    /// Returns a `Date` initialized relative to the current date and time by a given number of seconds.
    init(timeIntervalSinceNow: SwiftFoundation.TimeInterval) {
        self.init(timeIntervalSinceReferenceDate: timeIntervalSinceNow + JSDate.timeIntervalSinceReferenceDate)
    }
    
    /**
     The time interval between the date and the current date and time.
     
     If the date is earlier than the current date and time, the this property’s value is negative.
     
     - SeeAlso: `timeIntervalSince(_:)`
     - SeeAlso: `timeIntervalSince1970`
     - SeeAlso: `timeIntervalSinceReferenceDate`
     */
    var timeIntervalSinceNow: SwiftFoundation.TimeInterval {
        return self.timeIntervalSinceReferenceDate - JSDate.timeIntervalSinceReferenceDate
    }
    
    /**
     The interval between the date object and 00:00:00 UTC on 1 January 1970.
     
     This property’s value is negative if the date object is earlier than 00:00:00 UTC on 1 January 1970.
     
     - SeeAlso: `timeIntervalSince(_:)`
     - SeeAlso: `timeIntervalSinceNow`
     - SeeAlso: `timeIntervalSinceReferenceDate`
     */
    var timeIntervalSince1970: SwiftFoundation.TimeInterval {
        return self.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate
    }
}

public extension SwiftFoundation.Date {
    
    /// The interval between 00:00:00 UTC on 1 January 2001 and the current date and time.
    static var _timeIntervalSinceReferenceDate: SwiftFoundation.TimeInterval {
        // FIXME: Compiler error
        return JSDate.timeIntervalSinceReferenceDate
    }
}

// MARK: - CustomStringConvertible

extension SwiftFoundation.Date: CustomStringConvertible {
    
    public var description: String {
        return JSDate(self).description
    }
}

// MARK: - CustomDebugStringConvertible

extension SwiftFoundation.Date: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

#endif

// MARK: - JS Value

public extension JSDate {
    
    convenience init(_ date: SwiftFoundation.Date) {
        self.init(timeInterval: date.timeIntervalSince1970)
    }
}

extension SwiftFoundation.Date: JSValueConvertible {
    
    public func jsValue() -> JSValue {
        let date = JSDate()
        return date.jsValue()
    }
}
