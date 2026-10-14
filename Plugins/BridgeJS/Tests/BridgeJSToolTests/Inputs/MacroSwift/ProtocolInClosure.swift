import JavaScriptKit

@JS protocol Renderable {
    func render() -> String
}

@JS class Widget {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }
}

@JS func processRenderable(_ item: Renderable, transform: (Renderable) -> String) -> String
@JS func makeRenderableFactory(defaultName: String) -> () -> Renderable
@JS func roundtripRenderable(_ callback: (any Renderable) -> any Renderable) -> (any Renderable) -> any Renderable
@JS func processOptionalRenderable(_ callback: ((any Renderable)?) -> String) -> String
