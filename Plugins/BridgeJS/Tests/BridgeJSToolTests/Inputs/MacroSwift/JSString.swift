// Export: JSString parameter
@JS func checkJSString(a: JSString) {}

// Export: JSString return
@JS func getJSString() -> JSString { fatalError() }

// Export: JSString roundtrip
@JS func roundTripJSString(_ value: JSString) -> JSString { return value }

// Import: JSString parameter and return
@JSFunction func jsCheckJSString(_ a: JSString) throws(JSException) -> Void
@JSFunction func jsGetJSString() throws(JSException) -> JSString
