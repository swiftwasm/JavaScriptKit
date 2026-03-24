@JS class Greeter {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }
    @JS func greet() -> String {
        return "Hello, " + self.name + "!"
    }
    @JS func changeName(name: String) {
        self.name = name
    }
}

extension Greeter {
    @JS func greetEnthusiastically() -> String {
        return "Hey, " + self.name + "!!!"
    }

    @JS var nameCount: Int { name.count }

    @JS static func greetAnonymously() -> String {
        return "Hello."
    }

    @JS static var defaultGreeting: String { "Hello, world!" }
}

@JS func takeGreeter(greeter: Greeter) {
    print(greeter.greet())
}

@JS public class PublicGreeter {}
@JS package class PackageGreeter {}

@JSFunction func jsRoundTripGreeter(greeter: Greeter) throws(JSException) -> Greeter
@JSFunction func jsRoundTripOptionalGreeter(greeter: Greeter?) throws(JSException) -> Greeter?
