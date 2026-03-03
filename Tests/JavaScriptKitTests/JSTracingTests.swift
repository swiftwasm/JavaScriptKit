#if Tracing
import JavaScriptKit
import XCTest

final class JSTracingTests: XCTestCase {
    func testJSCallHookReportsMethod() throws {
        var startInfo: [JSTracing.JSCallInfo] = []
        var ended = 0
        let remove = JSTracing.default.addJSCallHook { info in
            startInfo.append(info)
            return { ended += 1 }
        }
        defer { remove() }

        let globalObject1 = JSObject.global.globalObject1
        let prop5 = try XCTUnwrap(globalObject1.prop_5.object)
        _ = prop5.func6!(true, 1, 2)

        let methodEvents = startInfo.filter {
            if case .method = $0 { return true }
            return false
        }
        XCTAssertEqual(methodEvents.count, 1)
        guard case let .method(receiver, methodName, arguments) = methodEvents.first else {
            XCTFail("Expected method info")
            return
        }
        XCTAssertEqual(receiver.id, prop5.id)
        XCTAssertEqual(methodName, "func6")
        XCTAssertEqual(arguments, [.boolean(true), .number(1), .number(2)])
        XCTAssertEqual(ended, startInfo.count)
    }

    func testJSCallHookReportsPropertyAccess() throws {
        var startInfo: [JSTracing.JSCallInfo] = []
        var ended = 0
        let remove = JSTracing.default.addJSCallHook { info in
            startInfo.append(info)
            return { ended += 1 }
        }
        defer { remove() }

        let obj = JSObject()
        obj.foo = .number(42)

        // Reset after setup so we only capture the reads/writes below.
        startInfo.removeAll()
        ended = 0

        // Read a property (triggers propertyGet)
        let _: JSValue = obj.foo

        // Write a property (triggers propertySet)
        obj.foo = .number(999)

        let propEvents = startInfo.filter {
            switch $0 {
            case .propertyGet(_, let name) where name == "foo": return true
            case .propertySet(_, let name, _) where name == "foo": return true
            default: return false
            }
        }

        XCTAssertEqual(propEvents.count, 2)

        guard case .propertyGet(let getReceiver, let getName) = propEvents[0] else {
            XCTFail("Expected propertyGet info")
            return
        }
        XCTAssertEqual(getReceiver.id, obj.id)
        XCTAssertEqual(getName, "foo")

        guard case .propertySet(let setReceiver, let setName, let setValue) = propEvents[1] else {
            XCTFail("Expected propertySet info")
            return
        }
        XCTAssertEqual(setReceiver.id, obj.id)
        XCTAssertEqual(setName, "foo")
        XCTAssertEqual(setValue, .number(999))

        XCTAssertEqual(ended, startInfo.count)
    }

    func testJSClosureCallHookReportsMetadata() throws {
        var startInfo: [JSTracing.JSClosureCallInfo] = []
        var ended = 0
        let remove = JSTracing.default.addJSClosureCallHook { info in
            startInfo.append(info)
            return { ended += 1 }
        }
        defer { remove() }

        let globalObject1 = JSObject.global.globalObject1
        let prop6 = try XCTUnwrap(globalObject1.prop_6.object)
        let closure = JSClosure(file: "TracingTests.swift", line: 4242) { _ in .number(7) }
        prop6.host_func_1 = .object(closure)

        let callHost = try XCTUnwrap(prop6.call_host_1.function)
        XCTAssertEqual(callHost(), .number(7))

        XCTAssertEqual(startInfo.count, 1)
        XCTAssertEqual(startInfo.first?.fileID, "TracingTests.swift")
        XCTAssertEqual(startInfo.first?.line, 4242)
        XCTAssertEqual(ended, 1)
    }
}
#endif
