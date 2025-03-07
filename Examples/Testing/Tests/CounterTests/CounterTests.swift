@testable import Counter

#if canImport(Testing)
import Testing

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

#endif

import XCTest

class CounterTests: XCTestCase {
    func testIncrement() async {
        var counter = Counter()
        counter.increment()
        XCTAssertEqual(counter.count, 1)
    }

    func testIncrementTwice() async {
        var counter = Counter()
        counter.increment()
        counter.increment()
        XCTAssertEqual(counter.count, 2)
    }
}
