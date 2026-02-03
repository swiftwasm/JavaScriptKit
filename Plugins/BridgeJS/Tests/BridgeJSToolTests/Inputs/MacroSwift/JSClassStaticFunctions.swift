extension StaticBox {
    @JSFunction static func makeDefault() throws(JSException) -> StaticBox
}

@JSClass struct StaticBox {
    @JSFunction static func create(_ value: Double) throws(JSException) -> StaticBox
    @JSFunction func value() throws(JSException) -> Double
    @JSFunction static func value() throws(JSException) -> Double
}

extension StaticBox {
    @JSFunction(jsName: "with-dashes") static func dashed() throws(JSException) -> StaticBox
}
