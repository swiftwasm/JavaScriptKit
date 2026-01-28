// bridge-js: skip
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_Basic_5Basicy_y")
fileprivate func invoke_js_callback_Basic_5Basicy_y(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_Basic_5Basicy_y(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_Basic_5Basicy_y")
fileprivate func make_swift_closure_Basic_5Basicy_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_Basic_5Basicy_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_5Basicy_y {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_Basic_5Basicy_y(callbackValue)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Void) {
        self.init(
            makeClosure: make_swift_closure_Basic_5Basicy_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_Basic_5Basicy_y")
@_cdecl("invoke_swift_closure_Basic_5Basicy_y")
public func _invoke_swift_closure_Basic_5Basicy_y(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_document_get")
fileprivate func bjs_document_get() -> Int32
#else
fileprivate func bjs_document_get() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$document_get() throws(JSException) -> JSDocument {
    let ret = bjs_document_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSDocument.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_alert")
fileprivate func bjs_alert(_ message: Int32) -> Void
#else
fileprivate func bjs_alert(_ message: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$alert(_ message: String) throws(JSException) -> Void {
    let messageValue = message.bridgeJSLowerParameter()
    bjs_alert(messageValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_fetch")
fileprivate func bjs_fetch(_ url: Int32) -> Int32
#else
fileprivate func bjs_fetch(_ url: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$fetch(_ url: String) throws(JSException) -> JSObject {
    let urlValue = url.bridgeJSLowerParameter()
    let ret = bjs_fetch(urlValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSDocument_body_get")
fileprivate func bjs_JSDocument_body_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_JSDocument_body_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSDocument_createElement")
fileprivate func bjs_JSDocument_createElement(_ self: Int32, _ tagName: Int32) -> Int32
#else
fileprivate func bjs_JSDocument_createElement(_ self: Int32, _ tagName: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$JSDocument_body_get(_ self: JSObject) throws(JSException) -> JSHTMLElement {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JSDocument_body_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSHTMLElement.bridgeJSLiftReturn(ret)
}

func _$JSDocument_createElement(_ self: JSObject, _ tagName: String) throws(JSException) -> JSHTMLElement {
    let selfValue = self.bridgeJSLowerParameter()
    let tagNameValue = tagName.bridgeJSLowerParameter()
    let ret = bjs_JSDocument_createElement(selfValue, tagNameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSHTMLElement.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSHTMLElement_innerText_get")
fileprivate func bjs_JSHTMLElement_innerText_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_JSHTMLElement_innerText_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSHTMLElement_innerText_set")
fileprivate func bjs_JSHTMLElement_innerText_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_JSHTMLElement_innerText_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSHTMLElement_appendChild")
fileprivate func bjs_JSHTMLElement_appendChild(_ self: Int32, _ element: Int32) -> Void
#else
fileprivate func bjs_JSHTMLElement_appendChild(_ self: Int32, _ element: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$JSHTMLElement_innerText_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JSHTMLElement_innerText_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$JSHTMLElement_innerText_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_JSHTMLElement_innerText_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$JSHTMLElement_appendChild(_ self: JSObject, _ element: JSHTMLElement) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let elementValue = element.bridgeJSLowerParameter()
    bjs_JSHTMLElement_appendChild(selfValue, elementValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSHTMLButtonElement_onclick_get")
fileprivate func bjs_JSHTMLButtonElement_onclick_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_JSHTMLButtonElement_onclick_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_JSHTMLButtonElement_onclick_set")
fileprivate func bjs_JSHTMLButtonElement_onclick_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_JSHTMLButtonElement_onclick_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$JSHTMLButtonElement_onclick_get(_ self: JSObject) throws(JSException) -> () -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JSHTMLButtonElement_onclick_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_5Basicy_y.bridgeJSLift(ret)
}

func _$JSHTMLButtonElement_onclick_set(_ self: JSObject, _ newValue: @escaping () -> Void) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValue = JSTypedClosure<() -> Void>(newValue)
    let newValueFuncRef = newValue.bridgeJSLowerParameter()
    withExtendedLifetime((newValue)) {
        bjs_JSHTMLButtonElement_onclick_set(selfValue, newValueFuncRef)
    }
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "Basic", name: "bjs_Response_uuid_get")
fileprivate func bjs_Response_uuid_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Response_uuid_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$Response_uuid_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Response_uuid_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}