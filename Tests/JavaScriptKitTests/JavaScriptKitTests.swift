import JavaScriptKit
import XCTest

class JavaScriptKitTests: XCTestCase {
    func testLiteralConversion() {
        let global = JSObject.global
        let inputs: [JSValue] = [
            .boolean(true),
            .boolean(false),
            .string("foobar"),
            .string("👨‍👩‍👧‍👧 Family Emoji"),
            .number(0),
            .number(Double(Int32.max)),
            .number(Double(Int32.min)),
            .number(Double.infinity),
            .number(Double.nan),
            .null,
            .undefined,
        ]
        for (index, input) in inputs.enumerated() {
            let prop = JSString("prop_\(index)")
            setJSValue(this: global, name: prop, value: input)
            let got = getJSValue(this: global, name: prop)
            switch (got, input) {
            case (.number(let lhs), .number(let rhs)):
                // Compare bitPattern because nan == nan is always false
                XCTAssertEqual(lhs.bitPattern, rhs.bitPattern)
            default:
                XCTAssertEqual(got, input)
            }
        }
    }

    func testObjectConversion() {
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

        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_1 = getJSValue(this: globalObject1Ref, name: "prop_1")
        let prop_1Ref = try! XCTUnwrap(prop_1.object)
        let nested_prop = getJSValue(this: prop_1Ref, name: "nested_prop")
        XCTAssertEqual(nested_prop, .number(1))
        let prop_2 = getJSValue(this: globalObject1Ref, name: "prop_2")
        XCTAssertEqual(prop_2, .number(2))
        let prop_3 = getJSValue(this: globalObject1Ref, name: "prop_3")
        XCTAssertEqual(prop_3, .boolean(true))
        let prop_4 = getJSValue(this: globalObject1Ref, name: "prop_4")
        let prop_4Array = try! XCTUnwrap(prop_4.object)
        let expectedProp_4: [JSValue] = [
            .number(3), .number(4), .string("str_elm_1"), .null, .undefined, .number(5),
        ]
        for (index, expectedElement) in expectedProp_4.enumerated() {
            let actualElement = getJSValue(this: prop_4Array, index: Int32(index))
            XCTAssertEqual(actualElement, expectedElement)
        }

        XCTAssertEqual(getJSValue(this: globalObject1Ref, name: "undefined_prop"), .undefined)
    }

    func testValueConstruction() {
        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_2 = getJSValue(this: globalObject1Ref, name: "prop_2")
        XCTAssertEqual(Int.construct(from: prop_2), 2)
        let prop_3 = getJSValue(this: globalObject1Ref, name: "prop_3")
        XCTAssertEqual(Bool.construct(from: prop_3), true)
        let prop_7 = getJSValue(this: globalObject1Ref, name: "prop_7")
        XCTAssertEqual(Double.construct(from: prop_7), 3.14)
        XCTAssertEqual(Float.construct(from: prop_7), 3.14)

        for source: JSValue in [
            .number(.infinity), .number(.nan),
            .number(Double(UInt64.max).nextUp), .number(Double(Int64.min).nextDown),
        ] {
            XCTAssertNil(Int.construct(from: source))
            XCTAssertNil(Int8.construct(from: source))
            XCTAssertNil(Int16.construct(from: source))
            XCTAssertNil(Int32.construct(from: source))
            XCTAssertNil(Int64.construct(from: source))
            XCTAssertNil(UInt.construct(from: source))
            XCTAssertNil(UInt8.construct(from: source))
            XCTAssertNil(UInt16.construct(from: source))
            XCTAssertNil(UInt32.construct(from: source))
            XCTAssertNil(UInt64.construct(from: source))
        }
    }

    func testArrayIterator() {
        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_4 = getJSValue(this: globalObject1Ref, name: "prop_4")
        let array1 = try! XCTUnwrap(prop_4.array)
        let expectedProp_4: [JSValue] = [
            .number(3), .number(4), .string("str_elm_1"), .null, .undefined, .number(5),
        ]
        XCTAssertEqual(Array(array1), expectedProp_4)

        // Ensure that iterator skips empty hole as JavaScript does.
        let prop_8 = getJSValue(this: globalObject1Ref, name: "prop_8")
        let array2 = try! XCTUnwrap(prop_8.array)
        let expectedProp_8: [JSValue] = [0, 2, 3, 6]
        XCTAssertEqual(Array(array2), expectedProp_8)
    }

