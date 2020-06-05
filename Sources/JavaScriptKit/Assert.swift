//
//  Assert.swift
//  
//
//  Created by Alsey Coleman Miller on 6/4/20.
//

/// Unconditionally prints a given message and stops execution.
internal func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    let message = message()
    JSConsole.error("Fatal error: \(message)")
    Swift.fatalError(message, file: file, line: line)
}

/// Performs a traditional C-style assert with an optional message.
internal func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    let condition = condition()
    let message = message()
    JSConsole.assert(condition, "Assertion failure: \(message)")
    Swift.assert(condition, message, file: file, line: line)
}

/// Performs a traditional C-style assert with an optional message.
internal func assert(_ condition: @autoclosure () -> JSBoolean, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    assert(condition().rawValue, message(), file: file, line: line)
}

internal extension Optional {
    
    func assert(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Wrapped {
        switch self {
        case .none:
            fatalError(message(), file: file, line: line)
        case let .some(value):
            return value
        }
    }
}
