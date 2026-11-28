#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

/// Handles the single subscription wasi-libc's sleep functions pass (`sleep`, `usleep`,
/// `nanosleep`, `clock_nanosleep`): a clock subscription blocks until its deadline. A read or
/// write subscription on a standard stream is ready right away (stdin at end of file); on any
/// other fd it fails with `EBADF`. Writes the subscription's event.
func pollOneoff(
    _ subscription: Span<UInt64>,
    _ event: inout MutableSpan<UInt64>,
    sleeper: inout Sleeper
) throws(Errno) {
    let type = subscription[1] & 0xFF
    var error: Errno?
    var flags: UInt64 = 0
    switch type {
    case EventType.clock:
        if let clock = ClockID(rawValue: UInt32(truncatingIfNeeded: subscription[2])) {
            let isAbsolute = subscription[5] & SubclockFlags.absoluteTime != 0
            try wait(on: clock, timeout: subscription[3], isAbsolute: isAbsolute, sleeper: &sleeper)
        } else {
            error = .inval
        }
    case EventType.fdRead, EventType.fdWrite:
        let isRead = type == EventType.fdRead
        if let stream = StandardStream(rawValue: Int32(truncatingIfNeeded: subscription[2])),
            (stream == .input) == isRead
        {
            flags = isRead ? EventRWFlags.hangup : 0
        } else {
            error = .badf
        }
    default:
        throw .inval
    }
    event[0] = subscription[0]
    event[1] = UInt64(error?.rawValue ?? 0) | type << 16
    event[2] = 0
    event[3] = flags
}

/// Sleeps until `clock` reaches the deadline, re-reading it after each sleep so an early wake-up
/// or drift between the sleeper's clock and `clock` never ends the wait too soon.
private func wait(on clock: ClockID, timeout: UInt64, isAbsolute: Bool, sleeper: inout Sleeper) throws(Errno) {
    var now = try clock.now()
    let deadline: UInt64
    if isAbsolute {
        deadline = timeout
    } else {
        let (sum, overflow) = now.addingReportingOverflow(timeout)
        deadline = overflow ? .max : sum
    }
    while now < deadline {
        sleeper.sleep(nanoseconds: deadline - now)
        now = try clock.now()
    }
}

#endif
