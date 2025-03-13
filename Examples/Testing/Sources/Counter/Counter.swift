public struct Counter {
    public private(set) var count = 0

    public mutating func increment() {
        count += 1
    }
}
