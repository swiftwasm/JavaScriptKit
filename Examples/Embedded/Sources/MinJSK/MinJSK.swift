public class JSObject {
    public subscript(_ index: Int) -> JSValue {
        get { .undefined }
        set {}
    }

    public static var global: JSObject { return _global.wrappedValue }
    private nonisolated(unsafe) static let _global = LazyThreadLocal(
        initialize: JSObject()
    )
}

struct LazyThreadLocal {
    var wrappedValue: JSObject

    init(initialize: JSObject) {
        self.wrappedValue = initialize
    }
}

public enum JSValue {
    case undefined
}