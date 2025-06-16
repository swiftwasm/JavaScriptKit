@JS func throwsSomething() throws(JSException) {
    throw JSException(JSError(message: "TestError").jsValue)
}
