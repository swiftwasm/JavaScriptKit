#if os(WASI) && !compiler(>=6.4)
#error("WASIShim requires Swift 6.4 or later.")
#endif
#if os(WASI) && _runtime(_multithreaded)
#error("WASIShim supports only single-threaded wasm32-unknown-wasip1.")
#endif

// The shim's sources are gated on the same conditions, so a rejected build reports only the
// errors above.
#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

/// WASI preview1 error codes returned by the shim.
enum Errno: UInt16, Error {
    case badf = 8
    case fault = 21
    case inval = 28
    case io = 29
    case noent = 44
    case notsup = 58
    case spipe = 70
}

extension Errno {
    var code: Int32 { Int32(rawValue) }
}

enum ClockID: UInt32 {
    case realtime = 0
    case monotonic = 1
    case processCPUTime = 2
    case threadCPUTime = 3
}

extension ClockID {
    init(validating id: UInt32) throws(Errno) {
        guard let clock = ClockID(rawValue: id) else { throw .inval }
        self = clock
    }
}

/// `__wasi_ciovec_t` / `__wasi_iovec_t`.
struct IOVec: BitwiseCopyable {
    var address: UInt32
    var count: UInt32
}

/// Layouts of the 8-byte aligned WASI structs, viewed as little-endian 64-bit words.
enum Layout {
    /// `__wasi_fdstat_t`: filetype (u8) and flags (u16 at byte 2), rights base, rights inheriting.
    static let fdstatWords = 3
    /// `__wasi_filestat_t`: dev, ino, filetype (u8), nlink, size, atim, mtim, ctim.
    static let filestatWords = 8
    /// `__wasi_subscription_t`: userdata, tag (u8), clock id or fd (u32), timeout, precision, flags.
    static let subscriptionWords = 6
    /// `__wasi_event_t`: userdata, error (u16) and type (u8 at byte 2), nbytes, flags.
    static let eventWords = 4
}

/// `__wasi_filetype_t`.
enum FileType {
    static let characterDevice: UInt64 = 2
}

/// `__wasi_eventtype_t`.
enum EventType {
    static let clock: UInt64 = 0
    static let fdRead: UInt64 = 1
    static let fdWrite: UInt64 = 2
}

/// `__wasi_eventrwflags_t`.
enum EventRWFlags {
    static let hangup: UInt64 = 1
}

/// `__wasi_subclockflags_t`.
enum SubclockFlags {
    static let absoluteTime: UInt64 = 1
}

/// `__wasi_rights_t`.
enum Rights {
    static let fdSeek: UInt64 = 1 << 2
    static let fdTell: UInt64 = 1 << 5
    /// Every right except seeking, so libc treats stdio as a line-buffered terminal.
    static let stdio: UInt64 = ((1 << 30) - 1) & ~(fdSeek | fdTell)
}

enum StandardStream: Int32 {
    case input = 0
    case output = 1
    case error = 2
}

extension StandardStream {
    /// Validates an fd that must be stdin, stdout or stderr.
    init(validating fd: Int32) throws(Errno) {
        guard let stream = StandardStream(rawValue: fd) else { throw .badf }
        self = stream
    }
}

#endif
