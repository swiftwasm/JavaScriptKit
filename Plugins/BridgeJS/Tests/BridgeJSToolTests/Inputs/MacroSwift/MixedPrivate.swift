@JS(namespace: "PrivateAPI")
func privateFunction() -> String

@JS(namespace: "PrivateAPI")
class PrivateClass {
    @JS public init()
    @JS public func greet() -> String
}
