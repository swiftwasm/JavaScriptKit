import JavaScriptKit

// Mark functions you want to export to JavaScript with the @JS attribute
// This function will be available as `renderCircleSVG(size)` in JavaScript
@JS public func renderCircleSVG(size: Int) -> String {
    let strokeWidth = 3
    let strokeColor = "black"
    let fillColor = "red"
    let cx = size / 2
    let cy = size / 2
    let r = (size / 2) - strokeWidth
    var svg = "<svg width=\"\(size)px\" height=\"\(size)px\">"
    svg +=
        "<circle cx=\"\(cx)\" cy=\"\(cy)\" r=\"\(r)\" stroke=\"\(strokeColor)\" stroke-width=\"\(strokeWidth)\" fill=\"\(fillColor)\" />"
    svg += "</svg>"
    return svg
}

// Classes can also be exported using the @JS attribute
// This class will be available as a constructor in JavaScript: new Greeter("name")
@JS class Greeter {
    var name: String

    // Use @JS for initializers you want to expose
    @JS init(name: String) {
        self.name = name
    }

    // Methods need the @JS attribute to be accessible from JavaScript
    // This method will be available as greeter.greet() in JavaScript
    @JS public func greet() -> String {
        "Hello, \(name)!"
    }
}
