@JS func checkInt() -> Int { fatalError() }
@JS func checkUInt() -> UInt { fatalError() }
@JS func checkFloat() -> Float { fatalError() }
@JS func checkDouble() -> Double { fatalError() }
@JS func checkBool() -> Bool { fatalError() }

@JSFunction func checkNumber() throws(JSException) -> Double
@JSFunction func checkBoolean() throws(JSException) -> Bool
