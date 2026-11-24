#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

import JavaScriptKit

/// Blocks the calling thread: `Atomics.wait` where the host allows it (workers, Node), otherwise a
/// busy-wait on `performance.now()` (the browser main thread, or no `SharedArrayBuffer`).
struct Sleeper: ~Copyable {
    private enum Strategy {
        case untried
        case atomics(HostInt32Array)
        case spin
    }

    private var strategy = Strategy.untried

    mutating func sleep(nanoseconds: UInt64) {
        let milliseconds = Double(nanoseconds) / 1_000_000
        if case .untried = strategy {
            if let array = try? HostInt32Array(HostSharedArrayBuffer(4)) {
                strategy = .atomics(array)
            } else {
                strategy = .spin
            }
        }
        if case .atomics(let array) = strategy {
            do {
                try HostAtomics.wait(array, 0, 0, milliseconds)
                return
            } catch {
                strategy = .spin
            }
        }
        guard let start = try? HostPerformance.now() else { return }
        let deadline = start + milliseconds
        while let now = try? HostPerformance.now(), now < deadline {}
    }
}

#endif
