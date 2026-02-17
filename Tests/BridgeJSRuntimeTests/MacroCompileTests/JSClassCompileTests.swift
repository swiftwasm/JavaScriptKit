import JavaScriptKit

@JSClass(from: .global) internal struct MyJSClassInternal {
    @JSFunction init() throws(JSException)
}
@JSClass(from: .global) public struct MyJSClassPublic {
    @JSFunction init() throws(JSException)
}
@JSClass(from: .global) package struct MyJSClassPackage {
    @JSFunction init() throws(JSException)
}
