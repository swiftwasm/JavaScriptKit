import JavaScriptKit

func expectEqual<T: Equatable>(_ lhs: T, _ rhs: T) {
    assert(lhs == rhs, "Expect to be equal \"\(lhs)\" and \"\(rhs)\"")
}

let global = JSRef.global()
do {
    let inputs: [JSValue] = [
        .boolean(true),
        .boolean(false),
    ]
    for (index, input) in inputs.enumerated() {
        let prop = "prop_\(index)"
        setJSValue(this: global, name: prop, value: input)
        let got = getJSValue(this: global, name: prop)
        expectEqual(input, got)
    }
}
