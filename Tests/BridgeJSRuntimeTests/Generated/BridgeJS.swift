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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests10HttpStatusO_Si: _BridgedSwiftClosureBox {
    let closure: (HttpStatus) -> Int
    init(_ closure: @escaping (HttpStatus) -> Int) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests10HttpStatusO_Si {
    static func bridgeJSLower(_ closure: @escaping (HttpStatus) -> Int) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests10HttpStatusO_Si(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests10HttpStatusO_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests10HttpStatusO_Si>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(HttpStatus.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_SS: _BridgedSwiftClosureBox {
    let closure: (Theme) -> String
    init(_ closure: @escaping (Theme) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_SS {
    static func bridgeJSLower(_ closure: @escaping (Theme) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_Sb: _BridgedSwiftClosureBox {
    let closure: (Theme) -> Bool
    init(_ closure: @escaping (Theme) -> Bool) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_Sb {
    static func bridgeJSLower(_ closure: @escaping (Theme) -> Bool) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_Sb(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests5ThemeO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests5ThemeO_Sb>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests7GreeterC_SS: _BridgedSwiftClosureBox {
    let closure: (Greeter) -> String
    init(_ closure: @escaping (Greeter) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests7GreeterC_SS {
    static func bridgeJSLower(_ closure: @escaping (Greeter) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests7GreeterC_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests7GreeterC_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Greeter.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests9APIResultO_SS: _BridgedSwiftClosureBox {
    let closure: (APIResult) -> String
    init(_ closure: @escaping (APIResult) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9APIResultO_SS {
    static func bridgeJSLower(_ closure: @escaping (APIResult) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests9APIResultO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests9APIResultO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(APIResult.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_SS: _BridgedSwiftClosureBox {
    let closure: (Direction) -> String
    init(_ closure: @escaping (Direction) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_SS {
    static func bridgeJSLower(_ closure: @escaping (Direction) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Direction.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_Sb: _BridgedSwiftClosureBox {
    let closure: (Direction) -> Bool
    init(_ closure: @escaping (Direction) -> Bool) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_Sb {
    static func bridgeJSLower(_ closure: @escaping (Direction) -> Bool) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_Sb(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTests9DirectionO_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTests9DirectionO_Sb>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Direction.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSS_7GreeterC: _BridgedSwiftClosureBox {
    let closure: (String) -> Greeter
    init(_ closure: @escaping (String) -> Greeter) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSS_7GreeterC {
    static func bridgeJSLower(_ closure: @escaping (String) -> Greeter) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSS_7GreeterC(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_7GreeterC(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSS_7GreeterC>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSS_SS: _BridgedSwiftClosureBox {
    let closure: (String) -> String
    init(_ closure: @escaping (String) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSS_SS {
    static func bridgeJSLower(_ closure: @escaping (String) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSS_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSS_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSiSSSd_SS: _BridgedSwiftClosureBox {
    let closure: (Int, String, Double) -> String
    init(_ closure: @escaping (Int, String, Double) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSiSSSd_SS {
    static func bridgeJSLower(_ closure: @escaping (Int, String, Double) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSiSSSd_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
    static func bridgeJSLift(_ callbackId: Int32) -> (Int, String, Double) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0, param1, param2 in
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSiSSSd_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32, _ param1Bytes: Int32, _ param1Length: Int32, _ param2: Float64) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSiSSSd_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Int.bridgeJSLiftParameter(param0), String.bridgeJSLiftParameter(param1Bytes, param1Length), Double.bridgeJSLiftParameter(param2))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSi_Si: _BridgedSwiftClosureBox {
    let closure: (Int) -> Int
    init(_ closure: @escaping (Int) -> Int) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSi_Si {
    static func bridgeJSLower(_ closure: @escaping (Int) -> Int) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSi_Si(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSi_Si>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Int.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSi_y: _BridgedSwiftClosureBox {
    let closure: (Int) -> Void
    init(_ closure: @escaping (Int) -> Void) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSi_y {
    static func bridgeJSLower(_ closure: @escaping (Int) -> Void) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSi_y(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSi_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSi_y>.fromOpaque(boxPtr).takeUnretainedValue()
    box.closure(Int.bridgeJSLiftParameter(param0))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSq5ThemeO_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<Theme>) -> String
    init(_ closure: @escaping (Optional<Theme>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq5ThemeO_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<Theme>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSq5ThemeO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq5ThemeO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSq5ThemeO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Theme>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSq7GreeterC_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<Greeter>) -> String
    init(_ closure: @escaping (Optional<Greeter>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq7GreeterC_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<Greeter>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSq7GreeterC_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq7GreeterC_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSq7GreeterC_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Greeter>.bridgeJSLiftParameter(param0IsSome, param0Value))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSq9APIResultO_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<APIResult>) -> String
    init(_ closure: @escaping (Optional<APIResult>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq9APIResultO_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<APIResult>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSq9APIResultO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9APIResultO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSq9APIResultO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<APIResult>.bridgeJSLiftParameter(param0IsSome, param0CaseId))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSq9DirectionO_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<Direction>) -> String
    init(_ closure: @escaping (Optional<Direction>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSq9DirectionO_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<Direction>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSq9DirectionO_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSq9DirectionO_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSq9DirectionO_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Direction>.bridgeJSLiftParameter(param0IsSome, param0Value))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSqSS_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<String>) -> String
    init(_ closure: @escaping (Optional<String>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSqSS_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<String>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSqSS_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSqSS_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<String>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsSqSi_SS: _BridgedSwiftClosureBox {
    let closure: (Optional<Int>) -> String
    init(_ closure: @escaping (Optional<Int>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsSqSi_SS {
    static func bridgeJSLower(_ closure: @escaping (Optional<Int>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsSqSi_SS(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsSqSi_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsSqSi_SS>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Int>.bridgeJSLiftParameter(param0IsSome, param0Value))
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

private final class _BJS_ClosureBox_20BridgeJSRuntimeTestsy_Sq7GreeterC: _BridgedSwiftClosureBox {
    let closure: () -> Optional<Greeter>
    init(_ closure: @escaping () -> Optional<Greeter>) {
        self.closure = closure
    }
}

private enum _BJS_Closure_20BridgeJSRuntimeTestsy_Sq7GreeterC {
    static func bridgeJSLower(_ closure: @escaping () -> Optional<Greeter>) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_20BridgeJSRuntimeTestsy_Sq7GreeterC(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }
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

@_expose(wasm, "invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
@_cdecl("invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC")
public func _invoke_swift_closure_BridgeJSRuntimeTests_20BridgeJSRuntimeTestsy_Sq7GreeterC(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_20BridgeJSRuntimeTestsy_Sq7GreeterC>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure()
    return result.bridgeJSLowerReturn()
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

extension Theme: _BridgedSwiftEnumNoPayload {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload {
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

extension TSTheme: _BridgedSwiftEnumNoPayload {
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

extension Configuration.LogLevel: _BridgedSwiftEnumNoPayload {
}

extension Configuration.Port: _BridgedSwiftEnumNoPayload {
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
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .flag(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 3:
            return .rate(Float.bridgeJSLiftParameter(_swift_js_pop_param_f32()))
        case 4:
            return .precise(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()))
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
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .failure(let param0):
            _swift_js_push_int(Int32(param0))
            return Int32(1)
        case .flag(let param0):
            _swift_js_push_int(param0 ? 1 : 0)
            return Int32(2)
        case .rate(let param0):
            _swift_js_push_f32(param0)
            return Int32(3)
        case .precise(let param0):
            _swift_js_push_f64(param0)
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
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0):
            _swift_js_push_tag(Int32(1))
            _swift_js_push_int(Int32(param0))
        case .flag(let param0):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_int(param0 ? 1 : 0)
        case .rate(let param0):
            _swift_js_push_tag(Int32(3))
            _swift_js_push_f32(param0)
        case .precise(let param0):
            _swift_js_push_tag(Int32(4))
            _swift_js_push_f64(param0)
        case .info:
            _swift_js_push_tag(Int32(5))
        }
    }
}

extension ComplexResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> ComplexResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .error(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .location(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 3:
            return .status(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 4:
            return .coordinates(Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()))
        case 5:
            return .comprehensive(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), Double.bridgeJSLiftParameter(_swift_js_pop_param_f64()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
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
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .error(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
            return Int32(1)
        case .location(let param0, let param1, let param2):
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(2)
        case .status(let param0, let param1, let param2):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(3)
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
            return Int32(4)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(param1 ? 1 : 0)
            _swift_js_push_int(Int32(param2))
            _swift_js_push_int(Int32(param3))
            _swift_js_push_f64(param4)
            _swift_js_push_f64(param5)
            var __bjs_param6 = param6
            __bjs_param6.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param7 = param7
            __bjs_param7.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param8 = param8
            __bjs_param8.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
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
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .error(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        case .location(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(3))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .coordinates(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(4))
            _swift_js_push_f64(param0)
            _swift_js_push_f64(param1)
            _swift_js_push_f64(param2)
        case .comprehensive(let param0, let param1, let param2, let param3, let param4, let param5, let param6, let param7, let param8):
            _swift_js_push_tag(Int32(5))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(param1 ? 1 : 0)
            _swift_js_push_int(Int32(param2))
            _swift_js_push_int(Int32(param3))
            _swift_js_push_f64(param4)
            _swift_js_push_f64(param5)
            var __bjs_param6 = param6
            __bjs_param6.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param7 = param7
            __bjs_param7.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            var __bjs_param8 = param8
            __bjs_param8.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .info:
            _swift_js_push_tag(Int32(6))
        }
    }
}

extension Utilities.Result: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> Utilities.Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        case 2:
            return .status(Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()), String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        default:
            fatalError("Unknown Utilities.Result case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .failure(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
            return Int32(1)
        case .status(let param0, let param1, let param2):
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
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
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            _swift_js_push_int(param0 ? 1 : 0)
            _swift_js_push_int(Int32(param1))
            var __bjs_param2 = param2
            __bjs_param2.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
    }
}

extension API.NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> API.NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        default:
            fatalError("Unknown API.NetworkingResult case ID: \(caseId)")
        }
    }

    // MARK: Protocol Export

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        switch self {
        case .success(let param0):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            return Int32(0)
        case .failure(let param0, let param1):
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
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
            _swift_js_push_tag(Int32(0))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            var __bjs_param0 = param0
            __bjs_param0.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
            _swift_js_push_int(Int32(param1))
        }
    }
}

extension APIOptionalResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> APIOptionalResult {
        switch caseId {
        case 0:
            return .success(Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 2:
            return .status(Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()), Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
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
                var __bjs_str_param0 = __bjs_unwrapped_param0
                __bjs_str_param0.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            return Int32(0)
        case .failure(let param0, let param1):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param0))
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(__bjs_unwrapped_param1 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            return Int32(1)
        case .status(let param0, let param1, let param2):
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(__bjs_unwrapped_param0 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param1))
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                var __bjs_str_param2 = __bjs_unwrapped_param2
                __bjs_str_param2.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param2 ? 1 : 0)
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
            _swift_js_push_tag(Int32(0))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                var __bjs_str_param0 = __bjs_unwrapped_param0
                __bjs_str_param0.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
        case .failure(let param0, let param1):
            _swift_js_push_tag(Int32(1))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param0))
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(__bjs_unwrapped_param1 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
        case .status(let param0, let param1, let param2):
            _swift_js_push_tag(Int32(2))
            let __bjs_isSome_param0 = param0 != nil
            if let __bjs_unwrapped_param0 = param0 {
                _swift_js_push_int(__bjs_unwrapped_param0 ? 1 : 0)
            }
            _swift_js_push_int(__bjs_isSome_param0 ? 1 : 0)
            let __bjs_isSome_param1 = param1 != nil
            if let __bjs_unwrapped_param1 = param1 {
                _swift_js_push_int(Int32(__bjs_unwrapped_param1))
            }
            _swift_js_push_int(__bjs_isSome_param1 ? 1 : 0)
            let __bjs_isSome_param2 = param2 != nil
            if let __bjs_unwrapped_param2 = param2 {
                var __bjs_str_param2 = __bjs_unwrapped_param2
                __bjs_str_param2.withUTF8 { ptr in
                    _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
                }
            }
            _swift_js_push_int(__bjs_isSome_param2 ? 1 : 0)
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

extension PointerFields: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> PointerFields {
        let mutPtr = UnsafeMutablePointer<UInt8>.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let ptr = UnsafePointer<UInt8>.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let opaque = OpaquePointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let mutRaw = UnsafeMutableRawPointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        let raw = UnsafeRawPointer.bridgeJSLiftParameter(_swift_js_pop_param_pointer())
        return PointerFields(raw: raw, mutRaw: mutRaw, opaque: opaque, ptr: ptr, mutPtr: mutPtr)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_pointer(self.raw.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.mutRaw.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.opaque.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.ptr.bridgeJSLowerReturn())
        _swift_js_push_pointer(self.mutPtr.bridgeJSLowerReturn())
    }
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
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> DataPoint {
        let optFlag = Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let optCount = Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let label = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let y = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        let x = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        return DataPoint(x: x, y: y, label: label, optCount: optCount, optFlag: optFlag)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_f64(self.x)
        _swift_js_push_f64(self.y)
        var __bjs_label = self.label
        __bjs_label.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        let __bjs_isSome_optCount = self.optCount != nil
        if let __bjs_unwrapped_optCount = self.optCount {
            _swift_js_push_int(Int32(__bjs_unwrapped_optCount))
        }
        _swift_js_push_int(__bjs_isSome_optCount ? 1 : 0)
        let __bjs_isSome_optFlag = self.optFlag != nil
        if let __bjs_unwrapped_optFlag = self.optFlag {
            _swift_js_push_int(__bjs_unwrapped_optFlag ? 1 : 0)
        }
        _swift_js_push_int(__bjs_isSome_optFlag ? 1 : 0)
    }
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

extension Address: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Address {
        let zipCode = Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let city = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let street = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return Address(street: street, city: city, zipCode: zipCode)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_street = self.street
        __bjs_street.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        var __bjs_city = self.city
        __bjs_city.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        let __bjs_isSome_zipCode = self.zipCode != nil
        if let __bjs_unwrapped_zipCode = self.zipCode {
            _swift_js_push_int(Int32(__bjs_unwrapped_zipCode))
        }
        _swift_js_push_int(__bjs_isSome_zipCode ? 1 : 0)
    }
}

extension Contact: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Contact {
        let secondaryAddress = Optional<Address>.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let email = Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let address = Address.bridgeJSLiftParameter()
        let age = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let name = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return Contact(name: name, age: age, address: address, email: email, secondaryAddress: secondaryAddress)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_name = self.name
        __bjs_name.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(Int32(self.age))
        self.address.bridgeJSLowerReturn()
        let __bjs_isSome_email = self.email != nil
        if let __bjs_unwrapped_email = self.email {
            var __bjs_str_email = __bjs_unwrapped_email
            __bjs_str_email.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
        _swift_js_push_int(__bjs_isSome_email ? 1 : 0)
        let __bjs_isSome_secondaryAddress = self.secondaryAddress != nil
        if let __bjs_unwrapped_secondaryAddress = self.secondaryAddress {
            __bjs_unwrapped_secondaryAddress.bridgeJSLowerReturn()
        }
        _swift_js_push_int(__bjs_isSome_secondaryAddress ? 1 : 0)
    }
}

extension Config: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Config {
        let status = Status.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let direction = Optional<Direction>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let theme = Optional<Theme>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let name = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return Config(name: name, theme: theme, direction: direction, status: status)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_name = self.name
        __bjs_name.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        let __bjs_isSome_theme = self.theme != nil
        if let __bjs_unwrapped_theme = self.theme {
            var __bjs_str_theme = __bjs_unwrapped_theme.rawValue
            __bjs_str_theme.withUTF8 { ptr in
                _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
            }
        }
        _swift_js_push_int(__bjs_isSome_theme ? 1 : 0)
        let __bjs_isSome_direction = self.direction != nil
        if let __bjs_unwrapped_direction = self.direction {
            _swift_js_push_int(__bjs_unwrapped_direction.bridgeJSLowerParameter())
        }
        _swift_js_push_int(__bjs_isSome_direction ? 1 : 0)
        _swift_js_push_int(Int32(self.status.bridgeJSLowerParameter()))
    }
}

extension SessionData: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> SessionData {
        let owner = Optional<Greeter>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_pointer())
        let id = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        return SessionData(id: id, owner: owner)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_int(Int32(self.id))
        let __bjs_isSome_owner = self.owner != nil
        if let __bjs_unwrapped_owner = self.owner {
            _swift_js_push_pointer(__bjs_unwrapped_owner.bridgeJSLowerReturn())
        }
        _swift_js_push_int(__bjs_isSome_owner ? 1 : 0)
    }
}

extension ValidationReport: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ValidationReport {
        let outcome = Optional<APIResult>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let status = Optional<Status>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        let result = APIResult.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let id = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        return ValidationReport(id: id, result: result, status: status, outcome: outcome)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_int(Int32(self.id))
        self.result.bridgeJSLowerReturn()
        let __bjs_isSome_status = self.status != nil
        if let __bjs_unwrapped_status = self.status {
            _swift_js_push_int(__bjs_unwrapped_status.bridgeJSLowerParameter())
        }
        _swift_js_push_int(__bjs_isSome_status ? 1 : 0)
        let __bjs_isSome_outcome = self.outcome != nil
        if let __bjs_unwrapped_outcome = self.outcome {
            _swift_js_push_int(__bjs_unwrapped_outcome.bridgeJSLowerParameter())
        }
        _swift_js_push_int(__bjs_isSome_outcome ? 1 : 0)
    }
}

extension MathOperations: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> MathOperations {
        let baseValue = Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())
        return MathOperations(baseValue: baseValue)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        _swift_js_push_f64(self.baseValue)
    }
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

extension ConfigStruct: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> ConfigStruct {
        let value = Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())
        let name = String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())
        return ConfigStruct(name: name, value: value)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
        var __bjs_name = self.name
        __bjs_name.withUTF8 { ptr in
            _swift_js_push_string(ptr.baseAddress, Int32(ptr.count))
        }
        _swift_js_push_int(Int32(self.value))
    }
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
    } .jsObject
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
public func _bjs_makeFormatter(_ prefixBytes: Int32, _ prefixLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeFormatter(prefix: String.bridgeJSLiftParameter(prefixBytes, prefixLength))
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAdder")
@_cdecl("bjs_makeAdder")
public func _bjs_makeAdder(_ base: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = makeAdder(base: Int.bridgeJSLiftParameter(base))
    return _BJS_Closure_20BridgeJSRuntimeTestsSi_Si.bridgeJSLower(ret)
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
public func _bjs_Greeter_makeFormatter(_ _self: UnsafeMutableRawPointer, _ suffixBytes: Int32, _ suffixLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).makeFormatter(suffix: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_static_makeCreator")
@_cdecl("bjs_Greeter_static_makeCreator")
public func _bjs_Greeter_static_makeCreator(_ defaultNameBytes: Int32, _ defaultNameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter.makeCreator(defaultName: String.bridgeJSLiftParameter(defaultNameBytes, defaultNameLength))
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_7GreeterC.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_makeCustomGreeter")
@_cdecl("bjs_Greeter_makeCustomGreeter")
public func _bjs_Greeter_makeCustomGreeter(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).makeCustomGreeter()
    return _BJS_Closure_20BridgeJSRuntimeTests7GreeterC_SS.bridgeJSLower(ret)
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
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).backupProcessor.flatMap {
        $0 as? AnyDataProcessor
    }
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
public func _bjs_TextProcessor_getTransform(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).getTransform()
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLower(ret)
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
public func _bjs_TextProcessor_makeOptionalStringFormatter(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalStringFormatter()
    return _BJS_Closure_20BridgeJSRuntimeTestsSqSS_SS.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeOptionalGreeterCreator")
@_cdecl("bjs_TextProcessor_makeOptionalGreeterCreator")
public func _bjs_TextProcessor_makeOptionalGreeterCreator(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalGreeterCreator()
    return _BJS_Closure_20BridgeJSRuntimeTestsy_Sq7GreeterC.bridgeJSLower(ret)
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
public func _bjs_TextProcessor_makeDirectionChecker(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeDirectionChecker()
    return _BJS_Closure_20BridgeJSRuntimeTests9DirectionO_Sb.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeThemeValidator")
@_cdecl("bjs_TextProcessor_makeThemeValidator")
public func _bjs_TextProcessor_makeThemeValidator(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeThemeValidator()
    return _BJS_Closure_20BridgeJSRuntimeTests5ThemeO_Sb.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeStatusCodeExtractor")
@_cdecl("bjs_TextProcessor_makeStatusCodeExtractor")
public func _bjs_TextProcessor_makeStatusCodeExtractor(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeStatusCodeExtractor()
    return _BJS_Closure_20BridgeJSRuntimeTests10HttpStatusO_Si.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TextProcessor_makeAPIResultHandler")
@_cdecl("bjs_TextProcessor_makeAPIResultHandler")
public func _bjs_TextProcessor_makeAPIResultHandler(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeAPIResultHandler()
    return _BJS_Closure_20BridgeJSRuntimeTests9APIResultO_SS.bridgeJSLower(ret)
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
public func _bjs_TextProcessor_makeOptionalDirectionFormatter(_ _self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TextProcessor.bridgeJSLiftParameter(_self).makeOptionalDirectionFormatter()
    return _BJS_Closure_20BridgeJSRuntimeTestsSq9DirectionO_SS.bridgeJSLower(ret)
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

@_expose(wasm, "bjs_Container_init")
@_cdecl("bjs_Container_init")
public func _bjs_Container_init(_ config: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let _tmp_config = Optional<Config>.bridgeJSLiftParameter(config)
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
public func _bjs_Container_config_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    Container.bridgeJSLiftParameter(_self).config = Optional<Config>.bridgeJSLiftParameter(value)
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
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsApplyInt")
fileprivate func bjs_jsApplyInt(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func bjs_jsApplyInt(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsApplyInt(_ value: Int, _ transform: @escaping (Int) -> Int) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let transformPointer = _BJS_Closure_20BridgeJSRuntimeTestsSi_Si.bridgeJSLower(transform)
    let ret = bjs_jsApplyInt(valueValue, transformPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsMakeAdder")
fileprivate func bjs_jsMakeAdder(_ base: Int32) -> Int32
#else
fileprivate func bjs_jsMakeAdder(_ base: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsMakeAdder(_ base: Int) throws(JSException) -> (Int) -> Int {
    let baseValue = base.bridgeJSLowerParameter()
    let ret = bjs_jsMakeAdder(baseValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_20BridgeJSRuntimeTestsSi_Si.bridgeJSLift(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsMapString")
fileprivate func bjs_jsMapString(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func bjs_jsMapString(_ value: Int32, _ transform: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsMapString(_ value: String, _ transform: @escaping (String) -> String) throws(JSException) -> String {
    let valueValue = value.bridgeJSLowerParameter()
    let transformPointer = _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLower(transform)
    let ret = bjs_jsMapString(valueValue, transformPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return String.bridgeJSLiftReturn(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsMakePrefixer")
fileprivate func bjs_jsMakePrefixer(_ prefix: Int32) -> Int32
#else
fileprivate func bjs_jsMakePrefixer(_ prefix: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsMakePrefixer(_ prefix: String) throws(JSException) -> (String) -> String {
    let prefixValue = prefix.bridgeJSLowerParameter()
    let ret = bjs_jsMakePrefixer(prefixValue)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return _BJS_Closure_20BridgeJSRuntimeTestsSS_SS.bridgeJSLift(ret)
}

#if arch(wasm32)
@_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_jsCallTwice")
fileprivate func bjs_jsCallTwice(_ value: Int32, _ callback: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func bjs_jsCallTwice(_ value: Int32, _ callback: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

func _$jsCallTwice(_ value: Int, _ callback: @escaping (Int) -> Void) throws(JSException) -> Int {
    let valueValue = value.bridgeJSLowerParameter()
    let callbackPointer = _BJS_Closure_20BridgeJSRuntimeTestsSi_y.bridgeJSLower(callback)
    let ret = bjs_jsCallTwice(valueValue, callbackPointer)
    if let error = _swift_js_take_exception() {
        throw error
    }
    return Int.bridgeJSLiftReturn(ret)
}