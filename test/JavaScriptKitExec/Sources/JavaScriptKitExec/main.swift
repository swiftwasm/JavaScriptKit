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
    //   ...
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

} catch {
    print(error)
}

Function_Call: do {
    // Notes: globalObject1 is defined in JavaScript environment
    //
    // ```js
    // global.globalObject1 = {
    //   ...
    //   "prop_5": {
    //     "func1": function () { return },
    //     "func2": function () { return 1 },
    //     "func3": function (n) { return n * 2 },
    //     "func4": function (a, b, c) { return a + b + c },
    //     "func5": function (x) { return "Hello, " + x },
    //     "func6": function (c, a, b) {
    //       if (c) { return a } else { return b }
    //     },
    //   }
    //   ...
    // }
    // ```
    //

    // Notes: If the size of `RawJSValue` is updated, these test suites will fail.
    let globalObject1 = getJSValue(this: .global(), name: "globalObject1")
    let globalObject1Ref = try expectObject(globalObject1)
    let prop_5 = getJSValue(this: globalObject1Ref, name: "prop_5")
    let prop_5Ref = try expectObject(prop_5)

    let func1 = try expectFunction(getJSValue(this: prop_5Ref, name: "func1"))
    try expectEqual(func1(), .undefined)
    let func2 = try expectFunction(getJSValue(this: prop_5Ref, name: "func2"))
    try expectEqual(func2(), .number(1))
    let func3 = try expectFunction(getJSValue(this: prop_5Ref, name: "func3"))
    try expectEqual(func3(.number(2)), .number(4))
    let func4 = try expectFunction(getJSValue(this: prop_5Ref, name: "func4"))
    try expectEqual(func4(.number(2), .number(3), .number(4)), .number(9))
    try expectEqual(func4(.number(2), .number(3), .number(4), .number(5)), .number(9))
    let func5 = try expectFunction(getJSValue(this: prop_5Ref, name: "func5"))
    try expectEqual(func5(.string("World!")), .string("Hello, World!"))
    let func6 = try expectFunction(getJSValue(this: prop_5Ref, name: "func6"))
    try expectEqual(func6(.boolean(true), .number(1), .number(2)), .number(1))
    try expectEqual(func6(.boolean(false), .number(1), .number(2)), .number(2))
    try expectEqual(func6(.boolean(true), .string("OK"), .number(2)), .string("OK"))

} catch {
    print(error)
}

Host_Function_Registration: do {

    // ```js
    // global.globalObject1 = {
    //   ...
    //   "prop_6": {
    //     "call_host_1": function() {
    //       return global.globalObject1.prop_6.host_func_1()
    //     }
    //   }
    // }
    // ```
    let globalObject1 = getJSValue(this: .global(), name: "globalObject1")
    let globalObject1Ref = try expectObject(globalObject1)
    let prop_6 = getJSValue(this: globalObject1Ref, name: "prop_6")
    let prop_6Ref = try expectObject(prop_6)

    var isHostFunc1Called = false
    let hostFunc1 = JSFunctionRef.from { (arguments) -> JSValue in
        isHostFunc1Called = true
        return .number(1)
    }

    setJSValue(this: prop_6Ref, name: "host_func_1", value: .function(hostFunc1))

    let call_host_1 = getJSValue(this: prop_6Ref, name: "call_host_1")
    let call_host_1Func = try expectFunction(call_host_1)
    try expectEqual(call_host_1Func(), .number(1))
    try expectEqual(isHostFunc1Called, true)

    let hostFunc2 = JSFunctionRef.from { (arguments) -> JSValue in
        do {
            let input = try expectNumber(arguments[0])
            return .number(input * 2)
        } catch {
            return .string(String(describing: error))
        }
    }

    try expectEqual(hostFunc2(.number(3)), .number(6))
    _ = try expectString(hostFunc2(.boolean(true)))
} catch {
    print(error)
}