    func testArrayRandomAccessCollection() {
        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_4 = getJSValue(this: globalObject1Ref, name: "prop_4")
        let array1 = try! XCTUnwrap(prop_4.array)
        let expectedProp_4: [JSValue] = [
            .number(3), .number(4), .string("str_elm_1"), .null, .undefined, .number(5),
        ]
        XCTAssertEqual([array1[0], array1[1], array1[2], array1[3], array1[4], array1[5]], expectedProp_4)

        // Ensure that subscript can access empty hole
        let prop_8 = getJSValue(this: globalObject1Ref, name: "prop_8")
        let array2 = try! XCTUnwrap(prop_8.array)
        let expectedProp_8: [JSValue] = [
            0, .undefined, 2, 3, .undefined, .undefined, 6,
        ]
        XCTAssertEqual([array2[0], array2[1], array2[2], array2[3], array2[4], array2[5], array2[6]], expectedProp_8)
    }

    func testValueDecoder() {
        struct GlobalObject1: Codable {
            struct Prop1: Codable {
                let nested_prop: Int
            }

            let prop_1: Prop1
            let prop_2: Int
            let prop_3: Bool
            let prop_7: Float
        }
        let decoder = JSValueDecoder()
        let rawGlobalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1 = try! decoder.decode(GlobalObject1.self, from: rawGlobalObject1)
        XCTAssertEqual(globalObject1.prop_1.nested_prop, 1)
        XCTAssertEqual(globalObject1.prop_2, 2)
        XCTAssertEqual(globalObject1.prop_3, true)
        XCTAssertEqual(globalObject1.prop_7, 3.14)
    }

    func testFunctionCall() {
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

        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_5 = getJSValue(this: globalObject1Ref, name: "prop_5")
        let prop_5Ref = try! XCTUnwrap(prop_5.object)

        let func1 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func1").function)
        XCTAssertEqual(func1(), .undefined)
        let func2 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func2").function)
        XCTAssertEqual(func2(), .number(1))
        let func3 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func3").function)
        XCTAssertEqual(func3(2), .number(4))
        let func4 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func4").function)
        XCTAssertEqual(func4(2, 3, 4), .number(9))
        XCTAssertEqual(func4(2, 3, 4, 5), .number(9))
        let func5 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func5").function)
        XCTAssertEqual(func5("World!"), .string("Hello, World!"))
        let func6 = try! XCTUnwrap(getJSValue(this: prop_5Ref, name: "func6").function)
        XCTAssertEqual(func6(true, 1, 2), .number(1))
        XCTAssertEqual(func6(false, 1, 2), .number(2))
        XCTAssertEqual(func6(true, "OK", 2), .string("OK"))
    }

    func testClosureLifetime() {
        let evalClosure = JSObject.global.globalObject1.eval_closure.function!

        do {
            let c1 = JSClosure { arguments in
                return arguments[0]
            }
            XCTAssertEqual(evalClosure(c1, JSValue.number(1.0)), .number(1.0))
            #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
            c1.release()
            #endif
        }

        do {
            let array = JSObject.global.Array.function!.new()
            let c1 = JSClosure { _ in .number(3) }
            _ = array.push!(c1)
            XCTAssertEqual(array[0].function!().number, 3.0)
            #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
            c1.release()
            #endif
        }

        do {
            let c1 = JSClosure { _ in .undefined }
            XCTAssertEqual(c1(), .undefined)
        }

        do {
            let c1 = JSClosure { _ in .number(4) }
            XCTAssertEqual(c1(), .number(4))
        }
    }

