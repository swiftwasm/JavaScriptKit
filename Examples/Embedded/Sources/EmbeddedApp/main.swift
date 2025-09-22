import JavaScriptKit

public func take(_ value: JSObject) {
    _ = value[0]
}

public func main() {
    take(JSObject.global)
}