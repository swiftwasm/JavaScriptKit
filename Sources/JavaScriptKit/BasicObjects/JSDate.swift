/** A wrapper around the [JavaScript `Date`
 class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) that
 exposes its properties in a type-safe way. This doesn't 100% match the JS API, for example
 `getMonth`/`setMonth` etc accessor methods are converted to properties, but the rest of it matches
 in the naming. Parts of the JavaScript `Date` API that are not consistent across browsers and JS
 implementations are not exposed in a type-safe manner, you should access the underlying `jsObject`
 property if you need those.
 */
public final class JSDate: JSBridgedClass {
    /// The constructor function used to create new `Date` objects.
    public static var constructor: JSFunction? { _constructor.wrappedValue }
    private static let _constructor = LazyThreadLocal(initialize: { JSObject.global.Date.function })

    /// The underlying JavaScript `Date` object.
    public let jsObject: JSObject

    /** Creates a new instance of the JavaScript `Date` class with a given amount of milliseconds
     that passed since midnight 01 January 1970 UTC.
     */
    public init(millisecondsSinceEpoch: Double? = nil) {
        if let milliseconds = millisecondsSinceEpoch {
            jsObject = Self.constructor!.new(milliseconds)
        } else {
            jsObject = Self.constructor!.new()
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
        jsObject = Self.constructor!.new(year, monthIndex, day, hours, minutes, seconds, milliseconds)
    }

    public init(unsafelyWrapping jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Year of this date in local time zone.
    public var fullYear: Int {
        get {
            Int(jsObject.getFullYear!().number!)
        }
        set {
            _ = jsObject.setFullYear!(newValue)
        }
    }

    /// Month of this date in `0–11` range in local time zone.
    public var month: Int {
        get {
            Int(jsObject.getMonth!().number!)
        }
        set {
            _ = jsObject.setMonth!(newValue)
        }
    }

    /// The day of the month in `1..31` range in local time zone.
    public var date: Int {
        get {
            Int(jsObject.getDate!().number!)
        }
        set {
            _ = jsObject.setDate!(newValue)
        }
    }

    /// The day of the week in `0..6` range in local time zone.
    public var day: Int {
        Int(jsObject.getDay!().number!)
    }

    /// The amount of hours in this day from `0..23` range in local time zone.
    public var hours: Int {
        get {
            Int(jsObject.getHours!().number!)
        }
        set {
            _ = jsObject.setHours!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in local time zone.
    public var minutes: Int {
        get {
            Int(jsObject.getMinutes!().number!)
        }
        set {
            _ = jsObject.setMinutes!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in local time zone.
    public var seconds: Int {
        get {
            Int(jsObject.getSeconds!().number!)
        }
        set {
            _ = jsObject.setSeconds!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in local time zone.
    public var milliseconds: Int {
        get {
            Int(jsObject.getMilliseconds!().number!)
        }
        set {
            _ = jsObject.setMilliseconds!(newValue)
        }
    }

    /// Year of this date in the UTC time zone.
    public var utcFullYear: Int {
        get {
            Int(jsObject.getUTCFullYear!().number!)
        }
        set {
            _ = jsObject.setUTCFullYear!(newValue)
        }
    }

    /// Month of this date in `0–11` range in the UTC time zone.
    public var utcMonth: Int {
        get {
            Int(jsObject.getUTCMonth!().number!)
        }
        set {
            _ = jsObject.setUTCMonth!(newValue)
        }
    }

    /// The day of the month in `1..31` range in the UTC time zone.
    public var utcDate: Int {
        get {
            Int(jsObject.getUTCDate!().number!)
        }
        set {
            _ = jsObject.setUTCDate!(newValue)
        }
    }

    /// The day of the week in `0..6` range in the UTC time zone.
    public var utcDay: Int {
        Int(jsObject.getUTCDay!().number!)
    }

    /// The amount of hours in this day from `0..23` range in the UTC time zone.
    public var utcHours: Int {
        get {
            Int(jsObject.getUTCHours!().number!)
        }
        set {
            _ = jsObject.setUTCHours!(newValue)
        }
    }

    /// The amount of minutes in this hours from `0..59` range in the UTC time zone.
    public var utcMinutes: Int {
        get {
            Int(jsObject.getUTCMinutes!().number!)
        }
        set {
            _ = jsObject.setUTCMinutes!(newValue)
        }
    }

    /// The amount of seconds in this minute from `0..59` range in the UTC time zone.
    public var utcSeconds: Int {
        get {
            Int(jsObject.getUTCSeconds!().number!)
        }
        set {
            _ = jsObject.setUTCSeconds!(newValue)
        }
    }

    /// The amount of milliseconds in this second `0..999` range in the UTC time zone.
    public var utcMilliseconds: Int {
        get {
            Int(jsObject.getUTCMilliseconds!().number!)
        }
        set {
            _ = jsObject.setUTCMilliseconds!(newValue)
        }
    }

    /// Offset in minutes between the local time zone and UTC.
    public var timezoneOffset: Int {
        Int(jsObject.getTimezoneOffset!().number!)
    }

    /// Returns a string conforming to ISO 8601 that contains date and time, e.g.
    /// `"2020-09-15T08:56:54.811Z"`.
    public func toISOString() -> String {
        jsObject.toISOString!().string!
    }

    /// Returns a string with date parts in a format defined by user's locale, e.g. `"9/15/2020"`.
    public func toLocaleDateString() -> String {
        jsObject.toLocaleDateString!().string!
    }

    /// Returns a string with time parts in a format defined by user's locale, e.g. `"10:04:14"`.
    public func toLocaleTimeString() -> String {
        jsObject.toLocaleTimeString!().string!
    }

    /** Returns a string formatted according to
     [rfc7231](https://tools.ietf.org/html/rfc7231#section-7.1.1.1) and modified according to
     [ecma-262](https://www.ecma-international.org/ecma-262/10.0/index.html#sec-date.prototype.toutcstring),
     e.g. `Tue, 15 Sep 2020 09:04:40 GMT`.
     */
    public func toUTCString() -> String {
        jsObject.toUTCString!().string!
    }

    /** Number of milliseconds since midnight 01 January 1970 UTC to the present moment ignoring
     leap seconds.
     */
    public static func now() -> Double {
        constructor!.now!().number!
    }

    /** Number of milliseconds since midnight 01 January 1970 UTC to the given date ignoring leap
     seconds.
     */
    public func valueOf() -> Double {
        jsObject.valueOf!().number!
    }
}

extension JSDate: Comparable {
    public static func == (lhs: JSDate, rhs: JSDate) -> Bool {
        return lhs.valueOf() == rhs.valueOf()
    }

    public static func < (lhs: JSDate, rhs: JSDate) -> Bool {
        return lhs.valueOf() < rhs.valueOf()
    }
}
