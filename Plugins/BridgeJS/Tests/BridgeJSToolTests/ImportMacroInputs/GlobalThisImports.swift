@JSClass
struct JSConsole {
    @JSFunction func log(_ message: String) throws(JSException)
}

@JSGetter(from: .global) var console: JSConsole

@JSFunction(jsName: "parseInt", from: .global) func parseInt(_ string: String) throws(JSException) -> Double

@JSClass(from: .global)
struct WebSocket {
    @JSFunction init(_ url: String) throws(JSException)
    @JSFunction func close() throws(JSException)
}
