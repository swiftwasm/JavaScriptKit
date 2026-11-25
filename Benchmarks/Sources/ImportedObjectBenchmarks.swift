import JavaScriptKit

@JSClass struct ImportedObject {
    @JSFunction init(_ start: Int) throws(JSException)
    @JSFunction func value() throws(JSException) -> Int
}

@JSClass struct ImportedObjectRoundtrip {
    @JSFunction init() throws(JSException)
    @JSFunction func make(_ start: Int) throws(JSException) -> ImportedObject
    @JSFunction func take(_ object: ImportedObject) throws(JSException) -> Int
}

func runImportedObjectBenchmarks() {
    let suite = Benchmark("Imported object")
    suite.testSuite("copyable/create and drop") {
        for i in 0..<100_000 {
            _ = try! ImportedObject(i)
        }
    }
    suite.testSuite("copyable/create, call and drop") {
        for i in 0..<100_000 {
            _ = try! ImportedObject(i).value()
        }
    }
    suite.testSuite("copyable/return and drop") {
        let roundtrip = try! ImportedObjectRoundtrip()
        for i in 0..<100_000 {
            _ = try! roundtrip.make(i)
        }
    }
    suite.testSuite("copyable/pass") {
        let roundtrip = try! ImportedObjectRoundtrip()
        let object = try! roundtrip.make(1)
        for _ in 0..<100_000 {
            _ = try! roundtrip.take(object)
        }
    }
    suite.testSuite("copyable/return and pass") {
        let roundtrip = try! ImportedObjectRoundtrip()
        for i in 0..<100_000 {
            _ = try! roundtrip.take(roundtrip.make(i))
        }
    }
    suite.testSuite("copyable/convert and drop") {
        let object = try! ImportedObject(1).jsObject
        for _ in 0..<100_000 {
            _ = ImportedObject(unsafelyWrapping: object)
        }
    }
    suite.testSuite("copyable/convert, call and drop") {
        let object = try! ImportedObject(1).jsObject
        for _ in 0..<100_000 {
            _ = try! ImportedObject(unsafelyWrapping: object).value()
        }
    }
    suite.testSuite("copyable/create object, convert and drop") {
        for _ in 0..<100_000 {
            _ = ImportedObject(unsafelyWrapping: JSObject())
        }
    }
}
