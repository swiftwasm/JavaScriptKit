#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

import WASILibc

// Definitions for every `wasi_snapshot_preview1` function wasi-libc imports.
//
// wasi-libc declares each import as a body-less `__imported_wasi_snapshot_preview1_<name>`
// function. Defining those symbols here makes wasm-ld bind libc to them instead of emitting
// an import. Parameter types mirror the wasm signatures: pointers and sizes are i32, and
// timestamps, offsets and rights are i64. Pointers only live in this file and become spans
// right away; unused pointer parameters stay plain integers.

// MARK: - Args and environment (called by libc startup, before JavaScriptKit is ready)

@c(__imported_wasi_snapshot_preview1_args_get)
func wasi_args_get(_ argv: UInt32, _ argvBuffer: UInt32) -> Int32 {
    success
}

@c(__imported_wasi_snapshot_preview1_args_sizes_get)
func wasi_args_sizes_get(_ count: UnsafeMutablePointer<UInt32>, _ bufferSize: UnsafeMutablePointer<UInt32>) -> Int32 {
    unsafe count.pointee = 0
    unsafe bufferSize.pointee = 0
    return success
}

@c(__imported_wasi_snapshot_preview1_environ_get)
func wasi_environ_get(_ environ: UInt32, _ environBuffer: UInt32) -> Int32 {
    success
}

@c(__imported_wasi_snapshot_preview1_environ_sizes_get)
func wasi_environ_sizes_get(_ count: UnsafeMutablePointer<UInt32>, _ bufferSize: UnsafeMutablePointer<UInt32>) -> Int32
{
    unsafe count.pointee = 0
    unsafe bufferSize.pointee = 0
    return success
}

// MARK: - Clocks and randomness

@c(__imported_wasi_snapshot_preview1_clock_res_get)
func wasi_clock_res_get(_ id: UInt32, _ resolution: UnsafeMutablePointer<UInt64>) -> Int32 {
    wasiResult { () throws(Errno) in
        let clock = try ClockID(validating: id)
        unsafe resolution.pointee = clock.resolution
    }
}

@c(__imported_wasi_snapshot_preview1_clock_time_get)
func wasi_clock_time_get(_ id: UInt32, _ precision: UInt64, _ time: UnsafeMutablePointer<UInt64>) -> Int32 {
    wasiResult { () throws(Errno) in
        let clock = try ClockID(validating: id)
        unsafe time.pointee = try clock.now()
    }
}

@c(__imported_wasi_snapshot_preview1_random_get)
func wasi_random_get(_ buffer: UnsafeMutablePointer<UInt8>, _ count: UInt32) -> Int32 {
    var output = unsafe MutableSpan(_unsafeStart: buffer, count: Int(count))
    do {
        try withRandom { try $0.fill(&output) }
        return success
    } catch {
        return Errno.io.code
    }
}

// MARK: - Standard streams

@c(__imported_wasi_snapshot_preview1_fd_write)
func wasi_fd_write(
    _ fd: Int32,
    _ vectors: UnsafeRawPointer,
    _ vectorCount: UInt32,
    _ written: UnsafeMutablePointer<UInt32>
) -> Int32 {
    wasiResult { () throws(Errno) in
        let stream = try StandardStream(validating: fd)
        guard stream != .input else { throw .badf }
        let vectors = unsafe Span(_unsafeStart: vectors.assumingMemoryBound(to: IOVec.self), count: Int(vectorCount))
        var total: UInt32 = 0
        for index in vectors.indices {
            let vector = vectors[index]
            guard vector.count > 0 else { continue }
            guard let start = unsafe UnsafePointer<UInt8>(bitPattern: UInt(vector.address)) else {
                throw .fault
            }
            let bytes = unsafe Span(_unsafeStart: start, count: Int(vector.count))
            withConsole { $0.write(bytes, to: stream) }
            total &+= vector.count
        }
        unsafe written.pointee = total
    }
}

