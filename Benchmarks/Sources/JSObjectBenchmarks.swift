import JavaScriptKit

func runJSObjectBenchmarks() {
    let suite = Benchmark("JSObject")
    let holder = JSObject()
    holder.child = JSObject().jsValue
    suite.testSuite("create and drop") {
        for _ in 0..<100_000 {
            _ = JSObject()
        }
    }
    suite.testSuite("read object property and drop") {
        for _ in 0..<100_000 {
            _ = holder.child.object
        }
    }
    let kept = holder.child.object!
    suite.testSuite("read object property Swift also holds and drop") {
        _ = kept
        for _ in 0..<100_000 {
            _ = holder.child.object
        }
    }
    let other = holder.child.object!
    suite.testSuite("compare two JSObjects") {
        for _ in 0..<100_000 {
            _ = kept == other
        }
    }
}
