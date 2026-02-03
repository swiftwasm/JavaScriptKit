@JSClass struct Greeter {
    @JSGetter var name: String
    @JSSetter func setName(_ value: String) throws(JSException)
    @JSGetter var age: Double
    @JSFunction init(_ name: String) throws(JSException)
    @JSFunction func greet() throws(JSException) -> String
    @JSFunction func changeName(_ name: String) throws(JSException) -> Void
}

@JSFunction func returnAnimatable() throws(JSException) -> Animatable

@JSClass struct Animatable {
    @JSFunction func animate(_ keyframes: JSObject, _ options: JSObject) throws(JSException) -> JSObject
    @JSFunction func getAnimations(_ options: JSObject) throws(JSException) -> JSObject
}
