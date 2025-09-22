import _CJavaScriptKit

@available(
    *,
    deprecated,
    renamed: "JSObject",
    message: "Please use JSObject instead. JSFunction is unified with JSObject"
)
public typealias JSFunction = JSObject

extension JSObject {
    @discardableResult
    public func callAsFunction(arguments: [JSValue]) -> JSValue {
        .undefined
    }
}
