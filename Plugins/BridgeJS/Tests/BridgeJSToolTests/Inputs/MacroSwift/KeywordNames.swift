// Swift identifiers escaped with backticks (e.g. `` `default` ``) must be normalized
// before reaching ABI names: the WebAssembly export name must be `bjs_default`, not
// `bjs_`default``, while the emitted Swift call still escapes the keyword as
// `` `default` ``. This input exercises every member emission path with keyword names.

// Top-level function: `default` is a common JS default-export name.
@JS func `default`() {}
@JS func `delete`(_ value: Int32) -> Int32 { value }

// Class: instance + static methods, instance + static properties, init.
@JS class `Parser` {
    @JS var `in`: Int
    @JS static var `self`: String { "parser" }

    @JS init(`in`: Int) {
        self.`in` = `in`
    }

    @JS func `class`() -> Int {
        return `in`
    }

    @JS static func `where`(_ value: Int) -> Int {
        return value
    }
}

// Struct: keyword-named stored fields + instance method.
@JS struct `Record` {
    var `case`: Int
    var `continue`: String

    @JS init(`case`: Int, `continue`: String) {
        self.`case` = `case`
        self.`continue` = `continue`
    }

    @JS func `as`() -> String {
        return `continue`
    }
}

// Enum: keyword-named cases + static method.
@JS enum `Token` {
    case `break`
    case `return`(String)

    @JS static func `switch`(_ value: Int) -> Int {
        return value
    }
}

// Protocol: keyword-named properties (get / get set) and methods.
@JS protocol `Observer` {
    var `do`: Int { get set }
    var `for`: String { get }
    func `if`(_ value: Int) -> Bool
    func `else`() -> String
}