@c(__imported_wasi_snapshot_preview1_fd_read)
func wasi_fd_read(
    _ fd: Int32,
    _ vectors: UInt32,
    _ vectorCount: UInt32,
    _ read: UnsafeMutablePointer<UInt32>
) -> Int32 {
    wasiResult { () throws(Errno) in
        guard try StandardStream(validating: fd) == .input else { throw .badf }
        unsafe read.pointee = 0
    }
}

@c(__imported_wasi_snapshot_preview1_fd_fdstat_get)
func wasi_fd_fdstat_get(_ fd: Int32, _ stat: UnsafeMutablePointer<UInt64>) -> Int32 {
    wasiResult { () throws(Errno) in
        _ = try StandardStream(validating: fd)
        var stat = unsafe MutableSpan(_unsafeStart: stat, count: Layout.fdstatWords)
        stat[0] = FileType.characterDevice
        stat[1] = Rights.stdio
        stat[2] = Rights.stdio
    }
}

@c(__imported_wasi_snapshot_preview1_fd_filestat_get)
func wasi_fd_filestat_get(_ fd: Int32, _ stat: UnsafeMutablePointer<UInt64>) -> Int32 {
    wasiResult { () throws(Errno) in
        _ = try StandardStream(validating: fd)
        var stat = unsafe MutableSpan(_unsafeStart: stat, count: Layout.filestatWords)
        for index in stat.indices {
            stat[index] = 0
        }
        stat[2] = FileType.characterDevice
    }
}

@c(__imported_wasi_snapshot_preview1_fd_close)
func wasi_fd_close(_ fd: Int32) -> Int32 {
    wasiResult { () throws(Errno) in
        let stream = try StandardStream(validating: fd)
        withConsole { $0.flush(stream) }
    }
}

@c(__imported_wasi_snapshot_preview1_fd_seek)
func wasi_fd_seek(_ fd: Int32, _ offset: Int64, _ whence: UInt32, _ newOffset: UInt32) -> Int32 {
    wasiResult { () throws(Errno) in
        _ = try StandardStream(validating: fd)
        throw .spipe
    }
}

@c(__imported_wasi_snapshot_preview1_fd_tell)
func wasi_fd_tell(_ fd: Int32, _ offset: UInt32) -> Int32 {
    wasiResult { () throws(Errno) in
        _ = try StandardStream(validating: fd)
        throw .spipe
    }
}

/// Ends wasi-libc's preopen scan: there are no preopened directories.
@c(__imported_wasi_snapshot_preview1_fd_prestat_get)
func wasi_fd_prestat_get(_ fd: Int32, _ prestat: UInt32) -> Int32 {
    Errno.badf.code
}

@c(__imported_wasi_snapshot_preview1_fd_prestat_dir_name)
func wasi_fd_prestat_dir_name(_ fd: Int32, _ path: UInt32, _ pathLength: UInt32) -> Int32 {
    Errno.badf.code
}

// MARK: - Polling, scheduling and exit

@c(__imported_wasi_snapshot_preview1_poll_oneoff)
func wasi_poll_oneoff(
    _ subscriptions: UnsafePointer<UInt64>,
    _ events: UnsafeMutablePointer<UInt64>,
    _ subscriptionCount: UInt32,
    _ eventCount: UnsafeMutablePointer<UInt32>
) -> Int32 {
    wasiResult { () throws(Errno) in
        guard subscriptionCount > 0 else { throw .inval }
        // wasi-libc's sleep functions pass one subscription; `poll` and `select` with several
        // are unsupported, as in browser_wasi_shim.
        guard subscriptionCount == 1 else { throw .notsup }
        let subscription = unsafe Span(_unsafeStart: subscriptions, count: Layout.subscriptionWords)
        var event = unsafe MutableSpan(_unsafeStart: events, count: Layout.eventWords)
        try withSleeper { sleeper throws(Errno) in try pollOneoff(subscription, &event, sleeper: &sleeper) }
        unsafe eventCount.pointee = 1
    }
}