    func testHostFunctionRegistration() {
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
        let globalObject1 = getJSValue(this: .global, name: "globalObject1")
        let globalObject1Ref = try! XCTUnwrap(globalObject1.object)
        let prop_6 = getJSValue(this: globalObject1Ref, name: "prop_6")
        let prop_6Ref = try! XCTUnwrap(prop_6.object)

        var isHostFunc1Called = false
        let hostFunc1 = JSClosure { (_) -> JSValue in
            isHostFunc1Called = true
            return .number(1)
        }

        setJSValue(this: prop_6Ref, name: "host_func_1", value: .object(hostFunc1))

        let call_host_1 = getJSValue(this: prop_6Ref, name: "call_host_1")
        let call_host_1Func = try! XCTUnwrap(call_host_1.function)
        XCTAssertEqual(call_host_1Func(), .number(1))
        XCTAssertEqual(isHostFunc1Called, true)

        #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
        hostFunc1.release()
        #endif

        let evalClosure = JSObject.global.globalObject1.eval_closure.function!
        let hostFunc2 = JSClosure { (arguments) -> JSValue in
            if let input = arguments[0].number {
                return .number(input * 2)
            } else {
                return .string(String(describing: arguments[0]))
            }
        }

        XCTAssertEqual(evalClosure(hostFunc2, 3), .number(6))
        XCTAssertTrue(evalClosure(hostFunc2, true).string != nil)

        #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
        hostFunc2.release()
        #endif
    }

    func testNewObjectConstruction() {
        // ```js
        // global.Animal = function(name, age, isCat) {
        //   this.name = name
        //   this.age = age
        //   this.bark = () => {
        //     return isCat ? "nyan" : "wan"
        //   }
        // }
        // ```
        let objectConstructor = try! XCTUnwrap(getJSValue(this: .global, name: "Animal").function)
        let cat1 = objectConstructor.new("Tama", 3, true)
        XCTAssertEqual(getJSValue(this: cat1, name: "name"), .string("Tama"))
        XCTAssertEqual(getJSValue(this: cat1, name: "age"), .number(3))
        XCTAssertEqual(cat1.isInstanceOf(objectConstructor), true)
        XCTAssertEqual(cat1.isInstanceOf(try! XCTUnwrap(getJSValue(this: .global, name: "Array").function)), false)
        let cat1Bark = try! XCTUnwrap(getJSValue(this: cat1, name: "bark").function)
        XCTAssertEqual(cat1Bark(), .string("nyan"))

        let dog1 = objectConstructor.new("Pochi", 3, false)
        let dog1Bark = try! XCTUnwrap(getJSValue(this: dog1, name: "bark").function)
        XCTAssertEqual(dog1Bark(), .string("wan"))
    }

    func testObjectDecoding() {
        /*
         ```js
         global.objectDecodingTest = {
             obj: {},
             fn: () => {},
             sym: Symbol("s"),
             bi: BigInt(3)
         };
         ```
         */
        let js: JSValue = JSObject.global.objectDecodingTest

        // I can't use regular name like `js.object` here
        // cz its conflicting with case name and DML.
        // so I use abbreviated names
        let object: JSValue = js.obj
        let function: JSValue = js.fn
        let symbol: JSValue = js.sym
        let bigInt: JSValue = js.bi

        XCTAssertNotNil(JSObject.construct(from: object))
        XCTAssertEqual(JSObject.construct(from: function).map { $0 is JSFunction }, .some(true))
        XCTAssertEqual(JSObject.construct(from: symbol).map { $0 is JSSymbol }, .some(true))
        XCTAssertEqual(JSObject.construct(from: bigInt).map { $0 is JSBigInt }, .some(true))

        XCTAssertNil(JSFunction.construct(from: object))
        XCTAssertNotNil(JSFunction.construct(from: function))
        XCTAssertNil(JSFunction.construct(from: symbol))
        XCTAssertNil(JSFunction.construct(from: bigInt))

        XCTAssertNil(JSSymbol.construct(from: object))
        XCTAssertNil(JSSymbol.construct(from: function))
        XCTAssertNotNil(JSSymbol.construct(from: symbol))
        XCTAssertNil(JSSymbol.construct(from: bigInt))

        XCTAssertNil(JSBigInt.construct(from: object))
        XCTAssertNil(JSBigInt.construct(from: function))
        XCTAssertNil(JSBigInt.construct(from: symbol))
        XCTAssertNotNil(JSBigInt.construct(from: bigInt))
    }

