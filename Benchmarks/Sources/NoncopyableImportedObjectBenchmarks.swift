import JavaScriptKit

@JSClass struct NoncopyableImportedObject: ~Copyable {
    @JSFunction init(_ start: Int) throws(JSException)
    @JSFunction func value() throws(JSException) -> Int
}

@JSClass struct NoncopyableImportedObjectRoundtrip: ~Copyable {
    @JSFunction init() throws(JSException)
    @JSFunction func make(_ start: Int) throws(JSException) -> NoncopyableImportedObject
    @JSFunction func take(_ object: borrowing NoncopyableImportedObject) throws(JSException) -> Int
}

func runNoncopyableImportedObjectBenchmarks() {
    let suite = Benchmark("Imported object")
    suite.testSuite("noncopyable/create and drop") {
        for i in 0..<100_000 {
            _ = try! NoncopyableImportedObject(i)
        }
    }
    suite.testSuite("noncopyable/create, call and drop") {
        for i in 0..<100_000 {
            _ = try! NoncopyableImportedObject(i).value()
        }
    }
    suite.testSuite("noncopyable/return and drop") {
        let roundtrip = try! NoncopyableImportedObjectRoundtrip()
        for i in 0..<100_000 {
            _ = try! roundtrip.make(i)
        }
    }
    suite.testSuite("noncopyable/pass") {
        let roundtrip = try! NoncopyableImportedObjectRoundtrip()
        let object = try! roundtrip.make(1)
        for _ in 0..<100_000 {
            _ = try! roundtrip.take(object)
        }
    }
    suite.testSuite("noncopyable/return and pass") {
        let roundtrip = try! NoncopyableImportedObjectRoundtrip()
        for i in 0..<100_000 {
            _ = try! roundtrip.take(roundtrip.make(i))
        }
    }
    suite.testSuite("noncopyable/convert and drop") {
        let object = try! ImportedObject(1).jsObject
        for _ in 0..<100_000 {
            _ = NoncopyableImportedObject(unsafelyWrapping: object)
        }
    }
    suite.testSuite("noncopyable/convert, call and drop") {
        let object = try! ImportedObject(1).jsObject
        for _ in 0..<100_000 {
            _ = try! NoncopyableImportedObject(unsafelyWrapping: object).value()
        }
    }
    suite.testSuite("noncopyable/create object, convert and drop") {
        for _ in 0..<100_000 {
            _ = NoncopyableImportedObject(unsafelyWrapping: JSObject())
        }
    }
}
