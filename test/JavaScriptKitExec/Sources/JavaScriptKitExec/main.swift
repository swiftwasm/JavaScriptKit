import JavaScriptKit

Literal_Conversion: do {
    let global = JSRef.global()
    let inputs: [JSValue] = [
        .boolean(true),
        .boolean(false),
        .string("foobar"),
        .number(0),
        .number(.max),
        .number(.min),
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
    let prop_1 = getJSValue(this: globalObject1Ref, name: "prop_1")
    let prop_1Ref = try expectObject(prop_1)
    let nested_prop = getJSValue(this: prop_1Ref, name: "nested_prop")
    try expectEqual(nested_prop, .number(1))
    let prop_2 = getJSValue(this: globalObject1Ref, name: "prop_2")
    try expectEqual(prop_2, .number(2))
    let prop_3 = getJSValue(this: globalObject1Ref, name: "prop_3")
    try expectEqual(prop_3, .boolean(true))
} catch {
    print(error)
}
