@JS struct Point {
    var x: Double
    var y: Double
}

@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS enum Status: Int {
    case pending = 0
    case active = 1
    case completed = 2
}

@JS class Item {
    var name: String

    init(name: String) {
        self.name = name
    }
}

@JS func processIntArray(_ values: [Int]) -> [Int]
@JS func processStringArray(_ values: [String]) -> [String]
@JS func processDoubleArray(_ values: [Double]) -> [Double]
@JS func processBoolArray(_ values: [Bool]) -> [Bool]

@JS func processPointArray(_ points: [Point]) -> [Point]

@JS func processDirectionArray(_ directions: [Direction]) -> [Direction]
@JS func processStatusArray(_ statuses: [Status]) -> [Status]

@JS func sumIntArray(_ values: [Int]) -> Int
@JS func findFirstPoint(_ points: [Point], matching: String) -> Point

@JS func processUnsafeRawPointerArray(_ values: [UnsafeRawPointer]) -> [UnsafeRawPointer]
@JS func processUnsafeMutableRawPointerArray(_ values: [UnsafeMutableRawPointer]) -> [UnsafeMutableRawPointer]
@JS func processOpaquePointerArray(_ values: [OpaquePointer]) -> [OpaquePointer]

@JS func processOptionalIntArray(_ values: [Int?]) -> [Int?]
@JS func processOptionalStringArray(_ values: [String?]) -> [String?]
@JS func processOptionalArray(_ values: [Int]?) -> [Int]?
@JS func processOptionalPointArray(_ points: [Point?]) -> [Point?]
@JS func processOptionalDirectionArray(_ directions: [Direction?]) -> [Direction?]
@JS func processOptionalStatusArray(_ statuses: [Status?]) -> [Status?]

@JS func processNestedIntArray(_ values: [[Int]]) -> [[Int]]
@JS func processNestedStringArray(_ values: [[String]]) -> [[String]]
@JS func processNestedPointArray(_ points: [[Point]]) -> [[Point]]

@JS func processItemArray(_ items: [Item]) -> [Item]
@JS func processNestedItemArray(_ items: [[Item]]) -> [[Item]]

@JS func processJSObjectArray(_ objects: [JSObject]) -> [JSObject]
@JS func processOptionalJSObjectArray(_ objects: [JSObject?]) -> [JSObject?]
@JS func processNestedJSObjectArray(_ objects: [[JSObject]]) -> [[JSObject]]

@JSFunction func checkArray(_ a: JSObject) throws(JSException) -> Void
@JSFunction func checkArrayWithLength(_ a: JSObject, _ b: Double) throws(JSException) -> Void

@JSFunction func importProcessNumbers(_ values: [Double]) throws(JSException) -> Void
@JSFunction func importGetNumbers() throws(JSException) -> [Double]
@JSFunction func importTransformNumbers(_ values: [Double]) throws(JSException) -> [Double]
@JSFunction func importProcessStrings(_ values: [String]) throws(JSException) -> [String]
@JSFunction func importProcessBooleans(_ values: [Bool]) throws(JSException) -> [Bool]
