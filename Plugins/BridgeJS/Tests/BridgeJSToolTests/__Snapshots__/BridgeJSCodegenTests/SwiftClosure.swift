#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
fileprivate func invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO")
fileprivate func make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule10HttpStatusO_10HttpStatusO_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO")
fileprivate func make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule5ThemeO_5ThemeO_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule5ThemeO_5ThemeO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> Theme {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret0 = param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                let ret = invoke_js_callback_TestModule_10TestModule5ThemeO_5ThemeO(callbackValue, param0Bytes, param0Length)
                return ret
            }
            let ret = ret0
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
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV")
fileprivate func invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV_extern(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV(_ callback: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV")
fileprivate func make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModule6AnimalV_6AnimalV {
    static func bridgeJSLift(_ callbackId: Int32) -> (Animal) -> Animal {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let _ = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModule6AnimalV_6AnimalV(callbackValue)
            return Animal.bridgeJSLiftReturn()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Animal) -> Animal {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Animal) -> Animal) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV")
@_cdecl("invoke_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV")
public func _invoke_swift_closure_TestModule_10TestModule6AnimalV_6AnimalV(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Animal) -> Animal>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Animal.bridgeJSLiftParameter())
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC")
fileprivate func invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC_extern(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC(_ callback: Int32, _ param0: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return invoke_js_callback_TestModule_10TestModule6PersonC_6PersonC_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule6PersonC_6PersonC")
fileprivate func make_swift_closure_TestModule_10TestModule6PersonC_6PersonC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule6PersonC_6PersonC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule6PersonC_6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule6PersonC_6PersonC_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule9APIResultO_9APIResultO_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO")
fileprivate func make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule9APIResultO_9APIResultO_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModule9DirectionO_9DirectionO_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO")
fileprivate func make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModule9DirectionO_9DirectionO_extern(boxPtr, file, line)
}

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
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleKSS_Sb")
fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Sb_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Sb_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Sb(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleKSS_Sb_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleKSS_Sb")
fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleKSS_Sb_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleKSS_Sb {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) throws(JSException) -> Bool {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: String) throws(JSException) -> Bool in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret0 = param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                let ret = invoke_js_callback_TestModule_10TestModuleKSS_Sb(callbackValue, param0Bytes, param0Length)
                return ret
            }
            let ret = ret0
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Bool.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) throws(JSException) -> Bool {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) throws(JSException) -> Bool) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleKSS_Sb,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleKSS_Sb")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleKSS_Sb")
public func _invoke_swift_closure_TestModule_10TestModuleKSS_Sb(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) throws(JSException) -> Bool>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    do {
        let result = try closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
        return result.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: error.description)
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

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleKSS_Si")
fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Si_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Si_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleKSS_Si(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleKSS_Si_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleKSS_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleKSS_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleKSS_Si_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleKSS_Si {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) throws(JSException) -> Int {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: String) throws(JSException) -> Int in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret0 = param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                let ret = invoke_js_callback_TestModule_10TestModuleKSS_Si(callbackValue, param0Bytes, param0Length)
                return ret
            }
            let ret = ret0
            if let error = _swift_js_take_exception() {
                throw error
            }
            return Int.bridgeJSLiftReturn(ret)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) throws(JSException) -> Int {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) throws(JSException) -> Int) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleKSS_Si,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleKSS_Si")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleKSS_Si")
