import JavaScriptKit
let global = JSRef.global()
setJSValue(this: global, name: "foobar", value: .boolean(true))
print(getJSValue(this: global, name: "foobar"))
