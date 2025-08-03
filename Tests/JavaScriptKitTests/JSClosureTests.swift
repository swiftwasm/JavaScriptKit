@_spi(JSObject_id) import JavaScriptKit
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

    func testRegressionTestForMisDeallocation() async throws {
        // Use Node.js's `--expose-gc` flag to enable manual garbage collection.
        guard let gc = JSObject.global.gc.function else {
            throw XCTSkip("Missing --expose-gc flag")
        }

        // Step 1: Create many JSClosure instances
        let obj = JSObject()
        var closurePointers: Set<UInt32> = []
        let numberOfSourceClosures = 10_000

        do {
            var closures: [JSClosure] = []
            for i in 0..<numberOfSourceClosures {
                let closure = JSClosure { _ in .undefined }
                obj["c\(i)"] = closure.jsValue
                closures.append(closure)
                // Store
                closurePointers.insert(UInt32(UInt(bitPattern: Unmanaged.passUnretained(closure).toOpaque())))

                // To avoid all JSClosures having a common address diffs, randomly allocate a new object.
                if Bool.random() {
                    _ = JSObject()
                }
            }
        }

        // Step 2: Create many JSObject to make JSObject.id close to Swift heap object address
        let minClosurePointer = closurePointers.min() ?? 0
        let maxClosurePointer = closurePointers.max() ?? 0
        while true {
            let obj = JSObject()
            if minClosurePointer == obj.id {
                break
            }
        }

        // Step 3: Create JSClosure instances and find the one with JSClosure.id == &closurePointers[x]
        do {
            while true {
                let c = JSClosure { _ in .undefined }
                if closurePointers.contains(c.id) || c.id > maxClosurePointer {
                    break
                }
                // To avoid all JSClosures having a common JSObject.id diffs, randomly allocate a new JS object.
                if Bool.random() {
                    _ = JSObject()
                }
            }
        }

        // Step 4: Trigger garbage collection to call the finalizer of the conflicting JSClosure instance
        for _ in 0..<100 {
            gc()
            // Tick the event loop to allow the garbage collector to run finalizers
            // registered by FinalizationRegistry.
            try await Task.sleep(for: .milliseconds(0))
        }

        // Step 5: Verify that the JSClosure instances are still alive and can be called
        for i in 0..<numberOfSourceClosures {
            _ = obj["c\(i)"].function!()
        }
    }
}
