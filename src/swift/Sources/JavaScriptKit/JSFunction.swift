import _CJavaScriptKit

@dynamicCallable
public class JSFunctionRef: Equatable {
    let id: UInt32

    init(id: UInt32) {
        self.id = id
    }

    public static func == (lhs: JSFunctionRef, rhs: JSFunctionRef) -> Bool {
        return lhs.id == rhs.id
    }

    public func dynamicallyCall(withArguments arguments: [JSValue]) -> JSValue {
        let result = arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer -> RawJSValue in
                let argv = bufferPointer.baseAddress
                let argc = bufferPointer.count
                var result = RawJSValue()
                _call_function(
                    self.id, argv, Int32(argc),
                    &result.kind, &result.payload1, &result.payload2
                )
                return result
            }
        }
        return result.jsValue()
    }
}
