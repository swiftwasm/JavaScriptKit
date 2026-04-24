import JavaScriptKit

@JS(identityMode: true)
class CachedModel {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }
}

@JS
class UncachedModel {
    @JS var value: Int

    @JS init(value: Int) {
        self.value = value
    }
}

@JS(identityMode: false)
class ExplicitlyUncachedModel {
    @JS var count: Int

    @JS init(count: Int) {
        self.count = count
    }
}
