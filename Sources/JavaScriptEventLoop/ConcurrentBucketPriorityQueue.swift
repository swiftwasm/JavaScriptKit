import Synchronization

#if compiler(>=5.5) && canImport(Synchronization)

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class ConcurrentBucketPriorityQueue: @unchecked Sendable {
    private struct JobList: Sendable {
        var head: UnownedJob? = nil
        var tail: UnownedJob? = nil

        mutating func enqueue(_ job: UnownedJob) {
            job.nextInQueue().pointee = nil
            if let tail {
                tail.nextInQueue().pointee = job
                self.tail = job
            } else {
                head = job
                tail = job
            }
        }

        mutating func dequeue() -> UnownedJob? {
            guard let job = head else { return nil }
            head = job.nextInQueue().pointee
            if head == nil {
                tail = nil
            }
            job.nextInQueue().pointee = nil
            return job
        }

        var isEmpty: Bool {
            head == nil
        }
    }

    private final class Bucket: @unchecked Sendable {
        let lock = Mutex(JobList())
    }

    private final class OccupancyWord: @unchecked Sendable {
        let value = Atomic<UInt64>(0)
    }

    private let maxPriority: Int
    private let buckets: [Bucket]
    private let occupancy: [OccupancyWord]

    init(maxPriority: Int = 255) {
        self.maxPriority = max(0, maxPriority)
        let bucketCount = self.maxPriority + 1
        self.buckets = (0..<bucketCount).map { _ in Bucket() }
        let wordCount = (bucketCount + 63) / 64
        self.occupancy = (0..<wordCount).map { _ in OccupancyWord() }
    }

    func enqueue(_ job: UnownedJob) {
        while !tryEnqueue(job) {}
    }

    @discardableResult
    func tryEnqueue(_ job: UnownedJob) -> Bool {
        let index = min(Int(job.rawPriority), maxPriority)
        let (word, mask) = bitComponents(for: index)
        guard buckets[index].lock.withLockIfAvailable({ list in
            list.enqueue(job)
        }) != nil else {
            return false
        }
        setOccupancyBit(wordIndex: word, mask: mask)
        return true
    }

    func dequeue() -> UnownedJob? {
        var wordIndex = occupancy.count - 1
        while wordIndex >= 0 {
            var word = occupancy[wordIndex].value.load(ordering: .sequentiallyConsistent)
            while word != 0 {
                let leadingZeros = word.leadingZeroBitCount
                if leadingZeros == UInt64.bitWidth {
                    break
                }
                let bitIndex = UInt64.bitWidth - 1 - leadingZeros
                let mask = UInt64(1) << bitIndex
                let bucketIndex = wordIndex * UInt64.bitWidth + Int(bitIndex)
                if bucketIndex > maxPriority {
                    clearOccupancyBit(wordIndex: wordIndex, mask: mask)
                    word = occupancy[wordIndex].value.load(ordering: .sequentiallyConsistent)
                    continue
                }
                let job = buckets[bucketIndex].lock.withLock { list -> UnownedJob? in
                    guard let job = list.dequeue() else {
                        return nil
                    }
                    if list.isEmpty {
                        clearOccupancyBit(wordIndex: wordIndex, mask: mask)
                    }
                    return job
                }
                if let job {
                    return job
                }
                clearOccupancyBit(wordIndex: wordIndex, mask: mask)
                word = occupancy[wordIndex].value.load(ordering: .sequentiallyConsistent)
            }
            wordIndex -= 1
        }
        return nil
    }

    var isEmpty: Bool {
        for word in occupancy {
            if word.value.load(ordering: .sequentiallyConsistent) != 0 {
                return false
            }
        }
        return true
    }

    private func bitComponents(for priority: Int) -> (Int, UInt64) {
        let clampedPriority = max(0, min(priority, maxPriority))
        let word = clampedPriority / UInt64.bitWidth
        let bit = clampedPriority % UInt64.bitWidth
        return (word, UInt64(1) << bit)
    }

    private func setOccupancyBit(wordIndex: Int, mask: UInt64) {
        while true {
            let current = occupancy[wordIndex].value.load(ordering: .sequentiallyConsistent)
            let desired = current | mask
            let (exchanged, _) = occupancy[wordIndex].value.compareExchange(
                expected: current,
                desired: desired,
                ordering: .sequentiallyConsistent
            )
            if exchanged { return }
        }
    }

    private func clearOccupancyBit(wordIndex: Int, mask: UInt64) {
        while true {
            let current = occupancy[wordIndex].value.load(ordering: .sequentiallyConsistent)
            let desired = current & ~mask
            let (exchanged, _) = occupancy[wordIndex].value.compareExchange(
                expected: current,
                desired: desired,
                ordering: .sequentiallyConsistent
            )
            if exchanged { return }
        }
    }
}
#endif
