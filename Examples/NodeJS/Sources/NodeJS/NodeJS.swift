import JavaScriptKit

@main
struct NodeJS {
    static func main() {
        JSObject.global["greet"] =
            JSClosure { args in
                let nameString = args[0].string!
                return .string("Hello, \(nameString) from NodeJS!")
            }.jsValue
    }
}
