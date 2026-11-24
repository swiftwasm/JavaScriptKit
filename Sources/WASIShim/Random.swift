#if os(WASI) && compiler(>=6.4) && !_runtime(_multithreaded)

@_spi(JSObject_id) import JavaScriptKit
import _CJavaScriptKit

/// Random bytes from `crypto.getRandomValues`.
///
/// Requests shorter than a block (hash seeds, `Int.random`) are served from a pooled block, so
/// most don't cross into JavaScript at all. Longer ones are filled in place.
struct RandomSource: ~Copyable {
    private typealias Block = InlineArray<1024, UInt8>
    private static let blockSize = Block.count
    /// `getRandomValues` throws for longer arrays.
    private static let maxChunkSize = 65_536

    private var block = Block(repeating: 0)
    private var used = blockSize
    /// Only a host without a working `Uint8Array` fails this, and no caller survives a failed
    /// `random_get` anyway.
    private let blockSource = try! HostUint8Array(blockSize)

    mutating func fill(_ output: inout MutableSpan<UInt8>) throws(JSException) {
        if output.count < Self.blockSize {
            for index in output.indices {
                if used == Self.blockSize {
                    try refill()
                }
                // Bytes handed out once are never reused.
                output[index] = block[used]
                used += 1
            }
        } else {
            try output.withUnsafeMutableBufferPointer { buffer throws(JSException) in
                var offset = 0
                while offset < buffer.count {
                    let count = min(buffer.count - offset, Self.maxChunkSize)
                    try unsafe loadRandomValues(into: buffer.baseAddress! + offset, through: HostUint8Array(count))
                    offset += count
                }
            }
        }
    }

    private mutating func refill() throws(JSException) {
        var span = block.mutableSpan
        try span.withUnsafeMutableBufferPointer { buffer throws(JSException) in
            try unsafe loadRandomValues(into: buffer.baseAddress!, through: blockSource)
        }
        used = 0
    }
}

/// Fills `array` with random values and copies them to `start`.
private func loadRandomValues(
    into start: UnsafeMutablePointer<UInt8>,
    through array: HostUint8Array
) throws(JSException) {
    try HostCrypto.getRandomValues(array)
    // The runtime call behind `JSTypedArray.copyMemory`, without its `length` property lookup.
    unsafe swjs_load_typed_array(array.jsObject.id, start)
}

#endif
