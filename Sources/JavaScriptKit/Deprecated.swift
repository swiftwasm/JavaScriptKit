#if !hasFeature(Embedded)
@available(*, deprecated, renamed: "JSObject")
public typealias JSObjectRef = JSObject

@available(*, deprecated, renamed: "JSArray")
public typealias JSArrayRef = JSArray

@available(*, deprecated, renamed: "JSFunction")
public typealias JSFunctionRef = JSFunction

@available(*, deprecated, renamed: "ConvertibleToJSValue")
public typealias JSValueConvertible = ConvertibleToJSValue

@available(*, deprecated, renamed: "ConstructibleFromJSValue")
public typealias JSValueConstructible = ConstructibleFromJSValue

@available(*, deprecated, renamed: "JSValueCompatible")
public typealias JSValueCodable = JSValueCompatible
#endif
