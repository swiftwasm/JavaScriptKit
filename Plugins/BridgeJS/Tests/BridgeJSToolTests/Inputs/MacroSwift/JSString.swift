// Export: JSString parameter
@JS func checkJSString(a: JSString) {}

// Export: JSString return
@JS func getJSString() -> JSString { fatalError() }

// Export: JSString roundtrip
@JS func roundTripJSString(_ value: JSString) -> JSString { return value }

// Export: Optional JSString parameter and return
@JS func checkOptionalJSString(a: JSString?) {}
@JS func getOptionalJSString() -> JSString? { fatalError() }
@JS func roundTripOptionalJSString(_ value: JSString?) -> JSString? { return value }

// Export: JSUndefinedOr<JSString> parameter and return
@JS func checkUndefinedOrJSString(a: JSUndefinedOr<JSString>) {}
@JS func getUndefinedOrJSString() -> JSUndefinedOr<JSString> { fatalError() }
@JS func roundTripUndefinedOrJSString(_ value: JSUndefinedOr<JSString>) -> JSUndefinedOr<JSString> { return value }

// Import: JSString parameter and return
@JSFunction func jsCheckJSString(_ a: JSString) throws(JSException) -> Void
@JSFunction func jsGetJSString() throws(JSException) -> JSString

// Import: Optional JSString parameter and return
@JSFunction func jsCheckOptionalJSString(_ a: JSString?) throws(JSException) -> Void
@JSFunction func jsGetOptionalJSString() throws(JSException) -> JSString?

// Import: JSUndefinedOr<JSString> parameter and return
@JSFunction func jsCheckUndefinedOrJSString(_ a: JSUndefinedOr<JSString>) throws(JSException) -> Void
@JSFunction func jsGetUndefinedOrJSString() throws(JSException) -> JSUndefinedOr<JSString>
