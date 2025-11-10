import _CJavaScriptEventLoop

#if compiler(>=5.5)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension UnownedJob {
    var rawPriority: UInt32 { flags.priority }

    func nextInQueue() -> UnsafeMutablePointer<UnownedJob?> {
        withUnsafeMutablePointer(to: &asImpl().pointee.SchedulerPrivate.0) { rawNextJobPtr in
            let nextJobPtr = UnsafeMutableRawPointer(rawNextJobPtr).bindMemory(to: UnownedJob?.self, capacity: 1)
            return nextJobPtr
        }
    }

    private func asImpl() -> UnsafeMutablePointer<_CJavaScriptEventLoop.Job> {
        unsafeBitCast(self, to: UnsafeMutablePointer<_CJavaScriptEventLoop.Job>.self)
    }

    private var flags: JobFlags {
        JobFlags(bits: asImpl().pointee.Flags)
    }
}

private struct JobFlags {
    var bits: UInt32 = 0

    var priority: UInt32 {
        (bits & 0xFF00) >> 8
    }
}
#endif