@c(__imported_wasi_snapshot_preview1_sched_yield)
func wasi_sched_yield() -> Int32 {
    success
}

/// Flushes pending output, records the exit code for `wasi_shim_exit_code` and traps.
///
/// The trap is the only way to stop without host-provided code: BridgeJS catches every
/// JavaScript exception, so a JavaScript `throw` cannot unwind through it.
@c(__imported_wasi_snapshot_preview1_proc_exit)
func wasi_proc_exit(_ code: UInt32) -> Never {
    withConsole { $0.flush() }
    unsafe exitCode = Int32(bitPattern: code)
    abort()
}

/// Not imported by current wasi-libc; defined so no build can end up importing it.
@c(__imported_wasi_snapshot_preview1_proc_raise)
func wasi_proc_raise(_ signal: UInt32) -> Int32 {
    wasi_proc_exit(128 &+ signal)
}

/// The code passed to `proc_exit`, or -1 if it was not called. A host that sees a
/// `WebAssembly.RuntimeError` reads this to tell an exit from a crash.
@_expose(wasm, "wasi_shim_exit_code")
func wasi_shim_exit_code() -> Int32 {
    unsafe exitCode
}

// MARK: - Unsupported file descriptor operations

@c(__imported_wasi_snapshot_preview1_fd_advise)
func wasi_fd_advise(_ fd: Int32, _ offset: UInt64, _ length: UInt64, _ advice: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_allocate)
func wasi_fd_allocate(_ fd: Int32, _ offset: UInt64, _ length: UInt64) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_datasync)
func wasi_fd_datasync(_ fd: Int32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_fdstat_set_flags)
func wasi_fd_fdstat_set_flags(_ fd: Int32, _ flags: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_fdstat_set_rights)
func wasi_fd_fdstat_set_rights(_ fd: Int32, _ base: UInt64, _ inheriting: UInt64) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_filestat_set_size)
func wasi_fd_filestat_set_size(_ fd: Int32, _ size: UInt64) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_filestat_set_times)
func wasi_fd_filestat_set_times(
    _ fd: Int32,
    _ accessTime: UInt64,
    _ modificationTime: UInt64,
    _ flags: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_pread)
func wasi_fd_pread(
    _ fd: Int32,
    _ vectors: UInt32,
    _ vectorCount: UInt32,
    _ offset: UInt64,
    _ read: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_pwrite)
func wasi_fd_pwrite(
    _ fd: Int32,
    _ vectors: UInt32,
    _ vectorCount: UInt32,
    _ offset: UInt64,
    _ written: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_readdir)
func wasi_fd_readdir(
    _ fd: Int32,
    _ buffer: UInt32,
    _ bufferLength: UInt32,
    _ cookie: UInt64,
    _ used: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_renumber)
func wasi_fd_renumber(_ fd: Int32, _ to: Int32) -> Int32 {
    guard StandardStream(rawValue: to) != nil else { return Errno.badf.code }
    return unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_fd_sync)
func wasi_fd_sync(_ fd: Int32) -> Int32 {
    unsupported(fd: fd)
}

// MARK: - Unsupported path operations (there are no preopened directories)

@c(__imported_wasi_snapshot_preview1_path_open)
func wasi_path_open(
    _ fd: Int32,
    _ lookupFlags: UInt32,
    _ path: UInt32,
    _ pathLength: UInt32,
    _ openFlags: UInt32,
    _ rightsBase: UInt64,
    _ rightsInheriting: UInt64,
    _ fdFlags: UInt32,
    _ openedFD: UInt32
) -> Int32 {
    Errno.noent.code
}

@c(__imported_wasi_snapshot_preview1_path_create_directory)
func wasi_path_create_directory(_ fd: Int32, _ path: UInt32, _ pathLength: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_filestat_get)
func wasi_path_filestat_get(
    _ fd: Int32,
    _ flags: UInt32,
    _ path: UInt32,
    _ pathLength: UInt32,
    _ stat: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_filestat_set_times)
