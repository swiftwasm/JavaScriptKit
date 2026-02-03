@JS(namespace: "GlobalAPI")
func globalFunction() -> String

@JS(namespace: "GlobalAPI")
class GlobalClass {
    @JS public init()
    @JS public func greet() -> String
}
