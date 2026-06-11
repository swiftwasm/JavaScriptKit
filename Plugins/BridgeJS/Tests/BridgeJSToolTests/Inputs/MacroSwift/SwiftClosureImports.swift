@JSFunction func applyInt(_ value: Int, _ transform: (Int) -> Int) throws(JSException) -> Int

@JSFunction func makeAdder(_ base: Int) throws(JSException) -> (Int) -> Int

@JS func runValidator(_ cb: (String) throws(JSException) -> Bool)

@JS func loadEach(_ fetch: (String) async throws(JSException) -> String)
