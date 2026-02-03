@_spi(Experimental) @_spi(BridgeJS) import JavaScriptKit

@JSFunction func jsRoundTripIntArray(_ items: [Int]) throws(JSException) -> [Int]
@JSFunction func jsRoundTripStringArray(_ items: [String]) throws(JSException) -> [String]
@JSFunction func jsArrayLength(_ items: [Int]) throws(JSException) -> Int

@JSClass struct ArrayHost {
    @JSGetter var numbers: [Int]
    @JSGetter var labels: [String]
    @JSSetter func setNumbers(_ value: [Int]) throws(JSException)
    @JSSetter func setLabels(_ value: [String]) throws(JSException)
    @JSFunction init(_ numbers: [Int], _ labels: [String]) throws(JSException)
    @JSFunction func concatNumbers(_ values: [Int]) throws(JSException) -> [Int]
    @JSFunction func concatLabels(_ values: [String]) throws(JSException) -> [String]
    @JSFunction func firstLabel(_ values: [String]) throws(JSException) -> String
}

@JSFunction func makeArrayHost(_ numbers: [Int], _ labels: [String]) throws(JSException) -> ArrayHost
