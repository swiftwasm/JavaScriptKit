import XCTest
import JavaScriptKit

final class JavaScriptEventLoopTestSupportTests: XCTestCase {
    func testAwaitMicrotask() async {
        let _: () = await withCheckedContinuation { cont in
            JSObject.global.queueMicrotask.function!(
                JSOneshotClosure { _ in
                    cont.resume(returning: ())
                    return .undefined
                }
            )
        }
    }
}
