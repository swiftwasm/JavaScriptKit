import JavaScriptKit

@JS("renamedEcho") func jsNameEcho(_ value: String) -> String {
    return "echo: \(value)"
}

@JS("greetName") func greet(_ name: String) -> String {
    return "Hello, \(name)!"
}

@JS("greetCount") func greet(_ count: Int) -> String {
    return "Hello, \(count) people!"
}

@JS class JSNameRenamedClass {
    private var storage: Int

    @JS init(value: Int) {
        self.storage = value
    }

    @JS("current") var value: Int {
        get { storage }
        set { storage = newValue }
    }

    @JS("doubled") func timesTwo() -> Int {
        return storage * 2
    }

    @JS("makeWithValue") static func create(value: Int) -> JSNameRenamedClass {
        return JSNameRenamedClass(value: value)
    }
}
