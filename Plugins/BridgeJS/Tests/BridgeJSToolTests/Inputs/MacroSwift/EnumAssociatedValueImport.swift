@JS enum PayloadSignal {
    case start(String)
    case stop(Int)
    case idle
}

// Associated-value enums bridge as their `Int32` case ID plus stack payload in imported
// function parameters and return values.
@JSClass struct PayloadSignalControls {
    @JSFunction func send(_ signal: PayloadSignal) throws(JSException)
    @JSFunction func current() throws(JSException) -> PayloadSignal
    @JSFunction static func roundTrip(_ signal: PayloadSignal) throws(JSException) -> PayloadSignal
    @JSFunction func roundTripOptional(_ signal: PayloadSignal?) throws(JSException) -> PayloadSignal?
}