public func _invoke_swift_closure_TestModule_10TestModuleKSS_Si(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) throws(JSException) -> Int>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    do {
        let result = try closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
        return result.bridgeJSLowerReturn()
    } catch let error {
        if let error = error.thrownValue.object {
            withExtendedLifetime(error) {
                _swift_js_throw(Int32(bitPattern: $0.id))
            }
        } else {
            let jsError = JSError(message: error.description)
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

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSS_SS")
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_SS_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSS_SS_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSS_SS(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSS_SS_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSS_SS")
fileprivate func make_swift_closure_TestModule_10TestModuleSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSS_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let ret0 = param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                let ret = invoke_js_callback_TestModule_10TestModuleSS_SS(callbackValue, param0Bytes, param0Length)
                return ret
            }
            let ret = ret0
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
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSb_Sb_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSb_Sb(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSb_Sb_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSb_Sb")
fileprivate func make_swift_closure_TestModule_10TestModuleSb_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSb_Sb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSb_Sb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSb_Sb_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_Sd_extern(_ callback: Int32, _ param0: Float64) -> Float64
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSd_Sd_extern(_ callback: Int32, _ param0: Float64) -> Float64 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSd_Sd(_ callback: Int32, _ param0: Float64) -> Float64 {
    return invoke_js_callback_TestModule_10TestModuleSd_Sd_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSd_Sd")
fileprivate func make_swift_closure_TestModule_10TestModuleSd_Sd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSd_Sd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSd_Sd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSd_Sd_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSf_Sf_extern(_ callback: Int32, _ param0: Float32) -> Float32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSf_Sf_extern(_ callback: Int32, _ param0: Float32) -> Float32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSf_Sf(_ callback: Int32, _ param0: Float32) -> Float32 {
    return invoke_js_callback_TestModule_10TestModuleSf_Sf_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSf_Sf")
fileprivate func make_swift_closure_TestModule_10TestModuleSf_Sf_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSf_Sf_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSf_Sf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSf_Sf_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si_extern(_ callback: Int32, _ param0: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSi_Si(_ callback: Int32, _ param0: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSi_Si_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSi_Si")
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSi_Si(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSi_Si_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq10HttpStatusO_Sq10HttpStatusO_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(callback, param0IsSome, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSq5ThemeO_Sq5ThemeO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Theme>) -> Optional<Theme> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            param0.bridgeJSWithLoweredParameter { (param0IsSome, param0Bytes, param0Length) in
                invoke_js_callback_TestModule_10TestModuleSq5ThemeO_Sq5ThemeO(callbackValue, param0IsSome, param0Bytes, param0Length)
            }
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
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV")
fileprivate func make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSq6AnimalV_Sq6AnimalV {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Animal>) -> Optional<Animal> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0IsSome = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV(callbackValue, param0IsSome)
            return Optional<Animal>.bridgeJSLiftReturn()
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Optional<Animal>) -> Optional<Animal> {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Optional<Animal>) -> Optional<Animal>) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV")
public func _invoke_swift_closure_TestModule_10TestModuleSq6AnimalV_Sq6AnimalV(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Optional<Animal>) -> Optional<Animal>>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    let result = closure(Optional<Animal>.bridgeJSLiftParameter())
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ callback: Int32, _ param0IsSome: Int32, _ param0Pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return invoke_js_callback_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(callback, param0IsSome, param0Pointer)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC")
fileprivate func make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq6PersonC_Sq6PersonC_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ callback: Int32, _ param0IsSome: Int32, _ param0CaseId: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(callback, param0IsSome, param0CaseId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq9APIResultO_Sq9APIResultO_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO")
fileprivate func make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSq9DirectionO_Sq9DirectionO_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSS_SqSS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSS_SqSS_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSqSS_SqSS(_ callback: Int32, _ param0IsSome: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSqSS_SqSS_extern(callback, param0IsSome, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSS_SqSS")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSS_SqSS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSS_SqSS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSqSS_SqSS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSqSS_SqSS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleSqSS_SqSS {
    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<String>) -> Optional<String> {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            param0.bridgeJSWithLoweredParameter { (param0IsSome, param0Bytes, param0Length) in
                invoke_js_callback_TestModule_10TestModuleSqSS_SqSS(callbackValue, param0IsSome, param0Bytes, param0Length)
            }
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
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSb_SqSb_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSb_SqSb_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSqSb_SqSb(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Int32 {
    return invoke_js_callback_TestModule_10TestModuleSqSb_SqSb_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSb_SqSb")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSb_SqSb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSb_SqSb_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSqSb_SqSb(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSqSb_SqSb_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSd_SqSd_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSd_SqSd_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSqSd_SqSd(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSqSd_SqSd_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSd_SqSd")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSd_SqSd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSd_SqSd_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSqSd_SqSd(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSqSd_SqSd_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSf_SqSf_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSf_SqSf_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSqSf_SqSf(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Float32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSqSf_SqSf_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSf_SqSf")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSf_SqSf_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSf_SqSf_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSqSf_SqSf(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSqSf_SqSf_extern(boxPtr, file, line)
}

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
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSi_SqSi_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleSqSi_SqSi_extern(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleSqSi_SqSi(_ callback: Int32, _ param0IsSome: Int32, _ param0Value: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleSqSi_SqSi_extern(callback, param0IsSome, param0Value)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleSqSi_SqSi")
fileprivate func make_swift_closure_TestModule_10TestModuleSqSi_SqSi_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleSqSi_SqSi_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleSqSi_SqSi(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleSqSi_SqSi_extern(boxPtr, file, line)
}

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

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleYaKSS_SS")
fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSS_SS_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSS_SS_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSS_SS(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleYaKSS_SS_extern(resolveRef, rejectRef, callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleYaKSS_SS")
fileprivate func make_swift_closure_TestModule_10TestModuleYaKSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleYaKSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleYaKSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleYaKSS_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleYaKSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) async throws(JSException) -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: String) async throws(JSException) -> String in
            #if arch(wasm32)
            let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
                    JSTypedClosure<(sending String) -> Void>($0)
                }, makeRejectClosure: {
                    JSTypedClosure<(sending JSValue) -> Void>($0)
                }) { resolveRef, rejectRef in
                let callbackValue = callback.bridgeJSLowerParameter()
                param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                    invoke_js_callback_TestModule_10TestModuleYaKSS_SS(resolveRef, rejectRef, callbackValue, param0Bytes, param0Length)
                }
            }
            return resolved
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) async throws(JSException) -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) async throws(JSException) -> String) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleYaKSS_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleYaKSS_SS")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleYaKSS_SS")
public func _invoke_swift_closure_TestModule_10TestModuleYaKSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) async throws(JSException) -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    return _bjs_makePromise(resolve: Promise_resolve_SS, reject: Promise_reject) { () async throws(JSException) -> String in
        return try await closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO")
fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO_extern(resolveRef, rejectRef, callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO")
fileprivate func make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleYaKSb_9APIResultO {
    static func bridgeJSLift(_ callbackId: Int32) -> (Bool) async throws(JSException) -> APIResult {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: Bool) async throws(JSException) -> APIResult in
            #if arch(wasm32)
            let resolved = try await _bjs_awaitPromise(makeResolveClosure: {
                    JSTypedClosure<(sending APIResult) -> Void>($0)
                }, makeRejectClosure: {
                    JSTypedClosure<(sending JSValue) -> Void>($0)
                }) { resolveRef, rejectRef in
                let callbackValue = callback.bridgeJSLowerParameter()
                let param0Value = param0.bridgeJSLowerParameter()
                invoke_js_callback_TestModule_10TestModuleYaKSb_9APIResultO(resolveRef, rejectRef, callbackValue, param0Value)
            }
            return resolved
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (Bool) async throws(JSException) -> APIResult {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (Bool) async throws(JSException) -> APIResult) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO")
public func _invoke_swift_closure_TestModule_10TestModuleYaKSb_9APIResultO(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(Bool) async throws(JSException) -> APIResult>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    return _bjs_makePromise(resolve: Promise_resolve_9APIResultO, reject: Promise_reject) { () async throws(JSException) -> APIResult in
        return try await closure(Bool.bridgeJSLiftParameter(param0))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV")
fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV_extern(resolveRef, rejectRef, callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV")
fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleYaSS_6AnimalV {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) async -> Animal {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: String) async -> Animal in
            #if arch(wasm32)
            let resolved = try! await _bjs_awaitPromise(makeResolveClosure: {
                    JSTypedClosure<(sending Animal) -> Void>($0)
                }, makeRejectClosure: {
                    JSTypedClosure<(sending JSValue) -> Void>($0)
                }) { resolveRef, rejectRef in
                let callbackValue = callback.bridgeJSLowerParameter()
                param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                    invoke_js_callback_TestModule_10TestModuleYaSS_6AnimalV(resolveRef, rejectRef, callbackValue, param0Bytes, param0Length)
                }
            }
            return resolved
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) async -> Animal {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) async -> Animal) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleYaSS_6AnimalV,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleYaSS_6AnimalV")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleYaSS_6AnimalV")
public func _invoke_swift_closure_TestModule_10TestModuleYaSS_6AnimalV(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) async -> Animal>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    return _bjs_makePromise(resolve: Promise_resolve_6AnimalV, reject: Promise_reject) {
        return await closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModuleYaSS_SS")
fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_SS_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_SS_extern(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModuleYaSS_SS(_ resolveRef: Int32, _ rejectRef: Int32, _ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModuleYaSS_SS_extern(resolveRef, rejectRef, callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModuleYaSS_SS")
fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_SS_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModuleYaSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModuleYaSS_SS_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModuleYaSS_SS {
    static func bridgeJSLift(_ callbackId: Int32) -> (String) async -> String {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] (param0: String) async -> String in
            #if arch(wasm32)
            let resolved = try! await _bjs_awaitPromise(makeResolveClosure: {
                    JSTypedClosure<(sending String) -> Void>($0)
                }, makeRejectClosure: {
                    JSTypedClosure<(sending JSValue) -> Void>($0)
                }) { resolveRef, rejectRef in
                let callbackValue = callback.bridgeJSLowerParameter()
                param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                    invoke_js_callback_TestModule_10TestModuleYaSS_SS(resolveRef, rejectRef, callbackValue, param0Bytes, param0Length)
                }
            }
            return resolved
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (String) async -> String {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (String) async -> String) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModuleYaSS_SS,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModuleYaSS_SS")
@_cdecl("invoke_swift_closure_TestModule_10TestModuleYaSS_SS")
public func _invoke_swift_closure_TestModule_10TestModuleYaSS_SS(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(String) async -> String>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    return _bjs_makePromise(resolve: Promise_resolve_SS, reject: Promise_reject) {
        return await closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    }
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules6AnimalV_y")
fileprivate func invoke_js_callback_TestModule_10TestModules6AnimalV_y_extern(_ callback: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules6AnimalV_y_extern(_ callback: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules6AnimalV_y(_ callback: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModules6AnimalV_y_extern(callback)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules6AnimalV_y")
fileprivate func make_swift_closure_TestModule_10TestModules6AnimalV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules6AnimalV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules6AnimalV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules6AnimalV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules6AnimalV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending Animal) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let _ = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules6AnimalV_y(callbackValue)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending Animal) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending Animal) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModules6AnimalV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules6AnimalV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules6AnimalV_y")
public func _invoke_swift_closure_TestModule_10TestModules6AnimalV_y(_ boxPtr: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending Animal) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(Animal.bridgeJSLiftParameter())
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules7JSValueV_y")
fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules7JSValueV_y(_ callback: Int32, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    return invoke_js_callback_TestModule_10TestModules7JSValueV_y_extern(callback, param0Kind, param0Payload1, param0Payload2)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules7JSValueV_y")
fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules7JSValueV_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules7JSValueV_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending JSValue) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let (param0Kind, param0Payload1, param0Payload2) = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules7JSValueV_y(callbackValue, param0Kind, param0Payload1, param0Payload2)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending JSValue) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending JSValue) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModules7JSValueV_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules7JSValueV_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules7JSValueV_y")
public func _invoke_swift_closure_TestModule_10TestModules7JSValueV_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Kind: Int32, _ param0Payload1: Int32, _ param0Payload2: Float64) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending JSValue) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(JSValue.bridgeJSLiftParameter(param0Kind, param0Payload1, param0Payload2))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModules9APIResultO_y")
fileprivate func invoke_js_callback_TestModule_10TestModules9APIResultO_y_extern(_ callback: Int32, _ param0: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModules9APIResultO_y_extern(_ callback: Int32, _ param0: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModules9APIResultO_y(_ callback: Int32, _ param0: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModules9APIResultO_y_extern(callback, param0)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModules9APIResultO_y")
fileprivate func make_swift_closure_TestModule_10TestModules9APIResultO_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModules9APIResultO_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModules9APIResultO_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModules9APIResultO_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModules9APIResultO_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending APIResult) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            let param0CaseId = param0.bridgeJSLowerParameter()
            invoke_js_callback_TestModule_10TestModules9APIResultO_y(callbackValue, param0CaseId)
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending APIResult) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending APIResult) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModules9APIResultO_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModules9APIResultO_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModules9APIResultO_y")
public func _invoke_swift_closure_TestModule_10TestModules9APIResultO_y(_ boxPtr: UnsafeMutableRawPointer, _ param0: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending APIResult) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(APIResult.bridgeJSLiftParameter(param0))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "invoke_js_callback_TestModule_10TestModulesSS_y")
fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void
#else
fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y_extern(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func invoke_js_callback_TestModule_10TestModulesSS_y(_ callback: Int32, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    return invoke_js_callback_TestModule_10TestModulesSS_y_extern(callback, param0Bytes, param0Length)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "make_swift_closure_TestModule_10TestModulesSS_y")
fileprivate func make_swift_closure_TestModule_10TestModulesSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
#else
fileprivate func make_swift_closure_TestModule_10TestModulesSS_y_extern(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func make_swift_closure_TestModule_10TestModulesSS_y(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
    return make_swift_closure_TestModule_10TestModulesSS_y_extern(boxPtr, file, line)
}

private enum _BJS_Closure_10TestModulesSS_y {
    static func bridgeJSLift(_ callbackId: Int32) -> (sending String) -> Void {
        let callback = JSObject.bridgeJSLiftParameter(callbackId)
        return { [callback] param0 in
            #if arch(wasm32)
            let callbackValue = callback.bridgeJSLowerParameter()
            param0.bridgeJSWithLoweredParameter { (param0Bytes, param0Length) in
                invoke_js_callback_TestModule_10TestModulesSS_y(callbackValue, param0Bytes, param0Length)
            }
            #else
            fatalError("Only available on WebAssembly")
            #endif
        }
    }
}

extension JSTypedClosure where Signature == (sending String) -> Void {
    init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping (sending String) -> Void) {
        self.init(
            makeClosure: make_swift_closure_TestModule_10TestModulesSS_y,
            body: body,
            fileID: fileID,
            line: line
        )
    }
}

@_expose(wasm, "invoke_swift_closure_TestModule_10TestModulesSS_y")
@_cdecl("invoke_swift_closure_TestModule_10TestModulesSS_y")
public func _invoke_swift_closure_TestModule_10TestModulesSS_y(_ boxPtr: UnsafeMutableRawPointer, _ param0Bytes: Int32, _ param0Length: Int32) -> Void {
    #if arch(wasm32)
    let closure = Unmanaged<_BridgeJSTypedClosureBox<(sending String) -> Void>>.fromOpaque(boxPtr).takeUnretainedValue().closure
    closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
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

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
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

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
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

extension Animal: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> Animal {
        let type = String.bridgeJSStackPop()
        return Animal(type: type)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.type.bridgeJSStackPush()
    }

    public init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_Animal(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    public func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_Animal()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_Animal")
fileprivate func _bjs_struct_lower_Animal_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_Animal_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_Animal(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_Animal_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_Animal")
fileprivate func _bjs_struct_lift_Animal_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_Animal_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_Animal() -> Int32 {
    return _bjs_struct_lift_Animal_extern()
}

@_expose(wasm, "bjs_Animal_init")
@_cdecl("bjs_Animal_init")
public func _bjs_Animal_init(_ typeBytes: Int32, _ typeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = Animal(type: String.bridgeJSLiftParameter(typeBytes, typeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAnimal")
@_cdecl("bjs_roundtripAnimal")
public func _bjs_roundtripAnimal(_ animalClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripAnimal(_: _BJS_Closure_10TestModule6AnimalV_6AnimalV.bridgeJSLift(animalClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripOptionalAnimal")
@_cdecl("bjs_roundtripOptionalAnimal")
public func _bjs_roundtripOptionalAnimal(_ animalClosure: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripOptionalAnimal(_: _BJS_Closure_10TestModuleSq6AnimalV_Sq6AnimalV.bridgeJSLift(animalClosure))
    return JSTypedClosure(ret).bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
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

@_expose(wasm, "bjs_makeThrowingParser")
@_cdecl("bjs_makeThrowingParser")
public func _bjs_makeThrowingParser() -> Int32 {
    #if arch(wasm32)
    let ret = makeThrowingParser()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_validateWith")
@_cdecl("bjs_validateWith")
public func _bjs_validateWith(_ validate: Int32) -> Void {
    #if arch(wasm32)
    validateWith(_: _BJS_Closure_10TestModuleKSS_Sb.bridgeJSLift(validate))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeFetcher")
@_cdecl("bjs_makeFetcher")
public func _bjs_makeFetcher() -> Int32 {
    #if arch(wasm32)
    let ret = makeFetcher()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAsyncEcho")
@_cdecl("bjs_makeAsyncEcho")
public func _bjs_makeAsyncEcho() -> Int32 {
    #if arch(wasm32)
    let ret = makeAsyncEcho()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAnimalLoader")
@_cdecl("bjs_makeAnimalLoader")
public func _bjs_makeAnimalLoader() -> Int32 {
    #if arch(wasm32)
    let ret = makeAnimalLoader()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeResultLoader")
@_cdecl("bjs_makeResultLoader")
public func _bjs_makeResultLoader() -> Int32 {
    #if arch(wasm32)
    let ret = makeResultLoader()
    return ret.bridgeJSLowerReturn()
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

extension Person: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    public var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Person_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    public consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_Person_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Person_wrap")
fileprivate func _bjs_Person_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Person_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_Person_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_Person_wrap_extern(pointer)
}

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

extension TestProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_TestProcessor_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_TestProcessor_wrap")
fileprivate func _bjs_TestProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_TestProcessor_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_TestProcessor_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_TestProcessor_wrap_extern(pointer)
}

@JSFunction func Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_reject_TestModule")
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void
#else
fileprivate func promise_reject_TestModule_extern(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_reject_TestModule(_ promise: Int32, _ valueKind: Int32, _ valuePayload1: Int32, _ valuePayload2: Float64) -> Void {
    return promise_reject_TestModule_extern(promise, valueKind, valuePayload1, valuePayload2)
}

func _$Promise_reject(_ promise: JSObject, _ value: JSValue) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let (valueKind, valuePayload1, valuePayload2) = value.bridgeJSLowerParameter()
    promise_reject_TestModule(promiseValue, valueKind, valuePayload1, valuePayload2)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_SS(_ promise: JSObject, _ value: String) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_SS")
fileprivate func promise_resolve_TestModule_SS_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_SS_extern(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_SS(_ promise: Int32, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    return promise_resolve_TestModule_SS_extern(promise, valueBytes, valueLength)
}

func _$Promise_resolve_SS(_ promise: JSObject, _ value: String) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    value.bridgeJSWithLoweredParameter { (valueBytes, valueLength) in
        promise_resolve_TestModule_SS(promiseValue, valueBytes, valueLength)
    }
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_6AnimalV(_ promise: JSObject, _ value: Animal) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_6AnimalV")
fileprivate func promise_resolve_TestModule_6AnimalV_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_6AnimalV_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_6AnimalV(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_6AnimalV_extern(promise, value)
}

func _$Promise_resolve_6AnimalV(_ promise: JSObject, _ value: Animal) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueObjectId = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_6AnimalV(promiseValue, valueObjectId)
    if let error = _swift_js_take_exception() { throw error }
}

@JSFunction func Promise_resolve_9APIResultO(_ promise: JSObject, _ value: APIResult) throws(JSException)

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "promise_resolve_TestModule_9APIResultO")
fileprivate func promise_resolve_TestModule_9APIResultO_extern(_ promise: Int32, _ value: Int32) -> Void
#else
fileprivate func promise_resolve_TestModule_9APIResultO_extern(_ promise: Int32, _ value: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func promise_resolve_TestModule_9APIResultO(_ promise: Int32, _ value: Int32) -> Void {
    return promise_resolve_TestModule_9APIResultO_extern(promise, value)
}

func _$Promise_resolve_9APIResultO(_ promise: JSObject, _ value: APIResult) throws(JSException) -> Void {
    let promiseValue = promise.bridgeJSLowerParameter()
    let valueCaseId = value.bridgeJSLowerParameter()
    promise_resolve_TestModule_9APIResultO(promiseValue, valueCaseId)
    if let error = _swift_js_take_exception() { throw error }
}