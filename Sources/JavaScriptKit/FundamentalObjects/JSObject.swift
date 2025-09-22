import _CJavaScriptKit

public class JSObject {
    internal var _id: UInt
    public init(id: UInt) {
        self._id = id
    }

    /// Access the `index` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter index: The index of this object's member to access.
    /// - Returns: The value of the `index` member of this object.
    public subscript(_ index: Int) -> JSValue {
        get { .undefined }
        set {}
    }

    /// A `JSObject` of the global scope object.
    /// This allows access to the global properties and global names by accessing the `JSObject` returned.
    public static var global: JSObject { return _global.wrappedValue }
    private nonisolated(unsafe) static let _global = LazyThreadLocal(
        initialize: JSObject(id: 1)
    )
}

/// A property wrapper that lazily initializes a thread-local value
/// for each thread that accesses the value.
struct LazyThreadLocal {
    var wrappedValue: JSObject

    init(initialize: JSObject) {
        self.wrappedValue = initialize
    }
}

/// `JSValue` represents a value in JavaScript.
public enum JSValue {
    case undefined
}