    func testCallFunctionWithThis() {
        // ```js
        // global.Animal = function(name, age, isCat) {
        //   this.name = name
        //   this.age = age
        //   this.bark = () => {
        //     return isCat ? "nyan" : "wan"
        //   }
        //   this.isCat = isCat
        //   this.getIsCat = function() {
        //     return this.isCat
        //   }
        // }
        // ```
        let objectConstructor = try! XCTUnwrap(getJSValue(this: .global, name: "Animal").function)
        let cat1 = objectConstructor.new("Tama", 3, true)
        let cat1Value = JSValue.object(cat1)
        let getIsCat = try! XCTUnwrap(getJSValue(this: cat1, name: "getIsCat").function)
        let setName = try! XCTUnwrap(getJSValue(this: cat1, name: "setName").function)

        // Direct call without this
        XCTAssertThrowsError(try getIsCat.throws())

        // Call with this
        let gotIsCat = getIsCat(this: cat1)
        XCTAssertEqual(gotIsCat, .boolean(true))
        XCTAssertEqual(cat1.getIsCat!(), .boolean(true))
        XCTAssertEqual(cat1Value.getIsCat(), .boolean(true))

        // Call with this and argument
        setName(this: cat1, JSValue.string("Shiro"))
        XCTAssertEqual(getJSValue(this: cat1, name: "name"), .string("Shiro"))
        _ = cat1.setName!("Tora")
        XCTAssertEqual(getJSValue(this: cat1, name: "name"), .string("Tora"))
        _ = cat1Value.setName("Chibi")
        XCTAssertEqual(getJSValue(this: cat1, name: "name"), .string("Chibi"))
    }

    func testJSObjectConversion() {
        let array1 = [1, 2, 3]
        let jsArray1 = array1.jsValue.object!
        XCTAssertEqual(jsArray1.length, .number(3))
        XCTAssertEqual(jsArray1[0], .number(1))
        XCTAssertEqual(jsArray1[1], .number(2))
        XCTAssertEqual(jsArray1[2], .number(3))

        let array2: [ConvertibleToJSValue] = [1, "str", false]
        let jsArray2 = array2.jsValue.object!
        XCTAssertEqual(jsArray2.length, .number(3))
        XCTAssertEqual(jsArray2[0], .number(1))
        XCTAssertEqual(jsArray2[1], .string("str"))
        XCTAssertEqual(jsArray2[2], .boolean(false))
        _ = jsArray2.push!(5)
        XCTAssertEqual(jsArray2.length, .number(4))
        _ = jsArray2.push!(jsArray1)

        XCTAssertEqual(jsArray2[4], .object(jsArray1))

        let dict1: [String: JSValue] = [
            "prop1": 1.jsValue,
            "prop2": "foo".jsValue,
        ]
        let jsDict1 = dict1.jsValue.object!
        XCTAssertEqual(jsDict1.prop1, .number(1))
        XCTAssertEqual(jsDict1.prop2, .string("foo"))
    }

    func testObjectRefLifetime() {
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

        let evalClosure = JSObject.global.globalObject1.eval_closure.function!
        let identity = JSClosure { $0[0] }
        let ref1 = getJSValue(this: .global, name: "globalObject1").object!
        let ref2 = evalClosure(identity, ref1).object!
        XCTAssertEqual(ref1.prop_2, .number(2))
        XCTAssertEqual(ref2.prop_2, .number(2))

        #if JAVASCRIPTKIT_WITHOUT_WEAKREFS
        identity.release()
        #endif
    }

    func testDate() {
        let date1Milliseconds = JSDate.now()
        let date1 = JSDate(millisecondsSinceEpoch: date1Milliseconds)
        let date2 = JSDate(millisecondsSinceEpoch: date1.valueOf())

        XCTAssertEqual(date1.valueOf(), date2.valueOf())
        XCTAssertEqual(date1.fullYear, date2.fullYear)
        XCTAssertEqual(date1.month, date2.month)
        XCTAssertEqual(date1.date, date2.date)
        XCTAssertEqual(date1.day, date2.day)
        XCTAssertEqual(date1.hours, date2.hours)
        XCTAssertEqual(date1.minutes, date2.minutes)
        XCTAssertEqual(date1.seconds, date2.seconds)
        XCTAssertEqual(date1.milliseconds, date2.milliseconds)
        XCTAssertEqual(date1.utcFullYear, date2.utcFullYear)
        XCTAssertEqual(date1.utcMonth, date2.utcMonth)
        XCTAssertEqual(date1.utcDate, date2.utcDate)
        XCTAssertEqual(date1.utcDay, date2.utcDay)
        XCTAssertEqual(date1.utcHours, date2.utcHours)
        XCTAssertEqual(date1.utcMinutes, date2.utcMinutes)
        XCTAssertEqual(date1.utcSeconds, date2.utcSeconds)
        XCTAssertEqual(date1.utcMilliseconds, date2.utcMilliseconds)
        XCTAssertEqual(date1, date2)

        let date3 = JSDate(millisecondsSinceEpoch: 0)
        XCTAssertEqual(date3.valueOf(), 0)
        XCTAssertEqual(date3.utcFullYear, 1970)
        XCTAssertEqual(date3.utcMonth, 0)
        XCTAssertEqual(date3.utcDate, 1)
        // the epoch date was on Friday
        XCTAssertEqual(date3.utcDay, 4)
        XCTAssertEqual(date3.utcHours, 0)
        XCTAssertEqual(date3.utcMinutes, 0)
        XCTAssertEqual(date3.utcSeconds, 0)
        XCTAssertEqual(date3.utcMilliseconds, 0)
        XCTAssertEqual(date3.toISOString(), "1970-01-01T00:00:00.000Z")

        XCTAssertTrue(date3 < date1)
    }

