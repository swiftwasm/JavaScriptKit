#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

import JavaScriptKit

extension ClockID {
    /// Nanoseconds since the Unix epoch (realtime) or since page load (everything else).
    ///
    /// Throws `EIO` when the host's clock throws, so a sleep fails instead of waiting on a clock
    /// that never advances.
    func now() throws(Errno) -> UInt64 {
        let milliseconds: Double
        do {
            milliseconds = try self == .realtime ? HostDate.now() : HostPerformance.now()
        } catch {
            throw .io
        }
        // A system clock set before 1970 reads negative; WASI timestamps are unsigned.
        return UInt64(max(milliseconds, 0) * 1_000_000)
    }

    /// `Date.now()` counts whole milliseconds; 5 µs is the finest `performance.now()` gets in browsers.
    var resolution: UInt64 { self == .realtime ? 1_000_000 : 5_000 }
}

#endif
