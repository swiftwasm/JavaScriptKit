#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

@_spi(BridgeJS) import JavaScriptKit

/// Turns `fd_write` calls on stdout or stderr into one console call per complete line.
struct LineBuffer: ~Copyable {
    let stream: StandardStream
    /// Bytes of the current, not yet terminated line.
    private var pending = UniqueArray<UInt8>()

    init(_ stream: StandardStream) {
        self.stream = stream
    }

    mutating func write(_ bytes: Span<UInt8>) {
        var lineStart = 0
        for index in bytes.indices where bytes[index] == newline {
            let line = bytes.extracting(lineStart..<index)
            if pending.isEmpty {
                emit(line)
            } else {
                pending.append(copying: line)
                emit(pending.span)
                pending.removeAll()
            }
            lineStart = index + 1
        }
        if lineStart < bytes.count {
            pending.append(copying: bytes.extracting(lineStart...))
        }
    }

    /// Emits a pending partial line.
    mutating func flush() {
        guard !pending.isEmpty else { return }
        emit(pending.span)
        pending.removeAll()
    }

    private func emit(_ line: Span<UInt8>) {
        if stream == .error {
            HostConsole.unsafeErrorUnowned(line)
        } else {
            HostConsole.unsafeLogUnowned(line)
        }
    }
}

struct Console: ~Copyable {
    var stdout = LineBuffer(.output)
    var stderr = LineBuffer(.error)

    mutating func write(_ bytes: Span<UInt8>, to stream: StandardStream) {
        switch stream {
        case .output: stdout.write(bytes)
        case .error: stderr.write(bytes)
        case .input: break
        }
    }

    mutating func flush(_ stream: StandardStream) {
        switch stream {
        case .output: stdout.flush()
        case .error: stderr.flush()
        case .input: break
        }
    }

    mutating func flush() {
        stdout.flush()
        stderr.flush()
    }
}

private let newline = UInt8(ascii: "\n")

extension HostConsole {
    /// Logs UTF-8 bytes in place: no validation, no copy. Invalid sequences become U+FFFD.
    static func unsafeLogUnowned(_ line: Span<UInt8>) {
        unsafeCallUnowned(bjs_HostConsole_log_static_unowned, line)
    }

    /// Like `unsafeLogUnowned`, through `console.error`.
    static func unsafeErrorUnowned(_ line: Span<UInt8>) {
        unsafeCallUnowned(bjs_HostConsole_error_static_unowned, line)
    }

    /// Passes `line` to a BridgeJS `String` import as the words of a large, mortal native string
    /// (count, storage address, flags), so the glue runs `TextDecoder` over wasm memory directly.
    /// Relies on Swift's internal wasm32 `String` layout, as BridgeJS's own lowering does; the
    /// `WASIShim` fixture tests in PackageToJS catch a toolchain that changes it.
    private static func unsafeCallUnowned(
        _ function: (Int32, Int32, Int32) -> Void,
        _ line: Span<UInt8>
    ) {
        if line.isEmpty {
            // An empty span may have no valid address; the empty literal is a small string
            // whose words carry no pointer.
            "".bridgeJSWithLoweredParameter(function)
        } else {
            let (count, address) = line.withUnsafeBufferPointer {
                (Int32($0.count), Int32(truncatingIfNeeded: Int(bitPattern: $0.baseAddress)))
            }
            // A native string's second word is the address of its storage object, whose UTF-8
            // bytes start `_StringObject.nativeBias` (20 on wasm32) bytes in, past the object
            // header and capacity and count fields. The glue adds the bias back.
            let nativeBias: Int32 = 20
            function(count, address &- nativeBias, 0)
        }
        // The glue reports a JavaScript exception here; console output has nowhere to send it.
        _ = _swift_js_take_exception()
    }
}

#endif
