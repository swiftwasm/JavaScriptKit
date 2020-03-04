import JavaScriptKit

func expectEqual<T: Equatable>(_ lhs: T, _ rhs: T) {
    if lhs != rhs {
        print("[ERROR] Expect to be equal \"\(lhs)\" and \"\(rhs)\"")
    }
}

let global = JSRef.global()
do {
    let inputs: [JSValue] = [
        .boolean(true),
        .boolean(false),
        .string("foobar"),
    ]
    for (index, input) in inputs.enumerated() {
        let prop = "prop_\(index)"
        setJSValue(this: global, name: prop, value: input)
        let got = getJSValue(this: global, name: prop)
        expectEqual(input, got)
    }
}
