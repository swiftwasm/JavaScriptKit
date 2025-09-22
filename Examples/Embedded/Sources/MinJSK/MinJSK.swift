public class JSObject {
    public subscript(_ index: Int) -> Int {
        get { 0 }
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
