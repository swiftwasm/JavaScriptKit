// bridge-js: skip
// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests8JSObjectC_8JSObjectC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ callback: Int32, _ param0: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ callback: Int32, _ param0: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Float64) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32, _ param2: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ callback: Int32, _ param0: Int32, _ param1: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ callback: Int32) -> Int32
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ callback: Int32) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ callback: Int32) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y")
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_increment")
fileprivate func _extern_increment(_ jsObject: Int32, _ amount: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getValue")
fileprivate func _extern_getValue(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_setLabelElements")
fileprivate func _extern_setLabelElements(_ jsObject: Int32, _ labelPrefix: Int32, _ labelSuffix: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getLabel")
fileprivate func _extern_getLabel(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_isEven")
fileprivate func _extern_isEven(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processGreeter")
fileprivate func _extern_processGreeter(_ jsObject: Int32, _ greeter: UnsafeMutableRawPointer) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createGreeter")
fileprivate func _extern_createGreeter(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processOptionalGreeter")
fileprivate func _extern_processOptionalGreeter(_ jsObject: Int32, _ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createOptionalGreeter")
fileprivate func _extern_createOptionalGreeter(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_handleAPIResult")
fileprivate func _extern_handleAPIResult(_ jsObject: Int32, _ resultIsSome: Int32, _ resultCaseId: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getAPIResult")
fileprivate func _extern_getAPIResult(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_get")
fileprivate func bjs_DataProcessor_count_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_set")
fileprivate func bjs_DataProcessor_count_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_name_get")
fileprivate func bjs_DataProcessor_name_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_get")
fileprivate func bjs_DataProcessor_optionalTag_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_set")
fileprivate func bjs_DataProcessor_optionalTag_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_get")
fileprivate func bjs_DataProcessor_optionalCount_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_set")
fileprivate func bjs_DataProcessor_optionalCount_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_get")
fileprivate func bjs_DataProcessor_direction_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_set")
fileprivate func bjs_DataProcessor_direction_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_get")
fileprivate func bjs_DataProcessor_optionalTheme_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_set")
fileprivate func bjs_DataProcessor_optionalTheme_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_get")
fileprivate func bjs_DataProcessor_httpStatus_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_set")
fileprivate func bjs_DataProcessor_httpStatus_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_get")
fileprivate func bjs_DataProcessor_apiResult_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_set")
fileprivate func bjs_DataProcessor_apiResult_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueCaseId: Int32) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_get")
fileprivate func bjs_DataProcessor_helper_get(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_set")
fileprivate func bjs_DataProcessor_helper_set(_ jsObject: Int32, _ newValue: UnsafeMutableRawPointer) -> Void

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_get")
fileprivate func bjs_DataProcessor_optionalHelper_get(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_set")
fileprivate func bjs_DataProcessor_optionalHelper_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValuePointer: UnsafeMutableRawPointer) -> Void

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
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(Int.bridgeJSLiftParameter())
        case 2:
            return .flag(Bool.bridgeJSLiftParameter())
        case 3:
            return .rate(Float.bridgeJSLiftParameter())
        case 4:
            return .precise(Double.bridgeJSLiftParameter())
        case 5:
            return .info
        default:
            fatalError("Unknown APIResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(1)
        case .flag(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(2)
        case .rate(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(3)
        case .precise(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(4)
        case .info:
            return Int32(5)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> APIResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> APIResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(0))
        case .failure(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        case .flag(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(2))
        case .rate(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(3))
        case .precise(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(4))
        case .info:
            _swift_js_push_i32(Int32(5))
        }
    }
}

extension ComplexResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .error(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        case 2:
            return .location(Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 3:
            return .status(Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 4:
            return .coordinates(Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter())
        case 5:
            return .comprehensive(Bool.bridgeJSLiftParameter(), Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 6:
            return .info
        default:
            fatalError("Unknown ComplexResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .error(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            return Int32(1)
        case .location(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(2)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(3)
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(4)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            param3.bridgeJSLowerStackReturn()
            param4.bridgeJSLowerStackReturn()
            param5.bridgeJSLowerStackReturn()
            param6.bridgeJSLowerStackReturn()
            param7.bridgeJSLowerStackReturn()
            param8.bridgeJSLowerStackReturn()
            return Int32(5)
        case .info:
            return Int32(6)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> ComplexResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> ComplexResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(0))
        case .error(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        case .location(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(2))
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(3))
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(4))
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            param3.bridgeJSLowerStackReturn()
            param4.bridgeJSLowerStackReturn()
            param5.bridgeJSLowerStackReturn()
            param6.bridgeJSLowerStackReturn()
            param7.bridgeJSLowerStackReturn()
            param8.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(5))
        case .info:
            _swift_js_push_i32(Int32(6))
        }
    }
}

extension Utilities.Result: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> Utilities.Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        case 2:
            return .status(Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        default:
            fatalError("Unknown Utilities.Result case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            return Int32(1)
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(2)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> Utilities.Result {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> Utilities.Result {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(0))
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(2))
        }
    }
}

extension API.NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> API.NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        default:
            fatalError("Unknown API.NetworkingResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            return Int32(1)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> API.NetworkingResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> API.NetworkingResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(0))
        case .failure(let param0, let param1):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        }
    }
}

extension AllTypesResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> AllTypesResult {
        switch caseId {
        case 0:
            return .structPayload(Address.bridgeJSLiftParameter())
        case 1:
            return .classPayload(Greeter.bridgeJSLiftParameter())
        case 2:
            return .jsObjectPayload(JSObject.bridgeJSLiftParameter())
        case 3:
            return .nestedEnum(APIResult.bridgeJSLiftParameter(_swift_js_pop_i32()))
        case 4:
            return .arrayPayload([Int].bridgeJSLiftParameter())
        case 5:
            return .jsClassPayload(Foo(unsafelyWrapping: JSObject.bridgeJSLiftParameter()))
        case 6:
            return .empty
        default:
            fatalError("Unknown AllTypesResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .structPayload(let param0):
            param0.bridgeJSLowerReturn()
            return Int32(0)
        case .classPayload(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(1)
        case .jsObjectPayload(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(2)
        case .nestedEnum(let param0):
            param0.bridgeJSLowerReturn()
            return Int32(3)
        case .arrayPayload(let param0):
            param0.bridgeJSLowerReturn()
            return Int32(4)
        case .jsClassPayload(let param0):
            param0.jsObject.bridgeJSLowerStackReturn()
            return Int32(5)
        case .empty:
            return Int32(6)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> AllTypesResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> AllTypesResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .structPayload(let param0):
            param0.bridgeJSLowerReturn()
            _swift_js_push_i32(Int32(0))
        case .classPayload(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        case .jsObjectPayload(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(2))
        case .nestedEnum(let param0):
            param0.bridgeJSLowerReturn()
            _swift_js_push_i32(Int32(3))
        case .arrayPayload(let param0):
            param0.bridgeJSLowerReturn()
            _swift_js_push_i32(Int32(4))
        case .jsClassPayload(let param0):
            param0.jsObject.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(5))
        case .empty:
            _swift_js_push_i32(Int32(6))
        }
    }
}

extension TypedPayloadResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> TypedPayloadResult {
        switch caseId {
        case 0:
            return .precision(Precision.bridgeJSLiftParameter(_swift_js_pop_f32()))
        case 1:
            return .direction(Direction.bridgeJSLiftParameter(_swift_js_pop_i32()))
        case 2:
            return .optPrecision(Optional<Precision>.bridgeJSLiftParameter())
        case 3:
            return .optDirection(Optional<Direction>.bridgeJSLiftParameter())
        case 4:
            return .empty
        default:
            fatalError("Unknown TypedPayloadResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .precision(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(0)
        case .direction(let param0):
            param0.bridgeJSLowerStackReturn()
            return Int32(1)
        case .optPrecision(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(2)
        case .optDirection(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(3)
        case .empty:
            return Int32(4)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> TypedPayloadResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> TypedPayloadResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .precision(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(0))
        case .direction(let param0):
            param0.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(1))
        case .optPrecision(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(2))
        case .optDirection(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(3))
        case .empty:
            _swift_js_push_i32(Int32(4))
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

extension OptionalAllTypesResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> OptionalAllTypesResult {
        switch caseId {
        case 0:
            return .optStruct(Optional<Address>.bridgeJSLiftParameter())
        case 1:
            return .optClass(Optional<Greeter>.bridgeJSLiftParameter())
        case 2:
            return .optJSObject(Optional<JSObject>.bridgeJSLiftParameter())
        case 3:
            return .optNestedEnum(Optional<APIResult>.bridgeJSLiftParameter())
        case 4:
            return .optArray(Optional<[Int]>.bridgeJSLiftParameter())
        case 5:
            return .optJsClass(Optional<JSObject>.bridgeJSLiftParameter().map { Foo(unsafelyWrapping: $0) })
        case 6:
            return .empty
        default:
            fatalError("Unknown OptionalAllTypesResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .optStruct(let param0):
            param0.bridgeJSLowerReturn()
            return Int32(0)
        case .optClass(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(1)
        case .optJSObject(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(2)
        case .optNestedEnum(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            _swift_js_push_i32(__bjs_unwrapped_param0.bridgeJSLowerParameter())
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(3)
        case .optArray(let param0):
            param0.bridgeJSLowerReturn()
            return Int32(4)
        case .optJsClass(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.jsObject.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(5)
        case .empty:
            return Int32(6)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> OptionalAllTypesResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> OptionalAllTypesResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .optStruct(let param0):
            param0.bridgeJSLowerReturn()
            _swift_js_push_i32(Int32(0))
        case .optClass(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(1))
        case .optJSObject(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(2))
        case .optNestedEnum(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            _swift_js_push_i32(__bjs_unwrapped_param0.bridgeJSLowerParameter())
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(3))
        case .optArray(let param0):
            param0.bridgeJSLowerReturn()
            _swift_js_push_i32(Int32(4))
        case .optJsClass(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.jsObject.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(5))
        case .empty:
            _swift_js_push_i32(Int32(6))
        }
    }
}

extension APIOptionalResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIOptionalResult {
        switch caseId {
        case 0:
            return .success(Optional<String>.bridgeJSLiftParameter())
        case 1:
            return .failure(Optional<Int>.bridgeJSLiftParameter(), Optional<Bool>.bridgeJSLiftParameter())
        case 2:
            return .status(Optional<Bool>.bridgeJSLiftParameter(), Optional<Int>.bridgeJSLiftParameter(), Optional<String>.bridgeJSLiftParameter())
        default:
            fatalError("Unknown APIOptionalResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            return Int32(0)
        case .failure(let param0, let param1):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
            __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            return Int32(1)
        case .status(let param0, let param1, let param2):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
            __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
            __bjs_unwrapped_param2.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param2 ? 1 : 0)
            return Int32(2)
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> APIOptionalResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> APIOptionalResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        switch self {
        case .success(let param0):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            _swift_js_push_i32(Int32(0))
        case .failure(let param0, let param1):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
            __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            _swift_js_push_i32(Int32(1))
        case .status(let param0, let param1, let param2):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
            __bjs_unwrapped_param0.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
            __bjs_unwrapped_param1.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
            __bjs_unwrapped_param2.bridgeJSLowerStackReturn()
            }
            _swift_js_push_i32(__bjs_isSome_param2 ? 1 : 0)
            _swift_js_push_i32(Int32(2))
        }
    }
}

extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Point {
        let y = Int.bridgeJSLiftParameter()
        let x = Int.bridgeJSLiftParameter()
        return Point(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.x.bridgeJSLowerStackReturn()
        self.y.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Point(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Point()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Point")
fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Point(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Point")
fileprivate func _bjs_struct_lift_Point() -> Int32
#else
fileprivate func _bjs_struct_lift_Point() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension PointerFields: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> PointerFields {
        let mutPtr = UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter()
        let ptr = UnsafePointer<UInt8>.bridgeJSLiftParameter()
        let opaque = OpaquePointer.bridgeJSLiftParameter()
        let mutRaw = UnsafeMutableRawPointer.bridgeJSLiftParameter()
        let raw = UnsafeRawPointer.bridgeJSLiftParameter()
        return PointerFields(raw: raw, mutRaw: mutRaw, opaque: opaque, ptr: ptr, mutPtr: mutPtr)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.raw.bridgeJSLowerStackReturn()
        self.mutRaw.bridgeJSLowerStackReturn()
        self.opaque.bridgeJSLowerStackReturn()
        self.ptr.bridgeJSLowerStackReturn()
        self.mutPtr.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_PointerFields(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_PointerFields()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_PointerFields")
fileprivate func _bjs_struct_lower_PointerFields(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_PointerFields(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_PointerFields")
fileprivate func _bjs_struct_lift_PointerFields() -> Int32
#else
fileprivate func _bjs_struct_lift_PointerFields() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> DataPoint {
        let optFlag = Optional<Bool>.bridgeJSLiftParameter()
        let optCount = Optional<Int>.bridgeJSLiftParameter()
        let label = String.bridgeJSLiftParameter()
        let y = Double.bridgeJSLiftParameter()
        let x = Double.bridgeJSLiftParameter()
        return DataPoint(x: x, y: y, label: label, optCount: optCount, optFlag: optFlag)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.x.bridgeJSLowerStackReturn()
        self.y.bridgeJSLowerStackReturn()
        self.label.bridgeJSLowerStackReturn()
        let __bjs_isSome_optCount = self.optCount != nil
        if let __bjs_unwrapped_optCount = self.optCount {
        __bjs_unwrapped_optCount.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optCount ? 1 : 0)
        let __bjs_isSome_optFlag = self.optFlag != nil
        if let __bjs_unwrapped_optFlag = self.optFlag {
        __bjs_unwrapped_optFlag.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optFlag ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_DataPoint(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_DataPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_DataPoint")
fileprivate func _bjs_struct_lower_DataPoint(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_DataPoint(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_DataPoint")
fileprivate func _bjs_struct_lift_DataPoint() -> Int32
#else
fileprivate func _bjs_struct_lift_DataPoint() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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

extension Address: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Address {
        let zipCode = Optional<Int>.bridgeJSLiftParameter()
        let city = String.bridgeJSLiftParameter()
        let street = String.bridgeJSLiftParameter()
        return Address(street: street, city: city, zipCode: zipCode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.street.bridgeJSLowerStackReturn()
        self.city.bridgeJSLowerStackReturn()
        let __bjs_isSome_zipCode = self.zipCode != nil
        if let __bjs_unwrapped_zipCode = self.zipCode {
        __bjs_unwrapped_zipCode.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_zipCode ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Address(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Address()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Address")
fileprivate func _bjs_struct_lower_Address(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Address(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Address")
fileprivate func _bjs_struct_lift_Address() -> Int32
#else
fileprivate func _bjs_struct_lift_Address() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Contact: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Contact {
        let secondaryAddress = Optional<Address>.bridgeJSLiftParameter()
        let email = Optional<String>.bridgeJSLiftParameter()
        let address = Address.bridgeJSLiftParameter()
        let age = Int.bridgeJSLiftParameter()
        let name = String.bridgeJSLiftParameter()
        return Contact(name: name, age: age, address: address, email: email, secondaryAddress: secondaryAddress)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.name.bridgeJSLowerStackReturn()
        self.age.bridgeJSLowerStackReturn()
        self.address.bridgeJSLowerReturn()
        let __bjs_isSome_email = self.email != nil
        if let __bjs_unwrapped_email = self.email {
        __bjs_unwrapped_email.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_email ? 1 : 0)
        self.secondaryAddress.bridgeJSLowerReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Contact(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Contact()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Contact")
fileprivate func _bjs_struct_lower_Contact(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Contact(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Contact")
fileprivate func _bjs_struct_lift_Contact() -> Int32
#else
fileprivate func _bjs_struct_lift_Contact() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension Config: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Config {
        let status = Status.bridgeJSLiftParameter(_swift_js_pop_i32())
        let direction = Optional<Direction>.bridgeJSLiftParameter()
        let theme = Optional<Theme>.bridgeJSLiftParameter()
        let name = String.bridgeJSLiftParameter()
        return Config(name: name, theme: theme, direction: direction, status: status)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.name.bridgeJSLowerStackReturn()
        let __bjs_isSome_theme = self.theme != nil
        if let __bjs_unwrapped_theme = self.theme {
        __bjs_unwrapped_theme.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_theme ? 1 : 0)
        let __bjs_isSome_direction = self.direction != nil
        if let __bjs_unwrapped_direction = self.direction {
        __bjs_unwrapped_direction.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_direction ? 1 : 0)
        self.status.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_Config(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Config()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Config")
fileprivate func _bjs_struct_lower_Config(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_Config(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Config")
fileprivate func _bjs_struct_lift_Config() -> Int32
#else
fileprivate func _bjs_struct_lift_Config() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension SessionData: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> SessionData {
        let owner = Optional<Greeter>.bridgeJSLiftParameter()
        let id = Int.bridgeJSLiftParameter()
        return SessionData(id: id, owner: owner)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.id.bridgeJSLowerStackReturn()
        let __bjs_isSome_owner = self.owner != nil
        if let __bjs_unwrapped_owner = self.owner {
        __bjs_unwrapped_owner.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_owner ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_SessionData(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_SessionData()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_SessionData")
fileprivate func _bjs_struct_lower_SessionData(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_SessionData(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_SessionData")
fileprivate func _bjs_struct_lift_SessionData() -> Int32
#else
fileprivate func _bjs_struct_lift_SessionData() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension ValidationReport: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ValidationReport {
        let outcome = Optional<APIResult>.bridgeJSLiftParameter()
        let status = Optional<Status>.bridgeJSLiftParameter()
        let result = APIResult.bridgeJSLiftParameter(_swift_js_pop_i32())
        let id = Int.bridgeJSLiftParameter()
        return ValidationReport(id: id, result: result, status: status, outcome: outcome)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.id.bridgeJSLowerStackReturn()
        self.result.bridgeJSLowerReturn()
        let __bjs_isSome_status = self.status != nil
        if let __bjs_unwrapped_status = self.status {
        __bjs_unwrapped_status.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_status ? 1 : 0)
        let __bjs_isSome_outcome = self.outcome != nil
        if let __bjs_unwrapped_outcome = self.outcome {
        _swift_js_push_i32(__bjs_unwrapped_outcome.bridgeJSLowerParameter())
        }
        _swift_js_push_i32(__bjs_isSome_outcome ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ValidationReport(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ValidationReport()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ValidationReport")
fileprivate func _bjs_struct_lower_ValidationReport(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_ValidationReport(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ValidationReport")
fileprivate func _bjs_struct_lift_ValidationReport() -> Int32
#else
fileprivate func _bjs_struct_lift_ValidationReport() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension AdvancedConfig: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> AdvancedConfig {
        let overrideDefaults = Optional<ConfigStruct>.bridgeJSLiftParameter()
        let defaults = ConfigStruct.bridgeJSLiftParameter()
        let location = Optional<DataPoint>.bridgeJSLiftParameter()
        let metadata = Optional<JSObject>.bridgeJSLiftParameter()
        let result = Optional<APIResult>.bridgeJSLiftParameter()
        let status = Status.bridgeJSLiftParameter(_swift_js_pop_i32())
        let theme = Theme.bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())
        let enabled = Bool.bridgeJSLiftParameter()
        let title = String.bridgeJSLiftParameter()
        let id = Int.bridgeJSLiftParameter()
        return AdvancedConfig(id: id, title: title, enabled: enabled, theme: theme, status: status, result: result, metadata: metadata, location: location, defaults: defaults, overrideDefaults: overrideDefaults)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.id.bridgeJSLowerStackReturn()
        self.title.bridgeJSLowerStackReturn()
        self.enabled.bridgeJSLowerStackReturn()
        self.theme.bridgeJSLowerStackReturn()
        self.status.bridgeJSLowerStackReturn()
        let __bjs_isSome_result = self.result != nil
        if let __bjs_unwrapped_result = self.result {
        _swift_js_push_i32(__bjs_unwrapped_result.bridgeJSLowerParameter())
        }
        _swift_js_push_i32(__bjs_isSome_result ? 1 : 0)
        let __bjs_isSome_metadata = self.metadata != nil
        if let __bjs_unwrapped_metadata = self.metadata {
        __bjs_unwrapped_metadata.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_metadata ? 1 : 0)
        self.location.bridgeJSLowerReturn()
        self.defaults.bridgeJSLowerReturn()
        self.overrideDefaults.bridgeJSLowerReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_AdvancedConfig(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_AdvancedConfig()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_AdvancedConfig")
fileprivate func _bjs_struct_lower_AdvancedConfig(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_AdvancedConfig(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_AdvancedConfig")
fileprivate func _bjs_struct_lift_AdvancedConfig() -> Int32
#else
fileprivate func _bjs_struct_lift_AdvancedConfig() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension MeasurementConfig: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> MeasurementConfig {
        let optionalRatio = Optional<Ratio>.bridgeJSLiftParameter()
        let optionalPrecision = Optional<Precision>.bridgeJSLiftParameter()
        let ratio = Ratio.bridgeJSLiftParameter(_swift_js_pop_f64())
        let precision = Precision.bridgeJSLiftParameter(_swift_js_pop_f32())
        return MeasurementConfig(precision: precision, ratio: ratio, optionalPrecision: optionalPrecision, optionalRatio: optionalRatio)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.precision.bridgeJSLowerStackReturn()
        self.ratio.bridgeJSLowerStackReturn()
        let __bjs_isSome_optionalPrecision = self.optionalPrecision != nil
        if let __bjs_unwrapped_optionalPrecision = self.optionalPrecision {
        __bjs_unwrapped_optionalPrecision.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optionalPrecision ? 1 : 0)
        let __bjs_isSome_optionalRatio = self.optionalRatio != nil
        if let __bjs_unwrapped_optionalRatio = self.optionalRatio {
        __bjs_unwrapped_optionalRatio.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optionalRatio ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_MeasurementConfig(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_MeasurementConfig()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_MeasurementConfig")
fileprivate func _bjs_struct_lower_MeasurementConfig(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_MeasurementConfig(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_MeasurementConfig")
fileprivate func _bjs_struct_lift_MeasurementConfig() -> Int32
#else
fileprivate func _bjs_struct_lift_MeasurementConfig() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension MathOperations: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> MathOperations {
        let baseValue = Double.bridgeJSLiftParameter()
        return MathOperations(baseValue: baseValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.baseValue.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_MathOperations(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_MathOperations()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_MathOperations")
fileprivate func _bjs_struct_lower_MathOperations(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_MathOperations(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_MathOperations")
fileprivate func _bjs_struct_lift_MathOperations() -> Int32
#else
fileprivate func _bjs_struct_lift_MathOperations() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> CopyableCart {
        let note = Optional<String>.bridgeJSLiftParameter()
        let x = Int.bridgeJSLiftParameter()
        return CopyableCart(x: x, note: note)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.x.bridgeJSLowerStackReturn()
        let __bjs_isSome_note = self.note != nil
        if let __bjs_unwrapped_note = self.note {
        __bjs_unwrapped_note.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_note ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_CopyableCart(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableCart()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableCart")
fileprivate func _bjs_struct_lower_CopyableCart(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_CopyableCart(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableCart")
fileprivate func _bjs_struct_lift_CopyableCart() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableCart() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> CopyableCartItem {
        let quantity = Int.bridgeJSLiftParameter()
        let sku = String.bridgeJSLiftParameter()
        return CopyableCartItem(sku: sku, quantity: quantity)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.sku.bridgeJSLowerStackReturn()
        self.quantity.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_CopyableCartItem(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableCartItem()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableCartItem")
fileprivate func _bjs_struct_lower_CopyableCartItem(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_CopyableCartItem(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableCartItem")
fileprivate func _bjs_struct_lift_CopyableCartItem() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableCartItem() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension CopyableNestedCart: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> CopyableNestedCart {
        let shippingAddress = Optional<Address>.bridgeJSLiftParameter()
        let item = CopyableCartItem.bridgeJSLiftParameter()
        let id = Int.bridgeJSLiftParameter()
        return CopyableNestedCart(id: id, item: item, shippingAddress: shippingAddress)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.id.bridgeJSLowerStackReturn()
        self.item.bridgeJSLowerReturn()
        self.shippingAddress.bridgeJSLowerReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_CopyableNestedCart(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_CopyableNestedCart()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_CopyableNestedCart")
fileprivate func _bjs_struct_lower_CopyableNestedCart(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_CopyableNestedCart(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_CopyableNestedCart")
fileprivate func _bjs_struct_lift_CopyableNestedCart() -> Int32
#else
fileprivate func _bjs_struct_lift_CopyableNestedCart() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ConfigStruct {
        let value = Int.bridgeJSLiftParameter()
        let name = String.bridgeJSLiftParameter()
        return ConfigStruct(name: name, value: value)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.name.bridgeJSLowerStackReturn()
        self.value.bridgeJSLowerStackReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ConfigStruct(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ConfigStruct()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ConfigStruct")
fileprivate func _bjs_struct_lower_ConfigStruct(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_ConfigStruct(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ConfigStruct")
fileprivate func _bjs_struct_lift_ConfigStruct() -> Int32
#else
fileprivate func _bjs_struct_lift_ConfigStruct() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> JSObjectContainer {
        let optionalObject = Optional<JSObject>.bridgeJSLiftParameter()
        let object = JSObject.bridgeJSLiftParameter()
        return JSObjectContainer(object: object, optionalObject: optionalObject)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.object.bridgeJSLowerStackReturn()
        let __bjs_isSome_optionalObject = self.optionalObject != nil
        if let __bjs_unwrapped_optionalObject = self.optionalObject {
        __bjs_unwrapped_optionalObject.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optionalObject ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_JSObjectContainer(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_JSObjectContainer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_JSObjectContainer")
fileprivate func _bjs_struct_lower_JSObjectContainer(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_JSObjectContainer(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_JSObjectContainer")
fileprivate func _bjs_struct_lift_JSObjectContainer() -> Int32
#else
fileprivate func _bjs_struct_lift_JSObjectContainer() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension FooContainer: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> FooContainer {
        let optionalFoo = Optional<JSObject>.bridgeJSLiftParameter().map { Foo(unsafelyWrapping: $0) }
        let foo = Foo(unsafelyWrapping: JSObject.bridgeJSLiftParameter())
        return FooContainer(foo: foo, optionalFoo: optionalFoo)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.foo.jsObject.bridgeJSLowerStackReturn()
        let __bjs_isSome_optionalFoo = self.optionalFoo != nil
        if let __bjs_unwrapped_optionalFoo = self.optionalFoo {
        __bjs_unwrapped_optionalFoo.jsObject.bridgeJSLowerStackReturn()
        }
        _swift_js_push_i32(__bjs_isSome_optionalFoo ? 1 : 0)
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_FooContainer(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_FooContainer()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_FooContainer")
fileprivate func _bjs_struct_lower_FooContainer(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_FooContainer(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_FooContainer")
fileprivate func _bjs_struct_lift_FooContainer() -> Int32
#else
fileprivate func _bjs_struct_lift_FooContainer() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

extension ArrayMembers: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ArrayMembers {
        let optStrings = Optional<[String]>.bridgeJSLiftParameter()
        let ints = [Int].bridgeJSLiftParameter()
        return ArrayMembers(ints: ints, optStrings: optStrings)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        self.ints.bridgeJSLowerReturn()
        self.optStrings.bridgeJSLowerReturn()
    }

    init(unsafelyCopying jsObject: JSObject) {
        let __bjs_cleanupId = _bjs_struct_lower_ArrayMembers(jsObject.bridgeJSLowerParameter())
        defer {
            _swift_js_struct_cleanup(__bjs_cleanupId)
        }
        self = Self.bridgeJSLiftParameter()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSLowerReturn()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ArrayMembers()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ArrayMembers")
fileprivate func _bjs_struct_lower_ArrayMembers(_ objectId: Int32) -> Int32
#else
fileprivate func _bjs_struct_lower_ArrayMembers(_ objectId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ArrayMembers")
fileprivate func _bjs_struct_lift_ArrayMembers() -> Int32
#else
fileprivate func _bjs_struct_lift_ArrayMembers() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ArrayMembers_sumValues")
@_cdecl("bjs_ArrayMembers_sumValues")
public func _bjs_ArrayMembers_sumValues() -> Int32 {
    #if arch(wasm32)
    let ret = ArrayMembers.bridgeJSLiftParameter().sumValues(_: [Int].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ArrayMembers_firstString")
@_cdecl("bjs_ArrayMembers_firstString")
public func _bjs_ArrayMembers_firstString() -> Void {
    #if arch(wasm32)
    let ret = ArrayMembers.bridgeJSLiftParameter().firstString(_: [String].bridgeJSLiftParameter())
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

@_expose(wasm, "bjs_roundTripJSValueArray")
@_cdecl("bjs_roundTripJSValueArray")
public func _bjs_roundTripJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripJSValueArray(v: [JSValue].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSValueArray")
@_cdecl("bjs_roundTripOptionalJSValueArray")
public func _bjs_roundTripOptionalJSValueArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSValueArray(v: Optional<[JSValue]>.bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
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

@_expose(wasm, "bjs_testStringDefault")
@_cdecl("bjs_testStringDefault")
public func _bjs_testStringDefault(_ messageBytes: Int32, _ messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testStringDefault(message: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testIntDefault")
@_cdecl("bjs_testIntDefault")
public func _bjs_testIntDefault(_ count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testIntDefault(count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testBoolDefault")
@_cdecl("bjs_testBoolDefault")
public func _bjs_testBoolDefault(_ flag: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testBoolDefault(flag: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalDefault")
@_cdecl("bjs_testOptionalDefault")
public func _bjs_testOptionalDefault(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalDefault(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMultipleDefaults")
@_cdecl("bjs_testMultipleDefaults")
public func _bjs_testMultipleDefaults(_ titleBytes: Int32, _ titleLength: Int32, _ count: Int32, _ enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMultipleDefaults(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSimpleEnumDefault")
@_cdecl("bjs_testSimpleEnumDefault")
public func _bjs_testSimpleEnumDefault(_ status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testSimpleEnumDefault(status: Status.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testDirectionDefault")
@_cdecl("bjs_testDirectionDefault")
public func _bjs_testDirectionDefault(_ direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testDirectionDefault(direction: Direction.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testRawStringEnumDefault")
@_cdecl("bjs_testRawStringEnumDefault")
public func _bjs_testRawStringEnumDefault(_ themeBytes: Int32, _ themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testRawStringEnumDefault(theme: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testComplexInit")
@_cdecl("bjs_testComplexInit")
public func _bjs_testComplexInit(_ greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testComplexInit(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEmptyInit")
@_cdecl("bjs_testEmptyInit")
public func _bjs_testEmptyInit(_ object: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testEmptyInit(_: StaticPropertyHolder.bridgeJSLiftParameter(object))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayWithDefault")
@_cdecl("bjs_arrayWithDefault")
public func _bjs_arrayWithDefault() -> Int32 {
    #if arch(wasm32)
    let ret = arrayWithDefault(_: [Int].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayWithOptionalDefault")
@_cdecl("bjs_arrayWithOptionalDefault")
public func _bjs_arrayWithOptionalDefault() -> Int32 {
    #if arch(wasm32)
    let ret = arrayWithOptionalDefault(_: Optional<[Int]>.bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_arrayMixedDefaults")
@_cdecl("bjs_arrayMixedDefaults")
public func _bjs_arrayMixedDefaults(_ prefixBytes: Int32, _ prefixLength: Int32, _ suffixBytes: Int32, _ suffixLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = arrayMixedDefaults(prefix: String.bridgeJSLiftParameter(prefixBytes, prefixLength), values: [Int].bridgeJSLiftParameter(), suffix: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
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

@_expose(wasm, "bjs_roundTripIntArray")
@_cdecl("bjs_roundTripIntArray")
public func _bjs_roundTripIntArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripIntArray(_: [Int].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripStringArray")
@_cdecl("bjs_roundTripStringArray")
public func _bjs_roundTripStringArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripStringArray(_: [String].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDoubleArray")
@_cdecl("bjs_roundTripDoubleArray")
public func _bjs_roundTripDoubleArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripDoubleArray(_: [Double].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBoolArray")
@_cdecl("bjs_roundTripBoolArray")
public func _bjs_roundTripBoolArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripBoolArray(_: [Bool].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDirectionArray")
@_cdecl("bjs_roundTripDirectionArray")
public func _bjs_roundTripDirectionArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripDirectionArray(_: [Direction].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripStatusArray")
@_cdecl("bjs_roundTripStatusArray")
public func _bjs_roundTripStatusArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripStatusArray(_: [Status].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripThemeArray")
@_cdecl("bjs_roundTripThemeArray")
public func _bjs_roundTripThemeArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripThemeArray(_: [Theme].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripHttpStatusArray")
@_cdecl("bjs_roundTripHttpStatusArray")
public func _bjs_roundTripHttpStatusArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripHttpStatusArray(_: [HttpStatus].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDataPointArray")
@_cdecl("bjs_roundTripDataPointArray")
public func _bjs_roundTripDataPointArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripDataPointArray(_: [DataPoint].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripGreeterArray")
@_cdecl("bjs_roundTripGreeterArray")
public func _bjs_roundTripGreeterArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripGreeterArray(_: [Greeter].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalIntArray")
@_cdecl("bjs_roundTripOptionalIntArray")
public func _bjs_roundTripOptionalIntArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalIntArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Int>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<Int>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalStringArray")
@_cdecl("bjs_roundTripOptionalStringArray")
public func _bjs_roundTripOptionalStringArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalStringArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<String>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<String>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalDataPointArray")
@_cdecl("bjs_roundTripOptionalDataPointArray")
public func _bjs_roundTripOptionalDataPointArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDataPointArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<DataPoint>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<DataPoint>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    __bjs_elem_ret.bridgeJSLowerReturn()
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalDirectionArray")
@_cdecl("bjs_roundTripOptionalDirectionArray")
public func _bjs_roundTripOptionalDirectionArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDirectionArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Direction>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<Direction>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalStatusArray")
@_cdecl("bjs_roundTripOptionalStatusArray")
public func _bjs_roundTripOptionalStatusArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalStatusArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Status>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<Status>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalIntArrayType")
@_cdecl("bjs_roundTripOptionalIntArrayType")
public func _bjs_roundTripOptionalIntArrayType() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalIntArrayType(_: Optional<[Int]>.bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalStringArrayType")
@_cdecl("bjs_roundTripOptionalStringArrayType")
public func _bjs_roundTripOptionalStringArrayType() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalStringArrayType(_: Optional<[String]>.bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalGreeterArrayType")
@_cdecl("bjs_roundTripOptionalGreeterArrayType")
public func _bjs_roundTripOptionalGreeterArrayType() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalGreeterArrayType(_: Optional<[Greeter]>.bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedIntArray")
@_cdecl("bjs_roundTripNestedIntArray")
public func _bjs_roundTripNestedIntArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedIntArray(_: [[Int]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedStringArray")
@_cdecl("bjs_roundTripNestedStringArray")
public func _bjs_roundTripNestedStringArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedStringArray(_: [[String]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedDoubleArray")
@_cdecl("bjs_roundTripNestedDoubleArray")
public func _bjs_roundTripNestedDoubleArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedDoubleArray(_: [[Double]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedBoolArray")
@_cdecl("bjs_roundTripNestedBoolArray")
public func _bjs_roundTripNestedBoolArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedBoolArray(_: [[Bool]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedDataPointArray")
@_cdecl("bjs_roundTripNestedDataPointArray")
public func _bjs_roundTripNestedDataPointArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedDataPointArray(_: [[DataPoint]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedDirectionArray")
@_cdecl("bjs_roundTripNestedDirectionArray")
public func _bjs_roundTripNestedDirectionArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedDirectionArray(_: [[Direction]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripNestedGreeterArray")
@_cdecl("bjs_roundTripNestedGreeterArray")
public func _bjs_roundTripNestedGreeterArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripNestedGreeterArray(_: [[Greeter]].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeRawPointerArray")
@_cdecl("bjs_roundTripUnsafeRawPointerArray")
public func _bjs_roundTripUnsafeRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripUnsafeRawPointerArray(_: [UnsafeRawPointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeMutableRawPointerArray")
@_cdecl("bjs_roundTripUnsafeMutableRawPointerArray")
public func _bjs_roundTripUnsafeMutableRawPointerArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripUnsafeMutableRawPointerArray(_: [UnsafeMutableRawPointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOpaquePointerArray")
@_cdecl("bjs_roundTripOpaquePointerArray")
public func _bjs_roundTripOpaquePointerArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOpaquePointerArray(_: [OpaquePointer].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafePointerArray")
@_cdecl("bjs_roundTripUnsafePointerArray")
public func _bjs_roundTripUnsafePointerArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripUnsafePointerArray(_: [UnsafePointer<UInt8>].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripUnsafeMutablePointerArray")
@_cdecl("bjs_roundTripUnsafeMutablePointerArray")
public func _bjs_roundTripUnsafeMutablePointerArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripUnsafeMutablePointerArray(_: [UnsafeMutablePointer<UInt8>].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_consumeDataProcessorArrayType")
@_cdecl("bjs_consumeDataProcessorArrayType")
public func _bjs_consumeDataProcessorArrayType() -> Int32 {
    #if arch(wasm32)
    let ret = consumeDataProcessorArrayType(_: [AnyDataProcessor].bridgeJSLiftParameter())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDataProcessorArrayType")
@_cdecl("bjs_roundTripDataProcessorArrayType")
public func _bjs_roundTripDataProcessorArrayType() -> Void {
    #if arch(wasm32)
    let ret = roundTripDataProcessorArrayType(_: [AnyDataProcessor].bridgeJSLiftParameter())
    ret.map { $0 as! AnyDataProcessor }.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObjectArray")
@_cdecl("bjs_roundTripJSObjectArray")
public func _bjs_roundTripJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripJSObjectArray(_: [JSObject].bridgeJSLiftParameter())
    ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalJSObjectArray")
@_cdecl("bjs_roundTripOptionalJSObjectArray")
public func _bjs_roundTripOptionalJSObjectArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalJSObjectArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<JSObject>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<JSObject>.bridgeJSLiftParameter())
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFooArray")
@_cdecl("bjs_roundTripFooArray")
public func _bjs_roundTripFooArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripFooArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Foo] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Foo(unsafelyWrapping: JSObject.bridgeJSLiftParameter()))
        }
        __result.reverse()
        return __result
    }())
    ret.map { $0.jsObject }.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalFooArray")
@_cdecl("bjs_roundTripOptionalFooArray")
public func _bjs_roundTripOptionalFooArray() -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalFooArray(_: {
        let __count = Int(_swift_js_pop_i32())
        var __result: [Optional<Foo>] = []
        __result.reserveCapacity(__count)
        for _ in 0..<__count {
            __result.append(Optional<JSObject>.bridgeJSLiftParameter().map { Foo(unsafelyWrapping: $0) })
        }
        __result.reverse()
        return __result
    }())
    for __bjs_elem_ret in ret {
    let __bjs_isSome_ret_elem = __bjs_elem_ret != nil
    if let __bjs_unwrapped_ret_elem = __bjs_elem_ret {
    __bjs_unwrapped_ret_elem.jsObject.bridgeJSLowerStackReturn()
    }
    _swift_js_push_i32(__bjs_isSome_ret_elem ? 1 : 0)
    }
    _swift_js_push_i32(Int32(ret.count))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalString")
@_cdecl("bjs_roundTripOptionalString")
public func _bjs_roundTripOptionalString(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalString(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalInt")
@_cdecl("bjs_roundTripOptionalInt")
public func _bjs_roundTripOptionalInt(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalInt(value: Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalBool")
@_cdecl("bjs_roundTripOptionalBool")
public func _bjs_roundTripOptionalBool(_ flagIsSome: Int32, _ flagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalBool(flag: Optional<Bool>.bridgeJSLiftParameter(flagIsSome, flagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalFloat")
@_cdecl("bjs_roundTripOptionalFloat")
public func _bjs_roundTripOptionalFloat(_ numberIsSome: Int32, _ numberValue: Float32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalFloat(number: Optional<Float>.bridgeJSLiftParameter(numberIsSome, numberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalDouble")
@_cdecl("bjs_roundTripOptionalDouble")
public func _bjs_roundTripOptionalDouble(_ precisionIsSome: Int32, _ precisionValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDouble(precision: Optional<Double>.bridgeJSLiftParameter(precisionIsSome, precisionValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalSyntax")
@_cdecl("bjs_roundTripOptionalSyntax")
public func _bjs_roundTripOptionalSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalMixSyntax")
@_cdecl("bjs_roundTripOptionalMixSyntax")
public func _bjs_roundTripOptionalMixSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalMixSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalSwiftSyntax")
@_cdecl("bjs_roundTripOptionalSwiftSyntax")
public func _bjs_roundTripOptionalSwiftSyntax(_ nameIsSome: Int32, _ nameBytes: Int32, _ nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalWithSpaces")
@_cdecl("bjs_roundTripOptionalWithSpaces")
public func _bjs_roundTripOptionalWithSpaces(_ valueIsSome: Int32, _ valueValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalWithSpaces(value: Optional<Double>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTypeAlias")
@_cdecl("bjs_roundTripOptionalTypeAlias")
public func _bjs_roundTripOptionalTypeAlias(_ ageIsSome: Int32, _ ageValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTypeAlias(age: Optional<Int>.bridgeJSLiftParameter(ageIsSome, ageValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalStatus")
@_cdecl("bjs_roundTripOptionalStatus")
public func _bjs_roundTripOptionalStatus(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalStatus(value: Optional<Status>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTheme")
@_cdecl("bjs_roundTripOptionalTheme")
public func _bjs_roundTripOptionalTheme(_ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTheme(value: Optional<Theme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalHttpStatus")
@_cdecl("bjs_roundTripOptionalHttpStatus")
public func _bjs_roundTripOptionalHttpStatus(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalHttpStatus(value: Optional<HttpStatus>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTSDirection")
@_cdecl("bjs_roundTripOptionalTSDirection")
public func _bjs_roundTripOptionalTSDirection(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTSDirection(value: Optional<TSDirection>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTSTheme")
@_cdecl("bjs_roundTripOptionalTSTheme")
public func _bjs_roundTripOptionalTSTheme(_ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTSTheme(value: Optional<TSTheme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalNetworkingAPIMethod")
@_cdecl("bjs_roundTripOptionalNetworkingAPIMethod")
public func _bjs_roundTripOptionalNetworkingAPIMethod(_ methodIsSome: Int32, _ methodValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalNetworkingAPIMethod(_: Optional<Networking.API.Method>.bridgeJSLiftParameter(methodIsSome, methodValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIResult")
@_cdecl("bjs_roundTripOptionalAPIResult")
public func _bjs_roundTripOptionalAPIResult(_ valueIsSome: Int32, _ valueCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIResult(value: Optional<APIResult>.bridgeJSLiftParameter(valueIsSome, valueCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTypedPayloadResult")
@_cdecl("bjs_roundTripOptionalTypedPayloadResult")
public func _bjs_roundTripOptionalTypedPayloadResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTypedPayloadResult(_: Optional<TypedPayloadResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_compareAPIResults")
@_cdecl("bjs_compareAPIResults")
public func _bjs_compareAPIResults(_ r1IsSome: Int32, _ r1CaseId: Int32, _ r2IsSome: Int32, _ r2CaseId: Int32) -> Void {
    #if arch(wasm32)
    let _tmp_r2 = Optional<APIResult>.bridgeJSLiftParameter(r2IsSome, r2CaseId)
    let _tmp_r1 = Optional<APIResult>.bridgeJSLiftParameter(r1IsSome, r1CaseId)
    let ret = compareAPIResults(_: _tmp_r1, _: _tmp_r2)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalComplexResult")
@_cdecl("bjs_roundTripOptionalComplexResult")
public func _bjs_roundTripOptionalComplexResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalComplexResult(_: Optional<ComplexResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAllTypesResult")
@_cdecl("bjs_roundTripOptionalAllTypesResult")
public func _bjs_roundTripOptionalAllTypesResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAllTypesResult(_: Optional<AllTypesResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalPayloadResult")
@_cdecl("bjs_roundTripOptionalPayloadResult")
public func _bjs_roundTripOptionalPayloadResult(_ result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalPayloadResult(_: OptionalAllTypesResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalPayloadResultOpt")
@_cdecl("bjs_roundTripOptionalPayloadResultOpt")
public func _bjs_roundTripOptionalPayloadResultOpt(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalPayloadResultOpt(_: Optional<OptionalAllTypesResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalClass")
@_cdecl("bjs_roundTripOptionalClass")
public func _bjs_roundTripOptionalClass(_ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalClass(value: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalGreeter")
@_cdecl("bjs_roundTripOptionalGreeter")
public func _bjs_roundTripOptionalGreeter(_ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalGreeter(_: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_applyOptionalGreeter")
@_cdecl("bjs_applyOptionalGreeter")
public func _bjs_applyOptionalGreeter(_ valueIsSome: Int32, _ valueValue: UnsafeMutableRawPointer, _ transform: Int32) -> Void {
    #if arch(wasm32)
    let ret = applyOptionalGreeter(_: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue), _: _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_Sq7GreeterC.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeOptionalHolder")
@_cdecl("bjs_makeOptionalHolder")
public func _bjs_makeOptionalHolder(_ nullableGreeterIsSome: Int32, _ nullableGreeterValue: UnsafeMutableRawPointer, _ undefinedNumberIsSome: Int32, _ undefinedNumberValue: Float64) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeOptionalHolder(nullableGreeter: Optional<Greeter>.bridgeJSLiftParameter(nullableGreeterIsSome, nullableGreeterValue), undefinedNumber: JSUndefinedOr<Double>.bridgeJSLiftParameter(undefinedNumberIsSome, undefinedNumberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIOptionalResult")
@_cdecl("bjs_roundTripOptionalAPIOptionalResult")
public func _bjs_roundTripOptionalAPIOptionalResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIOptionalResult(result: Optional<APIOptionalResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
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
    let _tmp_values = [Int].bridgeJSLiftParameter()
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
    let _tmp_values = [String].bridgeJSLiftParameter()
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
fileprivate func _bjs_ClosureSupportExports_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ClosureSupportExports_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Greeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_Calculator_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Calculator_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_InternalGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_InternalGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_PublicGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PublicGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_PackageGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PackageGreeter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_Converter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Converter_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_HTTPServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_HTTPServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_TestServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestServer_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_SimplePropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_SimplePropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_PropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_PropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_MathUtils_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_MathUtils_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_ConstructorDefaults_init")
@_cdecl("bjs_ConstructorDefaults_init")
public func _bjs_ConstructorDefaults_init(_ nameBytes: Int32, _ nameLength: Int32, _ count: Int32, _ enabled: Int32, _ status: Int32, _ tagIsSome: Int32, _ tagBytes: Int32, _ tagLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ConstructorDefaults(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled), status: Status.bridgeJSLiftParameter(status), tag: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_describe")
@_cdecl("bjs_ConstructorDefaults_describe")
public func _bjs_ConstructorDefaults_describe(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_get")
@_cdecl("bjs_ConstructorDefaults_name_get")
public func _bjs_ConstructorDefaults_name_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_set")
@_cdecl("bjs_ConstructorDefaults_name_set")
public func _bjs_ConstructorDefaults_name_set(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_get")
@_cdecl("bjs_ConstructorDefaults_count_get")
public func _bjs_ConstructorDefaults_count_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_set")
@_cdecl("bjs_ConstructorDefaults_count_set")
public func _bjs_ConstructorDefaults_count_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_get")
@_cdecl("bjs_ConstructorDefaults_enabled_get")
public func _bjs_ConstructorDefaults_enabled_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).enabled
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_set")
@_cdecl("bjs_ConstructorDefaults_enabled_set")
public func _bjs_ConstructorDefaults_enabled_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).enabled = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_get")
@_cdecl("bjs_ConstructorDefaults_status_get")
public func _bjs_ConstructorDefaults_status_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).status
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_set")
@_cdecl("bjs_ConstructorDefaults_status_set")
public func _bjs_ConstructorDefaults_status_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).status = Status.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_get")
@_cdecl("bjs_ConstructorDefaults_tag_get")
public func _bjs_ConstructorDefaults_tag_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).tag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_set")
@_cdecl("bjs_ConstructorDefaults_tag_set")
public func _bjs_ConstructorDefaults_tag_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).tag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_deinit")
@_cdecl("bjs_ConstructorDefaults_deinit")
public func _bjs_ConstructorDefaults_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ConstructorDefaults>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ConstructorDefaults: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ConstructorDefaults_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ConstructorDefaults_wrap")
fileprivate func _bjs_ConstructorDefaults_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ConstructorDefaults_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_StaticPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_StaticPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).backupProcessor.flatMap { $0 as? AnyDataProcessor }
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
fileprivate func _bjs_DataProcessorManager_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_DataProcessorManager_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_SwiftDataProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_SwiftDataProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_TextProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TextProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_OptionalHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_OptionalPropertyHolder_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func _bjs_Container_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Container_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyVoid_static")
fileprivate func bjs_ClosureSupportImports_jsApplyVoid_static(_ callback: Int32) -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsApplyVoid_static(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyBool_static")
fileprivate func bjs_ClosureSupportImports_jsApplyBool_static(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyBool_static(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyInt_static")
fileprivate func bjs_ClosureSupportImports_jsApplyInt_static(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyInt_static(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyDouble_static")
fileprivate func bjs_ClosureSupportImports_jsApplyDouble_static(_ value: Float64, _ transform: Int32) -> Float64
#else
fileprivate func bjs_ClosureSupportImports_jsApplyDouble_static(_ value: Float64, _ transform: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyString_static")
fileprivate func bjs_ClosureSupportImports_jsApplyString_static(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyString_static(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsApplyJSObject_static")
fileprivate func bjs_ClosureSupportImports_jsApplyJSObject_static(_ value: Int32, _ transform: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsApplyJSObject_static(_ value: Int32, _ transform: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeIntToInt_static")
fileprivate func bjs_ClosureSupportImports_jsMakeIntToInt_static(_ base: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeIntToInt_static(_ base: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeDoubleToDouble_static")
fileprivate func bjs_ClosureSupportImports_jsMakeDoubleToDouble_static(_ base: Float64) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeDoubleToDouble_static(_ base: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsMakeStringToString_static")
fileprivate func bjs_ClosureSupportImports_jsMakeStringToString_static(_ prefix: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsMakeStringToString_static(_ prefix: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallTwice_static")
fileprivate func bjs_ClosureSupportImports_jsCallTwice_static(_ value: Int32, _ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallTwice_static(_ value: Int32, _ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallBinary_static")
fileprivate func bjs_ClosureSupportImports_jsCallBinary_static(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallBinary_static(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallTriple_static")
fileprivate func bjs_ClosureSupportImports_jsCallTriple_static(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallTriple_static(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallAfterRelease_static")
fileprivate func bjs_ClosureSupportImports_jsCallAfterRelease_static(_ callback: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsCallAfterRelease_static(_ callback: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsOptionalInvoke_static")
fileprivate func bjs_ClosureSupportImports_jsOptionalInvoke_static(_ callbackIsSome: Int32, _ callbackFuncRef: Int32) -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsOptionalInvoke_static(_ callbackIsSome: Int32, _ callbackFuncRef: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsStoreClosure_static")
fileprivate func bjs_ClosureSupportImports_jsStoreClosure_static(_ callback: Int32) -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsStoreClosure_static(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsCallStoredClosure_static")
fileprivate func bjs_ClosureSupportImports_jsCallStoredClosure_static() -> Void
#else
fileprivate func bjs_ClosureSupportImports_jsCallStoredClosure_static() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_jsHeapCount_static")
fileprivate func bjs_ClosureSupportImports_jsHeapCount_static() -> Int32
#else
fileprivate func bjs_ClosureSupportImports_jsHeapCount_static() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ClosureSupportImports_runJsClosureSupportTests_static")
fileprivate func bjs_ClosureSupportImports_runJsClosureSupportTests_static() -> Void
#else
fileprivate func bjs_ClosureSupportImports_runJsClosureSupportTests_static() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

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
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripDictionary")
fileprivate func bjs_jsRoundTripDictionary() -> Void
#else
fileprivate func bjs_jsRoundTripDictionary() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripDictionary(_ values: [String: Int]) throws(JSException) -> [String: Int] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripDictionary()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Int].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripDictionaryBool")
fileprivate func bjs_jsRoundTripDictionaryBool() -> Void
#else
fileprivate func bjs_jsRoundTripDictionaryBool() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripDictionaryBool(_ values: [String: Bool]) throws(JSException) -> [String: Bool] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripDictionaryBool()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Bool].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripDictionaryDouble")
fileprivate func bjs_jsRoundTripDictionaryDouble() -> Void
#else
fileprivate func bjs_jsRoundTripDictionaryDouble() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripDictionaryDouble(_ values: [String: Double]) throws(JSException) -> [String: Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripDictionaryDouble()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: Double].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripDictionaryJSObject")
fileprivate func bjs_jsRoundTripDictionaryJSObject() -> Void
#else
fileprivate func bjs_jsRoundTripDictionaryJSObject() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripDictionaryJSObject(_ values: [String: JSObject]) throws(JSException) -> [String: JSObject] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripDictionaryJSObject()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: JSObject].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripDictionaryJSValue")
fileprivate func bjs_jsRoundTripDictionaryJSValue() -> Void
#else
fileprivate func bjs_jsRoundTripDictionaryJSValue() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripDictionaryJSValue(_ values: [String: JSValue]) throws(JSException) -> [String: JSValue] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripDictionaryJSValue()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: JSValue].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNestedDictionary")
fileprivate func bjs_jsRoundTripNestedDictionary() -> Void
#else
fileprivate func bjs_jsRoundTripNestedDictionary() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripNestedDictionary(_ values: [String: [Double]]) throws(JSException) -> [String: [Double]] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripNestedDictionary()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String: [Double]].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalDictionary")
fileprivate func bjs_jsRoundTripOptionalDictionary(_ values: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalDictionary(_ values: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalDictionary(_ values: Optional<[String: String]>) throws(JSException) -> Optional<[String: String]> {
    let valuesIsSome = values.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalDictionary(valuesIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<[String: String]>.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripUndefinedDictionary")
fileprivate func bjs_jsRoundTripUndefinedDictionary(_ values: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripUndefinedDictionary(_ values: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripUndefinedDictionary(_ values: JSUndefinedOr<[String: Int]>) throws(JSException) -> JSUndefinedOr<[String: Int]> {
    let valuesIsSome = values.bridgeJSLowerParameter()
    bjs_jsRoundTripUndefinedDictionary(valuesIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<[String: Int]>.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Foo_init")
fileprivate func bjs_Foo_init(_ value: Int32) -> Int32
#else
fileprivate func bjs_Foo_init(_ value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Foo_value_get")
fileprivate func bjs_Foo_value_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Foo_value_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_globalObject1_get() -> Void
#else
fileprivate func bjs_globalObject1_get() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$globalObject1_get() throws(JSException) -> JSValue {
    bjs_globalObject1_get()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSValue.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripVoid")
fileprivate func bjs_jsRoundTripVoid() -> Void
#else
fileprivate func bjs_jsRoundTripVoid() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripVoid() throws(JSException) -> Void {
    bjs_jsRoundTripVoid()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumber")
fileprivate func bjs_jsRoundTripNumber(_ v: Float64) -> Float64
#else
fileprivate func bjs_jsRoundTripNumber(_ v: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsRoundTripBool(_ v: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripBool(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsRoundTripString(_ v: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripString(_ v: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsRoundTripJSValue(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void
#else
fileprivate func bjs_jsRoundTripJSValue(_ vKind: Int32, _ vPayload1: Int32, _ vPayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripJSValue(_ v: JSValue) throws(JSException) -> JSValue {
    let (vKind, vPayload1, vPayload2) = v.bridgeJSLowerParameter()
    bjs_jsRoundTripJSValue(vKind, vPayload1, vPayload2)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSValue.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripJSValueArray")
fileprivate func bjs_jsRoundTripJSValueArray() -> Void
#else
fileprivate func bjs_jsRoundTripJSValueArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripJSValueArray(_ v: [JSValue]) throws(JSException) -> [JSValue] {
    let _ = v.bridgeJSLowerParameter()
    bjs_jsRoundTripJSValueArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [JSValue].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalJSValueArray")
fileprivate func bjs_jsRoundTripOptionalJSValueArray(_ v: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalJSValueArray(_ v: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalJSValueArray(_ v: Optional<[JSValue]>) throws(JSException) -> Optional<[JSValue]> {
    let vIsSome = v.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalJSValueArray(vIsSome)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<[JSValue]>.bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrVoid")
fileprivate func bjs_jsThrowOrVoid(_ shouldThrow: Int32) -> Void
#else
fileprivate func bjs_jsThrowOrVoid(_ shouldThrow: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsThrowOrVoid(_ shouldThrow: Bool) throws(JSException) -> Void {
    let shouldThrowValue = shouldThrow.bridgeJSLowerParameter()
    bjs_jsThrowOrVoid(shouldThrowValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsThrowOrNumber")
fileprivate func bjs_jsThrowOrNumber(_ shouldThrow: Int32) -> Float64
#else
fileprivate func bjs_jsThrowOrNumber(_ shouldThrow: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsThrowOrBool(_ shouldThrow: Int32) -> Int32
#else
fileprivate func bjs_jsThrowOrBool(_ shouldThrow: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsThrowOrString(_ shouldThrow: Int32) -> Int32
#else
fileprivate func bjs_jsThrowOrString(_ shouldThrow: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_jsRoundTripFeatureFlag(_ flag: Int32) -> Int32
#else
fileprivate func bjs_jsRoundTripFeatureFlag(_ flag: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_runAsyncWorks() -> Int32
#else
fileprivate func bjs_runAsyncWorks() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$runAsyncWorks() throws(JSException) -> JSPromise {
    let ret = bjs_runAsyncWorks()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSPromise.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs__jsWeirdFunction")
fileprivate func bjs__jsWeirdFunction() -> Float64
#else
fileprivate func bjs__jsWeirdFunction() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$_jsWeirdFunction() throws(JSException) -> Double {
    let ret = bjs__jsWeirdFunction()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripNumberArray")
fileprivate func bjs_jsRoundTripNumberArray() -> Void
#else
fileprivate func bjs_jsRoundTripNumberArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripNumberArray(_ values: [Double]) throws(JSException) -> [Double] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripNumberArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripStringArray")
fileprivate func bjs_jsRoundTripStringArray() -> Void
#else
fileprivate func bjs_jsRoundTripStringArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripStringArray(_ values: [String]) throws(JSException) -> [String] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripStringArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripBoolArray")
fileprivate func bjs_jsRoundTripBoolArray() -> Void
#else
fileprivate func bjs_jsRoundTripBoolArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripBoolArray(_ values: [Bool]) throws(JSException) -> [Bool] {
    let _ = values.bridgeJSLowerParameter()
    bjs_jsRoundTripBoolArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Bool].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsSumNumberArray")
fileprivate func bjs_jsSumNumberArray() -> Float64
#else
fileprivate func bjs_jsSumNumberArray() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsSumNumberArray(_ values: [Double]) throws(JSException) -> Double {
    let _ = values.bridgeJSLowerParameter()
    let ret = bjs_jsSumNumberArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Double.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsCreateNumberArray")
fileprivate func bjs_jsCreateNumberArray() -> Void
#else
fileprivate func bjs_jsCreateNumberArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsCreateNumberArray() throws(JSException) -> [Double] {
    bjs_jsCreateNumberArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Double].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_parseInt")
fileprivate func bjs_parseInt(_ string: Int32) -> Float64
#else
fileprivate func bjs_parseInt(_ string: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_init(_ name: Int32, _ prefix: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_get")
fileprivate func bjs_JsGreeter_name_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_name_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_prefix_get")
fileprivate func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_prefix_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_name_set")
fileprivate func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_JsGreeter_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_greet")
fileprivate func bjs_JsGreeter_greet(_ self: Int32) -> Int32
#else
fileprivate func bjs_JsGreeter_greet(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_JsGreeter_changeName")
fileprivate func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void
#else
fileprivate func bjs_JsGreeter_changeName(_ self: Int32, _ name: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs__WeirdClass_init() -> Int32
#else
fileprivate func bjs__WeirdClass_init() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs__WeirdClass_method_with_dashes")
fileprivate func bjs__WeirdClass_method_with_dashes(_ self: Int32) -> Int32
#else
fileprivate func bjs__WeirdClass_method_with_dashes(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_StaticBox_init(_ value: Float64) -> Int32
#else
fileprivate func bjs_StaticBox_init(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_create_static")
fileprivate func bjs_StaticBox_create_static(_ value: Float64) -> Int32
#else
fileprivate func bjs_StaticBox_create_static(_ value: Float64) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_value_static")
fileprivate func bjs_StaticBox_value_static() -> Float64
#else
fileprivate func bjs_StaticBox_value_static() -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_makeDefault_static")
fileprivate func bjs_StaticBox_makeDefault_static() -> Int32
#else
fileprivate func bjs_StaticBox_makeDefault_static() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_with_dashes_static")
fileprivate func bjs_StaticBox_with_dashes_static() -> Int32
#else
fileprivate func bjs_StaticBox_with_dashes_static() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticBox_value")
fileprivate func bjs_StaticBox_value(_ self: Int32) -> Float64
#else
fileprivate func bjs_StaticBox_value(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

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
fileprivate func bjs_Animal_init(_ name: Int32, _ age: Float64, _ isCat: Int32) -> Int32
#else
fileprivate func bjs_Animal_init(_ name: Int32, _ age: Float64, _ isCat: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_name_get")
fileprivate func bjs_Animal_name_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_name_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_age_get")
fileprivate func bjs_Animal_age_get(_ self: Int32) -> Float64
#else
fileprivate func bjs_Animal_age_get(_ self: Int32) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_isCat_get")
fileprivate func bjs_Animal_isCat_get(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_isCat_get(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_name_set")
fileprivate func bjs_Animal_name_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Animal_name_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_age_set")
fileprivate func bjs_Animal_age_set(_ self: Int32, _ newValue: Float64) -> Void
#else
fileprivate func bjs_Animal_age_set(_ self: Int32, _ newValue: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_isCat_set")
fileprivate func bjs_Animal_isCat_set(_ self: Int32, _ newValue: Int32) -> Void
#else
fileprivate func bjs_Animal_isCat_set(_ self: Int32, _ newValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_bark")
fileprivate func bjs_Animal_bark(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_bark(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Animal_getIsCat")
fileprivate func bjs_Animal_getIsCat(_ self: Int32) -> Int32
#else
fileprivate func bjs_Animal_getIsCat(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripIntArray")
fileprivate func bjs_jsRoundTripIntArray() -> Void
#else
fileprivate func bjs_jsRoundTripIntArray() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripIntArray(_ items: [Int]) throws(JSException) -> [Int] {
    let _ = items.bridgeJSLowerParameter()
    bjs_jsRoundTripIntArray()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsArrayLength")
fileprivate func bjs_jsArrayLength() -> Int32
#else
fileprivate func bjs_jsArrayLength() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsArrayLength(_ items: [Int]) throws(JSException) -> Int {
    let _ = items.bridgeJSLowerParameter()
    let ret = bjs_jsArrayLength()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_makeArrayHost")
fileprivate func bjs_makeArrayHost() -> Int32
#else
fileprivate func bjs_makeArrayHost() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$makeArrayHost(_ numbers: [Int], _ labels: [String]) throws(JSException) -> ArrayHost {
    let _ = labels.bridgeJSLowerParameter()
    let _ = numbers.bridgeJSLowerParameter()
    let ret = bjs_makeArrayHost()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return ArrayHost.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_init")
fileprivate func bjs_ArrayHost_init() -> Int32
#else
fileprivate func bjs_ArrayHost_init() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_numbers_get")
fileprivate func bjs_ArrayHost_numbers_get(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_numbers_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_labels_get")
fileprivate func bjs_ArrayHost_labels_get(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_labels_get(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_numbers_set")
fileprivate func bjs_ArrayHost_numbers_set(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_numbers_set(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_labels_set")
fileprivate func bjs_ArrayHost_labels_set(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_labels_set(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_concatNumbers")
fileprivate func bjs_ArrayHost_concatNumbers(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_concatNumbers(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_concatLabels")
fileprivate func bjs_ArrayHost_concatLabels(_ self: Int32) -> Void
#else
fileprivate func bjs_ArrayHost_concatLabels(_ self: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ArrayHost_firstLabel")
fileprivate func bjs_ArrayHost_firstLabel(_ self: Int32) -> Int32
#else
fileprivate func bjs_ArrayHost_firstLabel(_ self: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$ArrayHost_init(_ numbers: [Int], _ labels: [String]) throws(JSException) -> JSObject {
    let _ = labels.bridgeJSLowerParameter()
    let _ = numbers.bridgeJSLowerParameter()
    let ret = bjs_ArrayHost_init()
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSObject.bridgeJSLiftReturn(ret)
}

func _$ArrayHost_numbers_get(_ self: JSObject) throws(JSException) -> [Int] {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_ArrayHost_numbers_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

func _$ArrayHost_labels_get(_ self: JSObject) throws(JSException) -> [String] {
    let selfValue = self.bridgeJSLowerParameter()
    bjs_ArrayHost_labels_get(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

func _$ArrayHost_numbers_set(_ self: JSObject, _ newValue: [Int]) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = newValue.bridgeJSLowerParameter()
    bjs_ArrayHost_numbers_set(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ArrayHost_labels_set(_ self: JSObject, _ newValue: [String]) throws(JSException) -> Void {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = newValue.bridgeJSLowerParameter()
    bjs_ArrayHost_labels_set(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
}

func _$ArrayHost_concatNumbers(_ self: JSObject, _ values: [Int]) throws(JSException) -> [Int] {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    bjs_ArrayHost_concatNumbers(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [Int].bridgeJSLiftReturn()
}

func _$ArrayHost_concatLabels(_ self: JSObject, _ values: [String]) throws(JSException) -> [String] {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    bjs_ArrayHost_concatLabels(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return [String].bridgeJSLiftReturn()
}

func _$ArrayHost_firstLabel(_ self: JSObject, _ values: [String]) throws(JSException) -> String {
    let selfValue = self.bridgeJSLowerParameter()
    let _ = values.bridgeJSLowerParameter()
    let ret = bjs_ArrayHost_firstLabel(selfValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsTranslatePoint")
fileprivate func bjs_jsTranslatePoint(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32
#else
fileprivate func bjs_jsTranslatePoint(_ point: Int32, _ dx: Int32, _ dy: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

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
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_runJsOptionalSupportTests")
fileprivate func bjs_runJsOptionalSupportTests() -> Void
#else
fileprivate func bjs_runJsOptionalSupportTests() -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$runJsOptionalSupportTests() throws(JSException) -> Void {
    bjs_runJsOptionalSupportTests()
    if let error = _swift_js_take_exception() {
        throw error
    }
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalNumberNull")
fileprivate func bjs_jsRoundTripOptionalNumberNull(_ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalNumberNull(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalNumberNull(_ value: Optional<Int>) throws(JSException) -> Optional<Int> {
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalNumberNull(valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalNumberUndefined")
fileprivate func bjs_jsRoundTripOptionalNumberUndefined(_ valueIsSome: Int32, _ valueValue: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalNumberUndefined(_ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalNumberUndefined(_ value: JSUndefinedOr<Int>) throws(JSException) -> JSUndefinedOr<Int> {
    let (valueIsSome, valueValue) = value.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalNumberUndefined(valueIsSome, valueValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<Int>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalStringNull")
fileprivate func bjs_jsRoundTripOptionalStringNull(_ nameIsSome: Int32, _ nameValue: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalStringNull(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalStringNull(_ name: Optional<String>) throws(JSException) -> Optional<String> {
    let (nameIsSome, nameValue) = name.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalStringNull(nameIsSome, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsRoundTripOptionalStringUndefined")
fileprivate func bjs_jsRoundTripOptionalStringUndefined(_ nameIsSome: Int32, _ nameValue: Int32) -> Void
#else
fileprivate func bjs_jsRoundTripOptionalStringUndefined(_ nameIsSome: Int32, _ nameValue: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsRoundTripOptionalStringUndefined(_ name: JSUndefinedOr<String>) throws(JSException) -> JSUndefinedOr<String> {
    let (nameIsSome, nameValue) = name.bridgeJSLowerParameter()
    bjs_jsRoundTripOptionalStringUndefined(nameIsSome, nameValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return JSUndefinedOr<String>.bridgeJSLiftReturnFromSideChannel()
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsRoundTripGreeter_static")
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripGreeter_static(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripGreeter_static(_ greeter: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static")
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static(_ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static(_ greeterIsSome: Int32, _ greeterPointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

func _$SwiftClassSupportImports_jsRoundTripGreeter(_ greeter: Greeter) throws(JSException) -> Greeter {
    let greeterPointer = greeter.bridgeJSLowerParameter()
    let ret = bjs_SwiftClassSupportImports_jsRoundTripGreeter_static(greeterPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Greeter.bridgeJSLiftReturn(ret)
}

func _$SwiftClassSupportImports_jsRoundTripOptionalGreeter(_ greeter: Optional<Greeter>) throws(JSException) -> Optional<Greeter> {
    let (greeterIsSome, greeterPointer) = greeter.bridgeJSLowerParameter()
    let ret = bjs_SwiftClassSupportImports_jsRoundTripOptionalGreeter_static(greeterIsSome, greeterPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Optional<Greeter>.bridgeJSLiftReturn(ret)
}