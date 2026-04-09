@JS class Box {
    var value: Int

    init(value: Int) {
        self.value = value
    }
}

@JS struct Counters {
    var name: String
    var counts: [String: Int?]
}

@JS func mirrorDictionary(_ values: [String: Int]) -> [String: Int]
@JS func optionalDictionary(_ values: [String: String]?) -> [String: String]?
@JS func nestedDictionary(_ values: [String: [Int]]) -> [String: [Int]]
@JS func boxDictionary(_ boxes: [String: Box]) -> [String: Box]
@JS func optionalBoxDictionary(_ boxes: [String: Box?]) -> [String: Box?]
@JS func roundtripCounters(_ counters: Counters) -> Counters

@JSFunction func importMirrorDictionary(_ values: [String: Double]) throws(JSException) -> [String: Double]
