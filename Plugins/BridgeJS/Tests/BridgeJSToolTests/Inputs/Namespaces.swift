@JS func plainFunction() -> String { "plain" }

@JS("MyModule.Utils") func namespacedFunction() -> String { "namespaced" }

@JS("__Swift.Foundation") class Greeter {
    var name: String

    @JS init(name: String) {
        self.name = name
    }
    
    @JS func greet() -> String {
        return "Hello, " + self.name + "!"
    }
    
    func changeName(name: String) {
        self.name = name
    }
}

@JS("Utils.Converters") class Converter {
    @JS init() {}
    
    @JS func toString(value: Int) -> String {
        return String(value)
    }
}

@JS("__Swift.Foundation")
class UUID {
    @JS func uuidString() -> String {
         Foundation.UUID().uuidString
    }
}