    func testError() {
        let message = "test error"
        let expectedDescription = "Error: test error"
        let error = JSError(message: message)
        XCTAssertEqual(error.name, "Error")
        XCTAssertEqual(error.message, message)
        XCTAssertEqual(error.description, expectedDescription)
        XCTAssertFalse(error.stack?.isEmpty ?? true)
        XCTAssertNil(JSError(from: .string("error"))?.description)
        XCTAssertEqual(JSError(from: .object(error.jsObject))?.description, expectedDescription)
    }

    func testJSValueAccessor() {
        let globalObject1 = JSObject.global.globalObject1
        XCTAssertEqual(globalObject1.prop_1.nested_prop, .number(1))
        XCTAssertEqual(globalObject1.object!.prop_1.object!.nested_prop, .number(1))

        XCTAssertEqual(globalObject1.prop_4[0], .number(3))
        XCTAssertEqual(globalObject1.prop_4[1], .number(4))

        let originalProp1 = globalObject1.prop_1.object!.nested_prop
        globalObject1.prop_1.nested_prop = "bar"
        XCTAssertEqual(globalObject1.prop_1.nested_prop, .string("bar"))
        globalObject1.prop_1.nested_prop = originalProp1
    }

    func testException() {
        // ```js
        // global.globalObject1 = {
        //   ...
        //   prop_9: {
        //       func1: function () {
        //           throw new Error();
        //       },
        //       func2: function () {
        //           throw "String Error";
        //       },
        //       func3: function () {
        //           throw 3.0
        //       },
        //   },
        //   ...
        // }
        // ```
        //
        let globalObject1 = JSObject.global.globalObject1
        let prop_9: JSValue = globalObject1.prop_9

        // MARK: Throwing method calls
        XCTAssertThrowsError(try prop_9.object!.throwing.func1!()) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }

        XCTAssertThrowsError(try prop_9.object!.throwing.func2!()) { error in
            XCTAssertTrue(error is JSException)
            let thrownValue = (error as! JSException).thrownValue
            XCTAssertEqual(thrownValue.string, "String Error")
        }

        XCTAssertThrowsError(try prop_9.object!.throwing.func3!()) { error in
            XCTAssertTrue(error is JSException)
            let thrownValue = (error as! JSException).thrownValue
            XCTAssertEqual(thrownValue.number, 3.0)
        }

