@JS("makeGreeting") func renderGreeting(name: String) -> String

@JS("greetName") func greet(_ name: String) -> String

@JS("greetCount") func greet(_ count: Int) -> String

@JS("namespacedRenamed", namespace: "Utils.Text") func namespacedFunction() -> Int

@JS class RenamedMembers {
    @JS("label") var title: String
    @JS("total") let count: Int
    @JS("sharedTotal") nonisolated(unsafe) static var sharedCount: Int = 0
    @JS("readOnlyLimit") static let limit: Int = 10

    @JS init(title: String, count: Int)
    @JS("makeGreeting") func greet() -> String
    @JS("makeDefault") static func createDefault() -> RenamedMembers
}

@JS struct RenamedVector {
    var dx: Double
    var dy: Double

    @JS("originVector") static let origin: RenamedVector = RenamedVector(dx: 0, dy: 0)
    @JS("magnitude") func length() -> Double
    @JS("fromPolar") static func polar(radius: Double, angle: Double) -> RenamedVector
}

@JS enum RenamedEnumMembers {
    case active
    case inactive

    @JS("describeCase") static func describe() -> String
    @JS("currentDefault") nonisolated(unsafe) static var defaultValue: String = "active"
}

@JS enum RenamedNamespaceMembers {
    @JS("plus") static func add(_ a: Int, _ b: Int) -> Int
    @JS("theAnswer") nonisolated(unsafe) static var answer: Int = 42
}
