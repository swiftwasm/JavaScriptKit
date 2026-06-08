@JS enum Signal {
    case start
    case stop
}

// Case enums (no raw value) bridge as their `Int32` tag as imported-function
// parameters and return values.
@JSClass struct SignalControls {
    @JSFunction func send(_ signal: Signal) throws(JSException)
    @JSFunction func current() throws(JSException) -> Signal
    @JSFunction static func roundTrip(_ signal: Signal) throws(JSException) -> Signal
}
