@JS func plainFunction() -> String { "plain" }

@JS(namespace: "MyModule.Utils") func namespacedFunction() -> String { "namespaced" }

@JS(namespace: "__Swift.Foundation") class Greeter {
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

    // Static methods and properties on a namespaced class must land on the
    // class's namespace entry (alongside `new`), not on the instance
    // interface and not silently dropped. Regression test for the
    // `@JS(namespace:)` + `@JS static func` bug where the hierarchical
    // exports builder only emitted the constructor.
    @JS static func makeDefault() -> Greeter {
        return Greeter(name: "World")
    }

    @JS static var defaultGreeting: String { "Hello, world!" }
}

@JS(namespace: "Utils.Converters") class Converter {
    @JS init() {}

    @JS func toString(value: Int) -> String {
        return String(value)
    }
}

@JS(namespace: "__Swift.Foundation")
class UUID {
    @JS func uuidString() -> String {
        Foundation.UUID().uuidString
    }
}

@JS(namespace: "Collections") class Container {
    var items: [Greeter]

    @JS init() {
        self.items = []
    }

    @JS func getItems() -> [Greeter] {
        return items
    }

    @JS func addItem(_ item: Greeter) {
        items.append(item)
    }
}
