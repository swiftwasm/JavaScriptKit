@JSFunction func createWeirdObject() throws(JSException) -> WeirdNaming

@JSClass struct WeirdNaming {
    @JSGetter var normalProperty: String
    @JSSetter func setNormalProperty(_ value: String) throws(JSException)
    @JSGetter(jsName: "property-with-dashes") var property_with_dashes: Double
    @JSSetter(jsName: "property-with-dashes") func setProperty_with_dashes(_ value: Double) throws(JSException)
    @JSGetter(jsName: "123invalidStart") var _123invalidStart: Bool
    @JSSetter(jsName: "123invalidStart") func set_123invalidStart(_ value: Bool) throws(JSException)
    @JSGetter(jsName: "property with spaces") var property_with_spaces: String
    @JSSetter(jsName: "property with spaces") func setProperty_with_spaces(_ value: String) throws(JSException)
    @JSGetter(jsName: "@specialChar") var _specialChar: Double
    @JSSetter(jsName: "@specialChar") func set_specialChar(_ value: Double) throws(JSException)
    @JSGetter var constructor: String
    @JSSetter func setConstructor(_ value: String) throws(JSException)
    @JSGetter var `for`: String
    @JSSetter func setFor(_ value: String) throws(JSException)
    @JSGetter var `Any`: String
    @JSSetter(jsName: "Any") func setAny(_ value: String) throws(JSException)
    @JSFunction func `as`() throws(JSException) -> Void
    @JSFunction func `try`() throws(JSException) -> Void
}

@JSClass(jsName: "$Weird") struct _Weird {
    @JSFunction init() throws(JSException)
    @JSFunction(jsName: "method-with-dashes") func method_with_dashes() throws(JSException) -> Void
}

@JSFunction func createWeirdClass() throws(JSException) -> _Weird
