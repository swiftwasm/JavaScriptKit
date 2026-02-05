@JS class Box {
    var value: Int

    init(value: Int) {
        self.value = value
    }
}

@JS func mirrorDictionary(_ values: [String: Int]) -> [String: Int]
@JS func optionalDictionary(_ values: [String: String]?) -> [String: String]?
@JS func nestedDictionary(_ values: [String: [Int]]) -> [String: [Int]]
@JS func boxDictionary(_ boxes: [String: Box]) -> [String: Box]
@JS func optionalBoxDictionary(_ boxes: [String: Box?]) -> [String: Box?]

@JSFunction func importMirrorDictionary(_ values: [String: Double]) throws(JSException) -> [String: Double]
