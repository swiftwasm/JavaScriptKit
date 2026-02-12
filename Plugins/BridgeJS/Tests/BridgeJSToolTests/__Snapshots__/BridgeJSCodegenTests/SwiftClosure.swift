#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
fileprivate func invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
fileprivate func make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModule10HttpStatusO_10HttpStatusO {
    static func bridgeJSLift(_ callbackId: Int32) -> (HttpStatus) -> HttpStatus {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO(callbackValue, param0Value)
            return HttpStatus.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (HttpStatus) -> HttpStatus {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (HttpStatus) -> HttpStatus) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
@_cdecl("invoke_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
public func _invoke_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(HttpStatus) -> HttpStatus>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(HttpStatus.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO")
fileprivate func invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO")
fileprivate func make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModule5ThemeO_5ThemeO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> Theme {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO(callbackValue, param0Value)
            return Theme.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Theme) -> Theme {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Theme) -> Theme) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO")
@_cdecl("invoke_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO")
public func _invoke_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Theme) -> Theme>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC")
fileprivate func invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule6PersonC_6PersonC")
fileprivate func make_swift_closure_TestModule_10TestModule6PersonC_6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule6PersonC_6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModule6PersonC_6PersonC {
    static func bridgeJSLift(_ callbackId: Int32) -> (Person) -> Person {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Pointer = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC(callbackValue, param0Pointer)
            return Person.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Person) -> Person {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Person) -> Person) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule6PersonC_6PersonC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule6PersonC_6PersonC")
@_cdecl("invoke_swift_closure_TestModule_10TestModule6PersonC_6PersonC")
public func _invoke_swift_closure_TestModule_10TestModule6PersonC_6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Person) -> Person>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Person.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO")
fileprivate func invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO")
fileprivate func make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModule9APIResultO_9APIResultO {
    static func bridgeJSLift(_ callbackId: Int32) -> (APIResult) -> APIResult {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0CaseId = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO(callbackValue, param0CaseId)
            return APIResult.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (APIResult) -> APIResult {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (APIResult) -> APIResult) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO")
@_cdecl("invoke_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO")
public func _invoke_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(APIResult) -> APIResult>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(APIResult.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO")
fileprivate func invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO")
fileprivate func make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModule9DirectionO_9DirectionO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Direction) -> Direction {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO(callbackValue, param0Value)
            return Direction.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Direction) -> Direction {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Direction) -> Direction) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO")
@_cdecl("invoke_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO")
public func _invoke_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Direction) -> Direction>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Direction.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSS_SS")
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_SS(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_SS(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSS_SS")
fileprivate func make_swift_closure_TestModule_10TestModuleSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSS_SS(callbackValue, param0Value)
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
            makeClosure: make_swift_closure_TestModule_10TestModuleSS_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSS_SS")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSS_SS")
public func _invoke_swift_closure_TestModule_10TestModuleSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSb_Sb")
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_Sb(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSb_Sb")
fileprivate func make_swift_closure_TestModule_10TestModuleSb_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSb_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSb_Sb {
    static func bridgeJSLift(_ callbackId: Int32) -> (Bool) -> Bool {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSb_Sb(callbackValue, param0Value)
            return Bool.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Bool) -> Bool {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Bool) -> Bool) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSb_Sb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSb_Sb")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSb_Sb")
public func _invoke_swift_closure_TestModule_10TestModuleSb_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Bool) -> Bool>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Bool.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSd_Sd")
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSd_Sd")
fileprivate func make_swift_closure_TestModule_10TestModuleSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSd_Sd {
    static func bridgeJSLift(_ callbackId: Int32) -> (Double) -> Double {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSd_Sd(callbackValue, param0Value)
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
            makeClosure: make_swift_closure_TestModule_10TestModuleSd_Sd,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSd_Sd")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSd_Sd")
public func _invoke_swift_closure_TestModule_10TestModuleSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ param0: Float64) -> Float64 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Double) -> Double>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Double.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSf_Sf")
fileprivate func invoke_js_callback_TestModule_10TestModuleSf_Sf(_ callback: Int32, _ param0: Float32) -> Float32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSf_Sf(_ callback: Int32, _ param0: Float32) -> Float32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSf_Sf")
fileprivate func make_swift_closure_TestModule_10TestModuleSf_Sf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSf_Sf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSf_Sf {
    static func bridgeJSLift(_ callbackId: Int32) -> (Float) -> Float {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSf_Sf(callbackValue, param0Value)
            return Float.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Float) -> Float {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Float) -> Float) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSf_Sf,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSf_Sf")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSf_Sf")
