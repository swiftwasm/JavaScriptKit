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

        XCTAssertEqual(startInfo.count, 1)
        guard case let .method(receiver, methodName, arguments) = startInfo.first else {
            XCTFail("Expected method info")
            return
        }
        XCTAssertEqual(receiver.id, prop5.id)
        XCTAssertEqual(methodName, "func6")
        XCTAssertEqual(arguments, [.boolean(true), .number(1), .number(2)])
        XCTAssertEqual(ended, 1)
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