func wasi_path_filestat_set_times(
    _ fd: Int32,
    _ flags: UInt32,
    _ path: UInt32,
    _ pathLength: UInt32,
    _ accessTime: UInt64,
    _ modificationTime: UInt64,
    _ fstFlags: UInt32
) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_link)
func wasi_path_link(
    _ oldFD: Int32,
    _ oldFlags: UInt32,
    _ oldPath: UInt32,
    _ oldPathLength: UInt32,
    _ newFD: Int32,
    _ newPath: UInt32,
    _ newPathLength: UInt32
) -> Int32 {
    unsupported(fd: oldFD)
}

@c(__imported_wasi_snapshot_preview1_path_readlink)
func wasi_path_readlink(
    _ fd: Int32,
    _ path: UInt32,
    _ pathLength: UInt32,
    _ buffer: UInt32,
    _ bufferLength: UInt32,
    _ used: UInt32
) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_remove_directory)
func wasi_path_remove_directory(_ fd: Int32, _ path: UInt32, _ pathLength: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_rename)
func wasi_path_rename(
    _ fd: Int32,
    _ oldPath: UInt32,
    _ oldPathLength: UInt32,
    _ newFD: Int32,
    _ newPath: UInt32,
    _ newPathLength: UInt32
) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_symlink)
func wasi_path_symlink(
    _ oldPath: UInt32,
    _ oldPathLength: UInt32,
    _ fd: Int32,
    _ newPath: UInt32,
    _ newPathLength: UInt32
)
    -> Int32
{
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_path_unlink_file)
func wasi_path_unlink_file(_ fd: Int32, _ path: UInt32, _ pathLength: UInt32) -> Int32 {
    unsupported(fd: fd)
}

// MARK: - Unsupported sockets

@c(__imported_wasi_snapshot_preview1_sock_accept)
func wasi_sock_accept(_ fd: Int32, _ flags: UInt32, _ acceptedFD: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_sock_recv)
func wasi_sock_recv(
    _ fd: Int32,
    _ vectors: UInt32,
    _ vectorCount: UInt32,
    _ flags: UInt32,
    _ received: UInt32,
    _ outFlags: UInt32
) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_sock_send)
func wasi_sock_send(_ fd: Int32, _ vectors: UInt32, _ vectorCount: UInt32, _ flags: UInt32, _ sent: UInt32) -> Int32 {
    unsupported(fd: fd)
}

@c(__imported_wasi_snapshot_preview1_sock_shutdown)
func wasi_sock_shutdown(_ fd: Int32, _ how: UInt32) -> Int32 {
    unsupported(fd: fd)
}

// MARK: - Helpers

/// `ENOTSUP` for the standard streams, `EBADF` for every other fd.
private func unsupported(fd: Int32) -> Int32 {
    StandardStream(rawValue: fd) == nil ? Errno.badf.code : Errno.notsup.code
}

private let success: Int32 = 0

@inline(__always)
private func wasiResult(_ body: () throws(Errno) -> Void) -> Int32 {
    do {
        try body()
        return success
    } catch {
        return error.code
    }
}

// The shim's global state. Multithreaded builds are rejected (see `WASI.swift`), and each piece is only
// accessed for the duration of one call into it.

nonisolated(unsafe) private var console = Console()
nonisolated(unsafe) private var random = RandomSource()
nonisolated(unsafe) private var sleeper = Sleeper()
nonisolated(unsafe) private var exitCode: Int32 = -1

private func withConsole<R>(_ body: (inout Console) -> R) -> R {
    unsafe body(&console)
}

private func withSleeper<R, E>(_ body: (inout Sleeper) throws(E) -> R) throws(E) -> R {
    try unsafe body(&sleeper)
}

private func withRandom<R, E>(_ body: (inout RandomSource) throws(E) -> R) throws(E) -> R {
    try unsafe body(&random)
}

#endif