public func _invoke_swift_closure_TestModule_10TestModuleSf_Sf(_ boxPtr: UnsafeMutableRawPointer, _ param0: Float32) -> Float32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Float) -> Float>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Float.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSi_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSi_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSi_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (Int) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0Value = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSi_Si(callbackValue, param0Value)
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
            makeClosure: make_swift_closure_TestModule_10TestModuleSi_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSi_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSi_Si")
public func _invoke_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Int) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Int.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSq10HttpStatusO_Sq10HttpStatusO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<HttpStatus>) -> Optional<HttpStatus> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(callbackValue, param0IsSome, param0Value)
            return Optional<HttpStatus>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<HttpStatus>) -> Optional<HttpStatus> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<HttpStatus>) -> Optional<HttpStatus>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO")
public func _invoke_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<HttpStatus>) -> Optional<HttpStatus>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<HttpStatus>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSq5ThemeO_Sq5ThemeO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Theme>) -> Optional<Theme> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(callbackValue, param0IsSome, param0Value)
            return Optional<Theme>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Theme>) -> Optional<Theme> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Theme>) -> Optional<Theme>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO")
public func _invoke_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Theme>) -> Optional<Theme>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Theme>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
fileprivate func make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSq6PersonC_Sq6PersonC {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Person>) -> Optional<Person> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Pointer) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC(callbackValue, param0IsSome, param0Pointer)
            return Optional<Person>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Person>) -> Optional<Person> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Person>) -> Optional<Person>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
public func _invoke_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Person>) -> Optional<Person>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Person>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSq9APIResultO_Sq9APIResultO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<APIResult>) -> Optional<APIResult> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0CaseId) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(callbackValue, param0IsSome, param0CaseId)
            return Optional<APIResult>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<APIResult>) -> Optional<APIResult> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<APIResult>) -> Optional<APIResult>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO")
public func _invoke_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<APIResult>) -> Optional<APIResult>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<APIResult>.bridgeJSLiftParameter(param0IsSome, param0CaseId))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSq9DirectionO_Sq9DirectionO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Direction>) -> Optional<Direction> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(callbackValue, param0IsSome, param0Value)
            return Optional<Direction>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Direction>) -> Optional<Direction> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Direction>) -> Optional<Direction>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO")
public func _invoke_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Direction>) -> Optional<Direction>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Direction>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSqSS_SqSS")
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSS_SqSS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSS_SqSS(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSS_SqSS")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSS_SqSS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSS_SqSS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSqSS_SqSS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<String>) -> Optional<String> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSqSS_SqSS(callbackValue, param0IsSome, param0Value)
            return Optional<String>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<String>) -> Optional<String> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<String>) -> Optional<String>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSqSS_SqSS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSqSS_SqSS")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSqSS_SqSS")
public func _invoke_swift_closure_TestModule_10TestModuleSqSS_SqSS(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<String>) -> Optional<String>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<String>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSqSb_SqSb")
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSb_SqSb(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSb_SqSb(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSb_SqSb")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSb_SqSb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSb_SqSb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSqSb_SqSb {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Bool>) -> Optional<Bool> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            let ret = invoke_js_callback_TestModule_10TestModuleSqSb_SqSb(callbackValue, param0IsSome, param0Value)
            return Optional<Bool>.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Bool>) -> Optional<Bool> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Bool>) -> Optional<Bool>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSqSb_SqSb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSqSb_SqSb")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSqSb_SqSb")
