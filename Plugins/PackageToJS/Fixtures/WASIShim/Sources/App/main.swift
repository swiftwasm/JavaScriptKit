import JavaScriptKit
import WASILibc

// Top-level code is main-actor isolated; closures in it trip the runtime's isolation check.
run()

func run() {
    print("app: start")
    print("ab-", terminator: "")
    print("joined")
    print("")
    print("grüße 🌍")
    let invalid: [UInt8] = Array("bad:".utf8) + [0xFF, 0xC3] + Array(" end\n".utf8)
    _ = invalid.withUnsafeBytes { write(1, $0.baseAddress, $0.count) }
    fputs("to stderr\n", stderr)

    var samples: [Int] = []
    for _ in 0..<16 {
        samples.append(Int.random(in: 0..<1_000_000))
    }
    print("random varies: \(samples.contains { $0 != samples[0] })")

    let squares: [Int: Int] = [1: 1, 2: 4, 3: 9]
    print("dictionary: count=\(squares.count) 3=\(squares[3] ?? -1)")

    let pi = JSObject.global.Math.PI.number ?? 0
    print("js pi: \(pi > 3.14 && pi < 3.15)")

    print("clock monotonic: \(clockIsMonotonic())")

    let before = monotonicNanoseconds()
    usleep(20_000)
    print("usleep waited: \(monotonicNanoseconds() - before >= 20_000_000)")

    print("random bulk: \(randomLooksRandom(65_536) && randomLooksRandom(100_000))")
    print("random block edges: \(randomLooksRandom(1_023) && randomLooksRandom(1_024))")
    print("random small reads: \(smallRandomReadsDiffer())")

    var status = stat()
    print("stdout is a character device: \(fstat(1, &status) == 0 && status.st_mode & S_IFMT == S_IFCHR)")

    print("errors: \(errorsMatch())")

    print("tail", terminator: "")
    fputs("partial stderr", stderr)
    exit(7)
}

/// Fills `count` bytes through `arc4random_buf`, which wasi-libc forwards to `random_get` as is.
func randomLooksRandom(_ count: Int) -> Bool {
    var bytes = [UInt8](repeating: 0, count: count)
    bytes.withUnsafeMutableBytes { arc4random_buf($0.baseAddress, $0.count) }
    var zeros = 0
    for byte in bytes where byte == 0 {
        zeros += 1
    }
    return zeros < max(count / 128, 16) && bytes.suffix(64).contains { $0 != 0 }
}

/// Reads 7 bytes at a time, so the shim's 1 KiB pool runs out in the middle of a request.
func smallRandomReadsDiffer() -> Bool {
    let readCount = 300
    var reads: [UInt64] = []
    for _ in 0..<readCount {
        var value: UInt64 = 0
        withUnsafeMutableBytes(of: &value) { arc4random_buf($0.baseAddress, 7) }
        reads.append(value)
    }
    reads.sort()
    for index in 1..<reads.count where reads[index] == reads[index - 1] {
        return false
    }
    return true
}

/// `CLOCK_MONOTONIC` is a pointer macro Swift can't import, so this calls WASI directly.
func monotonicNanoseconds() -> UInt64 {
    var time: UInt64 = 0
    _ = __wasi_clock_time_get(1, 1, &time)
    return time
}

func clockIsMonotonic() -> Bool {
    #if hasFeature(Embedded)
    var previous = monotonicNanoseconds()
    for _ in 0..<10 {
        let now = monotonicNanoseconds()
        if now < previous { return false }
        previous = now
    }
    return true
    #else
    let clock = ContinuousClock()
    var previous = clock.now
    for _ in 0..<10 {
        let now = clock.now
        if now < previous { return false }
        previous = now
    }
    return true
    #endif
}

func errorsMatch() -> Bool {
    var byte: UInt8 = 0
    var checks: [Bool] = []

    errno = 0
    checks.append(write(42, &byte, 1) == -1 && errno == EBADF)
    errno = 0
    checks.append(fsync(1) == -1 && errno == ENOTSUP)
    errno = 0
    checks.append(lseek(1, 0, SEEK_SET) == -1 && errno == ESPIPE)
    errno = 0
    checks.append(open("/file", O_RDONLY) == -1)

    var time: UInt64 = 0
    checks.append(__wasi_clock_time_get(99, 1, &time) == EINVAL)

    checks.append(read(0, &byte, 1) == 0)

    var fds = [pollfd(fd: 0, events: Int16(POLLIN), revents: 0), pollfd(fd: 1, events: Int16(POLLOUT), revents: 0)]
    errno = 0
    checks.append(poll(&fds, 2, 10) == -1 && errno == ENOTSUP)

    for (index, check) in checks.enumerated() where !check {
        print("error check \(index) failed")
    }
    return !checks.contains(false)
}
