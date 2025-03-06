import Testing
@testable import Counter

@Test func increment() async throws {
    var counter = Counter()
    counter.increment()
    #expect(counter.count == 1)
}

@Test func incrementTwice() async throws {
    var counter = Counter()
    counter.increment()
    counter.increment()
    #expect(counter.count == 2)
}
