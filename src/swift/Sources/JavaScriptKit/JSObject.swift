import _CJavaScriptKit

public class JSObjectRef: Equatable {
    let id: UInt32
    init(id: UInt32) {
        self.id = id
    }
    public static func global() -> JSObjectRef {
        .init(id: _JS_Predef_Value_Global)
    }

    deinit {

    }

    public static func == (lhs: JSObjectRef, rhs: JSObjectRef) -> Bool {
        return lhs.id == rhs.id
    }
}
