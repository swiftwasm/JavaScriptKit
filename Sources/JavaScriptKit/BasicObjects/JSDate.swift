public final class JSDate {
    private static let constructor = JSObject.global.Date.function!
    public let ref: JSObject

    public init(millisecondsSinceEpoch: Double? = nil) {
        if let milliseconds = millisecondsSinceEpoch {
            ref = Self.constructor.new(milliseconds)
        } else {
            ref = Self.constructor.new()
        }
    }

    /** According to the standard, `monthIndex` is zero-indexed, where `11` is December. `day` 
    represents a day of the month starting at `1`.
    */
    public init(
        year: Int,
        monthIndex: Int,
        day: Int = 1,
        hours: Int = 0,
        minutes: Int = 0,
        seconds: Int = 0,
        milliseconds: Int = 0
    ) {
        ref = Self.constructor.new(year, monthIndex, day, hours, minutes, seconds, milliseconds)
    }

    /// Year of this date in local time zone.
    public var fullYear: Int {
        get {
            Int(ref.getFullYear!().number!)
        }
        set {
            _ = ref.setFullYear!(newValue)
        }
    }

    /// Month of this date in `0–11` range in local time zone
    public var month: Int {
        get {
            Int(ref.getMonth!().number!)
        }
        set {
            _ = ref.setMonth!(newValue)
        }
    }

    /// The day of the month in `1..31` range in local time zone.
    public var date: Int {
        get {
            Int(ref.getDate!().number!)
        }
        set {
            _ = ref.setDate!(newValue)
        }
    }

    /// The day of the week in `0..6` range in local time zone.
    public var day: Int {
        Int(ref.getDay!().number!)
    }

    /// The amount of hours in this day from `0..23` range in local time zone.
    public var hours: Int {
        get {
            Int(ref.getHours!().number!)
        }
        set {
            _ = ref.setHours!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in local time zone.
    public var minutes: Int {
        get {
            Int(ref.getMinutes!().number!)
        }
        set {
            _ = ref.setMinutes!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in local time zone.
    public var seconds: Int {
        get {
            Int(ref.getSeconds!().number!)
        }
        set {
            _ = ref.setSeconds!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in local time zone.
    public var milliseconds: Int {
        get {
            Int(ref.getMilliseconds!().number!)
        }
        set {
            _ = ref.setMilliseconds!(newValue)
        }
    }

    /// Year of this date in the UTC time zone
    public var utcFullYear: Int {
        get {
            Int(ref.getUTCFullYear!().number!)
        }
        set {
            _ = ref.setUTCFullYear!(newValue)
        }
    }

    /// Month of this date in `0–11` range in the UTC time zone
    public var utcMonth: Int {
        get {
            Int(ref.getUTCMonth!().number!)
        }
        set {
            _ = ref.setUTCMonth!(newValue)
        }
    }

    /// The day of the month in `1..31` range in the UTC time zone
    public var utcDate: Int {
        get {
            Int(ref.getUTCDate!().number!)
        }
        set {
            _ = ref.setUTCDate!(newValue)
        }
    }

    /// The day of the week in `0..6` range in the UTC time zone
    public var utcDay: Int {
        Int(ref.getUTCDay!().number!)
    }

    /// The amount of hours in this day from `0..23` range in the UTC time zone
    public var utcHours: Int {
        get {
            Int(ref.getUTCHours!().number!)
        }
        set {
            _ = ref.setUTCHours!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in the UTC time zone
    public var utcMinutes: Int {
        get {
            Int(ref.getUTCMinutes!().number!)
        }
        set {
            _ = ref.setUTCMinutes!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in the UTC time zone
    public var utcSeconds: Int {
        get {
            Int(ref.getUTCSeconds!().number!)
        }
        set {
            _ = ref.setUTCSeconds!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in the UTC time zone
    public var utcMilliseconds: Int {
        get {
            Int(ref.getUTCMilliseconds!().number!)
        }
        set {
            _ = ref.setUTCMilliseconds!(newValue)
        }
    }

    /// Offset in minutes between the local time zone and UTC
    public var timezoneOffset: Int {
        Int(ref.getTimezoneOffset!().number!)
    }

    public func toISOString() -> String {
        ref.toISOString!().string!
    }

    public func toLocaleDateString() -> String {
        ref.toLocaleDateString!().string!
    }

    public func toLocaleTimeString() -> String {
        ref.toLocaleTimeString!().string!
    }

    public func toUTCString() -> String {
        ref.toUTCString!().string!
    }

    /// Number of milliseconds since midnight 01 January 1970 UTC to the present moment ignoring leap 
    /// seconds
    public static func now() -> Double {
        constructor.now!().number!
    }

    /// Number of milliseconds since midnight 01 January 1970 UTC to the given date ignoring leap 
    /// seconds
    public func valueOf() -> Double {
        ref.valueOf!().number!
    }
}

extension JSDate: Comparable {
    public static func ==(lhs: JSDate, rhs: JSDate) -> Bool {
        return lhs.valueOf() == rhs.valueOf()
    }

    public static func <(lhs: JSDate, rhs: JSDate) -> Bool {
        return lhs.valueOf() < rhs.valueOf()
    }
}
