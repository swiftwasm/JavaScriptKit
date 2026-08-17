import JavaScriptKit

@JS class Workspace {
    let name: String

    @JS init(name: String) {
        self.name = name
    }

    @JS func describe() -> String {
        name
    }
}
