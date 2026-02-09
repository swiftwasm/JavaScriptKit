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

@JS func takeGreeter(greeter: Greeter) {
    print(greeter.greet())
}

@JS public class PublicGreeter {}
@JS package class PackageGreeter {}

@JSFunction func jsRoundTripGreeter(greeter: Greeter) throws(JSException) -> Greeter
@JSFunction func jsRoundTripOptionalGreeter(greeter: Greeter?) throws(JSException) -> Greeter?