@JS func takeUnsafeRawPointer(_ p: UnsafeRawPointer) {}
@JS func takeUnsafeMutableRawPointer(_ p: UnsafeMutableRawPointer) {}
@JS func takeOpaquePointer(_ p: OpaquePointer) {}
@JS func takeUnsafePointer(_ p: UnsafePointer<UInt8>) {}
@JS func takeUnsafeMutablePointer(_ p: UnsafeMutablePointer<UInt8>) {}

@JS func returnUnsafeRawPointer() -> UnsafeRawPointer { UnsafeRawPointer(bitPattern: 1)! }
@JS func returnUnsafeMutableRawPointer() -> UnsafeMutableRawPointer { UnsafeMutableRawPointer(bitPattern: 1)! }
@JS func returnOpaquePointer() -> OpaquePointer { OpaquePointer(bitPattern: 1)! }
@JS func returnUnsafePointer() -> UnsafePointer<UInt8> {
    UnsafeRawPointer(bitPattern: 1)!.assumingMemoryBound(to: UInt8.self)
}
@JS func returnUnsafeMutablePointer() -> UnsafeMutablePointer<UInt8> {
    UnsafeMutableRawPointer(bitPattern: 1)!.assumingMemoryBound(to: UInt8.self)
}

@JS struct PointerFields {
    var raw: UnsafeRawPointer
    var mutRaw: UnsafeMutableRawPointer
    var opaque: OpaquePointer
    var ptr: UnsafePointer<UInt8>
    var mutPtr: UnsafeMutablePointer<UInt8>

    @JS init(
        raw: UnsafeRawPointer,
        mutRaw: UnsafeMutableRawPointer,
        opaque: OpaquePointer,
        ptr: UnsafePointer<UInt8>,
        mutPtr: UnsafeMutablePointer<UInt8>
    ) {
        self.raw = raw
        self.mutRaw = mutRaw
        self.opaque = opaque
        self.ptr = ptr
        self.mutPtr = mutPtr
    }
}

@JS func roundTripPointerFields(_ value: PointerFields) -> PointerFields { value }
