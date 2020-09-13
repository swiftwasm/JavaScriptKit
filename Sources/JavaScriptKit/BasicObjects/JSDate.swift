public final class JSDate {
    private static let constructor = JSObject.global.Date.function!
    private let ref: JSObject

    public init(millisecondsSinceEpoch: Int? = nil) {
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
            Int(ref.getFullYear.function!().number!)
        }
        set {
            ref.setFullYear.function!(newValue)
        }
    }

    /// Month of this date in `0–11` range in local time zone
    public var month: Int {
        get {
            Int(ref.getMonth.function!().number!)
        }
        set {
            ref.setMonth.function!(newValue)
        }
    }

    /// The day of the month in `1..31` range in local time zone.
    public var date: Int {
        get {
            Int(ref.getDate.function!().number!)
        }
        set {
            ref.setDate.function!(newValue)
        }
    }

    /// The day of the week in `0..6` range in local time zone.
    public var day: Int {
        Int(ref.getDay.function!().number!)
    }

    /// The amount of hours in this day from `0..23` range in local time zone.
    public var hours: Int {
        get {
            Int(ref.getHours.function!().number!)
        }
        set {
            ref.setHours.function!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in local time zone.
    public var minutes: Int {
        get {
            Int(ref.getMinutes.function!().number!)
        }
        set {
            ref.setMinutes.function!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in local time zone.
    public var seconds: Int {
        get {
            Int(ref.getSeconds.function!().number!)
        }
        set {
            ref.setSeconds.function!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in local time zone.
    public var milliseconds: Int {
        get {
            Int(ref.getMilliseconds.function!().number!)
        }
        set {
            ref.setMilliseconds.function!(newValue)
        }
    }

    /// Year of this date in the UTC time zone
    public var utcFullYear: Int {
        get {
            Int(ref.getFullYear.function!().number!)
        }
        set {
            ref.setFullYear.function!(newValue)
        }
    }

    /// Month of this date in `0–11` range in the UTC time zone
    public var utcMonth: Int {
        get {
            Int(ref.getMonth.function!().number!)
        }
        set {
            ref.setMonth.function!(newValue)
        }
    }

    /// The day of the month in `1..31` range in the UTC time zone
    public var utcDate: Int {
        get {
            Int(ref.getDate.function!().number!)
        }
        set {
            ref.setDate.function!(newValue)
        }
    }

    /// The day of the week in `0..6` range in the UTC time zone
    public var utcDay: Int {
        Int(ref.getDay.function!().number!)
    }

    /// The amount of hours in this day from `0..23` range in the UTC time zone
    public var utcHours: Int {
        get {
            Int(ref.getHours.function!().number!)
        }
        set {
            ref.setHours.function!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in the UTC time zone
    public var utcMinutes: Int {
        get {
            Int(ref.getMinutes.function!().number!)
        }
        set {
            ref.setMinutes.function!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in the UTC time zone
    public var utcSeconds: Int {
        get {
            Int(ref.getSeconds.function!().number!)
        }
        set {
            ref.setSeconds.function!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in the UTC time zone
    public var utcMilliseconds: Int {
        get {
            Int(ref.getMilliseconds.function!().number!)
        }
        set {
            ref.setMilliseconds.function!(newValue)
        }
    }

    /// Offset in minutes between the local time zone and UTC
    public var timezoneOffset: Int {
        Int(ref.getTimezoneOffset.function!().number!)
    }

    public func toISOString() -> String {
        ref.toISOString.function!().string!
    }

    public func toLocaleDateString() -> String {
        ref.toLocaleDateString.function!().string!
    }

    public func toLocaleTimeString() -> String {
        ref.toLocaleTimeString.function!().string!
    }

    public func toUTCString() -> String {
        ref.toUTCString.function!().string!
    }

    /// Number of seconds since epoch ignoring leap seconds
    public func now() -> Int {
        Int(ref.now.function!().number!)
    }
}
