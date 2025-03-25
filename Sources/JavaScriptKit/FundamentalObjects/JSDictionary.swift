import _CJavaScriptKit

public final class JSDictionary {
    private let ref: JSObject

    init(ref: JSObject) { self.ref = ref }

    public init() { ref = JSObject(id: swjs_create_object()) }

    public subscript(key: String) -> JSValue {
        get { ref[dynamicMember: key] }
        set { ref[dynamicMember: key] = newValue }
    }
}

extension JSDictionary: ExpressibleByDictionaryLiteral {
    public convenience init(dictionaryLiteral elements: (String, JSValue)...) {
        self.init()

        for (key, value) in elements { self[key] = value }
    }
}

extension JSDictionary: ConvertibleToJSValue {
    public var jsValue: JSValue { .object(ref) }
}

extension JSDictionary: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> JSDictionary? {
        guard let object = value.object else { return nil }

        return JSDictionary(ref: object)
    }
}
