@JS struct Counter {
    var number: Int
}

extension Counter {
    @JS public mutating func increment() {
        number += 1
    }
    @JS public mutating func add(_ value: Int) {
        number += value
    }
}
