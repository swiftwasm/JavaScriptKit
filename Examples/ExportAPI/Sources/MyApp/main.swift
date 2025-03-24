import JavaScriptKit

@JS public func hello() -> String {
    "Hello, world!"
}

@JS public func twice(x: Int) -> Int {
    x * 2
}

JSObject.global.helloClosure = .object(
    JSClosure { _ in
        return "Hello, world!"
    }
)

JSObject.global.twiceClosure = .object(
    JSClosure { args in
        let x = Int(args[0].number!)
        return .number(Double(x * 2))
    }
)
