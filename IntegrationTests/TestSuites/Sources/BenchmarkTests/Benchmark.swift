import JavaScriptKit

class Benchmark {
    init(_ title: String) {
        self.title = title
    }

    let title: String
    let runner = JSObject.global.benchmarkRunner.function!

    func testSuite(_ name: String, _ body: @escaping (Int) -> Void) {
        let jsBody = JSClosure { arguments -> JSValue in
            let iteration = Int(arguments[0].number!)
            body(iteration)
            return .undefined
        }
        runner("\(title)/\(name)", jsBody)
    }
}
