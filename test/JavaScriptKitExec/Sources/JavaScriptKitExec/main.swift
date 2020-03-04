import JavaScriptKit

Literal_Conversion: do {
    let global = JSObjectRef.global()
    let inputs: [JSValue] = [
        .boolean(true),
        .boolean(false),
        .string("foobar"),
        .number(0),
        .number(.max),
        .number(.min),
        .null,
        .undefined,
    ]
    for (index, input) in inputs.enumerated() {
        let prop = "prop_\(index)"
        setJSValue(this: global, name: prop, value: input)
        let got = getJSValue(this: global, name: prop)
        try expectEqual(got, input)
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
    //   "prop_4": [
    //     3, 4, "str_elm_1", 5,
    //   ],
    //   "prop_5": function () {},
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
    let prop_4 = getJSValue(this: globalObject1Ref, name: "prop_4")
    let prop_4Array = try expectObject(prop_4)
    let expectedProp_4: [JSValue] = [
        .number(3), .number(4), .string("str_elm_1"), .number(5)
    ]
    for (index, expectedElement) in expectedProp_4.enumerated() {
        let actualElement = getJSValue(this: prop_4Array, index: Int32(index))
        try expectEqual(actualElement, expectedElement)
    }

    let prop_5 = getJSValue(this: globalObject1Ref, name: "prop_5")
    _ = try expectFunction(prop_5)

} catch {
    print(error)
}
