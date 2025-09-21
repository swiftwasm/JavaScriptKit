import _CJavaScriptKit

/// `JSObject` represents an object in JavaScript and supports dynamic member lookup.
/// Any member access like `object.foo` will dynamically request the JavaScript and Swift
/// runtime bridge library for a member with the specified name in this object.
///
/// And this object supports to call a member method of the object.
///
/// e.g.
/// ```swift
/// let document = JSObject.global.document.object!
/// let divElement = document.createElement!("div")
/// ```
///
/// The lifetime of this object is managed by the JavaScript and Swift runtime bridge library with
/// reference counting system.
@dynamicMemberLookup
public class JSObject {
    internal static var constructor: JSObject { _constructor.wrappedValue }
    private static let _constructor = LazyThreadLocal(initialize: { JSObject.global.Object.object! })

    @usableFromInline
    internal var _id: JavaScriptObjectRef

    @_spi(JSObject_id)
    @_spi(BridgeJS)
    @inlinable
    public var id: JavaScriptObjectRef { _id }

    @_spi(JSObject_id)
    @_spi(BridgeJS)
    public init(id: JavaScriptObjectRef) {
        self._id = id
    }

    /// Creates an empty JavaScript object.
    public convenience init() {
        self.init(id: swjs_create_object())
    }

    /// A convenience method of `subscript(_ name: String) -> JSValue`
    /// to access the member through Dynamic Member Lookup.
    public subscript(dynamicMember name: String) -> JSValue {
        get { .undefined }
        set {}
    }

    /// Access the `name` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: String) -> JSValue {
        get { .undefined }
        set {}
    }

    /// Access the `index` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter index: The index of this object's member to access.
    /// - Returns: The value of the `index` member of this object.
    public subscript(_ index: Int) -> JSValue {
        get { .undefined }
        set {}
    }

    static let _JS_Predef_Value_Global: JavaScriptObjectRef = 1

    /// A `JSObject` of the global scope object.
    /// This allows access to the global properties and global names by accessing the `JSObject` returned.
    public static var global: JSObject { return _global.wrappedValue }
    private static let _global = LazyThreadLocal(initialize: {
        JSObject(id: 1)
    })
}
