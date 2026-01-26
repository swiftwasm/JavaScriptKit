@JSClass class Foo {
    @JSFunction init() throws(JSException)
}

@JS func makeFoo() throws(JSException) -> Foo {
    return try Foo()
}
