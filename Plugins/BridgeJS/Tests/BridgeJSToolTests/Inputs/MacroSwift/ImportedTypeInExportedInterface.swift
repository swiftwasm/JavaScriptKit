@JSClass class Foo {
    @JSFunction init() throws(JSException)
}

@JS func makeFoo() throws(JSException) -> Foo {
    return try Foo()
}

@JS func processFooArray(_ foos: [Foo]) -> [Foo]
@JS func processOptionalFooArray(_ foos: [Foo?]) -> [Foo?]

@JS struct FooContainer {
    var foo: Foo
    var optionalFoo: Foo?
}

@JS func roundtripFooContainer(_ container: FooContainer) -> FooContainer