public func _invoke_swift_closure_TestModule_10TestModuleSqSb_SqSb(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Bool>) -> Optional<Bool>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Bool>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSqSd_SqSd")
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSd_SqSd(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSd_SqSd(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSd_SqSd")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSd_SqSd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSd_SqSd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSqSd_SqSd {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Double>) -> Optional<Double> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSqSd_SqSd(callbackValue, param0IsSome, param0Value)
            return Optional<Double>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Double>) -> Optional<Double> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Double>) -> Optional<Double>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSqSd_SqSd,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSqSd_SqSd")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSqSd_SqSd")
public func _invoke_swift_closure_TestModule_10TestModuleSqSd_SqSd(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Double>) -> Optional<Double>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Double>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSqSf_SqSf")
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSf_SqSf(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSf_SqSf(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSf_SqSf")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSf_SqSf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSf_SqSf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSqSf_SqSf {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Float>) -> Optional<Float> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSqSf_SqSf(callbackValue, param0IsSome, param0Value)
            return Optional<Float>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Float>) -> Optional<Float> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Float>) -> Optional<Float>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSqSf_SqSf,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSqSf_SqSf")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSqSf_SqSf")
public func _invoke_swift_closure_TestModule_10TestModuleSqSf_SqSf(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Float32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Float>) -> Optional<Float>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Float>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSqSi_SqSi")
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSi_SqSi(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSi_SqSi(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSi_SqSi")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSi_SqSi(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSi_SqSi(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

private enum _BJS_Closure_10TestModuleSqSi_SqSi {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Int>) -> Optional<Int> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0IsSome, param0Value) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSqSi_SqSi(callbackValue, param0IsSome, param0Value)
            return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Int>) -> Optional<Int> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Int>) -> Optional<Int>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSqSi_SqSi,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSqSi_SqSi")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSqSi_SqSi")
public func _invoke_swift_closure_TestModule_10TestModuleSqSi_SqSi(_ boxPtr: UnsafeMutableRawPointer, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Int>) -> Optional<Int>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Int>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
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

extension Theme: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension APIResult: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> APIResult {
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

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
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
}

