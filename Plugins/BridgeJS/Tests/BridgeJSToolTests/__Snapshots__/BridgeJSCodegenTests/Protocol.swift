struct AnyMyViewControllerDelegate: MyViewControllerDelegate, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func onSomethingHappened() -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        _extern_onSomethingHappened(jsObjectValue)
    }

    func onValueChanged(_ value: String) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let valueValue = value.bridgeJSLowerParameter()
        _extern_onValueChanged(jsObjectValue, valueValue)
    }

    func onCountUpdated(count: Int) -> Bool {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let countValue = count.bridgeJSLowerParameter()
        let ret = _extern_onCountUpdated(jsObjectValue, countValue)
        return Bool.bridgeJSLiftReturn(ret)
    }

    func onLabelUpdated(_ prefix: String, _ suffix: String) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let prefixValue = prefix.bridgeJSLowerParameter()
        let suffixValue = suffix.bridgeJSLowerParameter()
        _extern_onLabelUpdated(jsObjectValue, prefixValue, suffixValue)
    }

    func isCountEven() -> Bool {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_isCountEven(jsObjectValue)
        return Bool.bridgeJSLiftReturn(ret)
    }

    func onHelperUpdated(_ helper: Helper) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let helperPointer = helper.bridgeJSLowerParameter()
        _extern_onHelperUpdated(jsObjectValue, helperPointer)
    }

    func createHelper() -> Helper {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_createHelper(jsObjectValue)
        return Helper.bridgeJSLiftReturn(ret)
    }

    func onOptionalHelperUpdated(_ helper: Optional<Helper>) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let (helperIsSome, helperPointer) = helper.bridgeJSLowerParameter()
        _extern_onOptionalHelperUpdated(jsObjectValue, helperIsSome, helperPointer)
    }

    func createOptionalHelper() -> Optional<Helper> {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_createOptionalHelper(jsObjectValue)
        return Optional<Helper>.bridgeJSLiftReturn(ret)
    }

    func createEnum() -> ExampleEnum {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_createEnum(jsObjectValue)
        return ExampleEnum.bridgeJSLiftReturn(ret)
    }

    func handleResult(_ result: Result) -> Void {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let resultCaseId = result.bridgeJSLowerParameter()
        _extern_handleResult(jsObjectValue, resultCaseId)
    }

    func getResult() -> Result {
        let jsObjectValue = jsObject.bridgeJSLowerParameter()
        let ret = _extern_getResult(jsObjectValue)
        return Result.bridgeJSLiftReturn(ret)
    }

    var eventCount: Int {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_eventCount_get(jsObjectValue)
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_eventCount_set(jsObjectValue, newValueValue)
        }
    }

    var delegateName: String {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_delegateName_get(jsObjectValue)
            return String.bridgeJSLiftReturn(ret)
        }
    }

    var optionalName: Optional<String> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_optionalName_get(jsObjectValue)
            return Optional<String>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_optionalName_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var optionalRawEnum: Optional<ExampleEnum> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_optionalRawEnum_get(jsObjectValue)
            return Optional<ExampleEnum>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_optionalRawEnum_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var rawStringEnum: ExampleEnum {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_rawStringEnum_get(jsObjectValue)
            return ExampleEnum.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_rawStringEnum_set(jsObjectValue, newValueValue)
        }
    }

    var result: Result {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_result_get(jsObjectValue)
            return Result.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueCaseId = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_result_set(jsObjectValue, newValueCaseId)
        }
    }

    var optionalResult: Optional<Result> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_optionalResult_get(jsObjectValue)
            return Optional<Result>.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueCaseId) = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_optionalResult_set(jsObjectValue, newValueIsSome, newValueCaseId)
        }
    }

    var direction: Direction {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_direction_get(jsObjectValue)
            return Direction.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_direction_set(jsObjectValue, newValueValue)
        }
    }

    var directionOptional: Optional<Direction> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_directionOptional_get(jsObjectValue)
            return Optional<Direction>.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_directionOptional_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    var priority: Priority {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let ret = bjs_MyViewControllerDelegate_priority_get(jsObjectValue)
            return Priority.bridgeJSLiftReturn(ret)
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let newValueValue = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_priority_set(jsObjectValue, newValueValue)
        }
    }

    var priorityOptional: Optional<Priority> {
        get {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_priorityOptional_get(jsObjectValue)
            return Optional<Priority>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            let jsObjectValue = jsObject.bridgeJSLowerParameter()
            let (newValueIsSome, newValueValue) = newValue.bridgeJSLowerParameter()
            bjs_MyViewControllerDelegate_priorityOptional_set(jsObjectValue, newValueIsSome, newValueValue)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyMyViewControllerDelegate(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
}

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onSomethingHappened")
fileprivate func _extern_onSomethingHappened(_ jsObject: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onValueChanged")
fileprivate func _extern_onValueChanged(_ jsObject: Int32, _ value: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onCountUpdated")
fileprivate func _extern_onCountUpdated(_ jsObject: Int32, _ count: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onLabelUpdated")
fileprivate func _extern_onLabelUpdated(_ jsObject: Int32, _ prefix: Int32, _ suffix: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_isCountEven")
fileprivate func _extern_isCountEven(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onHelperUpdated")
fileprivate func _extern_onHelperUpdated(_ jsObject: Int32, _ helper: UnsafeMutableRawPointer) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createHelper")
fileprivate func _extern_createHelper(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_onOptionalHelperUpdated")
fileprivate func _extern_onOptionalHelperUpdated(_ jsObject: Int32, _ helperIsSome: Int32, _ helperPointer: UnsafeMutableRawPointer) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createOptionalHelper")
fileprivate func _extern_createOptionalHelper(_ jsObject: Int32) -> UnsafeMutableRawPointer

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_createEnum")
fileprivate func _extern_createEnum(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_handleResult")
fileprivate func _extern_handleResult(_ jsObject: Int32, _ result: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_getResult")
fileprivate func _extern_getResult(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_get")
fileprivate func bjs_MyViewControllerDelegate_eventCount_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_eventCount_set")
fileprivate func bjs_MyViewControllerDelegate_eventCount_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_delegateName_get")
fileprivate func bjs_MyViewControllerDelegate_delegateName_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalName_get")
fileprivate func bjs_MyViewControllerDelegate_optionalName_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalName_set")
fileprivate func bjs_MyViewControllerDelegate_optionalName_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalRawEnum_get")
fileprivate func bjs_MyViewControllerDelegate_optionalRawEnum_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalRawEnum_set")
fileprivate func bjs_MyViewControllerDelegate_optionalRawEnum_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_rawStringEnum_get")
fileprivate func bjs_MyViewControllerDelegate_rawStringEnum_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_rawStringEnum_set")
fileprivate func bjs_MyViewControllerDelegate_rawStringEnum_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_result_get")
fileprivate func bjs_MyViewControllerDelegate_result_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_result_set")
fileprivate func bjs_MyViewControllerDelegate_result_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalResult_get")
fileprivate func bjs_MyViewControllerDelegate_optionalResult_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_optionalResult_set")
fileprivate func bjs_MyViewControllerDelegate_optionalResult_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueCaseId: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_direction_get")
fileprivate func bjs_MyViewControllerDelegate_direction_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_direction_set")
fileprivate func bjs_MyViewControllerDelegate_direction_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_directionOptional_get")
fileprivate func bjs_MyViewControllerDelegate_directionOptional_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_directionOptional_set")
fileprivate func bjs_MyViewControllerDelegate_directionOptional_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priority_get")
fileprivate func bjs_MyViewControllerDelegate_priority_get(_ jsObject: Int32) -> Int32

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priority_set")
fileprivate func bjs_MyViewControllerDelegate_priority_set(_ jsObject: Int32, _ newValue: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priorityOptional_get")
fileprivate func bjs_MyViewControllerDelegate_priorityOptional_get(_ jsObject: Int32) -> Void

@_extern(wasm, module: "TestModule", name: "bjs_MyViewControllerDelegate_priorityOptional_set")
fileprivate func bjs_MyViewControllerDelegate_priorityOptional_set(_ jsObject: Int32, _ newValueIsSome: Int32, _ newValueValue: Int32) -> Void

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

extension ExampleEnum: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension Result: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> Result {
        switch caseId {
        case 0:
            return .success(String.bridgeJSStackPop())
        case 1:
            return .failure(Int.bridgeJSStackPop())
        default:
            fatalError("Unknown Result case ID: \(caseId)")
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
        }
    }
}

extension Priority: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

@_expose(wasm, "bjs_processDelegates")
@_cdecl("bjs_processDelegates")
public func _bjs_processDelegates() -> Void {
    #if arch(wasm32)
    let ret = processDelegates(_: [AnyMyViewControllerDelegate].bridgeJSStackPop())
    ret.map { $0 as! AnyMyViewControllerDelegate }.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_init")
@_cdecl("bjs_Helper_init")
public func _bjs_Helper_init(_ value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Helper(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_increment")
@_cdecl("bjs_Helper_increment")
public func _bjs_Helper_increment(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Helper.bridgeJSLiftParameter(_self).increment()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_value_get")
@_cdecl("bjs_Helper_value_get")
public func _bjs_Helper_value_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = Helper.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_value_set")
@_cdecl("bjs_Helper_value_set")
public func _bjs_Helper_value_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    Helper.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Helper_deinit")
@_cdecl("bjs_Helper_deinit")
public func _bjs_Helper_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<Helper>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension Helper: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Helper_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_Helper_wrap")
fileprivate func _bjs_Helper_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_Helper_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_MyViewController_init")
@_cdecl("bjs_MyViewController_init")
public func _bjs_MyViewController_init(_ delegate: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = MyViewController(delegate: AnyMyViewControllerDelegate.bridgeJSLiftParameter(delegate))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_triggerEvent")
@_cdecl("bjs_MyViewController_triggerEvent")
public func _bjs_MyViewController_triggerEvent(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).triggerEvent()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateValue")
@_cdecl("bjs_MyViewController_updateValue")
public func _bjs_MyViewController_updateValue(_ _self: UnsafeMutableRawPointer, _ valueBytes: Int32, _ valueLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateValue(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateCount")
@_cdecl("bjs_MyViewController_updateCount")
public func _bjs_MyViewController_updateCount(_ _self: UnsafeMutableRawPointer, _ count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).updateCount(_: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_updateLabel")
@_cdecl("bjs_MyViewController_updateLabel")
public func _bjs_MyViewController_updateLabel(_ _self: UnsafeMutableRawPointer, _ prefixBytes: Int32, _ prefixLength: Int32, _ suffixBytes: Int32, _ suffixLength: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).updateLabel(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength), _: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_checkEvenCount")
@_cdecl("bjs_MyViewController_checkEvenCount")
public func _bjs_MyViewController_checkEvenCount(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = MyViewController.bridgeJSLiftParameter(_self).checkEvenCount()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_sendHelper")
@_cdecl("bjs_MyViewController_sendHelper")
public func _bjs_MyViewController_sendHelper(_ _self: UnsafeMutableRawPointer, _ helper: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).sendHelper(_: Helper.bridgeJSLiftParameter(helper))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_get")
@_cdecl("bjs_MyViewController_delegate_get")
public func _bjs_MyViewController_delegate_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = (MyViewController.bridgeJSLiftParameter(_self).delegate as! AnyMyViewControllerDelegate)
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_delegate_set")
@_cdecl("bjs_MyViewController_delegate_set")
public func _bjs_MyViewController_delegate_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).delegate = AnyMyViewControllerDelegate.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_get")
@_cdecl("bjs_MyViewController_secondDelegate_get")
public func _bjs_MyViewController_secondDelegate_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = (MyViewController.bridgeJSLiftParameter(_self).secondDelegate).flatMap { $0 as? AnyMyViewControllerDelegate }
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_secondDelegate_set")
@_cdecl("bjs_MyViewController_secondDelegate_set")
public func _bjs_MyViewController_secondDelegate_set(_ _self: UnsafeMutableRawPointer, _ valueIsSome: Int32, _ valueValue: Int32) -> Void {
    #if arch(wasm32)
    MyViewController.bridgeJSLiftParameter(_self).secondDelegate = Optional<AnyMyViewControllerDelegate>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MyViewController_deinit")
@_cdecl("bjs_MyViewController_deinit")
public func _bjs_MyViewController_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<MyViewController>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension MyViewController: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MyViewController_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_MyViewController_wrap")
fileprivate func _bjs_MyViewController_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_MyViewController_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif

@_expose(wasm, "bjs_DelegateManager_init")
@_cdecl("bjs_DelegateManager_init")
public func _bjs_DelegateManager_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DelegateManager(delegates: [AnyMyViewControllerDelegate].bridgeJSStackPop())
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DelegateManager_notifyAll")
@_cdecl("bjs_DelegateManager_notifyAll")
public func _bjs_DelegateManager_notifyAll(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    DelegateManager.bridgeJSLiftParameter(_self).notifyAll()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DelegateManager_delegates_get")
@_cdecl("bjs_DelegateManager_delegates_get")
public func _bjs_DelegateManager_delegates_get(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DelegateManager.bridgeJSLiftParameter(_self).delegates
    ret.map { $0 as! AnyMyViewControllerDelegate }.bridgeJSStackPush()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DelegateManager_delegates_set")
@_cdecl("bjs_DelegateManager_delegates_set")
public func _bjs_DelegateManager_delegates_set(_ _self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    DelegateManager.bridgeJSLiftParameter(_self).delegates = [AnyMyViewControllerDelegate].bridgeJSStackPop()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DelegateManager_deinit")
@_cdecl("bjs_DelegateManager_deinit")
public func _bjs_DelegateManager_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<DelegateManager>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension DelegateManager: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DelegateManager_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_DelegateManager_wrap")
fileprivate func _bjs_DelegateManager_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_DelegateManager_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif