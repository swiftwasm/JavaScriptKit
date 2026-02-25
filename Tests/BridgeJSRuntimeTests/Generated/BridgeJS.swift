// bridge-js: skip
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests10HttpStatusO_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (HttpStatus) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(callbackValue, param0Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (HttpStatus) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (HttpStatus) -> Int) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(HttpStatus) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(HttpStatus.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(callbackValue, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Theme) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Theme) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Theme) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_Sb {
    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> Bool {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(callbackValue, param0Value)
            return Bool.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Theme) -> Bool {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Theme) -> Bool) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Theme) -> Bool>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests7GreeterC_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Greeter) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Pointer = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(callbackValue, param0Pointer)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Greeter) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Greeter) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Greeter) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Greeter.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC {
    static func bridgeJSLift(_ callbackId: Int32) -> (JSObject) -> JSObject {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(callbackValue, param0Value)
            return JSObject.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (JSObject) -> JSObject {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (JSObject) -> JSObject) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(JSObject) -> JSObject>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(JSObject.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9APIResultO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (APIResult) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0CaseId = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(callbackValue, param0CaseId)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (APIResult) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (APIResult) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(APIResult) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(APIResult.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Direction) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(callbackValue, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Direction) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Direction) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Direction) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Direction.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_Sb {
    static func bridgeJSLift(_ callbackId: Int32) -> (Direction) -> Bool {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(callbackValue, param0Value)
            return Bool.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Direction) -> Bool {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Direction) -> Bool) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Direction) -> Bool>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Direction.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(_ callback: Int32, _ param0: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(_ callback: Int32, _ param0: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ callback: Int32, _ param0: Int32) -> UnsafeMutableRawPointer {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSS_7GreeterC {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> Greeter {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(callbackValue, param0Value)
            return Greeter.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) -> Greeter {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) -> Greeter) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) -> Greeter>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(callbackValue, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(_ callback: Int32, _ param0: Float64) -> Float64
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(_ callback: Int32, _ param0: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSd_Sd {
    static func bridgeJSLift(_ callbackId: Int32) -> (Double) -> Double {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(callbackValue, param0Value)
            return Double.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Double) -> Double {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Double) -> Double) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ param0: Float64) -> Float64 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Double) -> Double>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Double.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Float64) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Float64) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(callback, param0, param1, param2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSiSSSd_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int, String, Double) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0, param1, param2) in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let param1Value = param1.bridgeJSLowerParameter()
            let param2Value = param2.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(callbackValue, param0Value, param1Value, param2Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int, String, Double) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int, String, Double) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32, _ param1Bytes: Int32, _ param1Length: Int32, _ param2: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int, String, Double) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0), String.bridgeJSLiftParameter(param1Bytes, param1Length), Double.bridgeJSLiftParameter(param2))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(callback, param0, param1, param2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSiSiSi_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int, Int, Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0, param1, param2) in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let param1Value = param1.bridgeJSLowerParameter()
            let param2Value = param2.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(callbackValue, param0Value, param1Value, param2Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int, Int, Int) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int, Int, Int) -> Int) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int, Int, Int) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0), Int.bridgeJSLiftParameter(param1), Int.bridgeJSLiftParameter(param2))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(_ callback: Int32, _ param0: Int32, _ param1: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(callback, param0, param1)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSiSi_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int, Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0, param1) in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let param1Value = param1.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(callbackValue, param0Value, param1Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int, Int) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int, Int) -> Int) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32, _ param1: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int, Int) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0), Int.bridgeJSLiftParameter(param1))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSi_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(callbackValue, param0Value)
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int) -> Int) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSi_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(callbackValue, param0Value)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Int) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Int) -> Void) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Int.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq5ThemeO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Theme>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(callbackValue, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Theme>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Theme>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Theme>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Theme>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(callback, param0IsSome, param0Pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Greeter>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Pointer) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(callbackValue, param0IsSome, param0Pointer)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Greeter>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Greeter>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Greeter>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Greeter>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(callback, param0IsSome, param0Pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Greeter>) -> Optional<Greeter> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Pointer) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(callbackValue, param0IsSome, param0Pointer)
            return Optional<Greeter>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Greeter>) -> Optional<Greeter> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Greeter>) -> Optional<Greeter>) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Greeter>) -> Optional<Greeter>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Greeter>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(callback, param0IsSome, param0CaseId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq9APIResultO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<APIResult>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0CaseId) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(callbackValue, param0IsSome, param0CaseId)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<APIResult>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<APIResult>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<APIResult>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<APIResult>.bridgeJSLiftParameter(param0IsSome, param0CaseId))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq9DirectionO_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Direction>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(callbackValue, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Direction>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Direction>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Direction>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Direction>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSqSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<String>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(callbackValue, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<String>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<String>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<String>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<String>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSqSi_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Int>) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(callbackValue, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Int>) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Int>) -> String) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Int>) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Int>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(_ callback: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ callback: Int32) -> Int32 {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsy_Sb {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Bool {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(callbackValue)
            return Bool.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Bool {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Bool) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ boxPtr: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Bool>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure()
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(_ callback: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(_ callback: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ callback: Int32) -> UnsafeMutableRawPointer {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsy_Sq7GreeterC {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Optional<Greeter> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret = invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(callbackValue)
            return Optional<Greeter>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Optional<Greeter> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Optional<Greeter>) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Optional<Greeter>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure()
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ callback: Int32) -> Void {
    return invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsy_y {
    static func bridgeJSLift(_ callbackId: Int32) -> () -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(callbackValue)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == () -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping () -> Void) {
        self.init(
            makeClosure: make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<() -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

struct AnyArrayElementProtocol: ArrayElementProtocol, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    var value: Int {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_ArrayElementProtocol_value_get(jsObjectValue)
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_ArrayElementProtocol_value_set(jsObjectValue, newValueValue)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyArrayElementProtocol(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayElementProtocol_value_get")
fileprivate func bjs_ArrayElementProtocol_value_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_ArrayElementProtocol_value_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArrayElementProtocol_value_get(_ jsObject: Int32) -> Int32 {
    return bjs_ArrayElementProtocol_value_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayElementProtocol_value_set")
fileprivate func bjs_ArrayElementProtocol_value_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_ArrayElementProtocol_value_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArrayElementProtocol_value_set(_ jsObject: Int32, _ newValue: Int32) -> Void {
    return bjs_ArrayElementProtocol_value_set_extern(jsObject, newValue)
}

struct AnyDataProcessor: DataProcessor, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func increment(by amount: Int) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let amountValue = amount.bridgeJSLowerParameter()
        _extern_increment(jsObjectValue, amountValue)
    }

    func getValue() -> Int {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_getValue(jsObjectValue)
        return Int.bridgeJSLiftReturn(ret)
    }

    func setLabelElements(_ labelPrefix: String, _ labelSuffix: String) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let labelPrefixValue = labelPrefix.bridgeJSLowerParameter()
        let labelSuffixValue = labelSuffix.bridgeJSLowerParameter()
        _extern_setLabelElements(jsObjectValue, labelPrefixValue, labelSuffixValue)
    }

    func getLabel() -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_getLabel(jsObjectValue)
        return String.bridgeJSLiftReturn(ret)
    }

    func isEven() -> Bool {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_isEven(jsObjectValue)
        return Bool.bridgeJSLiftReturn(ret)
    }

    func processGreeter(_ greeter: Greeter) -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let greeterPointer = greeter.bridgeJSLowerParameter()
        let ret = _extern_processGreeter(jsObjectValue, greeterPointer)
        return String.bridgeJSLiftReturn(ret)
    }

    func createGreeter() -> Greeter {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_createGreeter(jsObjectValue)
        return Greeter.bridgeJSLiftReturn(ret)
    }

    func processOptionalGreeter(_ greeter: Optional<Greeter>) -> String {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let (greeterIsSome, greeterPointer) = greeter.bridgeJSLowerParameter()
        let ret = _extern_processOptionalGreeter(jsObjectValue, greeterIsSome, greeterPointer)
        return String.bridgeJSLiftReturn(ret)
    }

    func createOptionalGreeter() -> Optional<Greeter> {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_createOptionalGreeter(jsObjectValue)
        return Optional<Greeter>.bridgeJSLiftReturn(ret)
    }

    func handleAPIResult(_ result: Optional<APIResult>) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let (resultIsSome, resultCaseId) = result.bridgeJSLowerParameter()
        _extern_handleAPIResult(jsObjectValue, resultIsSome, resultCaseId)
    }

    func getAPIResult() -> Optional<APIResult> {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_getAPIResult(jsObjectValue)
        return Optional<APIResult>.bridgeJSLiftReturn(ret)
    }

    var count: Int {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_count_get(jsObjectValue)
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_count_set(jsObjectValue, newValueValue)
        }
    }

    var name: String {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_name_get(jsObjectValue)
            return String.bridgeJSLiftReturn(ret)
        }
    }

    var optionalTag: Optional<String> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalTag_get(jsObjectValue)
            return Optional<String>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalTag_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var optionalCount: Optional<Int> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalCount_get(jsObjectValue)
            return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalCount_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var direction: Optional<Direction> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_direction_get(jsObjectValue)
            return Optional<Direction>.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_direction_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var optionalTheme: Optional<Theme> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalTheme_get(jsObjectValue)
            return Optional<Theme>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalTheme_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var httpStatus: Optional<HttpStatus> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_DataProcessor_httpStatus_get(jsObjectValue)
            return Optional<HttpStatus>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_httpStatus_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var apiResult: Optional<APIResult> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_apiResult_get(jsObjectValue)
            return Optional<APIResult>.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueCaseId) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_apiResult_set(jsObjectValue, newValueIsSome, newValueCaseId)
        }
    }

    var helper: Greeter {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_helper_get(jsObjectValue)
            return Greeter.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValuePointer = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_helper_set(jsObjectValue, newValuePointer)
        }
    }

    var optionalHelper: Optional<Greeter> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_DataProcessor_optionalHelper_get(jsObjectValue)
            return Optional<Greeter>.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValuePointer) = newValue.bridgeJSLowerParameter()
            bjs_DataProcessor_optionalHelper_set(jsObjectValue, newValueIsSome, newValuePointer)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyDataProcessor(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_increment")
fileprivate func _extern_increment_extern(_ jsObject: Int32, _ amount: Int32) -> Void
#else
fileprivate func _extern_increment_extern(_ jsObject: Int32, _ amount: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_increment(_ jsObject: Int32, _ amount: Int32) -> Void {
    return _extern_increment_extern(jsObject, amount)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getValue")
fileprivate func _extern_getValue_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_getValue_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_getValue(_ jsObject: Int32) -> Int32 {
    return _extern_getValue_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_setLabelElements")
fileprivate func _extern_setLabelElements_extern(_ jsObject: Int32, _ labelPrefix: Int32, _ labelSuffix: Int32) -> Void
#else
fileprivate func _extern_setLabelElements_extern(_ jsObject: Int32, _ labelPrefix: Int32, _ labelSuffix: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_setLabelElements(_ jsObject: Int32, _ labelPrefix: Int32, _ labelSuffix: Int32) -> Void {
    return _extern_setLabelElements_extern(jsObject, labelPrefix, labelSuffix)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getLabel")
fileprivate func _extern_getLabel_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_getLabel_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_getLabel(_ jsObject: Int32) -> Int32 {
    return _extern_getLabel_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_isEven")
fileprivate func _extern_isEven_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_isEven_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_isEven(_ jsObject: Int32) -> Int32 {
    return _extern_isEven_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processGreeter")
fileprivate func _extern_processGreeter_extern(_ jsObject: Int32, _ greeter: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _extern_processGreeter_extern(_ jsObject: Int32, _ greeter: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_processGreeter(_ jsObject: Int32, _ greeter: UnsafeMutableRawPointer) -> Int32 {
    return _extern_processGreeter_extern(jsObject, greeter)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createGreeter")
fileprivate func _extern_createGreeter_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func _extern_createGreeter_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_createGreeter(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    return _extern_createGreeter_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processOptionalGreeter")
fileprivate func _extern_processOptionalGreeter_extern(_ jsObject: Int32, _ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _extern_processOptionalGreeter_extern(_ jsObject: Int32, _ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_processOptionalGreeter(_ jsObject: Int32, _ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> Int32 {
    return _extern_processOptionalGreeter_extern(jsObject, greeterIsSome, greeterPointer)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createOptionalGreeter")
fileprivate func _extern_createOptionalGreeter_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func _extern_createOptionalGreeter_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_createOptionalGreeter(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    return _extern_createOptionalGreeter_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_handleAPIResult")
fileprivate func _extern_handleAPIResult_extern(_ jsObject: Int32, _ resultIsSome: Int32, _ resultCaseId: Int32) -> Void
#else
fileprivate func _extern_handleAPIResult_extern(_ jsObject: Int32, _ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_handleAPIResult(_ jsObject: Int32, _ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    return _extern_handleAPIResult_extern(jsObject, resultIsSome, resultCaseId)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getAPIResult")
fileprivate func _extern_getAPIResult_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func _extern_getAPIResult_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _extern_getAPIResult(_ jsObject: Int32) -> Int32 {
    return _extern_getAPIResult_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_get")
fileprivate func bjs_DataProcessor_count_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_DataProcessor_count_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_count_get(_ jsObject: Int32) -> Int32 {
    return bjs_DataProcessor_count_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_set")
fileprivate func bjs_DataProcessor_count_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_count_set_extern(_ jsObject: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_count_set(_ jsObject: Int32, _ newValue: Int32) -> Void {
    return bjs_DataProcessor_count_set_extern(jsObject, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_name_get")
fileprivate func bjs_DataProcessor_name_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_DataProcessor_name_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_name_get(_ jsObject: Int32) -> Int32 {
    return bjs_DataProcessor_name_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_get")
fileprivate func bjs_DataProcessor_optionalTag_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalTag_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalTag_get(_ jsObject: Int32) -> Void {
    return bjs_DataProcessor_optionalTag_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_set")
fileprivate func bjs_DataProcessor_optionalTag_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalTag_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalTag_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_DataProcessor_optionalTag_set_extern(jsObject, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_get")
fileprivate func bjs_DataProcessor_optionalCount_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalCount_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalCount_get(_ jsObject: Int32) -> Void {
    return bjs_DataProcessor_optionalCount_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_set")
fileprivate func bjs_DataProcessor_optionalCount_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalCount_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalCount_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_DataProcessor_optionalCount_set_extern(jsObject, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_get")
fileprivate func bjs_DataProcessor_direction_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_DataProcessor_direction_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_direction_get(_ jsObject: Int32) -> Int32 {
    return bjs_DataProcessor_direction_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_set")
fileprivate func bjs_DataProcessor_direction_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_direction_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_direction_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_DataProcessor_direction_set_extern(jsObject, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_get")
fileprivate func bjs_DataProcessor_optionalTheme_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalTheme_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalTheme_get(_ jsObject: Int32) -> Void {
    return bjs_DataProcessor_optionalTheme_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_set")
fileprivate func bjs_DataProcessor_optionalTheme_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_optionalTheme_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalTheme_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_DataProcessor_optionalTheme_set_extern(jsObject, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_get")
fileprivate func bjs_DataProcessor_httpStatus_get_extern(_ jsObject: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_httpStatus_get_extern(_ jsObject: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_httpStatus_get(_ jsObject: Int32) -> Void {
    return bjs_DataProcessor_httpStatus_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_set")
fileprivate func bjs_DataProcessor_httpStatus_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_httpStatus_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_httpStatus_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void {
    return bjs_DataProcessor_httpStatus_set_extern(jsObject, newValueIsSome, newValueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_get")
fileprivate func bjs_DataProcessor_apiResult_get_extern(_ jsObject: Int32) -> Int32
#else
fileprivate func bjs_DataProcessor_apiResult_get_extern(_ jsObject: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_apiResult_get(_ jsObject: Int32) -> Int32 {
    return bjs_DataProcessor_apiResult_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_set")
fileprivate func bjs_DataProcessor_apiResult_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueCaseId: Int32) -> Void
#else
fileprivate func bjs_DataProcessor_apiResult_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueCaseId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_apiResult_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueCaseId: Int32) -> Void {
    return bjs_DataProcessor_apiResult_set_extern(jsObject, newValueIsSome, newValueCaseId)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_get")
fileprivate func bjs_DataProcessor_helper_get_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_DataProcessor_helper_get_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_helper_get(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    return bjs_DataProcessor_helper_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_set")
fileprivate func bjs_DataProcessor_helper_set_extern(_ jsObject: Int32, _ newValue: UnsafeMutableRawPointer) -> Void
#else
fileprivate func bjs_DataProcessor_helper_set_extern(_ jsObject: Int32, _ newValue: UnsafeMutableRawPointer) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_helper_set(_ jsObject: Int32, _ newValue: UnsafeMutableRawPointer) -> Void {
    return bjs_DataProcessor_helper_set_extern(jsObject, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_get")
fileprivate func bjs_DataProcessor_optionalHelper_get_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_DataProcessor_optionalHelper_get_extern(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalHelper_get(_ jsObject: Int32) -> UnsafeMutableRawPointer {
    return bjs_DataProcessor_optionalHelper_get_extern(jsObject)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_set")
fileprivate func bjs_DataProcessor_optionalHelper_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValuePointer: UnsafeMutableRawPointer) -> Void
#else
fileprivate func bjs_DataProcessor_optionalHelper_set_extern(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValuePointer: UnsafeMutableRawPointer) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DataProcessor_optionalHelper_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValuePointer: UnsafeMutableRawPointer) -> Void {
    return bjs_DataProcessor_optionalHelper_set_extern(jsObject, newValueIsSome, newValuePointer)
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripIntArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripIntArray")
public func _bjs_ArraySupportExports_static_roundTripIntArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripIntArray(_: [Int].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripStringArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripStringArray")
public func _bjs_ArraySupportExports_static_roundTripStringArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripStringArray(_: [String].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripDoubleArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripDoubleArray")
public func _bjs_ArraySupportExports_static_roundTripDoubleArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripDoubleArray(_: [Double].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripBoolArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripBoolArray")
public func _bjs_ArraySupportExports_static_roundTripBoolArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripBoolArray(_: [Bool].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripUnsafeRawPointerArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripUnsafeRawPointerArray")
public func _bjs_ArraySupportExports_static_roundTripUnsafeRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripUnsafeRawPointerArray(_: [UnsafeRawPointer].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripUnsafeMutableRawPointerArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripUnsafeMutableRawPointerArray")
public func _bjs_ArraySupportExports_static_roundTripUnsafeMutableRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripUnsafeMutableRawPointerArray(_: [UnsafeMutableRawPointer].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOpaquePointerArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOpaquePointerArray")
public func _bjs_ArraySupportExports_static_roundTripOpaquePointerArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOpaquePointerArray(_: [OpaquePointer].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripUnsafePointerArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripUnsafePointerArray")
public func _bjs_ArraySupportExports_static_roundTripUnsafePointerArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripUnsafePointerArray(_: [UnsafePointer<UInt8>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripUnsafeMutablePointerArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripUnsafeMutablePointerArray")
public func _bjs_ArraySupportExports_static_roundTripUnsafeMutablePointerArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripUnsafeMutablePointerArray(_: [UnsafeMutablePointer<UInt8>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripJSValueArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripJSValueArray")
public func _bjs_ArraySupportExports_static_roundTripJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripJSValueArray(_: [JSValue].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripJSObjectArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripJSObjectArray")
public func _bjs_ArraySupportExports_static_roundTripJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripJSObjectArray(_: [JSObject].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripCaseEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripCaseEnumArray")
public func _bjs_ArraySupportExports_static_roundTripCaseEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripCaseEnumArray(_: [Direction].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripStringRawValueEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripStringRawValueEnumArray")
public func _bjs_ArraySupportExports_static_roundTripStringRawValueEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripStringRawValueEnumArray(_: [Theme].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripIntRawValueEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripIntRawValueEnumArray")
public func _bjs_ArraySupportExports_static_roundTripIntRawValueEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripIntRawValueEnumArray(_: [HttpStatus].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripStructArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripStructArray")
public func _bjs_ArraySupportExports_static_roundTripStructArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripStructArray(_: [DataPoint].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripSwiftClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripSwiftClassArray")
public func _bjs_ArraySupportExports_static_roundTripSwiftClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripSwiftClassArray(_: [Greeter].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNamespacedSwiftClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNamespacedSwiftClassArray")
public func _bjs_ArraySupportExports_static_roundTripNamespacedSwiftClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNamespacedSwiftClassArray(_: [Utils.Converter].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripProtocolArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripProtocolArray")
public func _bjs_ArraySupportExports_static_roundTripProtocolArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripProtocolArray(_: [AnyArrayElementProtocol].bridgeJSStackPop())
    ret.map { $0 as! AnyArrayElementProtocol }.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripJSClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripJSClassArray")
public func _bjs_ArraySupportExports_static_roundTripJSClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripJSClassArray(_: [ArrayElementObject].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalIntArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalIntArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalIntArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalIntArray(_: [Optional<Int>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalStringArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalStringArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalStringArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalStringArray(_: [Optional<String>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalJSObjectArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalJSObjectArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalJSObjectArray(_: [Optional<JSObject>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalCaseEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalCaseEnumArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalCaseEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalCaseEnumArray(_: [Optional<Direction>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalStringRawValueEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalStringRawValueEnumArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalStringRawValueEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalStringRawValueEnumArray(_: [Optional<Theme>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalIntRawValueEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalIntRawValueEnumArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalIntRawValueEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalIntRawValueEnumArray(_: [Optional<HttpStatus>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalStructArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalStructArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalStructArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalStructArray(_: [Optional<DataPoint>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalSwiftClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalSwiftClassArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalSwiftClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalSwiftClassArray(_: [Optional<Greeter>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripOptionalJSClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripOptionalJSClassArray")
public func _bjs_ArraySupportExports_static_roundTripOptionalJSClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripOptionalJSClassArray(_: [Optional<ArrayElementObject>].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedIntArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedIntArray")
public func _bjs_ArraySupportExports_static_roundTripNestedIntArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedIntArray(_: [[Int]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedStringArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedStringArray")
public func _bjs_ArraySupportExports_static_roundTripNestedStringArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedStringArray(_: [[String]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedDoubleArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedDoubleArray")
public func _bjs_ArraySupportExports_static_roundTripNestedDoubleArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedDoubleArray(_: [[Double]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedBoolArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedBoolArray")
public func _bjs_ArraySupportExports_static_roundTripNestedBoolArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedBoolArray(_: [[Bool]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedStructArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedStructArray")
public func _bjs_ArraySupportExports_static_roundTripNestedStructArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedStructArray(_: [[DataPoint]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedCaseEnumArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedCaseEnumArray")
public func _bjs_ArraySupportExports_static_roundTripNestedCaseEnumArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedCaseEnumArray(_: [[Direction]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_roundTripNestedSwiftClassArray")
@_cdecl("bjs_ArraySupportExports_static_roundTripNestedSwiftClassArray")
public func _bjs_ArraySupportExports_static_roundTripNestedSwiftClassArray() -> Void {
    #if arch(wasm32)
    let ret = ArraySupportExports.roundTripNestedSwiftClassArray(_: [[Greeter]].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_multiArrayFirst")
@_cdecl("bjs_ArraySupportExports_static_multiArrayFirst")
public func _bjs_ArraySupportExports_static_multiArrayFirst() -> Void {
    #if arch(wasm32)
    let _tmp_b = [String].bridgeJSStackPop()
    let _tmp_a = [Int].bridgeJSStackPop()
    let ret = ArraySupportExports.multiArrayFirst(_: _tmp_a, _: _tmp_b)
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_multiArraySecond")
@_cdecl("bjs_ArraySupportExports_static_multiArraySecond")
public func _bjs_ArraySupportExports_static_multiArraySecond() -> Void {
    #if arch(wasm32)
    let _tmp_b = [String].bridgeJSStackPop()
    let _tmp_a = [Int].bridgeJSStackPop()
    let ret = ArraySupportExports.multiArraySecond(_: _tmp_a, _: _tmp_b)
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_multiOptionalArrayFirst")
@_cdecl("bjs_ArraySupportExports_static_multiOptionalArrayFirst")
public func _bjs_ArraySupportExports_static_multiOptionalArrayFirst() -> Void {
    #if arch(wasm32)
    let _tmp_b = Optional<[String]>.bridgeJSLiftParameter()
    let _tmp_a = Optional<[Int]>.bridgeJSLiftParameter()
    let ret = ArraySupportExports.multiOptionalArrayFirst(_: _tmp_a, _: _tmp_b)
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArraySupportExports_static_multiOptionalArraySecond")
@_cdecl("bjs_ArraySupportExports_static_multiOptionalArraySecond")
public func _bjs_ArraySupportExports_static_multiOptionalArraySecond() -> Void {
    #if arch(wasm32)
    let _tmp_b = Optional<[String]>.bridgeJSLiftParameter()
    let _tmp_a = Optional<[Int]>.bridgeJSLiftParameter()
    let ret = ArraySupportExports.multiOptionalArraySecond(_: _tmp_a, _: _tmp_b)
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testStringDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testStringDefault")
public func _bjs_DefaultArgumentExports_static_testStringDefault(_ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testStringDefault(message: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testIntDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testIntDefault")
public func _bjs_DefaultArgumentExports_static_testIntDefault(_ count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testIntDefault(count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testBoolDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testBoolDefault")
public func _bjs_DefaultArgumentExports_static_testBoolDefault(_ flag: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testBoolDefault(flag: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testOptionalDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testOptionalDefault")
public func _bjs_DefaultArgumentExports_static_testOptionalDefault(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testOptionalDefault(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testMultipleDefaults")
@_cdecl("bjs_DefaultArgumentExports_static_testMultipleDefaults")
public func _bjs_DefaultArgumentExports_static_testMultipleDefaults(_ titleBytes: Int32, _ titleLength: Int32, _ count: Int32, _ enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testMultipleDefaults(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testSimpleEnumDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testSimpleEnumDefault")
public func _bjs_DefaultArgumentExports_static_testSimpleEnumDefault(_ status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testSimpleEnumDefault(status: Status.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testDirectionDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testDirectionDefault")
public func _bjs_DefaultArgumentExports_static_testDirectionDefault(_ direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testDirectionDefault(direction: Direction.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testRawStringEnumDefault")
@_cdecl("bjs_DefaultArgumentExports_static_testRawStringEnumDefault")
public func _bjs_DefaultArgumentExports_static_testRawStringEnumDefault(_ themeBytes: Int32, _ themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testRawStringEnumDefault(theme: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testComplexInit")
@_cdecl("bjs_DefaultArgumentExports_static_testComplexInit")
public func _bjs_DefaultArgumentExports_static_testComplexInit(_ greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testComplexInit(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_testEmptyInit")
@_cdecl("bjs_DefaultArgumentExports_static_testEmptyInit")
public func _bjs_DefaultArgumentExports_static_testEmptyInit(_ object: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.testEmptyInit(_: StaticPropertyHolder.bridgeJSLiftParameter(object))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_createConstructorDefaults")
@_cdecl("bjs_DefaultArgumentExports_static_createConstructorDefaults")
public func _bjs_DefaultArgumentExports_static_createConstructorDefaults(_ nameBytes: Int32, _ nameLength: Int32, _ count: Int32, _ enabled: Int32, _ status: Int32, _ tagIsSome: Int32, _ tagBytes: Int32, _ tagLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.createConstructorDefaults(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled), status: Status.bridgeJSLiftParameter(status), tag: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_describeConstructorDefaults")
@_cdecl("bjs_DefaultArgumentExports_static_describeConstructorDefaults")
public func _bjs_DefaultArgumentExports_static_describeConstructorDefaults(_ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.describeConstructorDefaults(_: DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_arrayWithDefault")
@_cdecl("bjs_DefaultArgumentExports_static_arrayWithDefault")
public func _bjs_DefaultArgumentExports_static_arrayWithDefault() -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.arrayWithDefault(_: [Int].bridgeJSStackPop())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_arrayWithOptionalDefault")
@_cdecl("bjs_DefaultArgumentExports_static_arrayWithOptionalDefault")
public func _bjs_DefaultArgumentExports_static_arrayWithOptionalDefault() -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.arrayWithOptionalDefault(_: Optional<[Int]>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentExports_static_arrayMixedDefaults")
@_cdecl("bjs_DefaultArgumentExports_static_arrayMixedDefaults")
public func _bjs_DefaultArgumentExports_static_arrayMixedDefaults(_ prefixBytes: Int32, _ prefixLength: Int32, _ suffixBytes: Int32, _ suffixLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentExports.arrayMixedDefaults(prefix: String.bridgeJSLiftParameter(prefixBytes, prefixLength), values: [Int].bridgeJSStackPop(), suffix: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Direction: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Direction {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Direction {
        return Direction(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}

extension Status: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Status {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Status {
        return Status(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .loading
        case 1:
            self = .success
        case 2:
            self = .error
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .loading:
            return 0
        case .success:
            return 1
        case .error:
            return 2
        }
    }
}

extension Theme: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Precision: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Ratio: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension TSDirection: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> TSDirection {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> TSDirection {
        return TSDirection(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .north
        case 1:
            self = .south
        case 2:
            self = .east
        case 3:
            self = .west
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .north:
            return 0
        case .south:
            return 1
        case .east:
            return 2
        case .west:
            return 3
        }
    }
}

extension TSTheme: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

@_expose(wasm, "bjs_Utils_StringUtils_static_uppercase")
@_cdecl("bjs_Utils_StringUtils_static_uppercase")
public func _bjs_Utils_StringUtils_static_uppercase(_ textBytes: Int32, _ textLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.StringUtils.uppercase(_: String.bridgeJSLiftParameter(textBytes, textLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Utils_StringUtils_static_lowercase")
@_cdecl("bjs_Utils_StringUtils_static_lowercase")
public func _bjs_Utils_StringUtils_static_lowercase(_ textBytes: Int32, _ textLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.StringUtils.lowercase(_: String.bridgeJSLiftParameter(textBytes, textLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Networking.API.Method: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Networking.API.Method {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Networking.API.Method {
        return Networking.API.Method(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        case 2:
            self = .put
        case 3:
            self = .delete
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        case .put:
            return 2
        case .delete:
            return 3
        }
    }
}

extension Configuration.LogLevel: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Configuration.Port: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Internal.SupportedMethod: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> Internal.SupportedMethod {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> Internal.SupportedMethod {
        return Internal.SupportedMethod(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .get
        case 1:
            self = .post
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .get:
            return 0
        case .post:
            return 1
        }
    }
}

extension APIResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .failure(Int.bridgeJSStackPop())
        case 2:
            return .flag(Bool.bridgeJSStackPop())
        case 3:
            return .rate(Float.bridgeJSStackPop())
        case 4:
            return .precise(Double.bridgeJSStackPop())
        case 5:
            return .info
        default:
            fatalError("Unknown APIResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .failure(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .flag(let param0):
            param0.bridgeJSStackPush()
            return Int32(2)
        case .rate(let param0):
            param0.bridgeJSStackPush()
            return Int32(3)
        case .precise(let param0):
            param0.bridgeJSStackPush()
            return Int32(4)
        case .info:
            return Int32(5)
        }
    }
}

extension ComplexResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .error(String.bridgeJSStackPop(), Int.bridgeJSStackPop())
        case 2:
            return .location(Double.bridgeJSStackPop(), Double.bridgeJSStackPop(), String.bridgeJSStackPop())
        case 3:
            return .status(Bool.bridgeJSStackPop(), Int.bridgeJSStackPop(), String.bridgeJSStackPop())
        case 4:
            return .coordinates(Double.bridgeJSStackPop(), Double.bridgeJSStackPop(), Double.bridgeJSStackPop())
        case 5:
            return .comprehensive(Bool.bridgeJSStackPop(), Bool.bridgeJSStackPop(), Int.bridgeJSStackPop(), Int.bridgeJSStackPop(), Double.bridgeJSStackPop(), Double.bridgeJSStackPop(), String.bridgeJSStackPop(), String.bridgeJSStackPop(), String.bridgeJSStackPop())
        case 6:
            return .info
        default:
            fatalError("Unknown ComplexResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .error(let param0, let param1):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            return Int32(1)
        case .location(let param0, let param1, let param2):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            return Int32(2)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            return Int32(3)
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            return Int32(4)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            param3.bridgeJSStackPush()
            param4.bridgeJSStackPush()
            param5.bridgeJSStackPush()
            param6.bridgeJSStackPush()
            param7.bridgeJSStackPush()
            param8.bridgeJSStackPush()
            return Int32(5)
        case .info:
            return Int32(6)
        }
    }
}

extension Utilities.Result: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> Utilities.Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .failure(String.bridgeJSStackPop(), Int.bridgeJSStackPop())
        case 2:
            return .status(Bool.bridgeJSStackPop(), Int.bridgeJSStackPop(), String.bridgeJSStackPop())
        default:
            fatalError("Unknown Utilities.Result case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            return Int32(1)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            return Int32(2)
        }
    }
}

extension API.NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> API.NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .failure(String.bridgeJSStackPop(), Int.bridgeJSStackPop())
        default:
            fatalError("Unknown API.NetworkingResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            return Int32(1)
        }
    }
}

extension AllTypesResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> AllTypesResult {
        switch caseId {
        case 0:
            return .structPayload(Address.bridgeJSStackPop())
        case 1:
            return .classPayload(Greeter.bridgeJSStackPop())
        case 2:
            return .jsObjectPayload(JSObject.bridgeJSStackPop())
        case 3:
            return .nestedEnum(APIResult.bridgeJSStackPop())
        case 4:
            return .arrayPayload([Int].bridgeJSStackPop())
        case 5:
            return .jsClassPayload(Foo(unsafelyWrapping: JSObject.bridgeJSStackPop()))
        case 6:
            return .empty
        default:
            fatalError("Unknown AllTypesResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .structPayload(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .classPayload(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .jsObjectPayload(let param0):
            param0.bridgeJSStackPush()
            return Int32(2)
        case .nestedEnum(let param0):
            param0.bridgeJSStackPush()
            return Int32(3)
        case .arrayPayload(let param0):
            param0.bridgeJSStackPush()
            return Int32(4)
        case .jsClassPayload(let param0):
            param0.jsObject.bridgeJSStackPush()
            return Int32(5)
        case .empty:
            return Int32(6)
        }
    }
}

extension TypedPayloadResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> TypedPayloadResult {
        switch caseId {
        case 0:
            return .precision(Precision.bridgeJSStackPop())
        case 1:
            return .direction(Direction.bridgeJSStackPop())
        case 2:
            return .optPrecision(Optional<Precision>.bridgeJSStackPop())
        case 3:
            return .optDirection(Optional<Direction>.bridgeJSStackPop())
        case 4:
            return .empty
        default:
            fatalError("Unknown TypedPayloadResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .precision(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .direction(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .optPrecision(let param0):
            param0.bridgeJSStackPush()
            return Int32(2)
        case .optDirection(let param0):
            param0.bridgeJSStackPush()
            return Int32(3)
        case .empty:
            return Int32(4)
        }
    }
}

extension StaticCalculator: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> StaticCalculator {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> StaticCalculator {
        return StaticCalculator(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .scientific
        case 1:
            self = .basic
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .scientific:
            return 0
        case .basic:
            return 1
        }
    }
}

@_expose(wasm, "bjs_StaticCalculator_static_roundtrip")
@_cdecl("bjs_StaticCalculator_static_roundtrip")
public func _bjs_StaticCalculator_static_roundtrip(_ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = StaticCalculator.roundtrip(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticUtils_Nested_static_roundtrip")
@_cdecl("bjs_StaticUtils_Nested_static_roundtrip")
public func _bjs_StaticUtils_Nested_static_roundtrip(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = StaticUtils.Nested.roundtrip(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Services_Graph_GraphOperations_static_createGraph")
@_cdecl("bjs_Services_Graph_GraphOperations_static_createGraph")
public func _bjs_Services_Graph_GraphOperations_static_createGraph(_ rootId: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = GraphOperations.createGraph(rootId: Int.bridgeJSLiftParameter(rootId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Services_Graph_GraphOperations_static_nodeCount")
@_cdecl("bjs_Services_Graph_GraphOperations_static_nodeCount")
public func _bjs_Services_Graph_GraphOperations_static_nodeCount(_ graphId: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = GraphOperations.nodeCount(graphId: Int.bridgeJSLiftParameter(graphId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension StaticPropertyEnum: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> StaticPropertyEnum {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> StaticPropertyEnum {
        return StaticPropertyEnum(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .option1
        case 1:
            self = .option2
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .option1:
            return 0
        case .option2:
            return 1
        }
    }
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumProperty_get")
@_cdecl("bjs_StaticPropertyEnum_static_enumProperty_get")
public func _bjs_StaticPropertyEnum_static_enumProperty_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.enumProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumProperty_set")
@_cdecl("bjs_StaticPropertyEnum_static_enumProperty_set")
public func _bjs_StaticPropertyEnum_static_enumProperty_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyEnum.enumProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumConstant_get")
@_cdecl("bjs_StaticPropertyEnum_static_enumConstant_get")
public func _bjs_StaticPropertyEnum_static_enumConstant_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.enumConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumBool_get")
@_cdecl("bjs_StaticPropertyEnum_static_enumBool_get")
public func _bjs_StaticPropertyEnum_static_enumBool_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.enumBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumBool_set")
@_cdecl("bjs_StaticPropertyEnum_static_enumBool_set")
public func _bjs_StaticPropertyEnum_static_enumBool_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyEnum.enumBool = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumVariable_get")
@_cdecl("bjs_StaticPropertyEnum_static_enumVariable_get")
public func _bjs_StaticPropertyEnum_static_enumVariable_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.enumVariable
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_enumVariable_set")
@_cdecl("bjs_StaticPropertyEnum_static_enumVariable_set")
public func _bjs_StaticPropertyEnum_static_enumVariable_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyEnum.enumVariable = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_computedReadonly_get")
@_cdecl("bjs_StaticPropertyEnum_static_computedReadonly_get")
public func _bjs_StaticPropertyEnum_static_computedReadonly_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.computedReadonly
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_computedReadWrite_get")
@_cdecl("bjs_StaticPropertyEnum_static_computedReadWrite_get")
public func _bjs_StaticPropertyEnum_static_computedReadWrite_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyEnum.computedReadWrite
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyEnum_static_computedReadWrite_set")
@_cdecl("bjs_StaticPropertyEnum_static_computedReadWrite_set")
public func _bjs_StaticPropertyEnum_static_computedReadWrite_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyEnum.computedReadWrite = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_static_namespaceProperty_get")
@_cdecl("bjs_StaticPropertyNamespace_static_namespaceProperty_get")
public func _bjs_StaticPropertyNamespace_static_namespaceProperty_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyNamespace.namespaceProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_static_namespaceProperty_set")
@_cdecl("bjs_StaticPropertyNamespace_static_namespaceProperty_set")
public func _bjs_StaticPropertyNamespace_static_namespaceProperty_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyNamespace.namespaceProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_static_namespaceConstant_get")
@_cdecl("bjs_StaticPropertyNamespace_static_namespaceConstant_get")
public func _bjs_StaticPropertyNamespace_static_namespaceConstant_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyNamespace.namespaceConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_get")
@_cdecl("bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_get")
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyNamespace.NestedProperties.nestedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_set")
@_cdecl("bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_set")
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyNamespace.NestedProperties.nestedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_NestedProperties_static_nestedConstant_get")
@_cdecl("bjs_StaticPropertyNamespace_NestedProperties_static_nestedConstant_get")
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedConstant_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyNamespace.NestedProperties.nestedConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_get")
@_cdecl("bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_get")
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_get() -> Float64 {
    #if arch(wasm32)
    let ret = StaticPropertyNamespace.NestedProperties.nestedDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_set")
@_cdecl("bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_set")
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_set(_ value: Float64) -> Void {
    #if arch(wasm32)
    StaticPropertyNamespace.NestedProperties.nestedDouble = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalString")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalString")
public func _bjs_OptionalSupportExports_static_roundTripOptionalString(_ vIsSome: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalString(_: Optional<String>.bridgeJSLiftParameter(vIsSome, vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalInt")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalInt")
public func _bjs_OptionalSupportExports_static_roundTripOptionalInt(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalInt(_: Optional<Int>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalBool")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalBool")
public func _bjs_OptionalSupportExports_static_roundTripOptionalBool(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalBool(_: Optional<Bool>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalFloat")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalFloat")
public func _bjs_OptionalSupportExports_static_roundTripOptionalFloat(_ vIsSome: Int32, _ vValue: Float32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalFloat(_: Optional<Float>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalDouble")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalDouble")
public func _bjs_OptionalSupportExports_static_roundTripOptionalDouble(_ vIsSome: Int32, _ vValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalDouble(_: Optional<Double>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalSyntax")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalSyntax")
public func _bjs_OptionalSupportExports_static_roundTripOptionalSyntax(_ vIsSome: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalSyntax(_: Optional<String>.bridgeJSLiftParameter(vIsSome, vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalCaseEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalCaseEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalCaseEnum(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalCaseEnum(_: Optional<Status>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalStringRawValueEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalStringRawValueEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalStringRawValueEnum(_ vIsSome: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalStringRawValueEnum(_: Optional<Theme>.bridgeJSLiftParameter(vIsSome, vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalIntRawValueEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalIntRawValueEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalIntRawValueEnum(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalIntRawValueEnum(_: Optional<HttpStatus>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalTSEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalTSEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalTSEnum(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalTSEnum(_: Optional<TSDirection>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalTSStringEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalTSStringEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalTSStringEnum(_ vIsSome: Int32, _ vBytes: Int32, _ vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalTSStringEnum(_: Optional<TSTheme>.bridgeJSLiftParameter(vIsSome, vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalNamespacedEnum")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalNamespacedEnum")
public func _bjs_OptionalSupportExports_static_roundTripOptionalNamespacedEnum(_ vIsSome: Int32, _ vValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalNamespacedEnum(_: Optional<Networking.API.Method>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalSwiftClass")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalSwiftClass")
public func _bjs_OptionalSupportExports_static_roundTripOptionalSwiftClass(_ vIsSome: Int32, _ vValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalSwiftClass(_: Optional<Greeter>.bridgeJSLiftParameter(vIsSome, vValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalIntArray")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalIntArray")
public func _bjs_OptionalSupportExports_static_roundTripOptionalIntArray() -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalIntArray(_: Optional<[Int]>.bridgeJSLiftParameter())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalStringArray")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalStringArray")
public func _bjs_OptionalSupportExports_static_roundTripOptionalStringArray() -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalStringArray(_: Optional<[String]>.bridgeJSLiftParameter())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalSwiftClassArray")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalSwiftClassArray")
public func _bjs_OptionalSupportExports_static_roundTripOptionalSwiftClassArray() -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalSwiftClassArray(_: Optional<[Greeter]>.bridgeJSLiftParameter())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalAPIResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalAPIResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalAPIResult(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalAPIResult(_: Optional<APIResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalTypedPayloadResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalTypedPayloadResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalTypedPayloadResult(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalTypedPayloadResult(_: Optional<TypedPayloadResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalComplexResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalComplexResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalComplexResult(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalComplexResult(_: Optional<ComplexResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalAllTypesResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalAllTypesResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalAllTypesResult(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalAllTypesResult(_: Optional<AllTypesResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalPayloadResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalPayloadResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalPayloadResult(_ v: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalPayloadResult(_: OptionalAllTypesResult.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalPayloadResultOpt")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalPayloadResultOpt")
public func _bjs_OptionalSupportExports_static_roundTripOptionalPayloadResultOpt(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalPayloadResultOpt(_: Optional<OptionalAllTypesResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_roundTripOptionalAPIOptionalResult")
@_cdecl("bjs_OptionalSupportExports_static_roundTripOptionalAPIOptionalResult")
public func _bjs_OptionalSupportExports_static_roundTripOptionalAPIOptionalResult(_ vIsSome: Int32, _ vCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.roundTripOptionalAPIOptionalResult(_: Optional<APIOptionalResult>.bridgeJSLiftParameter(vIsSome, vCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_takeOptionalJSObject")
@_cdecl("bjs_OptionalSupportExports_static_takeOptionalJSObject")
public func _bjs_OptionalSupportExports_static_takeOptionalJSObject(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    OptionalSupportExports.takeOptionalJSObject(_: Optional<JSObject>.bridgeJSLiftParameter(valueIsSome, valueValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_applyOptionalGreeter")
@_cdecl("bjs_OptionalSupportExports_static_applyOptionalGreeter")
public func _bjs_OptionalSupportExports_static_applyOptionalGreeter(_ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer, _ transform: Int32) -> Void {
    #if arch(wasm32)
    let ret = OptionalSupportExports.applyOptionalGreeter(_: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue), _: _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_makeOptionalHolder")
@_cdecl("bjs_OptionalSupportExports_static_makeOptionalHolder")
public func _bjs_OptionalSupportExports_static_makeOptionalHolder(_ nullableGreeterIsSome: Int32, _ nullableGreeterValue: UnsafeMutableRawPointer, _ undefinedNumberIsSome: Int32, _ undefinedNumberValue: Float64) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalSupportExports.makeOptionalHolder(nullableGreeter: Optional<Greeter>.bridgeJSLiftParameter(nullableGreeterIsSome, nullableGreeterValue), undefinedNumber: JSUndefinedOr<Double>.bridgeJSLiftParameter(undefinedNumberIsSome, undefinedNumberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalSupportExports_static_compareAPIResults")
@_cdecl("bjs_OptionalSupportExports_static_compareAPIResults")
public func _bjs_OptionalSupportExports_static_compareAPIResults(_ r1IsSome: Int32, _ r1CaseId: Int32, _ r2IsSome: Int32, _ r2CaseId: Int32) -> Void {
    #if arch(wasm32)
    let _tmp_r2 = Optional<APIResult>.bridgeJSLiftParameter(r2IsSome, r2CaseId)
    let _tmp_r1 = Optional<APIResult>.bridgeJSLiftParameter(r1IsSome, r1CaseId)
    let ret = OptionalSupportExports.compareAPIResults(_: _tmp_r1, _: _tmp_r2)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension OptionalAllTypesResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> OptionalAllTypesResult {
        switch caseId {
        case 0:
            return .optStruct(Optional<Address>.bridgeJSStackPop())
        case 1:
            return .optClass(Optional<Greeter>.bridgeJSStackPop())
        case 2:
            return .optJSObject(Optional<JSObject>.bridgeJSStackPop())
        case 3:
            return .optNestedEnum(Optional<APIResult>.bridgeJSStackPop())
        case 4:
            return .optArray(Optional<[Int]>.bridgeJSStackPop())
        case 5:
            return .optJsClass(Optional<JSObject>.bridgeJSStackPop().map { Foo(unsafelyWrapping: $0) })
        case 6:
            return .empty
        default:
            fatalError("Unknown OptionalAllTypesResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .optStruct(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .optClass(let param0):
            param0.bridgeJSStackPush()
            return Int32(1)
        case .optJSObject(let param0):
            param0.bridgeJSStackPush()
            return Int32(2)
        case .optNestedEnum(let param0):
            param0.bridgeJSStackPush()
            return Int32(3)
        case .optArray(let param0):
            param0.bridgeJSStackPush()
            return Int32(4)
        case .optJsClass(let param0):
            param0.bridgeJSStackPush()
            return Int32(5)
        case .empty:
            return Int32(6)
        }
    }
}

extension APIOptionalResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> APIOptionalResult {
        switch caseId {
        case 0:
            return .success(Optional<String>.bridgeJSStackPop())
        case 1:
            return .failure(Optional<Int>.bridgeJSStackPop(), Optional<Bool>.bridgeJSStackPop())
        case 2:
            return .status(Optional<Bool>.bridgeJSStackPop(), Optional<Int>.bridgeJSStackPop(), Optional<String>.bridgeJSStackPop())
        default:
            fatalError("Unknown APIOptionalResult case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSStackPush()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            return Int32(1)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSStackPush()
            param1.bridgeJSStackPush()
            param2.bridgeJSStackPush()
            return Int32(2)
        }
    }
}

extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Point {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return Point(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Point(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Point()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Point")
fileprivate func _bjs_struct_lower_Point_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Point_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Point_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Point")
fileprivate func _bjs_struct_lift_Point_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Point_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Point() -> Int32 {
    return _bjs_struct_lift_Point_extern()
}

extension PointerFields: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> PointerFields {
        let mutPtr = UnsafeMutablePointer<UInt8>.bridgeJSStackPop()
        let ptr = UnsafePointer<UInt8>.bridgeJSStackPop()
        let opaque = OpaquePointer.bridgeJSStackPop()
        let mutRaw = UnsafeMutableRawPointer.bridgeJSStackPop()
        let raw = UnsafeRawPointer.bridgeJSStackPop()
        return PointerFields(raw: raw, mutRaw: mutRaw, opaque: opaque, ptr: ptr, mutPtr: mutPtr)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.raw.bridgeJSStackPush()
        self.mutRaw.bridgeJSStackPush()
        self.opaque.bridgeJSStackPush()
        self.ptr.bridgeJSStackPush()
        self.mutPtr.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_PointerFields(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PointerFields()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PointerFields")
fileprivate func _bjs_struct_lower_PointerFields_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_PointerFields_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_PointerFields(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_PointerFields_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PointerFields")
fileprivate func _bjs_struct_lift_PointerFields_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_PointerFields_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_PointerFields() -> Int32 {
    return _bjs_struct_lift_PointerFields_extern()
}

@_expose(wasm, "bjs_PointerFields_init")
@_cdecl("bjs_PointerFields_init")
public func _bjs_PointerFields_init(_ raw: UnsafeMutableRawPointer, _ mutRaw: UnsafeMutableRawPointer, _ opaque: UnsafeMutableRawPointer, _ ptr: UnsafeMutableRawPointer, _ mutPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PointerFields(raw: UnsafeRawPointer.bridgeJSLiftParameter(raw), mutRaw: UnsafeMutableRawPointer.bridgeJSLiftParameter(mutRaw), opaque: OpaquePointer.bridgeJSLiftParameter(opaque), ptr: UnsafePointer<UInt8>.bridgeJSLiftParameter(ptr), mutPtr: UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(mutPtr))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension DataPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> DataPoint {
        let optFlag = Optional<Bool>.bridgeJSStackPop()
        let optCount = Optional<Int>.bridgeJSStackPop()
        let label = String.bridgeJSStackPop()
        let y = Double.bridgeJSStackPop()
        let x = Double.bridgeJSStackPop()
        return DataPoint(x: x, y: y, label: label, optCount: optCount, optFlag: optFlag)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
        self.label.bridgeJSStackPush()
        self.optCount.bridgeJSStackPush()
        self.optFlag.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_DataPoint(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_DataPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_DataPoint")
fileprivate func _bjs_struct_lower_DataPoint_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_DataPoint_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_DataPoint(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_DataPoint_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_DataPoint")
fileprivate func _bjs_struct_lift_DataPoint_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_DataPoint_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_DataPoint() -> Int32 {
    return _bjs_struct_lift_DataPoint_extern()
}

@_expose(wasm, "bjs_DataPoint_init")
@_cdecl("bjs_DataPoint_init")
public func _bjs_DataPoint_init(_ x: Float64, _ y: Float64, _ labelBytes: Int32, _ labelLength: Int32, _ optCountIsSome: Int32, _ optCountValue: Int32, _ optFlagIsSome: Int32, _ optFlagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = DataPoint(x: Double.bridgeJSLiftParameter(x), y: Double.bridgeJSLiftParameter(y), label: String.bridgeJSLiftParameter(labelBytes, labelLength), optCount: Optional<Int>.bridgeJSLiftParameter(optCountIsSome, optCountValue), optFlag: Optional<Bool>.bridgeJSLiftParameter(optFlagIsSome, optFlagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PublicPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> PublicPoint {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return PublicPoint(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_PublicPoint(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PublicPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PublicPoint")
fileprivate func _bjs_struct_lower_PublicPoint_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_PublicPoint_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_PublicPoint(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_PublicPoint_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PublicPoint")
fileprivate func _bjs_struct_lift_PublicPoint_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_PublicPoint_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_PublicPoint() -> Int32 {
    return _bjs_struct_lift_PublicPoint_extern()
}

@_expose(wasm, "bjs_PublicPoint_init")
@_cdecl("bjs_PublicPoint_init")
public func _bjs_PublicPoint_init(_ x: Int32, _ y: Int32) -> Void {
    #if arch(wasm32)
    let ret = PublicPoint(x: Int.bridgeJSLiftParameter(x), y: Int.bridgeJSLiftParameter(y))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Address: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Address {
        let zipCode = Optional<Int>.bridgeJSStackPop()
        let city = String.bridgeJSStackPop()
        let street = String.bridgeJSStackPop()
        return Address(street: street, city: city, zipCode: zipCode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.street.bridgeJSStackPush()
        self.city.bridgeJSStackPush()
        self.zipCode.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Address(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Address()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Address")
fileprivate func _bjs_struct_lower_Address_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Address_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Address(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Address_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Address")
fileprivate func _bjs_struct_lift_Address_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Address_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Address() -> Int32 {
    return _bjs_struct_lift_Address_extern()
}

extension Contact: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Contact {
        let secondaryAddress = Optional<Address>.bridgeJSStackPop()
        let email = Optional<String>.bridgeJSStackPop()
        let address = Address.bridgeJSStackPop()
        let age = Int.bridgeJSStackPop()
        let name = String.bridgeJSStackPop()
        return Contact(name: name, age: age, address: address, email: email, secondaryAddress: secondaryAddress)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.name.bridgeJSStackPush()
        self.age.bridgeJSStackPush()
        self.address.bridgeJSStackPush()
        self.email.bridgeJSStackPush()
        self.secondaryAddress.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Contact(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Contact()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Contact")
fileprivate func _bjs_struct_lower_Contact_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Contact_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Contact(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Contact_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Contact")
fileprivate func _bjs_struct_lift_Contact_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Contact_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Contact() -> Int32 {
    return _bjs_struct_lift_Contact_extern()
}

extension Config: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Config {
        let status = Status.bridgeJSStackPop()
        let direction = Optional<Direction>.bridgeJSStackPop()
        let theme = Optional<Theme>.bridgeJSStackPop()
        let name = String.bridgeJSStackPop()
        return Config(name: name, theme: theme, direction: direction, status: status)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.name.bridgeJSStackPush()
        self.theme.bridgeJSStackPush()
        self.direction.bridgeJSStackPush()
        self.status.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Config(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Config()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Config")
fileprivate func _bjs_struct_lower_Config_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Config_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Config(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Config_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Config")
fileprivate func _bjs_struct_lift_Config_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Config_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Config() -> Int32 {
    return _bjs_struct_lift_Config_extern()
}

extension SessionData: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> SessionData {
        let owner = Optional<Greeter>.bridgeJSStackPop()
        let id = Int.bridgeJSStackPop()
        return SessionData(id: id, owner: owner)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.id.bridgeJSStackPush()
        self.owner.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_SessionData(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_SessionData()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_SessionData")
fileprivate func _bjs_struct_lower_SessionData_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_SessionData_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_SessionData(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_SessionData_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_SessionData")
fileprivate func _bjs_struct_lift_SessionData_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_SessionData_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_SessionData() -> Int32 {
    return _bjs_struct_lift_SessionData_extern()
}

extension ValidationReport: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ValidationReport {
        let outcome = Optional<APIResult>.bridgeJSStackPop()
        let status = Optional<Status>.bridgeJSStackPop()
        let result = APIResult.bridgeJSStackPop()
        let id = Int.bridgeJSStackPop()
        return ValidationReport(id: id, result: result, status: status, outcome: outcome)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.id.bridgeJSStackPush()
        self.result.bridgeJSStackPush()
        self.status.bridgeJSStackPush()
        self.outcome.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ValidationReport(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ValidationReport()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ValidationReport")
fileprivate func _bjs_struct_lower_ValidationReport_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ValidationReport_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ValidationReport(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ValidationReport_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ValidationReport")
fileprivate func _bjs_struct_lift_ValidationReport_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ValidationReport_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ValidationReport() -> Int32 {
    return _bjs_struct_lift_ValidationReport_extern()
}

extension AdvancedConfig: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> AdvancedConfig {
        let overrideDefaults = Optional<ConfigStruct>.bridgeJSStackPop()
        let defaults = ConfigStruct.bridgeJSStackPop()
        let location = Optional<DataPoint>.bridgeJSStackPop()
        let metadata = Optional<JSObject>.bridgeJSStackPop()
        let result = Optional<APIResult>.bridgeJSStackPop()
        let status = Status.bridgeJSStackPop()
        let theme = Theme.bridgeJSStackPop()
        let enabled = Bool.bridgeJSStackPop()
        let title = String.bridgeJSStackPop()
        let id = Int.bridgeJSStackPop()
        return AdvancedConfig(id: id, title: title, enabled: enabled, theme: theme, status: status, result: result, metadata: metadata, location: location, defaults: defaults, overrideDefaults: overrideDefaults)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.id.bridgeJSStackPush()
        self.title.bridgeJSStackPush()
        self.enabled.bridgeJSStackPush()
        self.theme.bridgeJSStackPush()
        self.status.bridgeJSStackPush()
        self.result.bridgeJSStackPush()
        self.metadata.bridgeJSStackPush()
        self.location.bridgeJSStackPush()
        self.defaults.bridgeJSStackPush()
        self.overrideDefaults.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_AdvancedConfig(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_AdvancedConfig()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_AdvancedConfig")
fileprivate func _bjs_struct_lower_AdvancedConfig_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_AdvancedConfig_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_AdvancedConfig(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_AdvancedConfig_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_AdvancedConfig")
fileprivate func _bjs_struct_lift_AdvancedConfig_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_AdvancedConfig_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_AdvancedConfig() -> Int32 {
    return _bjs_struct_lift_AdvancedConfig_extern()
}

extension MeasurementConfig: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> MeasurementConfig {
        let optionalRatio = Optional<Ratio>.bridgeJSStackPop()
        let optionalPrecision = Optional<Precision>.bridgeJSStackPop()
        let ratio = Ratio.bridgeJSStackPop()
        let precision = Precision.bridgeJSStackPop()
        return MeasurementConfig(precision: precision, ratio: ratio, optionalPrecision: optionalPrecision, optionalRatio: optionalRatio)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.precision.bridgeJSStackPush()
        self.ratio.bridgeJSStackPush()
        self.optionalPrecision.bridgeJSStackPush()
        self.optionalRatio.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_MeasurementConfig(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_MeasurementConfig()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_MeasurementConfig")
fileprivate func _bjs_struct_lower_MeasurementConfig_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_MeasurementConfig_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_MeasurementConfig(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_MeasurementConfig_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_MeasurementConfig")
fileprivate func _bjs_struct_lift_MeasurementConfig_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_MeasurementConfig_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_MeasurementConfig() -> Int32 {
    return _bjs_struct_lift_MeasurementConfig_extern()
}

extension MathOperations: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> MathOperations {
        let baseValue = Double.bridgeJSStackPop()
        return MathOperations(baseValue: baseValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.baseValue.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_MathOperations(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_MathOperations()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_MathOperations")
fileprivate func _bjs_struct_lower_MathOperations_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_MathOperations_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_MathOperations(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_MathOperations_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_MathOperations")
fileprivate func _bjs_struct_lift_MathOperations_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_MathOperations_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_MathOperations() -> Int32 {
    return _bjs_struct_lift_MathOperations_extern()
}

@_expose(wasm, "bjs_MathOperations_init")
@_cdecl("bjs_MathOperations_init")
public func _bjs_MathOperations_init(_ baseValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = MathOperations(baseValue: Double.bridgeJSLiftParameter(baseValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_add")
@_cdecl("bjs_MathOperations_add")
public func _bjs_MathOperations_add(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.bridgeJSLiftParameter().add(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_multiply")
@_cdecl("bjs_MathOperations_multiply")
public func _bjs_MathOperations_multiply(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.bridgeJSLiftParameter().multiply(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathOperations_static_subtract")
@_cdecl("bjs_MathOperations_static_subtract")
public func _bjs_MathOperations_static_subtract(_ a: Float64, _ b: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = MathOperations.subtract(a: Double.bridgeJSLiftParameter(a), b: Double.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension CopyableCart: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> CopyableCart {
        let note = Optional<String>.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return CopyableCart(x: x, note: note)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.note.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_CopyableCart(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableCart()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableCart")
fileprivate func _bjs_struct_lower_CopyableCart_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_CopyableCart_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_CopyableCart(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_CopyableCart_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableCart")
fileprivate func _bjs_struct_lift_CopyableCart_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableCart_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_CopyableCart() -> Int32 {
    return _bjs_struct_lift_CopyableCart_extern()
}

@_expose(wasm, "bjs_CopyableCart_static_fromJSObject")
@_cdecl("bjs_CopyableCart_static_fromJSObject")
public func _bjs_CopyableCart_static_fromJSObject(_ object: Int32) -> Void {
    #if arch(wasm32)
    let ret = CopyableCart.fromJSObject(_: JSObject.bridgeJSLiftParameter(object))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension CopyableCartItem: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> CopyableCartItem {
        let quantity = Int.bridgeJSStackPop()
        let sku = String.bridgeJSStackPop()
        return CopyableCartItem(sku: sku, quantity: quantity)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.sku.bridgeJSStackPush()
        self.quantity.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_CopyableCartItem(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableCartItem()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableCartItem")
fileprivate func _bjs_struct_lower_CopyableCartItem_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_CopyableCartItem_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_CopyableCartItem(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_CopyableCartItem_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableCartItem")
fileprivate func _bjs_struct_lift_CopyableCartItem_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableCartItem_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_CopyableCartItem() -> Int32 {
    return _bjs_struct_lift_CopyableCartItem_extern()
}

extension CopyableNestedCart: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> CopyableNestedCart {
        let shippingAddress = Optional<Address>.bridgeJSStackPop()
        let item = CopyableCartItem.bridgeJSStackPop()
        let id = Int.bridgeJSStackPop()
        return CopyableNestedCart(id: id, item: item, shippingAddress: shippingAddress)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.id.bridgeJSStackPush()
        self.item.bridgeJSStackPush()
        self.shippingAddress.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_CopyableNestedCart(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableNestedCart()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableNestedCart")
fileprivate func _bjs_struct_lower_CopyableNestedCart_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_CopyableNestedCart_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_CopyableNestedCart(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_CopyableNestedCart_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableNestedCart")
fileprivate func _bjs_struct_lift_CopyableNestedCart_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableNestedCart_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_CopyableNestedCart() -> Int32 {
    return _bjs_struct_lift_CopyableNestedCart_extern()
}

@_expose(wasm, "bjs_CopyableNestedCart_static_fromJSObject")
@_cdecl("bjs_CopyableNestedCart_static_fromJSObject")
public func _bjs_CopyableNestedCart_static_fromJSObject(_ object: Int32) -> Void {
    #if arch(wasm32)
    let ret = CopyableNestedCart.fromJSObject(_: JSObject.bridgeJSLiftParameter(object))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ConfigStruct: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ConfigStruct {
        let value = Int.bridgeJSStackPop()
        let name = String.bridgeJSStackPop()
        return ConfigStruct(name: name, value: value)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.name.bridgeJSStackPush()
        self.value.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ConfigStruct(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ConfigStruct()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ConfigStruct")
fileprivate func _bjs_struct_lower_ConfigStruct_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ConfigStruct_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ConfigStruct(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ConfigStruct_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ConfigStruct")
fileprivate func _bjs_struct_lift_ConfigStruct_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ConfigStruct_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ConfigStruct() -> Int32 {
    return _bjs_struct_lift_ConfigStruct_extern()
}

@_expose(wasm, "bjs_ConfigStruct_static_defaultConfig_get")
@_cdecl("bjs_ConfigStruct_static_defaultConfig_get")
public func _bjs_ConfigStruct_static_defaultConfig_get() -> Void {
    #if arch(wasm32)
    let ret = ConfigStruct.defaultConfig
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_defaultConfig_set")
@_cdecl("bjs_ConfigStruct_static_defaultConfig_set")
public func _bjs_ConfigStruct_static_defaultConfig_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConfigStruct.defaultConfig = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_maxRetries_get")
@_cdecl("bjs_ConfigStruct_static_maxRetries_get")
public func _bjs_ConfigStruct_static_maxRetries_get() -> Int32 {
    #if arch(wasm32)
    let ret = ConfigStruct.maxRetries
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_timeout_get")
@_cdecl("bjs_ConfigStruct_static_timeout_get")
public func _bjs_ConfigStruct_static_timeout_get() -> Float64 {
    #if arch(wasm32)
    let ret = ConfigStruct.timeout
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_timeout_set")
@_cdecl("bjs_ConfigStruct_static_timeout_set")
public func _bjs_ConfigStruct_static_timeout_set(_ value: Float64) -> Void {
    #if arch(wasm32)
    ConfigStruct.timeout = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConfigStruct_static_computedSetting_get")
@_cdecl("bjs_ConfigStruct_static_computedSetting_get")
public func _bjs_ConfigStruct_static_computedSetting_get() -> Void {
    #if arch(wasm32)
    let ret = ConfigStruct.computedSetting
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension JSObjectContainer: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> JSObjectContainer {
        let optionalObject = Optional<JSObject>.bridgeJSStackPop()
        let object = JSObject.bridgeJSStackPop()
        return JSObjectContainer(object: object, optionalObject: optionalObject)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.object.bridgeJSStackPush()
        self.optionalObject.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_JSObjectContainer(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_JSObjectContainer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_JSObjectContainer")
fileprivate func _bjs_struct_lower_JSObjectContainer_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_JSObjectContainer_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_JSObjectContainer(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_JSObjectContainer_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_JSObjectContainer")
fileprivate func _bjs_struct_lift_JSObjectContainer_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_JSObjectContainer_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_JSObjectContainer() -> Int32 {
    return _bjs_struct_lift_JSObjectContainer_extern()
}

extension FooContainer: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> FooContainer {
        let optionalFoo = Optional<JSObject>.bridgeJSStackPop().map { Foo(unsafelyWrapping: $0) }
        let foo = Foo(unsafelyWrapping: JSObject.bridgeJSStackPop())
        return FooContainer(foo: foo, optionalFoo: optionalFoo)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.foo.jsObject.bridgeJSStackPush()
        self.optionalFoo.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_FooContainer(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_FooContainer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_FooContainer")
fileprivate func _bjs_struct_lower_FooContainer_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_FooContainer_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_FooContainer(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_FooContainer_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_FooContainer")
fileprivate func _bjs_struct_lift_FooContainer_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_FooContainer_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_FooContainer() -> Int32 {
    return _bjs_struct_lift_FooContainer_extern()
}

extension ArrayMembers: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ArrayMembers {
        let optStrings = Optional<[String]>.bridgeJSStackPop()
        let ints = [Int].bridgeJSStackPop()
        return ArrayMembers(ints: ints, optStrings: optStrings)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.ints.bridgeJSStackPush()
        self.optStrings.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ArrayMembers(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ArrayMembers()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ArrayMembers")
fileprivate func _bjs_struct_lower_ArrayMembers_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ArrayMembers_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ArrayMembers(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ArrayMembers_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ArrayMembers")
fileprivate func _bjs_struct_lift_ArrayMembers_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ArrayMembers_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ArrayMembers() -> Int32 {
    return _bjs_struct_lift_ArrayMembers_extern()
}

@_expose(wasm, "bjs_ArrayMembers_sumValues")
@_cdecl("bjs_ArrayMembers_sumValues")
public func _bjs_ArrayMembers_sumValues() -> Int32 {
    #if arch(wasm32)
    let ret = ArrayMembers.bridgeJSLiftParameter().sumValues(_: [Int].bridgeJSStackPop())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArrayMembers_firstString")
@_cdecl("bjs_ArrayMembers_firstString")
public func _bjs_ArrayMembers_firstString() -> Void {
    #if arch(wasm32)
    let ret = ArrayMembers.bridgeJSLiftParameter().firstString(_: [String].bridgeJSStackPop())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripVoid")
@_cdecl("bjs_roundTripVoid")
public func _bjs_roundTripVoid() -> Void {
    #if arch(wasm32)
    roundTripVoid()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripInt")
@_cdecl("bjs_roundTripInt")
public func _bjs_roundTripInt(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt(v: Int.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUInt")
@_cdecl("bjs_roundTripUInt")
public func _bjs_roundTripUInt(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripUInt(v: UInt.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(_ v: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = roundTripFloat(v: Float.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(_ v: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = roundTripDouble(v: Double.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripBool(v: Bool.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(_ vBytes: Int32, _ vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripString(v: String.bridgeJSLiftParameter(vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftHeapObject")
@_cdecl("bjs_roundTripSwiftHeapObject")
public func _bjs_roundTripSwiftHeapObject(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripSwiftHeapObject(v: Greeter.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeRawPointer")
@_cdecl("bjs_roundTripUnsafeRawPointer")
public func _bjs_roundTripUnsafeRawPointer(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripUnsafeRawPointer(v: UnsafeRawPointer.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeMutableRawPointer")
@_cdecl("bjs_roundTripUnsafeMutableRawPointer")
public func _bjs_roundTripUnsafeMutableRawPointer(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripUnsafeMutableRawPointer(v: UnsafeMutableRawPointer.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOpaquePointer")
@_cdecl("bjs_roundTripOpaquePointer")
public func _bjs_roundTripOpaquePointer(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripOpaquePointer(v: OpaquePointer.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafePointer")
@_cdecl("bjs_roundTripUnsafePointer")
public func _bjs_roundTripUnsafePointer(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripUnsafePointer(v: UnsafePointer<UInt8>.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeMutablePointer")
@_cdecl("bjs_roundTripUnsafeMutablePointer")
public func _bjs_roundTripUnsafeMutablePointer(_ v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripUnsafeMutablePointer(v: UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObject")
@_cdecl("bjs_roundTripJSObject")
public func _bjs_roundTripJSObject(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSObject(v: JSObject.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDictionaryExport")
@_cdecl("bjs_roundTripDictionaryExport")
public func _bjs_roundTripDictionaryExport() -> Void {
    #if arch(wasm32)
    let ret = roundTripDictionaryExport(v: [String: Int].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalDictionaryExport")
@_cdecl("bjs_roundTripOptionalDictionaryExport")
public func _bjs_roundTripOptionalDictionaryExport() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDictionaryExport(v: Optional<[String: String]>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSValue")
@_cdecl("bjs_roundTripJSValue")
public func _bjs_roundTripJSValue(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripJSValue(v: JSValue.bridgeJSLiftParameter(vKind, vPayload1, vPayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSValue")
@_cdecl("bjs_roundTripOptionalJSValue")
public func _bjs_roundTripOptionalJSValue(_ vIsSome: Int32, _ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSValue(v: Optional<JSValue>.bridgeJSLiftParameter(vIsSome, vKind, vPayload1, vPayload2))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSValueArray")
@_cdecl("bjs_roundTripOptionalJSValueArray")
public func _bjs_roundTripOptionalJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSValueArray(v: Optional<[JSValue]>.bridgeJSLiftParameter())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeImportedFoo")
@_cdecl("bjs_makeImportedFoo")
public func _bjs_makeImportedFoo(_ valueBytes: Int32, _ valueLength: Int32) -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try makeImportedFoo(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsSwiftError")
@_cdecl("bjs_throwsSwiftError")
public func _bjs_throwsSwiftError(_ shouldThrow: Int32) -> Void {
    #if arch(wasm32)
    do {
        try throwsSwiftError(shouldThrow: Bool.bridgeJSLiftParameter(shouldThrow))
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithIntResult")
@_cdecl("bjs_throwsWithIntResult")
public func _bjs_throwsWithIntResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithIntResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithStringResult")
@_cdecl("bjs_throwsWithStringResult")
public func _bjs_throwsWithStringResult() -> Void {
    #if arch(wasm32)
    do {
        let ret = try throwsWithStringResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithBoolResult")
@_cdecl("bjs_throwsWithBoolResult")
public func _bjs_throwsWithBoolResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithBoolResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithFloatResult")
@_cdecl("bjs_throwsWithFloatResult")
public func _bjs_throwsWithFloatResult() -> Float32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithFloatResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithDoubleResult")
@_cdecl("bjs_throwsWithDoubleResult")
public func _bjs_throwsWithDoubleResult() -> Float64 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithDoubleResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0.0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithSwiftHeapObjectResult")
@_cdecl("bjs_throwsWithSwiftHeapObjectResult")
public func _bjs_throwsWithSwiftHeapObjectResult() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    do {
        let ret = try throwsWithSwiftHeapObjectResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsWithJSObjectResult")
@_cdecl("bjs_throwsWithJSObjectResult")
public func _bjs_throwsWithJSObjectResult() -> Int32 {
    #if arch(wasm32)
    do {
        let ret = try throwsWithJSObjectResult()
        return ret.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: String(describing: error))
            withExtendedLifetime(jsError.jsObject) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        }
        return 0
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripVoid")
@_cdecl("bjs_asyncRoundTripVoid")
public func _bjs_asyncRoundTripVoid() -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        await asyncRoundTripVoid()
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripInt")
@_cdecl("bjs_asyncRoundTripInt")
public func _bjs_asyncRoundTripInt(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripInt(v: Int.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripFloat")
@_cdecl("bjs_asyncRoundTripFloat")
public func _bjs_asyncRoundTripFloat(_ v: Float32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripFloat(v: Float.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripDouble")
@_cdecl("bjs_asyncRoundTripDouble")
public func _bjs_asyncRoundTripDouble(_ v: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripDouble(v: Double.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripBool")
@_cdecl("bjs_asyncRoundTripBool")
public func _bjs_asyncRoundTripBool(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripBool(v: Bool.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripString")
@_cdecl("bjs_asyncRoundTripString")
public func _bjs_asyncRoundTripString(_ vBytes: Int32, _ vLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripString(v: String.bridgeJSLiftParameter(vBytes, vLength)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripSwiftHeapObject")
@_cdecl("bjs_asyncRoundTripSwiftHeapObject")
public func _bjs_asyncRoundTripSwiftHeapObject(_ v: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripSwiftHeapObject(v: Greeter.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_asyncRoundTripJSObject")
@_cdecl("bjs_asyncRoundTripJSObject")
public func _bjs_asyncRoundTripJSObject(_ v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = JSPromise.async {
        return await asyncRoundTripJSObject(v: JSObject.bridgeJSLiftParameter(v)).jsValue
    }.jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_takeGreeter")
@_cdecl("bjs_takeGreeter")
public func _bjs_takeGreeter(_ g: UnsafeMutableRawPointer, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    takeGreeter(g: Greeter.bridgeJSLiftParameter(g), name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createCalculator")
@_cdecl("bjs_createCalculator")
public func _bjs_createCalculator() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createCalculator()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_useCalculator")
@_cdecl("bjs_useCalculator")
public func _bjs_useCalculator(_ calc: UnsafeMutableRawPointer, _ x: Int32, _ y: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = useCalculator(calc: Calculator.bridgeJSLiftParameter(calc), x: Int.bridgeJSLiftParameter(x), y: Int.bridgeJSLiftParameter(y))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testGreeterToJSValue")
@_cdecl("bjs_testGreeterToJSValue")
public func _bjs_testGreeterToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testGreeterToJSValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testCalculatorToJSValue")
@_cdecl("bjs_testCalculatorToJSValue")
public func _bjs_testCalculatorToJSValue() -> Int32 {
    #if arch(wasm32)
    let ret = testCalculatorToJSValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSwiftClassAsJSValue")
@_cdecl("bjs_testSwiftClassAsJSValue")
public func _bjs_testSwiftClassAsJSValue(_ greeter: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = testSwiftClassAsJSValue(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(_ direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setDirection(_: Direction.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getDirection")
@_cdecl("bjs_getDirection")
public func _bjs_getDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processDirection")
@_cdecl("bjs_processDirection")
public func _bjs_processDirection(_ input: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processDirection(_: Direction.bridgeJSLiftParameter(input))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(_ themeBytes: Int32, _ themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = setTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTheme")
@_cdecl("bjs_getTheme")
public func _bjs_getTheme() -> Void {
    #if arch(wasm32)
    let ret = getTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setHttpStatus")
@_cdecl("bjs_setHttpStatus")
public func _bjs_setHttpStatus(_ status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setHttpStatus(_: HttpStatus.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getHttpStatus")
@_cdecl("bjs_getHttpStatus")
public func _bjs_getHttpStatus() -> Int32 {
    #if arch(wasm32)
    let ret = getHttpStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processTheme")
@_cdecl("bjs_processTheme")
public func _bjs_processTheme(_ themeBytes: Int32, _ themeLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSDirection")
@_cdecl("bjs_setTSDirection")
public func _bjs_setTSDirection(_ direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = setTSDirection(_: TSDirection.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSDirection")
@_cdecl("bjs_getTSDirection")
public func _bjs_getTSDirection() -> Int32 {
    #if arch(wasm32)
    let ret = getTSDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSTheme")
@_cdecl("bjs_setTSTheme")
public func _bjs_setTSTheme(_ themeBytes: Int32, _ themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = setTSTheme(_: TSTheme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getTSTheme")
@_cdecl("bjs_getTSTheme")
public func _bjs_getTSTheme() -> Void {
    #if arch(wasm32)
    let ret = getTSTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createConverter")
@_cdecl("bjs_createConverter")
public func _bjs_createConverter() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createConverter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_useConverter")
@_cdecl("bjs_useConverter")
public func _bjs_useConverter(_ converter: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = useConverter(converter: Utils.Converter.bridgeJSLiftParameter(converter), value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripConverterArray")
@_cdecl("bjs_roundTripConverterArray")
public func _bjs_roundTripConverterArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripConverterArray(_: [Utils.Converter].bridgeJSStackPop())
    ret.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createHTTPServer")
@_cdecl("bjs_createHTTPServer")
public func _bjs_createHTTPServer() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createHTTPServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createUUID")
@_cdecl("bjs_createUUID")
public func _bjs_createUUID(_ valueBytes: Int32, _ valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createUUID(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUUID")
@_cdecl("bjs_roundTripUUID")
public func _bjs_roundTripUUID(_ uuid: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripUUID(_: UUID.bridgeJSLiftParameter(uuid))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripNetworkingAPIMethod")
@_cdecl("bjs_roundtripNetworkingAPIMethod")
public func _bjs_roundtripNetworkingAPIMethod(_ method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripNetworkingAPIMethod(_: Networking.API.Method.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripConfigurationLogLevel")
@_cdecl("bjs_roundtripConfigurationLogLevel")
public func _bjs_roundtripConfigurationLogLevel(_ levelBytes: Int32, _ levelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripConfigurationPort")
@_cdecl("bjs_roundtripConfigurationPort")
public func _bjs_roundtripConfigurationPort(_ port: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripConfigurationPort(_: Configuration.Port.bridgeJSLiftParameter(port))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processConfigurationLogLevel")
@_cdecl("bjs_processConfigurationLogLevel")
public func _bjs_processConfigurationLogLevel(_ levelBytes: Int32, _ levelLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripInternalSupportedMethod")
@_cdecl("bjs_roundtripInternalSupportedMethod")
public func _bjs_roundtripInternalSupportedMethod(_ method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripInternalSupportedMethod(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPIResult")
@_cdecl("bjs_roundtripAPIResult")
public func _bjs_roundtripAPIResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPIResult(result: APIResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultSuccess")
@_cdecl("bjs_makeAPIResultSuccess")
public func _bjs_makeAPIResultSuccess(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFailure")
@_cdecl("bjs_makeAPIResultFailure")
public func _bjs_makeAPIResultFailure(_ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFailure(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultInfo")
@_cdecl("bjs_makeAPIResultInfo")
public func _bjs_makeAPIResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFlag")
@_cdecl("bjs_makeAPIResultFlag")
public func _bjs_makeAPIResultFlag(_ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFlag(_: Bool.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultRate")
@_cdecl("bjs_makeAPIResultRate")
public func _bjs_makeAPIResultRate(_ value: Float32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultRate(_: Float.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultPrecise")
@_cdecl("bjs_makeAPIResultPrecise")
public func _bjs_makeAPIResultPrecise(_ value: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultPrecise(_: Double.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultSuccess")
@_cdecl("bjs_makeComplexResultSuccess")
public func _bjs_makeComplexResultSuccess(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultError")
@_cdecl("bjs_makeComplexResultError")
public func _bjs_makeComplexResultError(_ messageBytes: Int32, _ messageLength: Int32, _ code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultError(_: String.bridgeJSLiftParameter(messageBytes, messageLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultLocation")
@_cdecl("bjs_makeComplexResultLocation")
public func _bjs_makeComplexResultLocation(_ lat: Float64, _ lng: Float64, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultLocation(_: Double.bridgeJSLiftParameter(lat), _: Double.bridgeJSLiftParameter(lng), _: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultStatus")
@_cdecl("bjs_makeComplexResultStatus")
public func _bjs_makeComplexResultStatus(_ active: Int32, _ code: Int32, _ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultCoordinates")
@_cdecl("bjs_makeComplexResultCoordinates")
public func _bjs_makeComplexResultCoordinates(_ x: Float64, _ y: Float64, _ z: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultCoordinates(_: Double.bridgeJSLiftParameter(x), _: Double.bridgeJSLiftParameter(y), _: Double.bridgeJSLiftParameter(z))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultComprehensive")
@_cdecl("bjs_makeComplexResultComprehensive")
public func _bjs_makeComplexResultComprehensive(_ flag1: Int32, _ flag2: Int32, _ count1: Int32, _ count2: Int32, _ value1: Float64, _ value2: Float64, _ text1Bytes: Int32, _ text1Length: Int32, _ text2Bytes: Int32, _ text2Length: Int32, _ text3Bytes: Int32, _ text3Length: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultComprehensive(_: Bool.bridgeJSLiftParameter(flag1), _: Bool.bridgeJSLiftParameter(flag2), _: Int.bridgeJSLiftParameter(count1), _: Int.bridgeJSLiftParameter(count2), _: Double.bridgeJSLiftParameter(value1), _: Double.bridgeJSLiftParameter(value2), _: String.bridgeJSLiftParameter(text1Bytes, text1Length), _: String.bridgeJSLiftParameter(text2Bytes, text2Length), _: String.bridgeJSLiftParameter(text3Bytes, text3Length))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultInfo")
@_cdecl("bjs_makeComplexResultInfo")
public func _bjs_makeComplexResultInfo() -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultInfo()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultSuccess")
@_cdecl("bjs_makeUtilitiesResultSuccess")
public func _bjs_makeUtilitiesResultSuccess(_ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultFailure")
@_cdecl("bjs_makeUtilitiesResultFailure")
public func _bjs_makeUtilitiesResultFailure(_ errorBytes: Int32, _ errorLength: Int32, _ code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultStatus")
@_cdecl("bjs_makeUtilitiesResultStatus")
public func _bjs_makeUtilitiesResultStatus(_ active: Int32, _ code: Int32, _ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultSuccess")
@_cdecl("bjs_makeAPINetworkingResultSuccess")
public func _bjs_makeAPINetworkingResultSuccess(_ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultFailure")
@_cdecl("bjs_makeAPINetworkingResultFailure")
public func _bjs_makeAPINetworkingResultFailure(_ errorBytes: Int32, _ errorLength: Int32, _ code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripUtilitiesResult")
@_cdecl("bjs_roundtripUtilitiesResult")
public func _bjs_roundtripUtilitiesResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripUtilitiesResult(_: Utilities.Result.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPINetworkingResult")
@_cdecl("bjs_roundtripAPINetworkingResult")
public func _bjs_roundtripAPINetworkingResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPINetworkingResult(_: API.NetworkingResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripAllTypesResult")
@_cdecl("bjs_roundTripAllTypesResult")
public func _bjs_roundTripAllTypesResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripAllTypesResult(_: AllTypesResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripTypedPayloadResult")
@_cdecl("bjs_roundTripTypedPayloadResult")
public func _bjs_roundTripTypedPayloadResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripTypedPayloadResult(_: TypedPayloadResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createPropertyHolder")
@_cdecl("bjs_createPropertyHolder")
public func _bjs_createPropertyHolder(_ intValue: Int32, _ floatValue: Float32, _ doubleValue: Float64, _ boolValue: Int32, _ stringValueBytes: Int32, _ stringValueLength: Int32, _ jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createPropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testPropertyHolder")
@_cdecl("bjs_testPropertyHolder")
public func _bjs_testPropertyHolder(_ holder: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testPropertyHolder(holder: PropertyHolder.bridgeJSLiftParameter(holder))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_resetObserverCounts")
@_cdecl("bjs_resetObserverCounts")
public func _bjs_resetObserverCounts() -> Void {
    #if arch(wasm32)
    resetObserverCounts()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getObserverStats")
@_cdecl("bjs_getObserverStats")
public func _bjs_getObserverStats() -> Void {
    #if arch(wasm32)
    let ret = getObserverStats()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_formatName")
@_cdecl("bjs_formatName")
public func _bjs_formatName(_ nameBytes: Int32, _ nameLength: Int32, _ transform: Int32) -> Void {
    #if arch(wasm32)
    let ret = formatName(_: String.bridgeJSLiftParameter(nameBytes, nameLength), transform: _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeFormatter")
@_cdecl("bjs_makeFormatter")
public func _bjs_makeFormatter(_ prefixBytes: Int32, _ prefixLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = makeFormatter(prefix: String.bridgeJSLiftParameter(prefixBytes, prefixLength))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAdder")
@_cdecl("bjs_makeAdder")
public func _bjs_makeAdder(_ base: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = makeAdder(base: Int.bridgeJSLiftParameter(base))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripPointerFields")
@_cdecl("bjs_roundTripPointerFields")
public func _bjs_roundTripPointerFields() -> Void {
    #if arch(wasm32)
    let ret = roundTripPointerFields(_: PointerFields.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testStructDefault")
@_cdecl("bjs_testStructDefault")
public func _bjs_testStructDefault() -> Void {
    #if arch(wasm32)
    let ret = testStructDefault(point: DataPoint.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_cartToJSObject")
@_cdecl("bjs_cartToJSObject")
public func _bjs_cartToJSObject() -> Int32 {
    #if arch(wasm32)
    let ret = cartToJSObject(_: CopyableCart.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_nestedCartToJSObject")
@_cdecl("bjs_nestedCartToJSObject")
public func _bjs_nestedCartToJSObject() -> Int32 {
    #if arch(wasm32)
    let ret = nestedCartToJSObject(_: CopyableNestedCart.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDataPoint")
@_cdecl("bjs_roundTripDataPoint")
public func _bjs_roundTripDataPoint() -> Void {
    #if arch(wasm32)
    let ret = roundTripDataPoint(_: DataPoint.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripPublicPoint")
@_cdecl("bjs_roundTripPublicPoint")
public func _bjs_roundTripPublicPoint() -> Void {
    #if arch(wasm32)
    let ret = roundTripPublicPoint(_: PublicPoint.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripContact")
@_cdecl("bjs_roundTripContact")
public func _bjs_roundTripContact() -> Void {
    #if arch(wasm32)
    let ret = roundTripContact(_: Contact.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripConfig")
@_cdecl("bjs_roundTripConfig")
public func _bjs_roundTripConfig() -> Void {
    #if arch(wasm32)
    let ret = roundTripConfig(_: Config.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSessionData")
@_cdecl("bjs_roundTripSessionData")
public func _bjs_roundTripSessionData() -> Void {
    #if arch(wasm32)
    let ret = roundTripSessionData(_: SessionData.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripValidationReport")
@_cdecl("bjs_roundTripValidationReport")
public func _bjs_roundTripValidationReport() -> Void {
    #if arch(wasm32)
    let ret = roundTripValidationReport(_: ValidationReport.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripAdvancedConfig")
@_cdecl("bjs_roundTripAdvancedConfig")
public func _bjs_roundTripAdvancedConfig() -> Void {
    #if arch(wasm32)
    let ret = roundTripAdvancedConfig(_: AdvancedConfig.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripMeasurementConfig")
@_cdecl("bjs_roundTripMeasurementConfig")
public func _bjs_roundTripMeasurementConfig() -> Void {
    #if arch(wasm32)
    let ret = roundTripMeasurementConfig(_: MeasurementConfig.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_updateValidationReport")
@_cdecl("bjs_updateValidationReport")
public func _bjs_updateValidationReport(_ newResultIsSome: Int32, _ newResultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let _tmp_report = ValidationReport.bridgeJSLiftParameter()
    let _tmp_newResult = Optional<APIResult>.bridgeJSLiftParameter(newResultIsSome, newResultCaseId)
    let ret = updateValidationReport(_: _tmp_newResult, _: _tmp_report)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testContainerWithStruct")
@_cdecl("bjs_testContainerWithStruct")
public func _bjs_testContainerWithStruct() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testContainerWithStruct(_: DataPoint.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObjectContainer")
@_cdecl("bjs_roundTripJSObjectContainer")
public func _bjs_roundTripJSObjectContainer() -> Void {
    #if arch(wasm32)
    let ret = roundTripJSObjectContainer(_: JSObjectContainer.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFooContainer")
@_cdecl("bjs_roundTripFooContainer")
public func _bjs_roundTripFooContainer() -> Void {
    #if arch(wasm32)
    let ret = roundTripFooContainer(_: FooContainer.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripArrayMembers")
@_cdecl("bjs_roundTripArrayMembers")
public func _bjs_roundTripArrayMembers() -> Void {
    #if arch(wasm32)
    let ret = roundTripArrayMembers(_: ArrayMembers.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayMembersSum")
@_cdecl("bjs_arrayMembersSum")
public func _bjs_arrayMembersSum() -> Int32 {
    #if arch(wasm32)
    let _tmp_values = [Int].bridgeJSStackPop()
    let _tmp_value = ArrayMembers.bridgeJSLiftParameter()
    let ret = arrayMembersSum(_: _tmp_value, _: _tmp_values)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayMembersFirst")
@_cdecl("bjs_arrayMembersFirst")
public func _bjs_arrayMembersFirst() -> Void {
    #if arch(wasm32)
    let _tmp_values = [String].bridgeJSStackPop()
    let _tmp_value = ArrayMembers.bridgeJSLiftParameter()
    let ret = arrayMembersFirst(_: _tmp_value, _: _tmp_values)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeIntToInt")
@_cdecl("bjs_ClosureSupportExports_static_makeIntToInt")
public func _bjs_ClosureSupportExports_static_makeIntToInt(_ base: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeIntToInt(_: Int.bridgeJSLiftParameter(base))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeDoubleToDouble")
@_cdecl("bjs_ClosureSupportExports_static_makeDoubleToDouble")
public func _bjs_ClosureSupportExports_static_makeDoubleToDouble(_ base: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeDoubleToDouble(_: Double.bridgeJSLiftParameter(base))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeStringToString")
@_cdecl("bjs_ClosureSupportExports_static_makeStringToString")
public func _bjs_ClosureSupportExports_static_makeStringToString(_ prefixBytes: Int32, _ prefixLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeStringToString(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeJSIntToInt")
@_cdecl("bjs_ClosureSupportExports_static_makeJSIntToInt")
public func _bjs_ClosureSupportExports_static_makeJSIntToInt(_ base: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeJSIntToInt(_: Int.bridgeJSLiftParameter(base))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeJSDoubleToDouble")
@_cdecl("bjs_ClosureSupportExports_static_makeJSDoubleToDouble")
public func _bjs_ClosureSupportExports_static_makeJSDoubleToDouble(_ base: Float64) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeJSDoubleToDouble(_: Double.bridgeJSLiftParameter(base))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_static_makeJSStringToString")
@_cdecl("bjs_ClosureSupportExports_static_makeJSStringToString")
public func _bjs_ClosureSupportExports_static_makeJSStringToString(_ prefixBytes: Int32, _ prefixLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = ClosureSupportExports.makeJSStringToString(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ClosureSupportExports_deinit")
@_cdecl("bjs_ClosureSupportExports_deinit")
public func _bjs_ClosureSupportExports_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ClosureSupportExports>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ClosureSupportExports: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ClosureSupportExports_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportExports_wrap")
fileprivate func _bjs_ClosureSupportExports_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClosureSupportExports_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_ClosureSupportExports_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_ClosureSupportExports_wrap_extern(pointer)
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_init")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_init")
public func _bjs_DefaultArgumentConstructorDefaults_init(_ nameBytes: Int32, _ nameLength: Int32, _ count: Int32, _ enabled: Int32, _ status: Int32, _ tagIsSome: Int32, _ tagBytes: Int32, _ tagLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled), status: Status.bridgeJSLiftParameter(status), tag: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_describe")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_describe")
public func _bjs_DefaultArgumentConstructorDefaults_describe(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_name_get")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_name_get")
public func _bjs_DefaultArgumentConstructorDefaults_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_name_set")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_name_set")
public func _bjs_DefaultArgumentConstructorDefaults_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_count_get")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_count_get")
public func _bjs_DefaultArgumentConstructorDefaults_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_count_set")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_count_set")
public func _bjs_DefaultArgumentConstructorDefaults_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_enabled_get")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_enabled_get")
public func _bjs_DefaultArgumentConstructorDefaults_enabled_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).enabled
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_enabled_set")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_enabled_set")
public func _bjs_DefaultArgumentConstructorDefaults_enabled_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).enabled = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_status_get")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_status_get")
public func _bjs_DefaultArgumentConstructorDefaults_status_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).status
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_status_set")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_status_set")
public func _bjs_DefaultArgumentConstructorDefaults_status_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).status = Status.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_tag_get")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_tag_get")
public func _bjs_DefaultArgumentConstructorDefaults_tag_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).tag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_tag_set")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_tag_set")
public func _bjs_DefaultArgumentConstructorDefaults_tag_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    DefaultArgumentConstructorDefaults.bridgeJSLiftParameter(_self).tag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DefaultArgumentConstructorDefaults_deinit")
@_cdecl("bjs_DefaultArgumentConstructorDefaults_deinit")
public func _bjs_DefaultArgumentConstructorDefaults_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<DefaultArgumentConstructorDefaults>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension DefaultArgumentConstructorDefaults: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DefaultArgumentConstructorDefaults_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DefaultArgumentConstructorDefaults_wrap")
fileprivate func _bjs_DefaultArgumentConstructorDefaults_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_DefaultArgumentConstructorDefaults_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_DefaultArgumentConstructorDefaults_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_DefaultArgumentConstructorDefaults_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_ _self: UnsafeMutableRawPointer, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greetWith")
@_cdecl("bjs_Greeter_greetWith")
public func _bjs_Greeter_greetWith(_ _self: UnsafeMutableRawPointer, _ greeter: UnsafeMutableRawPointer, _ customGreeting: Int32) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greetWith(greeter: Greeter.bridgeJSLiftParameter(greeter), customGreeting: _BJS_Closure_20BridgeJSRuntimeTests7GreeterC_SS.bridgeJSLift(customGreeting))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_makeFormatter")
@_cdecl("bjs_Greeter_makeFormatter")
public func _bjs_Greeter_makeFormatter(_ _self: UnsafeMutableRawPointer, _ suffixBytes: Int32, _ suffixLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).makeFormatter(suffix: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_static_makeCreator")
@_cdecl("bjs_Greeter_static_makeCreator")
public func _bjs_Greeter_static_makeCreator(_ defaultNameBytes: Int32, _ defaultNameLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Greeter.makeCreator(defaultName: String.bridgeJSLiftParameter(defaultNameBytes, defaultNameLength))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_makeCustomGreeter")
@_cdecl("bjs_Greeter_makeCustomGreeter")
public func _bjs_Greeter_makeCustomGreeter(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).makeCustomGreeter()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_prefix_get")
@_cdecl("bjs_Greeter_prefix_get")
public func _bjs_Greeter_prefix_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).prefix
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Greeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Greeter_wrap")
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Greeter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Calculator_square")
@_cdecl("bjs_Calculator_square")
public func _bjs_Calculator_square(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).square(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_add")
@_cdecl("bjs_Calculator_add")
public func _bjs_Calculator_add(_ _self: UnsafeMutableRawPointer, _ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_deinit")
@_cdecl("bjs_Calculator_deinit")
public func _bjs_Calculator_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Calculator>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Calculator: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Calculator_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Calculator_wrap")
fileprivate func _bjs_Calculator_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Calculator_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Calculator_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Calculator_wrap_extern(pointer)
}

@_expose(wasm, "bjs_InternalGreeter_deinit")
@_cdecl("bjs_InternalGreeter_deinit")
public func _bjs_InternalGreeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<InternalGreeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension InternalGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    internal var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_InternalGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_InternalGreeter_wrap")
fileprivate func _bjs_InternalGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_InternalGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_InternalGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_InternalGreeter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_PublicGreeter_deinit")
@_cdecl("bjs_PublicGreeter_deinit")
public func _bjs_PublicGreeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PublicGreeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PublicGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PublicGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PublicGreeter_wrap")
fileprivate func _bjs_PublicGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PublicGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PublicGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PublicGreeter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_PackageGreeter_deinit")
@_cdecl("bjs_PackageGreeter_deinit")
public func _bjs_PackageGreeter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PackageGreeter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PackageGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    package var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PackageGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PackageGreeter_wrap")
fileprivate func _bjs_PackageGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PackageGreeter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PackageGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PackageGreeter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Converter_init")
@_cdecl("bjs_Converter_init")
public func _bjs_Converter_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Utils.Converter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_toString")
@_cdecl("bjs_Converter_toString")
public func _bjs_Converter_toString(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.Converter.bridgeJSLiftParameter(_self).toString(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_precision_get")
@_cdecl("bjs_Converter_precision_get")
public func _bjs_Converter_precision_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Utils.Converter.bridgeJSLiftParameter(_self).precision
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_precision_set")
@_cdecl("bjs_Converter_precision_set")
public func _bjs_Converter_precision_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    Utils.Converter.bridgeJSLiftParameter(_self).precision = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_deinit")
@_cdecl("bjs_Converter_deinit")
public func _bjs_Converter_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Utils.Converter>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Utils.Converter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Converter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Converter_wrap")
fileprivate func _bjs_Converter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Converter_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Converter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Converter_wrap_extern(pointer)
}

@_expose(wasm, "bjs_HTTPServer_init")
@_cdecl("bjs_HTTPServer_init")
public func _bjs_HTTPServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Networking.API.HTTPServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_call")
@_cdecl("bjs_HTTPServer_call")
public func _bjs_HTTPServer_call(_ _self: UnsafeMutableRawPointer, _ method: Int32) -> Void {
    #if arch(wasm32)
    Networking.API.HTTPServer.bridgeJSLiftParameter(_self).call(_: Networking.API.Method.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_deinit")
@_cdecl("bjs_HTTPServer_deinit")
public func _bjs_HTTPServer_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Networking.API.HTTPServer>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Networking.API.HTTPServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_HTTPServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_HTTPServer_wrap")
fileprivate func _bjs_HTTPServer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_HTTPServer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_HTTPServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_HTTPServer_wrap_extern(pointer)
}

@_expose(wasm, "bjs_UUID_init")
@_cdecl("bjs_UUID_init")
public func _bjs_UUID_init(_ valueBytes: Int32, _ valueLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = UUID(value: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UUID_uuidString")
@_cdecl("bjs_UUID_uuidString")
public func _bjs_UUID_uuidString(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = UUID.bridgeJSLiftParameter(_self).uuidString()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_UUID_deinit")
@_cdecl("bjs_UUID_deinit")
public func _bjs_UUID_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<UUID>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension UUID: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_UUID_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_UUID_wrap")
fileprivate func _bjs_UUID_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_UUID_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_UUID_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_UUID_wrap_extern(pointer)
}

@_expose(wasm, "bjs_TestServer_init")
@_cdecl("bjs_TestServer_init")
public func _bjs_TestServer_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Internal.TestServer()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_call")
@_cdecl("bjs_TestServer_call")
public func _bjs_TestServer_call(_ _self: UnsafeMutableRawPointer, _ method: Int32) -> Void {
    #if arch(wasm32)
    Internal.TestServer.bridgeJSLiftParameter(_self).call(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_deinit")
@_cdecl("bjs_TestServer_deinit")
public func _bjs_TestServer_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Internal.TestServer>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Internal.TestServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_TestServer_wrap")
fileprivate func _bjs_TestServer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestServer_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_TestServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_TestServer_wrap_extern(pointer)
}

@_expose(wasm, "bjs_SimplePropertyHolder_init")
@_cdecl("bjs_SimplePropertyHolder_init")
public func _bjs_SimplePropertyHolder_init(_ value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SimplePropertyHolder(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_get")
@_cdecl("bjs_SimplePropertyHolder_value_get")
public func _bjs_SimplePropertyHolder_value_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SimplePropertyHolder.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_set")
@_cdecl("bjs_SimplePropertyHolder_value_set")
public func _bjs_SimplePropertyHolder_value_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    SimplePropertyHolder.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_deinit")
@_cdecl("bjs_SimplePropertyHolder_deinit")
public func _bjs_SimplePropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<SimplePropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension SimplePropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SimplePropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SimplePropertyHolder_wrap")
fileprivate func _bjs_SimplePropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_SimplePropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_SimplePropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_SimplePropertyHolder_wrap_extern(pointer)
}

@_expose(wasm, "bjs_PropertyHolder_init")
@_cdecl("bjs_PropertyHolder_init")
public func _bjs_PropertyHolder_init(_ intValue: Int32, _ floatValue: Float32, _ doubleValue: Float64, _ boolValue: Int32, _ stringValueBytes: Int32, _ stringValueLength: Int32, _ jsObject: Int32, _ sibling: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject), sibling: SimplePropertyHolder.bridgeJSLiftParameter(sibling))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_getAllValues")
@_cdecl("bjs_PropertyHolder_getAllValues")
public func _bjs_PropertyHolder_getAllValues(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).getAllValues()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_get")
@_cdecl("bjs_PropertyHolder_intValue_get")
public func _bjs_PropertyHolder_intValue_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).intValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_set")
@_cdecl("bjs_PropertyHolder_intValue_set")
public func _bjs_PropertyHolder_intValue_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).intValue = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_get")
@_cdecl("bjs_PropertyHolder_floatValue_get")
public func _bjs_PropertyHolder_floatValue_get(_ _self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).floatValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_set")
@_cdecl("bjs_PropertyHolder_floatValue_set")
public func _bjs_PropertyHolder_floatValue_set(_ _self: UnsafeMutableRawPointer, _ value: Float32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).floatValue = Float.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_get")
@_cdecl("bjs_PropertyHolder_doubleValue_get")
public func _bjs_PropertyHolder_doubleValue_get(_ _self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).doubleValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_set")
@_cdecl("bjs_PropertyHolder_doubleValue_set")
public func _bjs_PropertyHolder_doubleValue_set(_ _self: UnsafeMutableRawPointer, _ value: Float64) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).doubleValue = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_get")
@_cdecl("bjs_PropertyHolder_boolValue_get")
public func _bjs_PropertyHolder_boolValue_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).boolValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_set")
@_cdecl("bjs_PropertyHolder_boolValue_set")
public func _bjs_PropertyHolder_boolValue_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).boolValue = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_get")
@_cdecl("bjs_PropertyHolder_stringValue_get")
public func _bjs_PropertyHolder_stringValue_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).stringValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_set")
@_cdecl("bjs_PropertyHolder_stringValue_set")
public func _bjs_PropertyHolder_stringValue_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).stringValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyInt_get")
@_cdecl("bjs_PropertyHolder_readonlyInt_get")
public func _bjs_PropertyHolder_readonlyInt_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyInt
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyFloat_get")
@_cdecl("bjs_PropertyHolder_readonlyFloat_get")
public func _bjs_PropertyHolder_readonlyFloat_get(_ _self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyFloat
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyDouble_get")
@_cdecl("bjs_PropertyHolder_readonlyDouble_get")
public func _bjs_PropertyHolder_readonlyDouble_get(_ _self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyBool_get")
@_cdecl("bjs_PropertyHolder_readonlyBool_get")
public func _bjs_PropertyHolder_readonlyBool_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyString_get")
@_cdecl("bjs_PropertyHolder_readonlyString_get")
public func _bjs_PropertyHolder_readonlyString_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_get")
@_cdecl("bjs_PropertyHolder_jsObject_get")
public func _bjs_PropertyHolder_jsObject_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_set")
@_cdecl("bjs_PropertyHolder_jsObject_set")
public func _bjs_PropertyHolder_jsObject_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).jsObject = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_get")
@_cdecl("bjs_PropertyHolder_sibling_get")
public func _bjs_PropertyHolder_sibling_get(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).sibling
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_set")
@_cdecl("bjs_PropertyHolder_sibling_set")
public func _bjs_PropertyHolder_sibling_set(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).sibling = SimplePropertyHolder.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_get")
@_cdecl("bjs_PropertyHolder_lazyValue_get")
public func _bjs_PropertyHolder_lazyValue_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).lazyValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_set")
@_cdecl("bjs_PropertyHolder_lazyValue_set")
public func _bjs_PropertyHolder_lazyValue_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).lazyValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadonly_get")
@_cdecl("bjs_PropertyHolder_computedReadonly_get")
public func _bjs_PropertyHolder_computedReadonly_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadonly
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_get")
@_cdecl("bjs_PropertyHolder_computedReadWrite_get")
public func _bjs_PropertyHolder_computedReadWrite_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_set")
@_cdecl("bjs_PropertyHolder_computedReadWrite_set")
public func _bjs_PropertyHolder_computedReadWrite_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_get")
@_cdecl("bjs_PropertyHolder_observedProperty_get")
public func _bjs_PropertyHolder_observedProperty_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).observedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_set")
@_cdecl("bjs_PropertyHolder_observedProperty_set")
public func _bjs_PropertyHolder_observedProperty_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).observedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_deinit")
@_cdecl("bjs_PropertyHolder_deinit")
public func _bjs_PropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<PropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension PropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PropertyHolder_wrap")
fileprivate func _bjs_PropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_PropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_PropertyHolder_wrap_extern(pointer)
}

@_expose(wasm, "bjs_MathUtils_static_add")
@_cdecl("bjs_MathUtils_static_add")
public func _bjs_MathUtils_static_add(_ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_static_substract")
@_cdecl("bjs_MathUtils_static_substract")
public func _bjs_MathUtils_static_substract(_ a: Int32, _ b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.substract(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_deinit")
@_cdecl("bjs_MathUtils_deinit")
public func _bjs_MathUtils_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<MathUtils>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension MathUtils: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MathUtils_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_MathUtils_wrap")
fileprivate func _bjs_MathUtils_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_MathUtils_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_MathUtils_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_MathUtils_wrap_extern(pointer)
}

@_expose(wasm, "bjs_StaticPropertyHolder_init")
@_cdecl("bjs_StaticPropertyHolder_init")
public func _bjs_StaticPropertyHolder_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = StaticPropertyHolder()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticConstant_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticConstant_get")
public func _bjs_StaticPropertyHolder_static_staticConstant_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticConstant
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticVariable_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticVariable_get")
public func _bjs_StaticPropertyHolder_static_staticVariable_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticVariable
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticVariable_set")
@_cdecl("bjs_StaticPropertyHolder_static_staticVariable_set")
public func _bjs_StaticPropertyHolder_static_staticVariable_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.staticVariable = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticString_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticString_get")
public func _bjs_StaticPropertyHolder_static_staticString_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticString_set")
@_cdecl("bjs_StaticPropertyHolder_static_staticString_set")
public func _bjs_StaticPropertyHolder_static_staticString_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.staticString = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticBool_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticBool_get")
public func _bjs_StaticPropertyHolder_static_staticBool_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticBool_set")
@_cdecl("bjs_StaticPropertyHolder_static_staticBool_set")
public func _bjs_StaticPropertyHolder_static_staticBool_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.staticBool = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticFloat_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticFloat_get")
public func _bjs_StaticPropertyHolder_static_staticFloat_get() -> Float32 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticFloat
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticFloat_set")
@_cdecl("bjs_StaticPropertyHolder_static_staticFloat_set")
public func _bjs_StaticPropertyHolder_static_staticFloat_set(_ value: Float32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.staticFloat = Float.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticDouble_get")
@_cdecl("bjs_StaticPropertyHolder_static_staticDouble_get")
public func _bjs_StaticPropertyHolder_static_staticDouble_get() -> Float64 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.staticDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_staticDouble_set")
@_cdecl("bjs_StaticPropertyHolder_static_staticDouble_set")
public func _bjs_StaticPropertyHolder_static_staticDouble_set(_ value: Float64) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.staticDouble = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_computedProperty_get")
@_cdecl("bjs_StaticPropertyHolder_static_computedProperty_get")
public func _bjs_StaticPropertyHolder_static_computedProperty_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.computedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_computedProperty_set")
@_cdecl("bjs_StaticPropertyHolder_static_computedProperty_set")
public func _bjs_StaticPropertyHolder_static_computedProperty_set(_ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.computedProperty = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_readOnlyComputed_get")
@_cdecl("bjs_StaticPropertyHolder_static_readOnlyComputed_get")
public func _bjs_StaticPropertyHolder_static_readOnlyComputed_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.readOnlyComputed
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_optionalString_get")
@_cdecl("bjs_StaticPropertyHolder_static_optionalString_get")
public func _bjs_StaticPropertyHolder_static_optionalString_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.optionalString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_optionalString_set")
@_cdecl("bjs_StaticPropertyHolder_static_optionalString_set")
public func _bjs_StaticPropertyHolder_static_optionalString_set(_ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.optionalString = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_optionalInt_get")
@_cdecl("bjs_StaticPropertyHolder_static_optionalInt_get")
public func _bjs_StaticPropertyHolder_static_optionalInt_get() -> Void {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.optionalInt
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_optionalInt_set")
@_cdecl("bjs_StaticPropertyHolder_static_optionalInt_set")
public func _bjs_StaticPropertyHolder_static_optionalInt_set(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.optionalInt = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_jsObjectProperty_get")
@_cdecl("bjs_StaticPropertyHolder_static_jsObjectProperty_get")
public func _bjs_StaticPropertyHolder_static_jsObjectProperty_get() -> Int32 {
    #if arch(wasm32)
    let ret = StaticPropertyHolder.jsObjectProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_static_jsObjectProperty_set")
@_cdecl("bjs_StaticPropertyHolder_static_jsObjectProperty_set")
public func _bjs_StaticPropertyHolder_static_jsObjectProperty_set(_ value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.jsObjectProperty = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_deinit")
@_cdecl("bjs_StaticPropertyHolder_deinit")
public func _bjs_StaticPropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<StaticPropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension StaticPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StaticPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticPropertyHolder_wrap")
fileprivate func _bjs_StaticPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_StaticPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_StaticPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_StaticPropertyHolder_wrap_extern(pointer)
}

@_expose(wasm, "bjs_DataProcessorManager_init")
@_cdecl("bjs_DataProcessorManager_init")
public func _bjs_DataProcessorManager_init(_ processor: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DataProcessorManager(processor: AnyDataProcessor.bridgeJSLiftParameter(processor))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_incrementByAmount")
@_cdecl("bjs_DataProcessorManager_incrementByAmount")
public func _bjs_DataProcessorManager_incrementByAmount(_ _self: UnsafeMutableRawPointer, _ amount: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).incrementByAmount(_: Int.bridgeJSLiftParameter(amount))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorLabel")
@_cdecl("bjs_DataProcessorManager_setProcessorLabel")
public func _bjs_DataProcessorManager_setProcessorLabel(_ _self: UnsafeMutableRawPointer, _ prefixBytes: Int32, _ prefixLength: Int32, _ suffixBytes: Int32, _ suffixLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorLabel(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength), _: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_isProcessorEven")
@_cdecl("bjs_DataProcessorManager_isProcessorEven")
public func _bjs_DataProcessorManager_isProcessorEven(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).isProcessorEven()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorLabel")
@_cdecl("bjs_DataProcessorManager_getProcessorLabel")
public func _bjs_DataProcessorManager_getProcessorLabel(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorLabel()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getCurrentValue")
@_cdecl("bjs_DataProcessorManager_getCurrentValue")
public func _bjs_DataProcessorManager_getCurrentValue(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getCurrentValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_incrementBoth")
@_cdecl("bjs_DataProcessorManager_incrementBoth")
public func _bjs_DataProcessorManager_incrementBoth(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).incrementBoth()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getBackupValue")
@_cdecl("bjs_DataProcessorManager_getBackupValue")
public func _bjs_DataProcessorManager_getBackupValue(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getBackupValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_hasBackup")
@_cdecl("bjs_DataProcessorManager_hasBackup")
public func _bjs_DataProcessorManager_hasBackup(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).hasBackup()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorOptionalTag")
@_cdecl("bjs_DataProcessorManager_getProcessorOptionalTag")
public func _bjs_DataProcessorManager_getProcessorOptionalTag(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorOptionalTag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorOptionalTag")
@_cdecl("bjs_DataProcessorManager_setProcessorOptionalTag")
public func _bjs_DataProcessorManager_setProcessorOptionalTag(_ _self: UnsafeMutableRawPointer, _ tagIsSome: Int32, _ tagBytes: Int32, _ tagLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorOptionalTag(_: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorOptionalCount")
@_cdecl("bjs_DataProcessorManager_getProcessorOptionalCount")
public func _bjs_DataProcessorManager_getProcessorOptionalCount(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorOptionalCount()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorOptionalCount")
@_cdecl("bjs_DataProcessorManager_setProcessorOptionalCount")
public func _bjs_DataProcessorManager_setProcessorOptionalCount(_ _self: UnsafeMutableRawPointer, _ countIsSome: Int32, _ countValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorOptionalCount(_: Optional<Int>.bridgeJSLiftParameter(countIsSome, countValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorDirection")
@_cdecl("bjs_DataProcessorManager_getProcessorDirection")
public func _bjs_DataProcessorManager_getProcessorDirection(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorDirection")
@_cdecl("bjs_DataProcessorManager_setProcessorDirection")
public func _bjs_DataProcessorManager_setProcessorDirection(_ _self: UnsafeMutableRawPointer, _ directionIsSome: Int32, _ directionValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorDirection(_: Optional<Direction>.bridgeJSLiftParameter(directionIsSome, directionValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorTheme")
@_cdecl("bjs_DataProcessorManager_getProcessorTheme")
public func _bjs_DataProcessorManager_getProcessorTheme(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorTheme")
@_cdecl("bjs_DataProcessorManager_setProcessorTheme")
public func _bjs_DataProcessorManager_setProcessorTheme(_ _self: UnsafeMutableRawPointer, _ themeIsSome: Int32, _ themeBytes: Int32, _ themeLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorTheme(_: Optional<Theme>.bridgeJSLiftParameter(themeIsSome, themeBytes, themeLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorHttpStatus")
@_cdecl("bjs_DataProcessorManager_getProcessorHttpStatus")
public func _bjs_DataProcessorManager_getProcessorHttpStatus(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorHttpStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorHttpStatus")
@_cdecl("bjs_DataProcessorManager_setProcessorHttpStatus")
public func _bjs_DataProcessorManager_setProcessorHttpStatus(_ _self: UnsafeMutableRawPointer, _ statusIsSome: Int32, _ statusValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorHttpStatus(_: Optional<HttpStatus>.bridgeJSLiftParameter(statusIsSome, statusValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorAPIResult")
@_cdecl("bjs_DataProcessorManager_getProcessorAPIResult")
public func _bjs_DataProcessorManager_getProcessorAPIResult(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorAPIResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorAPIResult")
@_cdecl("bjs_DataProcessorManager_setProcessorAPIResult")
public func _bjs_DataProcessorManager_setProcessorAPIResult(_ _self: UnsafeMutableRawPointer, _ apiResultIsSome: Int32, _ apiResultCaseId: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorAPIResult(_: Optional<APIResult>.bridgeJSLiftParameter(apiResultIsSome, apiResultCaseId))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_processor_get")
@_cdecl("bjs_DataProcessorManager_processor_get")
public func _bjs_DataProcessorManager_processor_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).processor as! AnyDataProcessor
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_processor_set")
@_cdecl("bjs_DataProcessorManager_processor_set")
public func _bjs_DataProcessorManager_processor_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).processor = AnyDataProcessor.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_backupProcessor_get")
@_cdecl("bjs_DataProcessorManager_backupProcessor_get")
public func _bjs_DataProcessorManager_backupProcessor_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = (DataProcessorManager.bridgeJSLiftParameter(_self).backupProcessor).flatMap { $0 as? AnyDataProcessor }
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_backupProcessor_set")
@_cdecl("bjs_DataProcessorManager_backupProcessor_set")
public func _bjs_DataProcessorManager_backupProcessor_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).backupProcessor = Optional<AnyDataProcessor>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_deinit")
@_cdecl("bjs_DataProcessorManager_deinit")
public func _bjs_DataProcessorManager_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<DataProcessorManager>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension DataProcessorManager: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DataProcessorManager_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessorManager_wrap")
fileprivate func _bjs_DataProcessorManager_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_DataProcessorManager_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_DataProcessorManager_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_DataProcessorManager_wrap_extern(pointer)
}

@_expose(wasm, "bjs_SwiftDataProcessor_init")
@_cdecl("bjs_SwiftDataProcessor_init")
public func _bjs_SwiftDataProcessor_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SwiftDataProcessor()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_increment")
@_cdecl("bjs_SwiftDataProcessor_increment")
public func _bjs_SwiftDataProcessor_increment(_ _self: UnsafeMutableRawPointer, _ amount: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).increment(by: Int.bridgeJSLiftParameter(amount))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getValue")
@_cdecl("bjs_SwiftDataProcessor_getValue")
public func _bjs_SwiftDataProcessor_getValue(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_setLabelElements")
@_cdecl("bjs_SwiftDataProcessor_setLabelElements")
public func _bjs_SwiftDataProcessor_setLabelElements(_ _self: UnsafeMutableRawPointer, _ labelPrefixBytes: Int32, _ labelPrefixLength: Int32, _ labelSuffixBytes: Int32, _ labelSuffixLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).setLabelElements(_: String.bridgeJSLiftParameter(labelPrefixBytes, labelPrefixLength), _: String.bridgeJSLiftParameter(labelSuffixBytes, labelSuffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getLabel")
@_cdecl("bjs_SwiftDataProcessor_getLabel")
public func _bjs_SwiftDataProcessor_getLabel(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getLabel()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_isEven")
@_cdecl("bjs_SwiftDataProcessor_isEven")
public func _bjs_SwiftDataProcessor_isEven(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).isEven()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_processGreeter")
@_cdecl("bjs_SwiftDataProcessor_processGreeter")
public func _bjs_SwiftDataProcessor_processGreeter(_ _self: UnsafeMutableRawPointer, _ greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).processGreeter(_: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_createGreeter")
@_cdecl("bjs_SwiftDataProcessor_createGreeter")
public func _bjs_SwiftDataProcessor_createGreeter(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).createGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_processOptionalGreeter")
@_cdecl("bjs_SwiftDataProcessor_processOptionalGreeter")
public func _bjs_SwiftDataProcessor_processOptionalGreeter(_ _self: UnsafeMutableRawPointer, _ greeterIsSome: Int32, _ greeterValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).processOptionalGreeter(_: Optional<Greeter>.bridgeJSLiftParameter(greeterIsSome, greeterValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_createOptionalGreeter")
@_cdecl("bjs_SwiftDataProcessor_createOptionalGreeter")
public func _bjs_SwiftDataProcessor_createOptionalGreeter(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).createOptionalGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_handleAPIResult")
@_cdecl("bjs_SwiftDataProcessor_handleAPIResult")
public func _bjs_SwiftDataProcessor_handleAPIResult(_ _self: UnsafeMutableRawPointer, _ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).handleAPIResult(_: Optional<APIResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getAPIResult")
@_cdecl("bjs_SwiftDataProcessor_getAPIResult")
public func _bjs_SwiftDataProcessor_getAPIResult(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getAPIResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_count_get")
@_cdecl("bjs_SwiftDataProcessor_count_get")
public func _bjs_SwiftDataProcessor_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_count_set")
@_cdecl("bjs_SwiftDataProcessor_count_set")
public func _bjs_SwiftDataProcessor_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_name_get")
@_cdecl("bjs_SwiftDataProcessor_name_get")
public func _bjs_SwiftDataProcessor_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTag_get")
@_cdecl("bjs_SwiftDataProcessor_optionalTag_get")
public func _bjs_SwiftDataProcessor_optionalTag_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTag_set")
@_cdecl("bjs_SwiftDataProcessor_optionalTag_set")
public func _bjs_SwiftDataProcessor_optionalTag_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalCount_get")
@_cdecl("bjs_SwiftDataProcessor_optionalCount_get")
public func _bjs_SwiftDataProcessor_optionalCount_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalCount
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalCount_set")
@_cdecl("bjs_SwiftDataProcessor_optionalCount_set")
public func _bjs_SwiftDataProcessor_optionalCount_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalCount = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_direction_get")
@_cdecl("bjs_SwiftDataProcessor_direction_get")
public func _bjs_SwiftDataProcessor_direction_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).direction
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_direction_set")
@_cdecl("bjs_SwiftDataProcessor_direction_set")
public func _bjs_SwiftDataProcessor_direction_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).direction = Optional<Direction>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTheme_get")
@_cdecl("bjs_SwiftDataProcessor_optionalTheme_get")
public func _bjs_SwiftDataProcessor_optionalTheme_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTheme
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTheme_set")
@_cdecl("bjs_SwiftDataProcessor_optionalTheme_set")
public func _bjs_SwiftDataProcessor_optionalTheme_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTheme = Optional<Theme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_httpStatus_get")
@_cdecl("bjs_SwiftDataProcessor_httpStatus_get")
public func _bjs_SwiftDataProcessor_httpStatus_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).httpStatus
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_httpStatus_set")
@_cdecl("bjs_SwiftDataProcessor_httpStatus_set")
public func _bjs_SwiftDataProcessor_httpStatus_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).httpStatus = Optional<HttpStatus>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_apiResult_get")
@_cdecl("bjs_SwiftDataProcessor_apiResult_get")
public func _bjs_SwiftDataProcessor_apiResult_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).apiResult
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_apiResult_set")
@_cdecl("bjs_SwiftDataProcessor_apiResult_set")
public func _bjs_SwiftDataProcessor_apiResult_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueCaseId: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).apiResult = Optional<APIResult>.bridgeJSLiftParameter(valueIsSome, valueCaseId)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_helper_get")
@_cdecl("bjs_SwiftDataProcessor_helper_get")
public func _bjs_SwiftDataProcessor_helper_get(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).helper
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_helper_set")
@_cdecl("bjs_SwiftDataProcessor_helper_set")
public func _bjs_SwiftDataProcessor_helper_set(_ _self: UnsafeMutableRawPointer, _ value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).helper = Greeter.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalHelper_get")
@_cdecl("bjs_SwiftDataProcessor_optionalHelper_get")
public func _bjs_SwiftDataProcessor_optionalHelper_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalHelper
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalHelper_set")
@_cdecl("bjs_SwiftDataProcessor_optionalHelper_set")
public func _bjs_SwiftDataProcessor_optionalHelper_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalHelper = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_deinit")
@_cdecl("bjs_SwiftDataProcessor_deinit")
public func _bjs_SwiftDataProcessor_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<SwiftDataProcessor>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension SwiftDataProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SwiftDataProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftDataProcessor_wrap")
fileprivate func _bjs_SwiftDataProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_SwiftDataProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_SwiftDataProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_SwiftDataProcessor_wrap_extern(pointer)
}

@_expose(wasm, "bjs_TextProcessor_init")
@_cdecl("bjs_TextProcessor_init")
public func _bjs_TextProcessor_init(_ transform: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor(transform: _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_process")
@_cdecl("bjs_TextProcessor_process")
public func _bjs_TextProcessor_process(_ _self: UnsafeMutableRawPointer, _ textBytes: Int32, _ textLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).process(_: String.bridgeJSLiftParameter(textBytes, textLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processWithCustom")
@_cdecl("bjs_TextProcessor_processWithCustom")
public func _bjs_TextProcessor_processWithCustom(_ _self: UnsafeMutableRawPointer, _ textBytes: Int32, _ textLength: Int32, _ customTransform: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processWithCustom(_: String.bridgeJSLiftParameter(textBytes, textLength), customTransform: _BJS_Closure_20BridgeJSRuntimeTestsSiSSSd_SS.bridgeJSLift(customTransform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_getTransform")
@_cdecl("bjs_TextProcessor_getTransform")
public func _bjs_TextProcessor_getTransform(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).getTransform()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalString")
@_cdecl("bjs_TextProcessor_processOptionalString")
public func _bjs_TextProcessor_processOptionalString(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalString(_: _BJS_Closure_20BridgeJSRuntimeTestsSqSS_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalInt")
@_cdecl("bjs_TextProcessor_processOptionalInt")
public func _bjs_TextProcessor_processOptionalInt(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalInt(_: _BJS_Closure_20BridgeJSRuntimeTestsSqSi_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalGreeter")
@_cdecl("bjs_TextProcessor_processOptionalGreeter")
public func _bjs_TextProcessor_processOptionalGreeter(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalGreeter(_: _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeOptionalStringFormatter")
@_cdecl("bjs_TextProcessor_makeOptionalStringFormatter")
public func _bjs_TextProcessor_makeOptionalStringFormatter(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalStringFormatter()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeOptionalGreeterCreator")
@_cdecl("bjs_TextProcessor_makeOptionalGreeterCreator")
public func _bjs_TextProcessor_makeOptionalGreeterCreator(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalGreeterCreator()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processDirection")
@_cdecl("bjs_TextProcessor_processDirection")
public func _bjs_TextProcessor_processDirection(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processDirection(_: _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processTheme")
@_cdecl("bjs_TextProcessor_processTheme")
public func _bjs_TextProcessor_processTheme(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processTheme(_: _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processHttpStatus")
@_cdecl("bjs_TextProcessor_processHttpStatus")
public func _bjs_TextProcessor_processHttpStatus(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processHttpStatus(_: _BJS_Closure_20BridgeJSRuntimeTests10HttpStatusO_Si.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processAPIResult")
@_cdecl("bjs_TextProcessor_processAPIResult")
public func _bjs_TextProcessor_processAPIResult(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processAPIResult(_: _BJS_Closure_20BridgeJSRuntimeTests9APIResultO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeDirectionChecker")
@_cdecl("bjs_TextProcessor_makeDirectionChecker")
public func _bjs_TextProcessor_makeDirectionChecker(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeDirectionChecker()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeThemeValidator")
@_cdecl("bjs_TextProcessor_makeThemeValidator")
public func _bjs_TextProcessor_makeThemeValidator(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeThemeValidator()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeStatusCodeExtractor")
@_cdecl("bjs_TextProcessor_makeStatusCodeExtractor")
public func _bjs_TextProcessor_makeStatusCodeExtractor(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeStatusCodeExtractor()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeAPIResultHandler")
@_cdecl("bjs_TextProcessor_makeAPIResultHandler")
public func _bjs_TextProcessor_makeAPIResultHandler(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeAPIResultHandler()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalDirection")
@_cdecl("bjs_TextProcessor_processOptionalDirection")
public func _bjs_TextProcessor_processOptionalDirection(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalDirection(_: _BJS_Closure_20BridgeJSRuntimeTestsSq9DirectionO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalTheme")
@_cdecl("bjs_TextProcessor_processOptionalTheme")
public func _bjs_TextProcessor_processOptionalTheme(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalTheme(_: _BJS_Closure_20BridgeJSRuntimeTestsSq5ThemeO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_processOptionalAPIResult")
@_cdecl("bjs_TextProcessor_processOptionalAPIResult")
public func _bjs_TextProcessor_processOptionalAPIResult(_ _self: UnsafeMutableRawPointer, _ callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).processOptionalAPIResult(_: _BJS_Closure_20BridgeJSRuntimeTestsSq9APIResultO_SS.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeOptionalDirectionFormatter")
@_cdecl("bjs_TextProcessor_makeOptionalDirectionFormatter")
public func _bjs_TextProcessor_makeOptionalDirectionFormatter(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalDirectionFormatter()
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_deinit")
@_cdecl("bjs_TextProcessor_deinit")
public func _bjs_TextProcessor_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<TextProcessor>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension TextProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TextProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_TextProcessor_wrap")
fileprivate func _bjs_TextProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TextProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_TextProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_TextProcessor_wrap_extern(pointer)
}

@_expose(wasm, "bjs_OptionalHolder_init")
@_cdecl("bjs_OptionalHolder_init")
public func _bjs_OptionalHolder_init(_ nullableGreeterIsSome: Int32, _ nullableGreeterValue: UnsafeMutableRawPointer, _ undefinedNumberIsSome: Int32, _ undefinedNumberValue: Float64) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalHolder(nullableGreeter: Optional<Greeter>.bridgeJSLiftParameter(nullableGreeterIsSome, nullableGreeterValue), undefinedNumber: JSUndefinedOr<Double>.bridgeJSLiftParameter(undefinedNumberIsSome, undefinedNumberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalHolder_nullableGreeter_get")
@_cdecl("bjs_OptionalHolder_nullableGreeter_get")
public func _bjs_OptionalHolder_nullableGreeter_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalHolder.bridgeJSLiftParameter(_self).nullableGreeter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalHolder_nullableGreeter_set")
@_cdecl("bjs_OptionalHolder_nullableGreeter_set")
public func _bjs_OptionalHolder_nullableGreeter_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    OptionalHolder.bridgeJSLiftParameter(_self).nullableGreeter = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalHolder_undefinedNumber_get")
@_cdecl("bjs_OptionalHolder_undefinedNumber_get")
public func _bjs_OptionalHolder_undefinedNumber_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalHolder.bridgeJSLiftParameter(_self).undefinedNumber
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalHolder_undefinedNumber_set")
@_cdecl("bjs_OptionalHolder_undefinedNumber_set")
public func _bjs_OptionalHolder_undefinedNumber_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    #if arch(wasm32)
    OptionalHolder.bridgeJSLiftParameter(_self).undefinedNumber = JSUndefinedOr<Double>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalHolder_deinit")
@_cdecl("bjs_OptionalHolder_deinit")
public func _bjs_OptionalHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<OptionalHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension OptionalHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalHolder_wrap")
fileprivate func _bjs_OptionalHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_OptionalHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_OptionalHolder_wrap_extern(pointer)
}

@_expose(wasm, "bjs_OptionalPropertyHolder_init")
@_cdecl("bjs_OptionalPropertyHolder_init")
public func _bjs_OptionalPropertyHolder_init(_ optionalNameIsSome: Int32, _ optionalNameBytes: Int32, _ optionalNameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder(optionalName: Optional<String>.bridgeJSLiftParameter(optionalNameIsSome, optionalNameBytes, optionalNameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_get")
public func _bjs_OptionalPropertyHolder_optionalName_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_set")
public func _bjs_OptionalPropertyHolder_optionalName_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_get")
public func _bjs_OptionalPropertyHolder_optionalAge_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_set")
public func _bjs_OptionalPropertyHolder_optionalAge_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_get")
public func _bjs_OptionalPropertyHolder_optionalGreeter_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_set")
public func _bjs_OptionalPropertyHolder_optionalGreeter_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_deinit")
@_cdecl("bjs_OptionalPropertyHolder_deinit")
public func _bjs_OptionalPropertyHolder_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<OptionalPropertyHolder>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension OptionalPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalPropertyHolder_wrap")
fileprivate func _bjs_OptionalPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalPropertyHolder_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_OptionalPropertyHolder_wrap_extern(pointer)
}

@_expose(wasm, "bjs_Container_init")
@_cdecl("bjs_Container_init")
public func _bjs_Container_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let _tmp_config = Optional<Config>.bridgeJSLiftParameter()
    let _tmp_location = DataPoint.bridgeJSLiftParameter()
    let ret = Container(location: _tmp_location, config: _tmp_config)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_location_get")
@_cdecl("bjs_Container_location_get")
public func _bjs_Container_location_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Container.bridgeJSLiftParameter(_self).location
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_location_set")
@_cdecl("bjs_Container_location_set")
public func _bjs_Container_location_set(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Container.bridgeJSLiftParameter(_self).location = DataPoint.bridgeJSLiftParameter()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_config_get")
@_cdecl("bjs_Container_config_get")
public func _bjs_Container_config_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Container.bridgeJSLiftParameter(_self).config
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_config_set")
@_cdecl("bjs_Container_config_set")
public func _bjs_Container_config_set(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Container.bridgeJSLiftParameter(_self).config = Optional<Config>.bridgeJSLiftParameter()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Container_deinit")
@_cdecl("bjs_Container_deinit")
public func _bjs_Container_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Container>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Container: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Container_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Container_wrap")
fileprivate func _bjs_Container_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Container_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Container_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Container_wrap_extern(pointer)
}

@_expose(wasm, "bjs_LeakCheck_init")
@_cdecl("bjs_LeakCheck_init")
public func _bjs_LeakCheck_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = LeakCheck()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_LeakCheck_deinit")
@_cdecl("bjs_LeakCheck_deinit")
public func _bjs_LeakCheck_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<LeakCheck>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension LeakCheck: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_LeakCheck_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_LeakCheck_wrap")
fileprivate func _bjs_LeakCheck_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_LeakCheck_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_LeakCheck_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_LeakCheck_wrap_extern(pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayElementObject_init")
fileprivate func bjs_ArrayElementObject_init_extern(_ id: Int32) -> Int32
#else
fileprivate func bjs_ArrayElementObject_init_extern(_ id: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArrayElementObject_init(_ id: Int32) -> Int32 {
    return bjs_ArrayElementObject_init_extern(id)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayElementObject_id_get")
fileprivate func bjs_ArrayElementObject_id_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_ArrayElementObject_id_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArrayElementObject_id_get(_ self: Int32) -> Int32 {
    return bjs_ArrayElementObject_id_get_extern(self)
}

func _$ArrayElementObject_init(_ id: String) throws(JSException) -> JSObject {
    let idValue = id.bridgeJSLowerParameter()
    let ret = bjs_ArrayElementObject_init(idValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ArrayElementObject_id_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_ArrayElementObject_id_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsIntArrayLength_static")
fileprivate func bjs_ArraySupportImports_jsIntArrayLength_static_extern() -> Int32
#else
fileprivate func bjs_ArraySupportImports_jsIntArrayLength_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsIntArrayLength_static() -> Int32 {
    return bjs_ArraySupportImports_jsIntArrayLength_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripIntArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripIntArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripIntArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripIntArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripIntArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripNumberArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripNumberArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripNumberArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripNumberArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripNumberArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripStringArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripStringArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripStringArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripStringArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripStringArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripBoolArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripBoolArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripBoolArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripBoolArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripBoolArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripJSValueArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripJSValueArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripJSValueArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripJSValueArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripJSValueArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripJSObjectArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripJSObjectArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripJSObjectArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripJSObjectArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripJSObjectArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripJSClassArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripJSClassArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripJSClassArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripJSClassArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripJSClassArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static")
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static() -> Void {
    return bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsSumNumberArray_static")
fileprivate func bjs_ArraySupportImports_jsSumNumberArray_static_extern() -> Float64
#else
fileprivate func bjs_ArraySupportImports_jsSumNumberArray_static_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsSumNumberArray_static() -> Float64 {
    return bjs_ArraySupportImports_jsSumNumberArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_jsCreateNumberArray_static")
fileprivate func bjs_ArraySupportImports_jsCreateNumberArray_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_jsCreateNumberArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_jsCreateNumberArray_static() -> Void {
    return bjs_ArraySupportImports_jsCreateNumberArray_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArraySupportImports_runJsArraySupportTests_static")
fileprivate func bjs_ArraySupportImports_runJsArraySupportTests_static_extern() -> Void
#else
fileprivate func bjs_ArraySupportImports_runJsArraySupportTests_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ArraySupportImports_runJsArraySupportTests_static() -> Void {
    return bjs_ArraySupportImports_runJsArraySupportTests_static_extern()
}

func _$ArraySupportImports_jsIntArrayLength(_ items: [Int]) throws(JSException) -> Int {
    let _ = items.bridgeJSLowerParameter()
    let ret = bjs_ArraySupportImports_jsIntArrayLength_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ArraySupportImports_jsRoundTripIntArray(_ items: [Int]) throws(JSException) -> [Int] {
    let _ = items.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripIntArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripNumberArray(_ values: [Double]) throws(JSException) -> [Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripNumberArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripStringArray(_ values: [String]) throws(JSException) -> [String] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripStringArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripBoolArray(_ values: [Bool]) throws(JSException) -> [Bool] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripBoolArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Bool].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripJSValueArray(_ v: [JSValue]) throws(JSException) -> [JSValue] {
    let _ = v.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripJSValueArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [JSValue].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripJSObjectArray(_ values: [JSObject]) throws(JSException) -> [JSObject] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripJSObjectArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [JSObject].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripJSClassArray(_ values: [ArrayElementObject]) throws(JSException) -> [ArrayElementObject] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripJSClassArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [ArrayElementObject].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalIntArray(_ values: [Optional<Int>]) throws(JSException) -> [Optional<Int>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalIntArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<Int>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalStringArray(_ values: [Optional<String>]) throws(JSException) -> [Optional<String>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalStringArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<String>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalBoolArray(_ values: [Optional<Bool>]) throws(JSException) -> [Optional<Bool>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalBoolArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<Bool>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalJSValueArray(_ values: [Optional<JSValue>]) throws(JSException) -> [Optional<JSValue>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalJSValueArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<JSValue>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalJSObjectArray(_ values: [Optional<JSObject>]) throws(JSException) -> [Optional<JSObject>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalJSObjectArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<JSObject>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsRoundTripOptionalJSClassArray(_ values: [Optional<ArrayElementObject>]) throws(JSException) -> [Optional<ArrayElementObject>] {
    let _ = values.bridgeJSLowerParameter()
    bjs_ArraySupportImports_jsRoundTripOptionalJSClassArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Optional<ArrayElementObject>].bridgeJSLiftReturn()
}

func _$ArraySupportImports_jsSumNumberArray(_ values: [Double]) throws(JSException) -> Double {
    let _ = values.bridgeJSLowerParameter()
    let ret = bjs_ArraySupportImports_jsSumNumberArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$ArraySupportImports_jsCreateNumberArray() throws(JSException) -> [Double] {
    bjs_ArraySupportImports_jsCreateNumberArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

func _$ArraySupportImports_runJsArraySupportTests() throws(JSException) -> Void {
    bjs_ArraySupportImports_runJsArraySupportTests_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyVoid_static")
fileprivate func bjs_ClosureSupportImports_jsApplyVoid_static_extern(_ callback: Int32) -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsApplyVoid_static_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyVoid_static(_ callback: Int32) -> Void {
    return bjs_ClosureSupportImports_jsApplyVoid_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyBool_static")
fileprivate func bjs_ClosureSupportImports_jsApplyBool_static_extern(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyBool_static_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyBool_static(_ callback: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsApplyBool_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyInt_static")
fileprivate func bjs_ClosureSupportImports_jsApplyInt_static_extern(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyInt_static_extern(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyInt_static(_ value: Int32, _ transform: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsApplyInt_static_extern(value, transform)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyDouble_static")
fileprivate func bjs_ClosureSupportImports_jsApplyDouble_static_extern(_ value: Float64, _ transform: Int32) -> Float64
#else
fileprivate func bjs_ClosureSupportImports_jsApplyDouble_static_extern(_ value: Float64, _ transform: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyDouble_static(_ value: Float64, _ transform: Int32) -> Float64 {
    return bjs_ClosureSupportImports_jsApplyDouble_static_extern(value, transform)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyString_static")
fileprivate func bjs_ClosureSupportImports_jsApplyString_static_extern(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyString_static_extern(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyString_static(_ value: Int32, _ transform: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsApplyString_static_extern(value, transform)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyJSObject_static")
fileprivate func bjs_ClosureSupportImports_jsApplyJSObject_static_extern(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyJSObject_static_extern(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsApplyJSObject_static(_ value: Int32, _ transform: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsApplyJSObject_static_extern(value, transform)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeIntToInt_static")
fileprivate func bjs_ClosureSupportImports_jsMakeIntToInt_static_extern(_ base: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeIntToInt_static_extern(_ base: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsMakeIntToInt_static(_ base: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsMakeIntToInt_static_extern(base)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeDoubleToDouble_static")
fileprivate func bjs_ClosureSupportImports_jsMakeDoubleToDouble_static_extern(_ base: Float64) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeDoubleToDouble_static_extern(_ base: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsMakeDoubleToDouble_static(_ base: Float64) -> Int32 {
    return bjs_ClosureSupportImports_jsMakeDoubleToDouble_static_extern(base)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeStringToString_static")
fileprivate func bjs_ClosureSupportImports_jsMakeStringToString_static_extern(_ prefix: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeStringToString_static_extern(_ prefix: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsMakeStringToString_static(_ prefix: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsMakeStringToString_static_extern(prefix)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallTwice_static")
fileprivate func bjs_ClosureSupportImports_jsCallTwice_static_extern(_ value: Int32, _ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallTwice_static_extern(_ value: Int32, _ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsCallTwice_static(_ value: Int32, _ callback: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsCallTwice_static_extern(value, callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallBinary_static")
fileprivate func bjs_ClosureSupportImports_jsCallBinary_static_extern(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallBinary_static_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsCallBinary_static(_ callback: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsCallBinary_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallTriple_static")
fileprivate func bjs_ClosureSupportImports_jsCallTriple_static_extern(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallTriple_static_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsCallTriple_static(_ callback: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsCallTriple_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallAfterRelease_static")
fileprivate func bjs_ClosureSupportImports_jsCallAfterRelease_static_extern(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallAfterRelease_static_extern(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsCallAfterRelease_static(_ callback: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsCallAfterRelease_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsOptionalInvoke_static")
fileprivate func bjs_ClosureSupportImports_jsOptionalInvoke_static_extern(_ callbackIsSome: Int32, _ callbackFuncRef: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsOptionalInvoke_static_extern(_ callbackIsSome: Int32, _ callbackFuncRef: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsOptionalInvoke_static(_ callbackIsSome: Int32, _ callbackFuncRef: Int32) -> Int32 {
    return bjs_ClosureSupportImports_jsOptionalInvoke_static_extern(callbackIsSome, callbackFuncRef)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsStoreClosure_static")
fileprivate func bjs_ClosureSupportImports_jsStoreClosure_static_extern(_ callback: Int32) -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsStoreClosure_static_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsStoreClosure_static(_ callback: Int32) -> Void {
    return bjs_ClosureSupportImports_jsStoreClosure_static_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallStoredClosure_static")
fileprivate func bjs_ClosureSupportImports_jsCallStoredClosure_static_extern() -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsCallStoredClosure_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsCallStoredClosure_static() -> Void {
    return bjs_ClosureSupportImports_jsCallStoredClosure_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsHeapCount_static")
fileprivate func bjs_ClosureSupportImports_jsHeapCount_static_extern() -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsHeapCount_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_jsHeapCount_static() -> Int32 {
    return bjs_ClosureSupportImports_jsHeapCount_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_runJsClosureSupportTests_static")
fileprivate func bjs_ClosureSupportImports_runJsClosureSupportTests_static_extern() -> Void
#else
fileprivate func bjs_ClosureSupportImports_runJsClosureSupportTests_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_ClosureSupportImports_runJsClosureSupportTests_static() -> Void {
    return bjs_ClosureSupportImports_runJsClosureSupportTests_static_extern()
}

func _$ClosureSupportImports_jsApplyVoid(_ callback: JSTypedClosure<() -> Void>) throws(JSException) -> Void {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    bjs_ClosureSupportImports_jsApplyVoid_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ClosureSupportImports_jsApplyBool(_ callback: JSTypedClosure<() -> Bool>) throws(JSException) -> Bool {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsApplyBool_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsApplyInt(_ value: Int, _ transform: JSTypedClosure<(Int) -> Int>) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let transformFuncRef = transform.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsApplyInt_static(valueValue, transformFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsApplyDouble(_ value: Double, _ transform: JSTypedClosure<(Double) -> Double>) throws(JSException) -> Double {
    let valueValue = value.bridgeJSLowerParameter()
    let transformFuncRef = transform.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsApplyDouble_static(valueValue, transformFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsApplyString(_ value: String, _ transform: JSTypedClosure<(String) -> String>) throws(JSException) -> String {
    let valueValue = value.bridgeJSLowerParameter()
    let transformFuncRef = transform.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsApplyString_static(valueValue, transformFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsApplyJSObject(_ value: JSObject, _ transform: JSTypedClosure<(JSObject) -> JSObject>) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let transformFuncRef = transform.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsApplyJSObject_static(valueValue, transformFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsMakeIntToInt(_ base: Int) throws(JSException) -> (Int) -> Int {
    let baseValue = base.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsMakeIntToInt_static(baseValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_20BridgeJSRuntimeTestsSi_Si.bridgeJSLift(ret)
}

func _$ClosureSupportImports_jsMakeDoubleToDouble(_ base: Double) throws(JSException) -> (Double) -> Double {
    let baseValue = base.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsMakeDoubleToDouble_static(baseValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_20BridgeJSRuntimeTestsSd_Sd.bridgeJSLift(ret)
}

func _$ClosureSupportImports_jsMakeStringToString(_ prefix: String) throws(JSException) -> (String) -> String {
    let prefixValue = prefix.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsMakeStringToString_static(prefixValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLift(ret)
}

func _$ClosureSupportImports_jsCallTwice(_ value: Int, _ callback: JSTypedClosure<(Int) -> Void>) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsCallTwice_static(valueValue, callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsCallBinary(_ callback: JSTypedClosure<(Int, Int) -> Int>) throws(JSException) -> Int {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsCallBinary_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsCallTriple(_ callback: JSTypedClosure<(Int, Int, Int) -> Int>) throws(JSException) -> Int {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsCallTriple_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsCallAfterRelease(_ callback: JSTypedClosure<() -> Void>) throws(JSException) -> String {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsCallAfterRelease_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsOptionalInvoke(_ callback: Optional<JSTypedClosure<() -> Bool>>) throws(JSException) -> Bool {
    let (callbackIsSome, callbackFuncRef) = callback.bridgeJSLowerParameter()
    let ret = bjs_ClosureSupportImports_jsOptionalInvoke_static(callbackIsSome, callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_jsStoreClosure(_ callback: JSTypedClosure<() -> Void>) throws(JSException) -> Void {
    let callbackFuncRef = callback.bridgeJSLowerParameter()
    bjs_ClosureSupportImports_jsStoreClosure_static(callbackFuncRef)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ClosureSupportImports_jsCallStoredClosure() throws(JSException) -> Void {
    bjs_ClosureSupportImports_jsCallStoredClosure_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ClosureSupportImports_jsHeapCount() throws(JSException) -> Int {
    let ret = bjs_ClosureSupportImports_jsHeapCount_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

func _$ClosureSupportImports_runJsClosureSupportTests() throws(JSException) -> Void {
    bjs_ClosureSupportImports_runJsClosureSupportTests_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static")
fileprivate func bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static_extern() -> Void
#else
fileprivate func bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static() -> Void {
    return bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static_extern()
}

func _$DefaultArgumentImports_runJsDefaultArgumentTests() throws(JSException) -> Void {
    bjs_DefaultArgumentImports_runJsDefaultArgumentTests_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static")
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static_extern() -> Void
#else
fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static() -> Void {
    return bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static_extern()
}

func _$DictionarySupportImports_jsRoundTripDictionaryInt(_ values: [String: Int]) throws(JSException) -> [String: Int] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryInt_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Int].bridgeJSLiftReturn()
}

func _$DictionarySupportImports_jsRoundTripDictionaryBool(_ values: [String: Bool]) throws(JSException) -> [String: Bool] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryBool_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Bool].bridgeJSLiftReturn()
}

func _$DictionarySupportImports_jsRoundTripDictionaryDouble(_ values: [String: Double]) throws(JSException) -> [String: Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryDouble_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Double].bridgeJSLiftReturn()
}

func _$DictionarySupportImports_jsRoundTripDictionaryJSObject(_ values: [String: JSObject]) throws(JSException) -> [String: JSObject] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryJSObject_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: JSObject].bridgeJSLiftReturn()
}

func _$DictionarySupportImports_jsRoundTripDictionaryJSValue(_ values: [String: JSValue]) throws(JSException) -> [String: JSValue] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryJSValue_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: JSValue].bridgeJSLiftReturn()
}

func _$DictionarySupportImports_jsRoundTripDictionaryDoubleArray(_ values: [String: [Double]]) throws(JSException) -> [String: [Double]] {
    let _ = values.bridgeJSLowerParameter()
    bjs_DictionarySupportImports_jsRoundTripDictionaryDoubleArray_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: [Double]].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Foo_init")
fileprivate func bjs_Foo_init_extern(_ value: Int32) -> Int32
#else
fileprivate func bjs_Foo_init_extern(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Foo_init(_ value: Int32) -> Int32 {
    return bjs_Foo_init_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Foo_value_get")
fileprivate func bjs_Foo_value_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Foo_value_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Foo_value_get(_ self: Int32) -> Int32 {
    return bjs_Foo_value_get_extern(self)
}

func _$Foo_init(_ value: String) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_Foo_init(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Foo_value_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Foo_value_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_globalObject1_get")
fileprivate func bjs_globalObject1_get_extern() -> Void
#else
fileprivate func bjs_globalObject1_get_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_globalObject1_get() -> Void {
    return bjs_globalObject1_get_extern()
}

func _$globalObject1_get() throws(JSException) -> JSValue {
    bjs_globalObject1_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSValue.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripVoid")
fileprivate func bjs_jsRoundTripVoid_extern() -> Void
#else
fileprivate func bjs_jsRoundTripVoid_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripVoid() -> Void {
    return bjs_jsRoundTripVoid_extern()
}

func _$jsRoundTripVoid() throws(JSException) -> Void {
    bjs_jsRoundTripVoid()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumber")
fileprivate func bjs_jsRoundTripNumber_extern(_ v: Float64) -> Float64
#else
fileprivate func bjs_jsRoundTripNumber_extern(_ v: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripNumber(_ v: Float64) -> Float64 {
    return bjs_jsRoundTripNumber_extern(v)
}

func _$jsRoundTripNumber(_ v: Double) throws(JSException) -> Double {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_jsRoundTripNumber(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripBool")
fileprivate func bjs_jsRoundTripBool_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripBool_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripBool(_ v: Int32) -> Int32 {
    return bjs_jsRoundTripBool_extern(v)
}

func _$jsRoundTripBool(_ v: Bool) throws(JSException) -> Bool {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_jsRoundTripBool(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripString")
fileprivate func bjs_jsRoundTripString_extern(_ v: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripString_extern(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripString(_ v: Int32) -> Int32 {
    return bjs_jsRoundTripString_extern(v)
}

func _$jsRoundTripString(_ v: String) throws(JSException) -> String {
    let vValue = v.bridgeJSLowerParameter()
    let ret = bjs_jsRoundTripString(vValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripJSValue")
fileprivate func bjs_jsRoundTripJSValue_extern(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void
#else
fileprivate func bjs_jsRoundTripJSValue_extern(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripJSValue(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void {
    return bjs_jsRoundTripJSValue_extern(vKind, vPayload1, vPayload2)
}

func _$jsRoundTripJSValue(_ v: JSValue) throws(JSException) -> JSValue {
    let (vKind, vPayload1, vPayload2) = v.bridgeJSLowerParameter()
    bjs_jsRoundTripJSValue(vKind, vPayload1, vPayload2)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSValue.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrVoid")
fileprivate func bjs_jsThrowOrVoid_extern(_ shouldThrow: Int32) -> Void
#else
fileprivate func bjs_jsThrowOrVoid_extern(_ shouldThrow: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsThrowOrVoid(_ shouldThrow: Int32) -> Void {
    return bjs_jsThrowOrVoid_extern(shouldThrow)
}

func _$jsThrowOrVoid(_ shouldThrow: Bool) throws(JSException) -> Void {
    let shouldThrowValue = shouldThrow.bridgeJSLowerParameter()
    bjs_jsThrowOrVoid(shouldThrowValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrNumber")
fileprivate func bjs_jsThrowOrNumber_extern(_ shouldThrow: Int32) -> Float64
#else
fileprivate func bjs_jsThrowOrNumber_extern(_ shouldThrow: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsThrowOrNumber(_ shouldThrow: Int32) -> Float64 {
    return bjs_jsThrowOrNumber_extern(shouldThrow)
}

func _$jsThrowOrNumber(_ shouldThrow: Bool) throws(JSException) -> Double {
    let shouldThrowValue = shouldThrow.bridgeJSLowerParameter()
    let ret = bjs_jsThrowOrNumber(shouldThrowValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrBool")
fileprivate func bjs_jsThrowOrBool_extern(_ shouldThrow: Int32) -> Int32
#else
fileprivate func bjs_jsThrowOrBool_extern(_ shouldThrow: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsThrowOrBool(_ shouldThrow: Int32) -> Int32 {
    return bjs_jsThrowOrBool_extern(shouldThrow)
}

func _$jsThrowOrBool(_ shouldThrow: Bool) throws(JSException) -> Bool {
    let shouldThrowValue = shouldThrow.bridgeJSLowerParameter()
    let ret = bjs_jsThrowOrBool(shouldThrowValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrString")
fileprivate func bjs_jsThrowOrString_extern(_ shouldThrow: Int32) -> Int32
#else
fileprivate func bjs_jsThrowOrString_extern(_ shouldThrow: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsThrowOrString(_ shouldThrow: Int32) -> Int32 {
    return bjs_jsThrowOrString_extern(shouldThrow)
}

func _$jsThrowOrString(_ shouldThrow: Bool) throws(JSException) -> String {
    let shouldThrowValue = shouldThrow.bridgeJSLowerParameter()
    let ret = bjs_jsThrowOrString(shouldThrowValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripFeatureFlag")
fileprivate func bjs_jsRoundTripFeatureFlag_extern(_ flag: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripFeatureFlag_extern(_ flag: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsRoundTripFeatureFlag(_ flag: Int32) -> Int32 {
    return bjs_jsRoundTripFeatureFlag_extern(flag)
}

func _$jsRoundTripFeatureFlag(_ flag: FeatureFlag) throws(JSException) -> FeatureFlag {
    let flagValue = flag.bridgeJSLowerParameter()
    let ret = bjs_jsRoundTripFeatureFlag(flagValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return FeatureFlag.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_runAsyncWorks")
fileprivate func bjs_runAsyncWorks_extern() -> Int32
#else
fileprivate func bjs_runAsyncWorks_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_runAsyncWorks() -> Int32 {
    return bjs_runAsyncWorks_extern()
}

func _$runAsyncWorks() throws(JSException) -> JSPromise {
    let ret = bjs_runAsyncWorks()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs__jsWeirdFunction")
fileprivate func bjs__jsWeirdFunction_extern() -> Float64
#else
fileprivate func bjs__jsWeirdFunction_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs__jsWeirdFunction() -> Float64 {
    return bjs__jsWeirdFunction_extern()
}

func _$_jsWeirdFunction() throws(JSException) -> Double {
    let ret = bjs__jsWeirdFunction()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_parseInt")
fileprivate func bjs_parseInt_extern(_ string: Int32) -> Float64
#else
fileprivate func bjs_parseInt_extern(_ string: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_parseInt(_ string: Int32) -> Float64 {
    return bjs_parseInt_extern(string)
}

func _$parseInt(_ string: String) throws(JSException) -> Double {
    let stringValue = string.bridgeJSLowerParameter()
    let ret = bjs_parseInt(stringValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_init")
fileprivate func bjs_JsGreeter_init_extern(_ name: Int32, _ prefix: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_init_extern(_ name: Int32, _ prefix: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32 {
    return bjs_JsGreeter_init_extern(name, prefix)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_get")
fileprivate func bjs_JsGreeter_name_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_name_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_name_get(_ self: Int32) -> Int32 {
    return bjs_JsGreeter_name_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_prefix_get")
fileprivate func bjs_JsGreeter_prefix_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_prefix_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32 {
    return bjs_JsGreeter_prefix_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_set")
fileprivate func bjs_JsGreeter_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_JsGreeter_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_JsGreeter_name_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_greet")
fileprivate func bjs_JsGreeter_greet_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_greet_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_greet(_ self: Int32) -> Int32 {
    return bjs_JsGreeter_greet_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_changeName")
fileprivate func bjs_JsGreeter_changeName_extern(_ self: Int32, _ name: Int32) -> Void
#else
fileprivate func bjs_JsGreeter_changeName_extern(_ self: Int32, _ name: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void {
    return bjs_JsGreeter_changeName_extern(self, name)
}

func _$JsGreeter_init(_ name: String, _ prefix: String) throws(JSException) -> JSObject {
    let nameValue = name.bridgeJSLowerParameter()
    let prefixValue = prefix.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_init(nameValue, prefixValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$JsGreeter_name_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_name_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$JsGreeter_prefix_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_prefix_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$JsGreeter_name_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_JsGreeter_name_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$JsGreeter_greet(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_JsGreeter_greet(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$JsGreeter_changeName(_ self: JSObject, _ name: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let nameValue = name.bridgeJSLowerParameter()
    bjs_JsGreeter_changeName(selfValue, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs__WeirdClass_init")
fileprivate func bjs__WeirdClass_init_extern() -> Int32
#else
fileprivate func bjs__WeirdClass_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs__WeirdClass_init() -> Int32 {
    return bjs__WeirdClass_init_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs__WeirdClass_method_with_dashes")
fileprivate func bjs__WeirdClass_method_with_dashes_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs__WeirdClass_method_with_dashes_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs__WeirdClass_method_with_dashes(_ self: Int32) -> Int32 {
    return bjs__WeirdClass_method_with_dashes_extern(self)
}

func _$_WeirdClass_init() throws(JSException) -> JSObject {
    let ret = bjs__WeirdClass_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$_WeirdClass_method_with_dashes(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs__WeirdClass_method_with_dashes(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_init")
fileprivate func bjs_StaticBox_init_extern(_ value: Float64) -> Int32
#else
fileprivate func bjs_StaticBox_init_extern(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_init(_ value: Float64) -> Int32 {
    return bjs_StaticBox_init_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_create_static")
fileprivate func bjs_StaticBox_create_static_extern(_ value: Float64) -> Int32
#else
fileprivate func bjs_StaticBox_create_static_extern(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_create_static(_ value: Float64) -> Int32 {
    return bjs_StaticBox_create_static_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_value_static")
fileprivate func bjs_StaticBox_value_static_extern() -> Float64
#else
fileprivate func bjs_StaticBox_value_static_extern() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_value_static() -> Float64 {
    return bjs_StaticBox_value_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_makeDefault_static")
fileprivate func bjs_StaticBox_makeDefault_static_extern() -> Int32
#else
fileprivate func bjs_StaticBox_makeDefault_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_makeDefault_static() -> Int32 {
    return bjs_StaticBox_makeDefault_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_with_dashes_static")
fileprivate func bjs_StaticBox_with_dashes_static_extern() -> Int32
#else
fileprivate func bjs_StaticBox_with_dashes_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_with_dashes_static() -> Int32 {
    return bjs_StaticBox_with_dashes_static_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_value")
fileprivate func bjs_StaticBox_value_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_StaticBox_value_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_StaticBox_value(_ self: Int32) -> Float64 {
    return bjs_StaticBox_value_extern(self)
}

func _$StaticBox_init(_ value: Double) throws(JSException) -> JSObject {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_StaticBox_init(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$StaticBox_create(_ value: Double) throws(JSException) -> StaticBox {
    let valueValue = value.bridgeJSLowerParameter()
    let ret = bjs_StaticBox_create_static(valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_value() throws(JSException) -> Double {
    let ret = bjs_StaticBox_value_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$StaticBox_makeDefault() throws(JSException) -> StaticBox {
    let ret = bjs_StaticBox_makeDefault_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_with_dashes() throws(JSException) -> StaticBox {
    let ret = bjs_StaticBox_with_dashes_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return StaticBox.bridgeJSLiftReturn(ret)
}

func _$StaticBox_value(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_StaticBox_value(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_init")
fileprivate func bjs_Animal_init_extern(_ name: Int32, _ age: Float64, _ isCat: Int32) -> Int32
#else
fileprivate func bjs_Animal_init_extern(_ name: Int32, _ age: Float64, _ isCat: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_init(_ name: Int32, _ age: Float64, _ isCat: Int32) -> Int32 {
    return bjs_Animal_init_extern(name, age, isCat)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_name_get")
fileprivate func bjs_Animal_name_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_name_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_name_get(_ self: Int32) -> Int32 {
    return bjs_Animal_name_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_age_get")
fileprivate func bjs_Animal_age_get_extern(_ self: Int32) -> Float64
#else
fileprivate func bjs_Animal_age_get_extern(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_age_get(_ self: Int32) -> Float64 {
    return bjs_Animal_age_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_isCat_get")
fileprivate func bjs_Animal_isCat_get_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_isCat_get_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_isCat_get(_ self: Int32) -> Int32 {
    return bjs_Animal_isCat_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_name_set")
fileprivate func bjs_Animal_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Animal_name_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_Animal_name_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_age_set")
fileprivate func bjs_Animal_age_set_extern(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_Animal_age_set_extern(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_age_set(_ self: Int32, _ newValue: Float64) -> Void {
    return bjs_Animal_age_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_isCat_set")
fileprivate func bjs_Animal_isCat_set_extern(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Animal_isCat_set_extern(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_isCat_set(_ self: Int32, _ newValue: Int32) -> Void {
    return bjs_Animal_isCat_set_extern(self, newValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_bark")
fileprivate func bjs_Animal_bark_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_bark_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_bark(_ self: Int32) -> Int32 {
    return bjs_Animal_bark_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_getIsCat")
fileprivate func bjs_Animal_getIsCat_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_getIsCat_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_Animal_getIsCat(_ self: Int32) -> Int32 {
    return bjs_Animal_getIsCat_extern(self)
}

func _$Animal_init(_ name: String, _ age: Double, _ isCat: Bool) throws(JSException) -> JSObject {
    let nameValue = name.bridgeJSLowerParameter()
    let ageValue = age.bridgeJSLowerParameter()
    let isCatValue = isCat.bridgeJSLowerParameter()
    let ret = bjs_Animal_init(nameValue, ageValue, isCatValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$Animal_name_get(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Animal_name_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$Animal_age_get(_ self: JSObject) throws(JSException) -> Double {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Animal_age_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

func _$Animal_isCat_get(_ self: JSObject) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Animal_isCat_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

func _$Animal_name_set(_ self: JSObject, _ newValue: String) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_Animal_name_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$Animal_age_set(_ self: JSObject, _ newValue: Double) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_Animal_age_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$Animal_isCat_set(_ self: JSObject, _ newValue: Bool) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let newValueValue = newValue.bridgeJSLowerParameter()
    bjs_Animal_isCat_set(selfValue, newValueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$Animal_bark(_ self: JSObject) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Animal_bark(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

func _$Animal_getIsCat(_ self: JSObject) throws(JSException) -> Bool {
    let selfValue = self.bridgeJSLowerParameter()
    let ret = bjs_Animal_getIsCat(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Bool.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsTranslatePoint")
fileprivate func bjs_jsTranslatePoint_extern(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32
#else
fileprivate func bjs_jsTranslatePoint_extern(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsTranslatePoint(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32 {
    return bjs_jsTranslatePoint_extern(point, dx, dy)
}

func _$jsTranslatePoint(_ point: Point, _ dx: Int, _ dy: Int) throws(JSException) -> Point {
    let pointObjectId = point.bridgeJSLowerParameter()
    let dxValue = dx.bridgeJSLowerParameter()
    let dyValue = dy.bridgeJSLowerParameter()
    let ret = bjs_jsTranslatePoint(pointObjectId, dxValue, dyValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Point.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_init")
fileprivate func bjs_JSClassWithArrayMembers_init_extern() -> Int32
#else
fileprivate func bjs_JSClassWithArrayMembers_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_init() -> Int32 {
    return bjs_JSClassWithArrayMembers_init_extern()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_numbers_get")
fileprivate func bjs_JSClassWithArrayMembers_numbers_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_numbers_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_numbers_get(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_numbers_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_labels_get")
fileprivate func bjs_JSClassWithArrayMembers_labels_get_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_labels_get_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_labels_get(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_labels_get_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_numbers_set")
fileprivate func bjs_JSClassWithArrayMembers_numbers_set_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_numbers_set_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_numbers_set(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_numbers_set_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_labels_set")
fileprivate func bjs_JSClassWithArrayMembers_labels_set_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_labels_set_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_labels_set(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_labels_set_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_concatNumbers")
fileprivate func bjs_JSClassWithArrayMembers_concatNumbers_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_concatNumbers_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_concatNumbers(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_concatNumbers_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_concatLabels")
fileprivate func bjs_JSClassWithArrayMembers_concatLabels_extern(_ self: Int32) -> Void
#else
fileprivate func bjs_JSClassWithArrayMembers_concatLabels_extern(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_concatLabels(_ self: Int32) -> Void {
    return bjs_JSClassWithArrayMembers_concatLabels_extern(self)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassWithArrayMembers_firstLabel")
fileprivate func bjs_JSClassWithArrayMembers_firstLabel_extern(_ self: Int32) -> Int32
#else
fileprivate func bjs_JSClassWithArrayMembers_firstLabel_extern(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassWithArrayMembers_firstLabel(_ self: Int32) -> Int32 {
    return bjs_JSClassWithArrayMembers_firstLabel_extern(self)
}

func _$JSClassWithArrayMembers_init(_ numbers: [Int], _ labels: [String]) throws(JSException) -> JSObject {
    let _ = labels.bridgeJSLowerParameter()
    let _ = numbers.bridgeJSLowerParameter()
    let ret = bjs_JSClassWithArrayMembers_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$JSClassWithArrayMembers_numbers_get(_ self: JSObject) throws(JSException) -> [Int] {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_numbers_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

func _$JSClassWithArrayMembers_labels_get(_ self: JSObject) throws(JSException) -> [String] {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_labels_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

func _$JSClassWithArrayMembers_numbers_set(_ self: JSObject, _ newValue: [Int]) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = newValue.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_numbers_set(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$JSClassWithArrayMembers_labels_set(_ self: JSObject, _ newValue: [String]) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = newValue.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_labels_set(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$JSClassWithArrayMembers_concatNumbers(_ self: JSObject, _ values: [Int]) throws(JSException) -> [Int] {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_concatNumbers(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

func _$JSClassWithArrayMembers_concatLabels(_ self: JSObject, _ values: [String]) throws(JSException) -> [String] {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    bjs_JSClassWithArrayMembers_concatLabels(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

func _$JSClassWithArrayMembers_firstLabel(_ self: JSObject, _ values: [String]) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    let ret = bjs_JSClassWithArrayMembers_firstLabel(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static")
fileprivate func bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static_extern() -> Int32
#else
fileprivate func bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static() -> Int32 {
    return bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static_extern()
}

func _$JSClassSupportImports_makeJSClassWithArrayMembers(_ numbers: [Int], _ labels: [String]) throws(JSException) -> JSClassWithArrayMembers {
    let _ = labels.bridgeJSLowerParameter()
    let _ = numbers.bridgeJSLowerParameter()
    let ret = bjs_JSClassSupportImports_makeJSClassWithArrayMembers_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSClassWithArrayMembers.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_MyJSClassInternal_init")
fileprivate func bjs_MyJSClassInternal_init_extern() -> Int32
#else
fileprivate func bjs_MyJSClassInternal_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_MyJSClassInternal_init() -> Int32 {
    return bjs_MyJSClassInternal_init_extern()
}

func _$MyJSClassInternal_init() throws(JSException) -> JSObject {
    let ret = bjs_MyJSClassInternal_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_MyJSClassPublic_init")
fileprivate func bjs_MyJSClassPublic_init_extern() -> Int32
#else
fileprivate func bjs_MyJSClassPublic_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_MyJSClassPublic_init() -> Int32 {
    return bjs_MyJSClassPublic_init_extern()
}

func _$MyJSClassPublic_init() throws(JSException) -> JSObject {
    let ret = bjs_MyJSClassPublic_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_MyJSClassPackage_init")
fileprivate func bjs_MyJSClassPackage_init_extern() -> Int32
#else
fileprivate func bjs_MyJSClassPackage_init_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_MyJSClassPackage_init() -> Int32 {
    return bjs_MyJSClassPackage_init_extern()
}

func _$MyJSClassPackage_init() throws(JSException) -> JSObject {
    let ret = bjs_MyJSClassPackage_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsFunctionWithPackageAccess")
fileprivate func bjs_jsFunctionWithPackageAccess_extern() -> Void
#else
fileprivate func bjs_jsFunctionWithPackageAccess_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsFunctionWithPackageAccess() -> Void {
    return bjs_jsFunctionWithPackageAccess_extern()
}

func _$jsFunctionWithPackageAccess() throws(JSException) -> Void {
    bjs_jsFunctionWithPackageAccess()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsFunctionWithPublicAccess")
fileprivate func bjs_jsFunctionWithPublicAccess_extern() -> Void
#else
fileprivate func bjs_jsFunctionWithPublicAccess_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsFunctionWithPublicAccess() -> Void {
    return bjs_jsFunctionWithPublicAccess_extern()
}

func _$jsFunctionWithPublicAccess() throws(JSException) -> Void {
    bjs_jsFunctionWithPublicAccess()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsFunctionWithInternalAccess")
fileprivate func bjs_jsFunctionWithInternalAccess_extern() -> Void
#else
fileprivate func bjs_jsFunctionWithInternalAccess_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsFunctionWithInternalAccess() -> Void {
    return bjs_jsFunctionWithInternalAccess_extern()
}

func _$jsFunctionWithInternalAccess() throws(JSException) -> Void {
    bjs_jsFunctionWithInternalAccess()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsFunctionWithFilePrivateAccess")
fileprivate func bjs_jsFunctionWithFilePrivateAccess_extern() -> Void
#else
fileprivate func bjs_jsFunctionWithFilePrivateAccess_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsFunctionWithFilePrivateAccess() -> Void {
    return bjs_jsFunctionWithFilePrivateAccess_extern()
}

func _$jsFunctionWithFilePrivateAccess() throws(JSException) -> Void {
    bjs_jsFunctionWithFilePrivateAccess()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsFunctionWithPrivateAccess")
fileprivate func bjs_jsFunctionWithPrivateAccess_extern() -> Void
#else
fileprivate func bjs_jsFunctionWithPrivateAccess_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_jsFunctionWithPrivateAccess() -> Void {
    return bjs_jsFunctionWithPrivateAccess_extern()
}

func _$jsFunctionWithPrivateAccess() throws(JSException) -> Void {
    bjs_jsFunctionWithPrivateAccess()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static_extern(_ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static_extern(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static_extern(valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static_extern(_ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static_extern(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static_extern(valueIsSome, valueValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static_extern(_ nameIsSome: Int32, _ nameValue: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static_extern(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static_extern(nameIsSome, nameValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static_extern(_ nameIsSome: Int32, _ nameValue: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static_extern(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static_extern(nameIsSome, nameValue)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static_extern(_ v: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static_extern(_ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static(_ v: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static_extern(v)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static_extern(_ v: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static_extern(_ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static(_ v: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static_extern(v)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static_extern(_ v: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static_extern(_ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static(_ v: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static_extern(v)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static")
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static_extern(_ v: Int32) -> Void
#else
fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static_extern(_ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static(_ v: Int32) -> Void {
    return bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static_extern(v)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalSupportImports_runJsOptionalSupportTests_static")
fileprivate func bjs_OptionalSupportImports_runJsOptionalSupportTests_static_extern() -> Void
#else
fileprivate func bjs_OptionalSupportImports_runJsOptionalSupportTests_static_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_OptionalSupportImports_runJsOptionalSupportTests_static() -> Void {
    return bjs_OptionalSupportImports_runJsOptionalSupportTests_static_extern()
}

func _$OptionalSupportImports_jsRoundTripOptionalNumberNull(_ value: Optional<Int>) throws(JSException) -> Optional<Int> {
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalNumberNull_static(valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
}

func _$OptionalSupportImports_jsRoundTripOptionalNumberUndefined(_ value: JSUndefinedOr<Int>) throws(JSException) -> JSUndefinedOr<Int> {
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalNumberUndefined_static(valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Int>.bridgeJSLiftReturnFromSideChannel()
}

func _$OptionalSupportImports_jsRoundTripOptionalStringNull(_ name: Optional<String>) throws(JSException) -> Optional<String> {
    let (nameIsSome, nameValue) = name.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalStringNull_static(nameIsSome, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$OptionalSupportImports_jsRoundTripOptionalStringUndefined(_ name: JSUndefinedOr<String>) throws(JSException) -> JSUndefinedOr<String> {
    let (nameIsSome, nameValue) = name.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalStringUndefined_static(nameIsSome, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<String>.bridgeJSLiftReturnFromSideChannel()
}

func _$OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull(_ v: Optional<[JSValue]>) throws(JSException) -> Optional<[JSValue]> {
    let vIsSome = v.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayNull_static(vIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<[JSValue]>.bridgeJSLiftReturn()
}

func _$OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined(_ v: JSUndefinedOr<[JSValue]>) throws(JSException) -> JSUndefinedOr<[JSValue]> {
    let vIsSome = v.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalJSValueArrayUndefined_static(vIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<[JSValue]>.bridgeJSLiftReturn()
}

func _$OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull(_ v: Optional<[String: String]>) throws(JSException) -> Optional<[String: String]> {
    let vIsSome = v.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryNull_static(vIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<[String: String]>.bridgeJSLiftReturn()
}

func _$OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined(_ v: JSUndefinedOr<[String: String]>) throws(JSException) -> JSUndefinedOr<[String: String]> {
    let vIsSome = v.bridgeJSLowerParameter()
    bjs_OptionalSupportImports_jsRoundTripOptionalStringToStringDictionaryUndefined_static(vIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<[String: String]>.bridgeJSLiftReturn()
}

func _$OptionalSupportImports_runJsOptionalSupportTests() throws(JSException) -> Void {
    bjs_OptionalSupportImports_runJsOptionalSupportTests_static()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_gc")
fileprivate func bjs_gc_extern() -> Void
#else
fileprivate func bjs_gc_extern() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_gc() -> Void {
    return bjs_gc_extern()
}

func _$gc() throws(JSException) -> Void {
    bjs_gc()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsRoundTripGreeter_static")
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripGreeter_static_extern(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripGreeter_static_extern(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SwiftClassSupportImports_jsRoundTripGreeter_static(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return bjs_SwiftClassSupportImports_jsRoundTripGreeter_static_extern(greeter)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsRoundTripUUID_static")
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripUUID_static_extern(_ uuid: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripUUID_static_extern(_ uuid: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SwiftClassSupportImports_jsRoundTripUUID_static(_ uuid: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return bjs_SwiftClassSupportImports_jsRoundTripUUID_static_extern(uuid)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static")
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static_extern(_ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static_extern(_ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static(_ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static_extern(greeterIsSome, greeterPointer)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static")
fileprivate func bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static_extern(_ value: UnsafeMutableRawPointer) -> Void
#else
fileprivate func bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static_extern(_ value: UnsafeMutableRawPointer) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static(_ value: UnsafeMutableRawPointer) -> Void {
    return bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static_extern(value)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static")
fileprivate func bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static_extern(_ valueIsSome: Int32, _ valuePointer: UnsafeMutableRawPointer) -> Void
#else
fileprivate func bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static_extern(_ valueIsSome: Int32, _ valuePointer: UnsafeMutableRawPointer) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static(_ valueIsSome: Int32, _ valuePointer: UnsafeMutableRawPointer) -> Void {
    return bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static_extern(valueIsSome, valuePointer)
}

func _$SwiftClassSupportImports_jsRoundTripGreeter(_ greeter: Greeter) throws(JSException) -> Greeter {
    let greeterPointer = greeter.bridgeJSLowerParameter()
    let ret = bjs_SwiftClassSupportImports_jsRoundTripGreeter_static(greeterPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Greeter.bridgeJSLiftReturn(ret)
}

func _$SwiftClassSupportImports_jsRoundTripUUID(_ uuid: UUID) throws(JSException) -> UUID {
    let uuidPointer = uuid.bridgeJSLowerParameter()
    let ret = bjs_SwiftClassSupportImports_jsRoundTripUUID_static(uuidPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return UUID.bridgeJSLiftReturn(ret)
}

func _$SwiftClassSupportImports_jsRoundTripOptionalGreeter(_ greeter: Optional<Greeter>) throws(JSException) -> Optional<Greeter> {
    let (greeterIsSome, greeterPointer) = greeter.bridgeJSLowerParameter()
    let ret = bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static(greeterIsSome, greeterPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Greeter>.bridgeJSLiftReturn(ret)
}

func _$SwiftClassSupportImports_jsConsumeLeakCheck(_ value: LeakCheck) throws(JSException) -> Void {
    let valuePointer = value.bridgeJSLowerParameter()
    bjs_SwiftClassSupportImports_jsConsumeLeakCheck_static(valuePointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$SwiftClassSupportImports_jsConsumeOptionalLeakCheck(_ value: Optional<LeakCheck>) throws(JSException) -> Void {
    let (valueIsSome, valuePointer) = value.bridgeJSLowerParameter()
    bjs_SwiftClassSupportImports_jsConsumeOptionalLeakCheck_static(valueIsSome, valuePointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
}