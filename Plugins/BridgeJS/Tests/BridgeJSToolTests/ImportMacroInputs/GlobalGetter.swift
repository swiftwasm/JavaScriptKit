@JSClass
struct JSConsole {
    @JSFunction func log(_ message: String) throws (JSException)
}

@JSGetter var console: JSConsole
