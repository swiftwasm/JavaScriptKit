import JavaScriptKit

struct MessageError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

func expectEqual<T: Equatable>(_ lhs: T, _ rhs: T) throws {
    if lhs != rhs {
        throw MessageError("Expect to be equal \"\(lhs)\" and \"\(rhs)\"")
    }
}

func expectObject(_ value: JSValue) throws -> JSRef {
    switch value {
    case .object(let ref): return ref
    default:
        throw MessageError("Type of \(value) should be \"object\"")
    }
}

func expectBoolean(_ value: JSValue) throws -> Bool {
    switch value {
    case .boolean(let bool): return bool
    default:
        throw MessageError("Type of \(value) should be \"boolean\"")
    }
}

Literal_Conversion: do {
    let global = JSRef.global()
    let inputs: [JSValue] = [
        .boolean(true),
        .boolean(false),
        .string("foobar"),
    ]
    for (index, input) in inputs.enumerated() {
        let prop = "prop_\(index)"
        setJSValue(this: global, name: prop, value: input)
        let got = getJSValue(this: global, name: prop)
        try expectEqual(input, got)
    }
} catch {
    print(error)
}

Object_Conversion: do {
    // Notes: globalObject1 is defined in JavaScript environment
    //
    // ```js
    // global.globalObject1 = {
    //   "prop_1": {
    //     "nested_prop": 1,
    //   },
    //   "prop_2": 2,
    //   "prop_3": true,
    // }
    // ```
    //

    let globalObject1 = getJSValue(this: .global(), name: "globalObject1")
    let globalObject1Ref = try expectObject(globalObject1)
    _ = try expectObject(getJSValue(this: globalObject1Ref, name: "prop_1"))
    let prop_3 = getJSValue(this: globalObject1Ref, name: "prop_3")
    try expectEqual(prop_3, .boolean(true))
} catch {
    print(error)
}
