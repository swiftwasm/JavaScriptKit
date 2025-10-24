// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

private final class _BJS_ClosureBox_APIResult_To_String: _BridgedSwiftClosureBox {
    let closure: (APIResult) -> String
    init(_ closure: @escaping (APIResult) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_APIResult_To_String {
    static func bridgeJSLower(_ closure: @escaping (APIResult) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_APIResult_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (APIResult) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_apiresult_to_string")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_apiresult_to_string")
@_cdecl("invoke_swift_closure_apiresult_to_string")
public func _invoke_swift_closure_apiresult_to_string(boxPtr: UnsafeMutableRawPointer, param0: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_APIResult_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(APIResult.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_Direction_To_Bool: _BridgedSwiftClosureBox {
    let closure: (Direction) -> Bool
    init(_ closure: @escaping (Direction) -> Bool) {
        self.closure = closure
    }
}

private enum _BJS_Closure_Direction_To_Bool {
    static func bridgeJSLower(_ closure: @escaping (Direction) -> Bool) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_Direction_To_Bool(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Direction) -> Bool {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_direction_to_bool")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return Bool.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_direction_to_bool")
@_cdecl("invoke_swift_closure_direction_to_bool")
public func _invoke_swift_closure_direction_to_bool(boxPtr: UnsafeMutableRawPointer, param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_Direction_To_Bool>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Direction.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_Direction_To_String: _BridgedSwiftClosureBox {
    let closure: (Direction) -> String
    init(_ closure: @escaping (Direction) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_Direction_To_String {
    static func bridgeJSLower(_ closure: @escaping (Direction) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_Direction_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Direction) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_direction_to_string")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_direction_to_string")
@_cdecl("invoke_swift_closure_direction_to_string")
public func _invoke_swift_closure_direction_to_string(boxPtr: UnsafeMutableRawPointer, param0: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_Direction_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Direction.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_HttpStatus_To_Int: _BridgedSwiftClosureBox {
    let closure: (HttpStatus) -> Int
    init(_ closure: @escaping (HttpStatus) -> Int) {
        self.closure = closure
    }
}

private enum _BJS_Closure_HttpStatus_To_Int {
    static func bridgeJSLower(_ closure: @escaping (HttpStatus) -> Int) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_HttpStatus_To_Int(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (HttpStatus) -> Int {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_httpstatus_to_int")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return Int.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_httpstatus_to_int")
@_cdecl("invoke_swift_closure_httpstatus_to_int")
public func _invoke_swift_closure_httpstatus_to_int(boxPtr: UnsafeMutableRawPointer, param0: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_HttpStatus_To_Int>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(HttpStatus.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_OptionalAPIResult_To_String: _BridgedSwiftClosureBox {
    let closure: (Optional<APIResult>) -> String
    init(_ closure: @escaping (Optional<APIResult>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_OptionalAPIResult_To_String {
    static func bridgeJSLower(_ closure: @escaping (Optional<APIResult>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_OptionalAPIResult_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<APIResult>) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_optionalapiresult_to_string")
                func _invoke(_: Int32, _: Int32, _: Int32) -> Int32
                let (param0IsSome, param0Value) = param0.bridgeJSLowerParameterWithPresence()
let resultId = _invoke(owner.callbackId, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_optionalapiresult_to_string")
@_cdecl("invoke_swift_closure_optionalapiresult_to_string")
public func _invoke_swift_closure_optionalapiresult_to_string(boxPtr: UnsafeMutableRawPointer, param0IsSome: Int32, param0CaseId: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_OptionalAPIResult_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<APIResult>.bridgeJSLiftParameter(param0IsSome, param0CaseId))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_OptionalDirection_To_String: _BridgedSwiftClosureBox {
    let closure: (Optional<Direction>) -> String
    init(_ closure: @escaping (Optional<Direction>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_OptionalDirection_To_String {
    static func bridgeJSLower(_ closure: @escaping (Optional<Direction>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_OptionalDirection_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Direction>) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_optionaldirection_to_string")
                func _invoke(_: Int32, _: Int32, _: Int32) -> Int32
                let (param0IsSome, param0Value) = param0.bridgeJSLowerParameterWithPresence()
let resultId = _invoke(owner.callbackId, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_optionaldirection_to_string")
@_cdecl("invoke_swift_closure_optionaldirection_to_string")
public func _invoke_swift_closure_optionaldirection_to_string(boxPtr: UnsafeMutableRawPointer, param0IsSome: Int32, param0Value: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_OptionalDirection_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Direction>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_OptionalPerson_OptionalString_OptionalDouble_To_String: _BridgedSwiftClosureBox {
    let closure: (Optional<Person>, Optional<String>, Optional<Double>) -> String
    init(_ closure: @escaping (Optional<Person>, Optional<String>, Optional<Double>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_OptionalPerson_OptionalString_OptionalDouble_To_String {
    static func bridgeJSLower(_ closure: @escaping (Optional<Person>, Optional<String>, Optional<Double>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_OptionalPerson_OptionalString_OptionalDouble_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Person>, Optional<String>, Optional<Double>) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0, param1, param2 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_optionalperson_optionalstring_optionaldouble_to_string")
                func _invoke(_: Int32, _: Int32, _: UnsafeMutableRawPointer, _: Int32, _: Int32, _: Int32, _: Float64) -> Int32
                let (param0IsSome, param0Value) = param0.bridgeJSLowerParameterWithRetain()
let (param1IsSome, param1Value) = param1.bridgeJSLowerParameterWithPresence()
let (param2IsSome, param2Value) = param2.bridgeJSLowerParameterWithPresence()
let resultId = _invoke(owner.callbackId, param0IsSome, param0Value, param1IsSome, param1Value, param2IsSome, param2Value)
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_optionalperson_optionalstring_optionaldouble_to_string")
@_cdecl("invoke_swift_closure_optionalperson_optionalstring_optionaldouble_to_string")
public func _invoke_swift_closure_optionalperson_optionalstring_optionaldouble_to_string(boxPtr: UnsafeMutableRawPointer, param0IsSome: Int32, param0Value: UnsafeMutableRawPointer, param1IsSome: Int32, param1Bytes: Int32, param1Length: Int32, param2IsSome: Int32, param2Value: Float64) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_OptionalPerson_OptionalString_OptionalDouble_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Person>.bridgeJSLiftParameter(param0IsSome, param0Value), Optional<String>.bridgeJSLiftParameter(param1IsSome, param1Bytes, param1Length), Optional<Double>.bridgeJSLiftParameter(param2IsSome, param2Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_OptionalPerson_To_String: _BridgedSwiftClosureBox {
    let closure: (Optional<Person>) -> String
    init(_ closure: @escaping (Optional<Person>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_OptionalPerson_To_String {
    static func bridgeJSLower(_ closure: @escaping (Optional<Person>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_OptionalPerson_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Person>) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_optionalperson_to_string")
                func _invoke(_: Int32, _: Int32, _: UnsafeMutableRawPointer) -> Int32
                let (param0IsSome, param0Value) = param0.bridgeJSLowerParameterWithRetain()
let resultId = _invoke(owner.callbackId, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_optionalperson_to_string")
@_cdecl("invoke_swift_closure_optionalperson_to_string")
public func _invoke_swift_closure_optionalperson_to_string(boxPtr: UnsafeMutableRawPointer, param0IsSome: Int32, param0Value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_OptionalPerson_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Person>.bridgeJSLiftParameter(param0IsSome, param0Value))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_OptionalTheme_To_String: _BridgedSwiftClosureBox {
    let closure: (Optional<Theme>) -> String
    init(_ closure: @escaping (Optional<Theme>) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_OptionalTheme_To_String {
    static func bridgeJSLower(_ closure: @escaping (Optional<Theme>) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_OptionalTheme_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Optional<Theme>) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_optionaltheme_to_string")
                func _invoke(_: Int32, _: Int32, _: Int32) -> Int32
                let (param0IsSome, param0Value) = param0.bridgeJSLowerParameterWithPresence()
let resultId = _invoke(owner.callbackId, param0IsSome, param0Value)
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_optionaltheme_to_string")
@_cdecl("invoke_swift_closure_optionaltheme_to_string")
public func _invoke_swift_closure_optionaltheme_to_string(boxPtr: UnsafeMutableRawPointer, param0IsSome: Int32, param0Bytes: Int32, param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_OptionalTheme_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Optional<Theme>.bridgeJSLiftParameter(param0IsSome, param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_Person_To_String: _BridgedSwiftClosureBox {
    let closure: (Person) -> String
    init(_ closure: @escaping (Person) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_Person_To_String {
    static func bridgeJSLower(_ closure: @escaping (Person) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_Person_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Person) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_person_to_string")
                func _invoke(_: Int32, _: UnsafeMutableRawPointer) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_person_to_string")
@_cdecl("invoke_swift_closure_person_to_string")
public func _invoke_swift_closure_person_to_string(boxPtr: UnsafeMutableRawPointer, param0: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_Person_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Person.bridgeJSLiftParameter(param0))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_String_To_String: _BridgedSwiftClosureBox {
    let closure: (String) -> String
    init(_ closure: @escaping (String) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_String_To_String {
    static func bridgeJSLower(_ closure: @escaping (String) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_String_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (String) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_string_to_string")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_string_to_string")
@_cdecl("invoke_swift_closure_string_to_string")
public func _invoke_swift_closure_string_to_string(boxPtr: UnsafeMutableRawPointer, param0Bytes: Int32, param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_String_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(String.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_Theme_To_Bool: _BridgedSwiftClosureBox {
    let closure: (Theme) -> Bool
    init(_ closure: @escaping (Theme) -> Bool) {
        self.closure = closure
    }
}

private enum _BJS_Closure_Theme_To_Bool {
    static func bridgeJSLower(_ closure: @escaping (Theme) -> Bool) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_Theme_To_Bool(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> Bool {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_theme_to_bool")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return Bool.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_theme_to_bool")
@_cdecl("invoke_swift_closure_theme_to_bool")
public func _invoke_swift_closure_theme_to_bool(boxPtr: UnsafeMutableRawPointer, param0Bytes: Int32, param0Length: Int32) -> Int32 {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_Theme_To_Bool>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
    return result.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

private final class _BJS_ClosureBox_Theme_To_String: _BridgedSwiftClosureBox {
    let closure: (Theme) -> String
    init(_ closure: @escaping (Theme) -> String) {
        self.closure = closure
    }
}

private enum _BJS_Closure_Theme_To_String {
    static func bridgeJSLower(_ closure: @escaping (Theme) -> String) -> UnsafeMutableRawPointer {
        let box = _BJS_ClosureBox_Theme_To_String(closure)
        return Unmanaged.passRetained(box).toOpaque()
    }

    static func bridgeJSLift(_ callbackId: Int32) -> (Theme) -> String {
            let owner = _JSCallbackOwner(callbackId: callbackId)
            return { [owner] param0 in
                #if arch(wasm32)
                @_extern(wasm, module: "bjs", name: "invoke_js_callback_theme_to_string")
                func _invoke(_: Int32, _: Int32) -> Int32
                let resultId = _invoke(owner.callbackId, param0.bridgeJSLowerParameter())
            return String.bridgeJSLiftReturn(resultId)
                #else
                fatalError("Only available on WebAssembly")
                 #endif
            }
        }
}

@_expose(wasm, "invoke_swift_closure_theme_to_string")
@_cdecl("invoke_swift_closure_theme_to_string")
public func _invoke_swift_closure_theme_to_string(boxPtr: UnsafeMutableRawPointer, param0Bytes: Int32, param0Length: Int32) -> Void {
    #if arch(wasm32)
    let box = Unmanaged<_BJS_ClosureBox_Theme_To_String>.fromOpaque(boxPtr).takeUnretainedValue()
    let result = box.closure(Theme.bridgeJSLiftParameter(param0Bytes, param0Length))
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

extension Theme: _BridgedSwiftEnumNoPayload {
}

extension HttpStatus: _BridgedSwiftEnumNoPayload {
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

@_expose(wasm, "bjs_Person_init")
@_cdecl("bjs_Person_init")
public func _bjs_Person_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Person(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Person_deinit")
@_cdecl("bjs_Person_deinit")
public func _bjs_Person_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Person>.fromOpaque(pointer).release()
}

extension Person: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_Person_wrap")
        func _bjs_Person_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Person_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Person_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_TestProcessor_init")
@_cdecl("bjs_TestProcessor_init")
public func _bjs_TestProcessor_init(transform: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor(transform: _BJS_Closure_String_To_String.bridgeJSLift(transform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_getTransform")
@_cdecl("bjs_TestProcessor_getTransform")
public func _bjs_TestProcessor_getTransform(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).getTransform()
    return _BJS_Closure_String_To_String.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processWithCustom")
@_cdecl("bjs_TestProcessor_processWithCustom")
public func _bjs_TestProcessor_processWithCustom(_self: UnsafeMutableRawPointer, textBytes: Int32, textLength: Int32, customTransform: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processWithCustom(_: String.bridgeJSLiftParameter(textBytes, textLength), customTransform: _BJS_Closure_String_To_String.bridgeJSLift(customTransform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_printTogether")
@_cdecl("bjs_TestProcessor_printTogether")
public func _bjs_TestProcessor_printTogether(_self: UnsafeMutableRawPointer, person: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32, ratio: Float64, customTransform: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).printTogether(person: Person.bridgeJSLiftParameter(person), name: String.bridgeJSLiftParameter(nameBytes, nameLength), ratio: Double.bridgeJSLiftParameter(ratio), customTransform: _BJS_Closure_OptionalPerson_OptionalString_OptionalDouble_To_String.bridgeJSLift(customTransform))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_roundtrip")
@_cdecl("bjs_TestProcessor_roundtrip")
public func _bjs_TestProcessor_roundtrip(_self: UnsafeMutableRawPointer, personClosure: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).roundtrip(_: _BJS_Closure_Person_To_String.bridgeJSLift(personClosure))
    return _BJS_Closure_Person_To_String.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_roundtripOptional")
@_cdecl("bjs_TestProcessor_roundtripOptional")
public func _bjs_TestProcessor_roundtripOptional(_self: UnsafeMutableRawPointer, personClosure: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).roundtripOptional(_: _BJS_Closure_OptionalPerson_To_String.bridgeJSLift(personClosure))
    return _BJS_Closure_OptionalPerson_To_String.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processDirection")
@_cdecl("bjs_TestProcessor_processDirection")
public func _bjs_TestProcessor_processDirection(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processDirection(_: _BJS_Closure_Direction_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processTheme")
@_cdecl("bjs_TestProcessor_processTheme")
public func _bjs_TestProcessor_processTheme(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processTheme(_: _BJS_Closure_Theme_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processHttpStatus")
@_cdecl("bjs_TestProcessor_processHttpStatus")
public func _bjs_TestProcessor_processHttpStatus(_self: UnsafeMutableRawPointer, callback: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processHttpStatus(_: _BJS_Closure_HttpStatus_To_Int.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processAPIResult")
@_cdecl("bjs_TestProcessor_processAPIResult")
public func _bjs_TestProcessor_processAPIResult(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processAPIResult(_: _BJS_Closure_APIResult_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_makeDirectionChecker")
@_cdecl("bjs_TestProcessor_makeDirectionChecker")
public func _bjs_TestProcessor_makeDirectionChecker(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).makeDirectionChecker()
    return _BJS_Closure_Direction_To_Bool.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_makeThemeValidator")
@_cdecl("bjs_TestProcessor_makeThemeValidator")
public func _bjs_TestProcessor_makeThemeValidator(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).makeThemeValidator()
    return _BJS_Closure_Theme_To_Bool.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_makeStatusCodeExtractor")
@_cdecl("bjs_TestProcessor_makeStatusCodeExtractor")
public func _bjs_TestProcessor_makeStatusCodeExtractor(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).makeStatusCodeExtractor()
    return _BJS_Closure_HttpStatus_To_Int.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_makeAPIResultHandler")
@_cdecl("bjs_TestProcessor_makeAPIResultHandler")
public func _bjs_TestProcessor_makeAPIResultHandler(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).makeAPIResultHandler()
    return _BJS_Closure_APIResult_To_String.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processOptionalDirection")
@_cdecl("bjs_TestProcessor_processOptionalDirection")
public func _bjs_TestProcessor_processOptionalDirection(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processOptionalDirection(_: _BJS_Closure_OptionalDirection_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processOptionalTheme")
@_cdecl("bjs_TestProcessor_processOptionalTheme")
public func _bjs_TestProcessor_processOptionalTheme(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processOptionalTheme(_: _BJS_Closure_OptionalTheme_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_processOptionalAPIResult")
@_cdecl("bjs_TestProcessor_processOptionalAPIResult")
public func _bjs_TestProcessor_processOptionalAPIResult(_self: UnsafeMutableRawPointer, callback: Int32) -> Void {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).processOptionalAPIResult(_: _BJS_Closure_OptionalAPIResult_To_String.bridgeJSLift(callback))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_makeOptionalDirectionFormatter")
@_cdecl("bjs_TestProcessor_makeOptionalDirectionFormatter")
public func _bjs_TestProcessor_makeOptionalDirectionFormatter(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = TestProcessor.bridgeJSLiftParameter(_self).makeOptionalDirectionFormatter()
    return _BJS_Closure_OptionalDirection_To_String.bridgeJSLower(ret)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestProcessor_deinit")
@_cdecl("bjs_TestProcessor_deinit")
public func _bjs_TestProcessor_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<TestProcessor>.fromOpaque(pointer).release()
}

extension TestProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "TestModule", name: "bjs_TestProcessor_wrap")
        func _bjs_TestProcessor_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_TestProcessor_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}