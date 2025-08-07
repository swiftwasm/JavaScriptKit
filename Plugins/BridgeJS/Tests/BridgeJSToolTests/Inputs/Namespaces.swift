@JS func plainFunction() -> String { "plain" }

@JS("__Swift.Foundation") class Greeter {
    var name: String

    @JS("__Swift.Foundation") init(name: String) {
        self.name = name
    }
    
    @JS("__Swift.Foundation") func greet() -> String {
        return "Hello, " + self.name + "!"
    }
    
    @JS("__Swift.Foundation") func changeName(name: String) {
        self.name = name
    }
}

@JS("Utils.Converters") class Converter {
    @JS("Utils.Converters") init() {}
    
    @JS("Utils.Converters") func toString(value: Int) -> String {
        return String(value)
    }
}

@JS("__Swift.Foundation")
class UUID {
    @JS("__Swift.Foundation")
    @JS func uuidString() -> String {
         Foundation.UUID().uuidString
    }
}
