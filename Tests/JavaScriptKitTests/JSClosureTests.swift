import JavaScriptKit
import XCTest

class JSClosureTests: XCTestCase {
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
}
