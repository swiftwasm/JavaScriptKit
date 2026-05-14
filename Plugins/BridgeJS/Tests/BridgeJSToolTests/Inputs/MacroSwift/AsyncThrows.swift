@JS func asyncThrowsVoid() async throws(JSException) {
    throw JSException(message: "TestError")
}

@JS func asyncThrowsWithResult() async throws(JSException) -> Int {
    return 1
}
