// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

struct AnyMyViewControllerDelegate: MyViewControllerDelegate, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func onSomethingHappened() {
    _extern_onSomethingHappened(this: Int32(bitPattern: jsObject.id))
    }

    func onValueChanged(_ value: String) {
        _extern_onValueChanged(this: Int32(bitPattern: jsObject.id), value: value.bridgeJSLowerParameter())
    }

    func onCountUpdated(count: Int) -> Bool {
        let ret = _extern_onCountUpdated(this: Int32(bitPattern: jsObject.id), count: count.bridgeJSLowerParameter())
        return Bool.bridgeJSLiftReturn(ret)
    }

    func onLabelUpdated(_ prefix: String, _ suffix: String) {
        _extern_onLabelUpdated(this: Int32(bitPattern: jsObject.id), prefix: prefix.bridgeJSLowerParameter(), suffix: suffix.bridgeJSLowerParameter())
    }

    func isCountEven() -> Bool {
        let ret = _extern_isCountEven(this: Int32(bitPattern: jsObject.id))
        return Bool.bridgeJSLiftReturn(ret)
    }

    func onHelperUpdated(_ helper: Helper) {
        _extern_onHelperUpdated(this: Int32(bitPattern: jsObject.id), helper: helper.bridgeJSLowerParameter())
    }

    func createHelper() -> Helper {
        let ret = _extern_createHelper(this: Int32(bitPattern: jsObject.id))
        return Helper.bridgeJSLiftReturn(ret)
    }

    func onOptionalHelperUpdated(_ helper: Optional<Helper>) {
        let (helperIsSome, helperPointer) = helper.bridgeJSLowerParameterWithPresence()
    _extern_onOptionalHelperUpdated(this: Int32(bitPattern: jsObject.id), helperIsSome: helperIsSome, helperPointer: helperPointer)
    }

    func createOptionalHelper() -> Optional<Helper> {
        let ret = _extern_createOptionalHelper(this: Int32(bitPattern: jsObject.id))
        return Optional<Helper>.bridgeJSLiftReturn(ret)
    }

    func createEnum() -> ExampleEnum {
        let ret = _extern_createEnum(this: Int32(bitPattern: jsObject.id))
        return ExampleEnum.bridgeJSLiftReturn(ret)
    }

    func handleResult(_ result: Result) {
        _extern_handleResult(this: Int32(bitPattern: jsObject.id), result: result.bridgeJSLowerParameter())
    }

    func getResult() -> Result {
        let ret = _extern_getResult(this: Int32(bitPattern: jsObject.id))
        return Result.bridgeJSLiftReturn(ret)
    }

    var eventCount: Int {
        get {
            let ret = bjs_MyViewControllerDelegate_eventCount_get(this: Int32(bitPattern: jsObject.id))
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            bjs_MyViewControllerDelegate_eventCount_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var delegateName: String {
        get {
            let ret = bjs_MyViewControllerDelegate_delegateName_get(this: Int32(bitPattern: jsObject.id))
            return String.bridgeJSLiftReturn(ret)
        }
    }

    var optionalName: Optional<String> {
        get {
            bjs_MyViewControllerDelegate_optionalName_get(this: Int32(bitPattern: jsObject.id))
            return Optional<String>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            bjs_MyViewControllerDelegate_optionalName_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var optionalRawEnum: Optional<ExampleEnum> {
        get {
            bjs_MyViewControllerDelegate_optionalRawEnum_get(this: Int32(bitPattern: jsObject.id))
            return Optional<ExampleEnum>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            bjs_MyViewControllerDelegate_optionalRawEnum_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var rawStringEnum: ExampleEnum {
        get {
            let ret = bjs_MyViewControllerDelegate_rawStringEnum_get(this: Int32(bitPattern: jsObject.id))
            return ExampleEnum.bridgeJSLiftReturn(ret)
        }
        set {
            bjs_MyViewControllerDelegate_rawStringEnum_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var result: Result {
        get {
            let ret = bjs_MyViewControllerDelegate_result_get(this: Int32(bitPattern: jsObject.id))
            return Result.bridgeJSLiftReturn(ret)
        }
        set {
            bjs_MyViewControllerDelegate_result_set(this: Int32(bitPattern: jsObject.id), caseId: newValue.bridgeJSLowerParameter())
        }
    }

    var optionalResult: Optional<Result> {
        get {
            let ret = bjs_MyViewControllerDelegate_optionalResult_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Result>.bridgeJSLiftReturn(ret)
        }
        set {
            let (isSome, caseId) = newValue.bridgeJSLowerParameterWithPresence()
            bjs_MyViewControllerDelegate_optionalResult_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, caseId: caseId)
        }
    }

    var direction: Direction {
        get {
            let ret = bjs_MyViewControllerDelegate_direction_get(this: Int32(bitPattern: jsObject.id))
            return Direction.bridgeJSLiftReturn(ret)
        }
        set {
            bjs_MyViewControllerDelegate_direction_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var directionOptional: Optional<Direction> {
        get {
            let ret = bjs_MyViewControllerDelegate_directionOptional_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Direction>.bridgeJSLiftReturn(ret)
        }
        set {
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            bjs_MyViewControllerDelegate_directionOptional_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var priority: Priority {
        get {
            let ret = bjs_MyViewControllerDelegate_priority_get(this: Int32(bitPattern: jsObject.id))
            return Priority.bridgeJSLiftReturn(ret)
        }
        set {
            bjs_MyViewControllerDelegate_priority_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var priorityOptional: Optional<Priority> {
        get {
            bjs_MyViewControllerDelegate_priorityOptional_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Priority>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            bjs_MyViewControllerDelegate_priorityOptional_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyMyViewControllerDelegate(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onSomethingHappened")
fileprivate func _extern_onSomethingHappened(this: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onValueChanged")
fileprivate func _extern_onValueChanged(this: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onCountUpdated")
fileprivate func _extern_onCountUpdated(this: Int32, count: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onLabelUpdated")
fileprivate func _extern_onLabelUpdated(this: Int32, prefix: Int32, suffix: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_isCountEven")
fileprivate func _extern_isCountEven(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onHelperUpdated")
fileprivate func _extern_onHelperUpdated(this: Int32, helper: UnsafeMutableRawPointer)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createHelper")
fileprivate func _extern_createHelper(this: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onOptionalHelperUpdated")
fileprivate func _extern_onOptionalHelperUpdated(this: Int32, helperIsSome: Int32, helperPointer: UnsafeMutableRawPointer)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createOptionalHelper")
fileprivate func _extern_createOptionalHelper(this: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createEnum")
fileprivate func _extern_createEnum(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_handleResult")
fileprivate func _extern_handleResult(this: Int32, result: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_getResult")
fileprivate func _extern_getResult(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_get")
fileprivate func bjs_MyViewControllerDelegate_eventCount_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_set")
fileprivate func bjs_MyViewControllerDelegate_eventCount_set(this: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_delegateName_get")
fileprivate func bjs_MyViewControllerDelegate_delegateName_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalName_get")
fileprivate func bjs_MyViewControllerDelegate_optionalName_get(this: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalName_set")
fileprivate func bjs_MyViewControllerDelegate_optionalName_set(this: Int32, isSome: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalRawEnum_get")
fileprivate func bjs_MyViewControllerDelegate_optionalRawEnum_get(this: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalRawEnum_set")
fileprivate func bjs_MyViewControllerDelegate_optionalRawEnum_set(this: Int32, isSome: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_rawStringEnum_get")
fileprivate func bjs_MyViewControllerDelegate_rawStringEnum_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_rawStringEnum_set")
fileprivate func bjs_MyViewControllerDelegate_rawStringEnum_set(this: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_result_get")
fileprivate func bjs_MyViewControllerDelegate_result_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_result_set")
fileprivate func bjs_MyViewControllerDelegate_result_set(this: Int32, caseId: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalResult_get")
fileprivate func bjs_MyViewControllerDelegate_optionalResult_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalResult_set")
fileprivate func bjs_MyViewControllerDelegate_optionalResult_set(this: Int32, isSome: Int32, caseId: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_direction_get")
fileprivate func bjs_MyViewControllerDelegate_direction_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_direction_set")
fileprivate func bjs_MyViewControllerDelegate_direction_set(this: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_directionOptional_get")
fileprivate func bjs_MyViewControllerDelegate_directionOptional_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_directionOptional_set")
fileprivate func bjs_MyViewControllerDelegate_directionOptional_set(this: Int32, isSome: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priority_get")
fileprivate func bjs_MyViewControllerDelegate_priority_get(this: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priority_set")
fileprivate func bjs_MyViewControllerDelegate_priority_set(this: Int32, value: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priorityOptional_get")
fileprivate func bjs_MyViewControllerDelegate_priorityOptional_get(this: Int32)

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priorityOptional_set")
fileprivate func bjs_MyViewControllerDelegate_priorityOptional_set(this: Int32, isSome: Int32, value: Int32)

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

extension ExampleEnum: _BridgedSwiftEnumNoPayload {
}

extension Result: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32()))
        case 1:
            return .failure(Int.bridgeJSLiftParameter(_swift_js_pop_param_int32()))
        default:
            fatalError("Unknown Result case ID: \(caseId)")
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
        }
    }

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> Result {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> Result {
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
        }
    }
}

extension Priority: _BridgedSwiftEnumNoPayload {
}

@_expose(wasm, "bjs_Helper_init")
@_cdecl("bjs_Helper_init")
public func _bjs_Helper_init(value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Helper(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_increment")
@_cdecl("bjs_Helper_increment")
public func _bjs_Helper_increment(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Helper.bridgeJSLiftParameter(_self).increment()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_value_get")
@_cdecl("bjs_Helper_value_get")
public func _bjs_Helper_value_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Helper.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_value_set")
@_cdecl("bjs_Helper_value_set")
public func _bjs_Helper_value_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    Helper.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_deinit")
@_cdecl("bjs_Helper_deinit")
public func _bjs_Helper_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Helper>.fromOpaque(pointer).release()
}

extension Helper: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Helper_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Helper_wrap")
fileprivate func _bjs_Helper_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Helper_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_MyViewController_init")
@_cdecl("bjs_MyViewController_init")
public func _bjs_MyViewController_init(delegate: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = MyViewController(delegate: AnyMyViewControllerDelegate.bridgeJSLiftParameter(delegate))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_triggerEvent")
@_cdecl("bjs_MyViewController_triggerEvent")
public func _bjs_MyViewController_triggerEvent(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).triggerEvent()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateValue")
@_cdecl("bjs_MyViewController_updateValue")
public func _bjs_MyViewController_updateValue(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateValue(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateCount")
@_cdecl("bjs_MyViewController_updateCount")
public func _bjs_MyViewController_updateCount(_self: UnsafeMutableRawPointer, count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).updateCount(_: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateLabel")
@_cdecl("bjs_MyViewController_updateLabel")
public func _bjs_MyViewController_updateLabel(_self: UnsafeMutableRawPointer, prefixBytes: Int32, prefixLength: Int32, suffixBytes: Int32, suffixLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateLabel(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength), _: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_checkEvenCount")
@_cdecl("bjs_MyViewController_checkEvenCount")
public func _bjs_MyViewController_checkEvenCount(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).checkEvenCount()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_sendHelper")
@_cdecl("bjs_MyViewController_sendHelper")
public func _bjs_MyViewController_sendHelper(_self: UnsafeMutableRawPointer, helper: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).sendHelper(_: Helper.bridgeJSLiftParameter(helper))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_get")
@_cdecl("bjs_MyViewController_delegate_get")
public func _bjs_MyViewController_delegate_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).delegate as! AnyMyViewControllerDelegate
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_set")
@_cdecl("bjs_MyViewController_delegate_set")
public func _bjs_MyViewController_delegate_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).delegate = AnyMyViewControllerDelegate.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_get")
@_cdecl("bjs_MyViewController_secondDelegate_get")
public func _bjs_MyViewController_secondDelegate_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).secondDelegate.flatMap {
        $0 as? AnyMyViewControllerDelegate
    }
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_set")
@_cdecl("bjs_MyViewController_secondDelegate_set")
public func _bjs_MyViewController_secondDelegate_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).secondDelegate = Optional<AnyMyViewControllerDelegate>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_deinit")
@_cdecl("bjs_MyViewController_deinit")
public func _bjs_MyViewController_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<MyViewController>.fromOpaque(pointer).release()
}

extension MyViewController: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MyViewController_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_MyViewController_wrap")
fileprivate func _bjs_MyViewController_wrap(_: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_MyViewController_wrap(_: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif