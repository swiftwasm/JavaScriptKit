import _CJavaScriptKit

@dynamicMemberLookup
public class JSObjectRef {
    
    public typealias ID = UInt32
    
    // MARK: - Properties
    
    public let id: ID
    
    // MARK: - Initialization
    
    deinit { _destroy_ref(id) }

    public init(id: ID) {
        self.id = id
    }
    
    // MARK: - Methods

    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((JSValueConvertible...) -> JSValue)? {
        get {
            guard let function = self[dynamicMember: name].function else { return nil }
            return { (arguments: JSValueConvertible...) in
                function.apply(this: self, argumentList: arguments)
            }
        }
    }

    public subscript(dynamicMember name: String) -> JSValue {
        get { get(name) }
        set { set(name, newValue) }
    }

    public func get(_ name: String) -> JSValue {
        getJSValue(this: self, name: name)
    }

    public func set(_ name: String, _ value: JSValue) {
        setJSValue(this: self, name: name, value: value)
    }

    public func get(_ index: Int) -> JSValue {
        getJSValue(this: self, index: Int32(index))
    }

    public subscript(_ index: Int) -> JSValue {
        get { get(index) }
        set { set(index, newValue) }
    }

    public func set(_ index: Int, _ value: JSValue) {
        setJSValue(this: self, index: Int32(index), value: value)
    }

    public func jsValue() -> JSValue {
        .object(self)
    }
}

// MARK: - Constants

public extension JSObjectRef {
    
    internal static let _JS_Predef_Value_Global: UInt32 = 0
    
    static let global = JSObjectRef(id: _JS_Predef_Value_Global)
}

// MARK: - Equatable

extension JSObjectRef: Equatable {
    
    public static func == (lhs: JSObjectRef, rhs: JSObjectRef) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Identifiable

extension JSObjectRef: Identifiable { }