        // MARK: Simple function calls
        XCTAssertThrowsError(try prop_9.func1.function!.throws()) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }

        // MARK: Throwing constructor call
        let Animal = JSObject.global.Animal.function!
        XCTAssertNoThrow(try Animal.throws.new("Tama", 3, true))
        XCTAssertThrowsError(try Animal.throws.new("Tama", -3, true)) { error in
            XCTAssertTrue(error is JSException)
            let errorObject = JSError(from: (error as! JSException).thrownValue)
            XCTAssertNotNil(errorObject)
        }
    }

    func testSymbols() {
        let symbol1 = JSSymbol("abc")
        let symbol2 = JSSymbol("abc")
        XCTAssertNotEqual(symbol1, symbol2)
        XCTAssertEqual(symbol1.name, symbol2.name)
        XCTAssertEqual(symbol1.name, "abc")

        XCTAssertEqual(JSSymbol.iterator, JSSymbol.iterator)

        // let hasInstanceClass = {
        //   prop: function () {}
        // }.prop
        // Object.defineProperty(hasInstanceClass, Symbol.hasInstance, { value: () => true })
        let hasInstanceObject = JSObject.global.Object.function!.new()
        hasInstanceObject.prop = JSClosure { _ in .undefined }.jsValue
        let hasInstanceClass = hasInstanceObject.prop.function!
        let propertyDescriptor = JSObject.global.Object.function!.new()
        propertyDescriptor.value = JSClosure { _ in .boolean(true) }.jsValue
        _ = JSObject.global.Object.function!.defineProperty!(
            hasInstanceClass,
            JSSymbol.hasInstance,
            propertyDescriptor
        )
        XCTAssertEqual(hasInstanceClass[JSSymbol.hasInstance].function!().boolean, true)
        XCTAssertEqual(JSObject.global.Object.isInstanceOf(hasInstanceClass), true)
    }

    func testJSValueDecoder() {
        struct AnimalStruct: Decodable {
            let name: String
            let age: Int
            let isCat: Bool
        }

        let Animal = JSObject.global.Animal.function!
        let tama = try! Animal.throws.new("Tama", 3, true)
        let decoder = JSValueDecoder()
        let decodedTama = try! decoder.decode(AnimalStruct.self, from: tama.jsValue)

        XCTAssertEqual(decodedTama.name, tama.name.string)
        XCTAssertEqual(decodedTama.name, "Tama")

        XCTAssertEqual(decodedTama.age, tama.age.number.map(Int.init))
        XCTAssertEqual(decodedTama.age, 3)

        XCTAssertEqual(decodedTama.isCat, tama.isCat.boolean)
        XCTAssertEqual(decodedTama.isCat, true)
    }

    func testConvertibleToJSValue() {
        let array1 = [1, 2, 3]
        let jsArray1 = array1.jsValue.object!
        XCTAssertEqual(jsArray1.length, .number(3))
        XCTAssertEqual(jsArray1[0], .number(1))
        XCTAssertEqual(jsArray1[1], .number(2))
        XCTAssertEqual(jsArray1[2], .number(3))

        let array2: [ConvertibleToJSValue] = [1, "str", false]
        let jsArray2 = array2.jsValue.object!
        XCTAssertEqual(jsArray2.length, .number(3))
        XCTAssertEqual(jsArray2[0], .number(1))
        XCTAssertEqual(jsArray2[1], .string("str"))
        XCTAssertEqual(jsArray2[2], .boolean(false))
        _ = jsArray2.push!(5)
        XCTAssertEqual(jsArray2.length, .number(4))
        _ = jsArray2.push!(jsArray1)

        XCTAssertEqual(jsArray2[4], .object(jsArray1))

        let dict1: [String: JSValue] = [
            "prop1": 1.jsValue,
            "prop2": "foo".jsValue,
        ]
        let jsDict1 = dict1.jsValue.object!
        XCTAssertEqual(jsDict1.prop1, .number(1))
        XCTAssertEqual(jsDict1.prop2, .string("foo"))
    }

    func testGrowMemory() {
        // If WebAssembly.Memory is not accessed correctly (i.e. creating a new view each time),
        // this test will fail with `TypeError: Cannot perform Construct on a detached ArrayBuffer`,
        // since asking to grow memory will detach the backing ArrayBuffer.
        // See https://github.com/swiftwasm/JavaScriptKit/pull/153
        let string = "Hello"
        let jsString = JSValue.string(string)
        _ = growMemory(0, 1)
        XCTAssertEqual(string, jsString.description)
    }

    func testHashableConformance() {
        let globalObject1 = JSObject.global.console.object!
        let globalObject2 = JSObject.global.console.object!
        XCTAssertEqual(globalObject1.hashValue, globalObject2.hashValue)
        // These are 2 different objects in Swift referencing the same object in JavaScript
        XCTAssertNotEqual(ObjectIdentifier(globalObject1), ObjectIdentifier(globalObject2))

        let objectConstructor = JSObject.global.Object.function!
        let obj = objectConstructor.new()
        obj.a = 1.jsValue
        let firstHash = obj.hashValue
        obj.b = 2.jsValue
        let secondHash = obj.hashValue
        XCTAssertEqual(firstHash, secondHash)
    }
}

@_extern(c, "llvm.wasm.memory.grow.i32")
func growMemory(_ memory: Int32, _ pages: Int32) -> Int32