@_expose(wasm, "bjs_roundtripString")
@_cdecl("bjs_roundtripString")
public func _bjs_roundtripString(_ stringClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripString(_: _BJS_Closure_10TestModuleSS_SS.bridgeJSLift(stringClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripInt")
@_cdecl("bjs_roundtripInt")
public func _bjs_roundtripInt(_ intClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripInt(_: _BJS_Closure_10TestModuleSi_Si.bridgeJSLift(intClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripBool")
@_cdecl("bjs_roundtripBool")
public func _bjs_roundtripBool(_ boolClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripBool(_: _BJS_Closure_10TestModuleSb_Sb.bridgeJSLift(boolClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripFloat")
@_cdecl("bjs_roundtripFloat")
public func _bjs_roundtripFloat(_ floatClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripFloat(_: _BJS_Closure_10TestModuleSf_Sf.bridgeJSLift(floatClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripDouble")
@_cdecl("bjs_roundtripDouble")
public func _bjs_roundtripDouble(_ doubleClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripDouble(_: _BJS_Closure_10TestModuleSd_Sd.bridgeJSLift(doubleClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalString")
@_cdecl("bjs_roundtripOptionalString")
public func _bjs_roundtripOptionalString(_ stringClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalString(_: _BJS_Closure_10TestModuleSqSS_SqSS.bridgeJSLift(stringClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalInt")
@_cdecl("bjs_roundtripOptionalInt")
public func _bjs_roundtripOptionalInt(_ intClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalInt(_: _BJS_Closure_10TestModuleSqSi_SqSi.bridgeJSLift(intClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalBool")
@_cdecl("bjs_roundtripOptionalBool")
public func _bjs_roundtripOptionalBool(_ boolClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalBool(_: _BJS_Closure_10TestModuleSqSb_SqSb.bridgeJSLift(boolClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalFloat")
@_cdecl("bjs_roundtripOptionalFloat")
public func _bjs_roundtripOptionalFloat(_ floatClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalFloat(_: _BJS_Closure_10TestModuleSqSf_SqSf.bridgeJSLift(floatClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalDouble")
@_cdecl("bjs_roundtripOptionalDouble")
public func _bjs_roundtripOptionalDouble(_ doubleClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalDouble(_: _BJS_Closure_10TestModuleSqSd_SqSd.bridgeJSLift(doubleClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripPerson")
@_cdecl("bjs_roundtripPerson")
public func _bjs_roundtripPerson(_ personClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripPerson(_: _BJS_Closure_10TestModule6PersonC_6PersonC.bridgeJSLift(personClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalPerson")
@_cdecl("bjs_roundtripOptionalPerson")
public func _bjs_roundtripOptionalPerson(_ personClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalPerson(_: _BJS_Closure_10TestModuleSq6PersonC_Sq6PersonC.bridgeJSLift(personClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripDirection")
@_cdecl("bjs_roundtripDirection")
public func _bjs_roundtripDirection(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripDirection(_: _BJS_Closure_10TestModule9DirectionO_9DirectionO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripTheme")
@_cdecl("bjs_roundtripTheme")
public func _bjs_roundtripTheme(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripTheme(_: _BJS_Closure_10TestModule5ThemeO_5ThemeO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripHttpStatus")
@_cdecl("bjs_roundtripHttpStatus")
public func _bjs_roundtripHttpStatus(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripHttpStatus(_: _BJS_Closure_10TestModule10HttpStatusO_10HttpStatusO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPIResult")
@_cdecl("bjs_roundtripAPIResult")
public func _bjs_roundtripAPIResult(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripAPIResult(_: _BJS_Closure_10TestModule9APIResultO_9APIResultO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalDirection")
@_cdecl("bjs_roundtripOptionalDirection")
public func _bjs_roundtripOptionalDirection(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalDirection(_: _BJS_Closure_10TestModuleSq9DirectionO_Sq9DirectionO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalTheme")
@_cdecl("bjs_roundtripOptionalTheme")
public func _bjs_roundtripOptionalTheme(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalTheme(_: _BJS_Closure_10TestModuleSq5ThemeO_Sq5ThemeO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalHttpStatus")
@_cdecl("bjs_roundtripOptionalHttpStatus")
public func _bjs_roundtripOptionalHttpStatus(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalHttpStatus(_: _BJS_Closure_10TestModuleSq10HttpStatusO_Sq10HttpStatusO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalAPIResult")
@_cdecl("bjs_roundtripOptionalAPIResult")
public func _bjs_roundtripOptionalAPIResult(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalAPIResult(_: _BJS_Closure_10TestModuleSq9APIResultO_Sq9APIResultO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalDirection")
@_cdecl("bjs_roundtripOptionalDirection")
public func _bjs_roundtripOptionalDirection(_ callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalDirection(_: _BJS_Closure_10TestModuleSq9DirectionO_Sq9DirectionO.bridgeJSLift(callback))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Person_init")
@_cdecl("bjs_Person_init")
public func _bjs_Person_init(_ nameBytes: Int32, _ nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Person(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Person_deinit")
@_cdecl("bjs_Person_deinit")
public func _bjs_Person_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Person>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Person: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Person_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Person_wrap")
fileprivate func _bjs_Person_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Person_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_TestProcessor_init")
@_cdecl("bjs_TestProcessor_init")
public func _bjs_TestProcessor_init(_ transform: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor(transform: _BJS_Closure_10TestModuleSS_SS.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_deinit")
@_cdecl("bjs_TestProcessor_deinit")
public func _bjs_TestProcessor_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<TestProcessor>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension TestProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_TestProcessor_wrap")
fileprivate func _bjs_TestProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif