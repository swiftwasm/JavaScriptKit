@JS func checkString(a: String) {}
@JS func roundtripString(a: String) -> String { return a }

@JSFunction func checkString(_ a: String) throws(JSException) -> Void
@JSFunction func checkStringWithLength(_ a: String, _ b: Double) throws(JSException) -> Void
