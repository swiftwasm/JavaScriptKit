// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

@_spi(BridgeJS) import JavaScriptKit

struct AnyDataProcessor: DataProcessor, _BridgedSwiftProtocolWrapper {
    let jsObject: JSObject

    func increment(by amount: Int) {
    @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_increment")
    func _extern_increment(this: Int32, amount: Int32)
    _extern_increment(this: Int32(bitPattern: jsObject.id), amount: amount.bridgeJSLowerParameter())
    }

    func getValue() -> Int {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getValue")
        func _extern_getValue(this: Int32) -> Int32
        let ret = _extern_getValue(this: Int32(bitPattern: jsObject.id))
        return Int.bridgeJSLiftReturn(ret)
    }

    func setLabelElements(_ labelPrefix: String, _ labelSuffix: String) {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_setLabelElements")
        func _extern_setLabelElements(this: Int32, labelPrefix: Int32, labelSuffix: Int32)
        _extern_setLabelElements(this: Int32(bitPattern: jsObject.id), labelPrefix: labelPrefix.bridgeJSLowerParameter(), labelSuffix: labelSuffix.bridgeJSLowerParameter())
    }

    func getLabel() -> String {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getLabel")
        func _extern_getLabel(this: Int32) -> Int32
        let ret = _extern_getLabel(this: Int32(bitPattern: jsObject.id))
        return String.bridgeJSLiftReturn(ret)
    }

    func isEven() -> Bool {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_isEven")
        func _extern_isEven(this: Int32) -> Int32
        let ret = _extern_isEven(this: Int32(bitPattern: jsObject.id))
        return Bool.bridgeJSLiftReturn(ret)
    }

    func processGreeter(_ greeter: Greeter) -> String {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processGreeter")
        func _extern_processGreeter(this: Int32, greeter: UnsafeMutableRawPointer) -> Int32
        let ret = _extern_processGreeter(this: Int32(bitPattern: jsObject.id), greeter: greeter.bridgeJSLowerParameter())
        return String.bridgeJSLiftReturn(ret)
    }

    func createGreeter() -> Greeter {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createGreeter")
        func _extern_createGreeter(this: Int32) -> UnsafeMutableRawPointer
        let ret = _extern_createGreeter(this: Int32(bitPattern: jsObject.id))
        return Greeter.bridgeJSLiftReturn(ret)
    }

    func processOptionalGreeter(_ greeter: Optional<Greeter>) -> String {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_processOptionalGreeter")
        func _extern_processOptionalGreeter(this: Int32, greeterIsSome: Int32, greeterPointer: UnsafeMutableRawPointer) -> Int32
        let (greeterIsSome, greeterPointer) = greeter.bridgeJSLowerParameterWithPresence()
    let ret = _extern_processOptionalGreeter(this: Int32(bitPattern: jsObject.id), greeterIsSome: greeterIsSome, greeterPointer: greeterPointer)
        return String.bridgeJSLiftReturn(ret)
    }

    func createOptionalGreeter() -> Optional<Greeter> {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_createOptionalGreeter")
        func _extern_createOptionalGreeter(this: Int32) -> UnsafeMutableRawPointer
        let ret = _extern_createOptionalGreeter(this: Int32(bitPattern: jsObject.id))
        return Optional<Greeter>.bridgeJSLiftReturn(ret)
    }

    func handleAPIResult(_ result: Optional<APIResult>) {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_handleAPIResult")
        func _extern_handleAPIResult(this: Int32, resultIsSome: Int32, resultCaseId: Int32)
        let (resultIsSome, resultCaseId) = result.bridgeJSLowerParameterWithPresence()
    _extern_handleAPIResult(this: Int32(bitPattern: jsObject.id), resultIsSome: resultIsSome, resultCaseId: resultCaseId)
    }

    func getAPIResult() -> Optional<APIResult> {
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_getAPIResult")
        func _extern_getAPIResult(this: Int32) -> Int32
        let ret = _extern_getAPIResult(this: Int32(bitPattern: jsObject.id))
        return Optional<APIResult>.bridgeJSLiftReturn(ret)
    }

    var count: Int {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Int.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_count_set")
            func _extern_set(this: Int32, value: Int32)
            _extern_set(this: Int32(bitPattern: jsObject.id), value: newValue.bridgeJSLowerParameter())
        }
    }

    var name: String {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_name_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return String.bridgeJSLiftReturn(ret)
        }
    }

    var optionalTag: Optional<String> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_get")
            func _extern_get(this: Int32)
            _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<String>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTag_set")
            func _extern_set(this: Int32, isSome: Int32, value: Int32)
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var optionalCount: Optional<Int> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_get")
            func _extern_get(this: Int32)
            _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Int>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalCount_set")
            func _extern_set(this: Int32, isSome: Int32, value: Int32)
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var direction: Optional<Direction> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Direction>.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_direction_set")
            func _extern_set(this: Int32, isSome: Int32, value: Int32)
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var optionalTheme: Optional<Theme> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_get")
            func _extern_get(this: Int32)
            _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Theme>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalTheme_set")
            func _extern_set(this: Int32, isSome: Int32, value: Int32)
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var httpStatus: Optional<HttpStatus> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_get")
            func _extern_get(this: Int32)
            _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<HttpStatus>.bridgeJSLiftReturnFromSideChannel()
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_httpStatus_set")
            func _extern_set(this: Int32, isSome: Int32, value: Int32)
            let (isSome, value) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, value: value)
        }
    }

    var apiResult: Optional<APIResult> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_get")
            func _extern_get(this: Int32) -> Int32
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<APIResult>.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_apiResult_set")
            func _extern_set(this: Int32, isSome: Int32, caseId: Int32)
            let (isSome, caseId) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, caseId: caseId)
        }
    }

    var helper: Greeter {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_get")
            func _extern_get(this: Int32) -> UnsafeMutableRawPointer
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Greeter.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_helper_set")
            func _extern_set(this: Int32, pointer: UnsafeMutableRawPointer)
            _extern_set(this: Int32(bitPattern: jsObject.id), pointer: newValue.bridgeJSLowerParameter())
        }
    }

    var optionalHelper: Optional<Greeter> {
        get {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_get")
            func _extern_get(this: Int32) -> UnsafeMutableRawPointer
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
            return Optional<Greeter>.bridgeJSLiftReturn(ret)
        }
        set {
            @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessor_optionalHelper_set")
            func _extern_set(this: Int32, isSome: Int32, pointer: UnsafeMutableRawPointer)
            let (isSome, pointer) = newValue.bridgeJSLowerParameterWithPresence()
            _extern_set(this: Int32(bitPattern: jsObject.id), isSome: isSome, pointer: pointer)
        }
    }

    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
        return AnyDataProcessor(jsObject: JSObject(id: UInt32(bitPattern: value)))
    }
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
public func _bjs_StaticCalculator_static_roundtrip(value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = StaticCalculator.roundtrip(_: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticUtils_Nested_static_roundtrip")
@_cdecl("bjs_StaticUtils_Nested_static_roundtrip")
public func _bjs_StaticUtils_Nested_static_roundtrip(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyEnum_static_enumProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyEnum_static_enumBool_set(value: Int32) -> Void {
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
public func _bjs_StaticPropertyEnum_static_enumVariable_set(value: Int32) -> Void {
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
public func _bjs_StaticPropertyEnum_static_computedReadWrite_set(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyNamespace_static_namespaceProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedProperty_set(value: Int32) -> Void {
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
public func _bjs_StaticPropertyNamespace_NestedProperties_static_nestedDouble_set(value: Float64) -> Void {
    #if arch(wasm32)
    StaticPropertyNamespace.NestedProperties.nestedDouble = Double.bridgeJSLiftParameter(value)
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
public func _bjs_roundTripInt(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripInt(v: Int.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripFloat")
@_cdecl("bjs_roundTripFloat")
public func _bjs_roundTripFloat(v: Float32) -> Float32 {
    #if arch(wasm32)
    let ret = roundTripFloat(v: Float.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripDouble")
@_cdecl("bjs_roundTripDouble")
public func _bjs_roundTripDouble(v: Float64) -> Float64 {
    #if arch(wasm32)
    let ret = roundTripDouble(v: Double.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripBool")
@_cdecl("bjs_roundTripBool")
public func _bjs_roundTripBool(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripBool(v: Bool.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripString")
@_cdecl("bjs_roundTripString")
public func _bjs_roundTripString(vBytes: Int32, vLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripString(v: String.bridgeJSLiftParameter(vBytes, vLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripSwiftHeapObject")
@_cdecl("bjs_roundTripSwiftHeapObject")
public func _bjs_roundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = roundTripSwiftHeapObject(v: Greeter.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripJSObject")
@_cdecl("bjs_roundTripJSObject")
public func _bjs_roundTripJSObject(v: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundTripJSObject(v: JSObject.bridgeJSLiftParameter(v))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_throwsSwiftError")
@_cdecl("bjs_throwsSwiftError")
public func _bjs_throwsSwiftError(shouldThrow: Int32) -> Void {
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
public func _bjs_asyncRoundTripInt(v: Int32) -> Int32 {
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
public func _bjs_asyncRoundTripFloat(v: Float32) -> Int32 {
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
public func _bjs_asyncRoundTripDouble(v: Float64) -> Int32 {
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
public func _bjs_asyncRoundTripBool(v: Int32) -> Int32 {
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
public func _bjs_asyncRoundTripString(vBytes: Int32, vLength: Int32) -> Int32 {
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
public func _bjs_asyncRoundTripSwiftHeapObject(v: UnsafeMutableRawPointer) -> Int32 {
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
public func _bjs_asyncRoundTripJSObject(v: Int32) -> Int32 {
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
public func _bjs_takeGreeter(g: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32) -> Void {
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
public func _bjs_useCalculator(calc: UnsafeMutableRawPointer, x: Int32, y: Int32) -> Int32 {
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
public func _bjs_testSwiftClassAsJSValue(greeter: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = testSwiftClassAsJSValue(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(direction: Int32) -> Int32 {
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
public func _bjs_processDirection(input: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processDirection(_: Direction.bridgeJSLiftParameter(input))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTheme")
@_cdecl("bjs_setTheme")
public func _bjs_setTheme(themeBytes: Int32, themeLength: Int32) -> Void {
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
public func _bjs_setHttpStatus(status: Int32) -> Int32 {
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
public func _bjs_processTheme(themeBytes: Int32, themeLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processTheme(_: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSDirection")
@_cdecl("bjs_setTSDirection")
public func _bjs_setTSDirection(direction: Int32) -> Int32 {
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
public func _bjs_setTSTheme(themeBytes: Int32, themeLength: Int32) -> Void {
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
public func _bjs_roundtripNetworkingAPIMethod(method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripNetworkingAPIMethod(_: Networking.API.Method.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripConfigurationLogLevel")
@_cdecl("bjs_roundtripConfigurationLogLevel")
public func _bjs_roundtripConfigurationLogLevel(levelBytes: Int32, levelLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripConfigurationPort")
@_cdecl("bjs_roundtripConfigurationPort")
public func _bjs_roundtripConfigurationPort(port: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripConfigurationPort(_: Configuration.Port.bridgeJSLiftParameter(port))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_processConfigurationLogLevel")
@_cdecl("bjs_processConfigurationLogLevel")
public func _bjs_processConfigurationLogLevel(levelBytes: Int32, levelLength: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = processConfigurationLogLevel(_: Configuration.LogLevel.bridgeJSLiftParameter(levelBytes, levelLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripInternalSupportedMethod")
@_cdecl("bjs_roundtripInternalSupportedMethod")
public func _bjs_roundtripInternalSupportedMethod(method: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = roundtripInternalSupportedMethod(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPIResult")
@_cdecl("bjs_roundtripAPIResult")
public func _bjs_roundtripAPIResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPIResult(result: APIResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultSuccess")
@_cdecl("bjs_makeAPIResultSuccess")
public func _bjs_makeAPIResultSuccess(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultFailure")
@_cdecl("bjs_makeAPIResultFailure")
public func _bjs_makeAPIResultFailure(value: Int32) -> Void {
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
public func _bjs_makeAPIResultFlag(value: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultFlag(_: Bool.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultRate")
@_cdecl("bjs_makeAPIResultRate")
public func _bjs_makeAPIResultRate(value: Float32) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultRate(_: Float.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPIResultPrecise")
@_cdecl("bjs_makeAPIResultPrecise")
public func _bjs_makeAPIResultPrecise(value: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeAPIResultPrecise(_: Double.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripComplexResult")
@_cdecl("bjs_roundtripComplexResult")
public func _bjs_roundtripComplexResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripComplexResult(_: ComplexResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultSuccess")
@_cdecl("bjs_makeComplexResultSuccess")
public func _bjs_makeComplexResultSuccess(valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultSuccess(_: String.bridgeJSLiftParameter(valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultError")
@_cdecl("bjs_makeComplexResultError")
public func _bjs_makeComplexResultError(messageBytes: Int32, messageLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultError(_: String.bridgeJSLiftParameter(messageBytes, messageLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultLocation")
@_cdecl("bjs_makeComplexResultLocation")
public func _bjs_makeComplexResultLocation(lat: Float64, lng: Float64, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultLocation(_: Double.bridgeJSLiftParameter(lat), _: Double.bridgeJSLiftParameter(lng), _: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultStatus")
@_cdecl("bjs_makeComplexResultStatus")
public func _bjs_makeComplexResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultCoordinates")
@_cdecl("bjs_makeComplexResultCoordinates")
public func _bjs_makeComplexResultCoordinates(x: Float64, y: Float64, z: Float64) -> Void {
    #if arch(wasm32)
    let ret = makeComplexResultCoordinates(_: Double.bridgeJSLiftParameter(x), _: Double.bridgeJSLiftParameter(y), _: Double.bridgeJSLiftParameter(z))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeComplexResultComprehensive")
@_cdecl("bjs_makeComplexResultComprehensive")
public func _bjs_makeComplexResultComprehensive(flag1: Int32, flag2: Int32, count1: Int32, count2: Int32, value1: Float64, value2: Float64, text1Bytes: Int32, text1Length: Int32, text2Bytes: Int32, text2Length: Int32, text3Bytes: Int32, text3Length: Int32) -> Void {
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
public func _bjs_makeUtilitiesResultSuccess(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultFailure")
@_cdecl("bjs_makeUtilitiesResultFailure")
public func _bjs_makeUtilitiesResultFailure(errorBytes: Int32, errorLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeUtilitiesResultStatus")
@_cdecl("bjs_makeUtilitiesResultStatus")
public func _bjs_makeUtilitiesResultStatus(active: Int32, code: Int32, messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeUtilitiesResultStatus(_: Bool.bridgeJSLiftParameter(active), _: Int.bridgeJSLiftParameter(code), _: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultSuccess")
@_cdecl("bjs_makeAPINetworkingResultSuccess")
public func _bjs_makeAPINetworkingResultSuccess(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultSuccess(_: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_makeAPINetworkingResultFailure")
@_cdecl("bjs_makeAPINetworkingResultFailure")
public func _bjs_makeAPINetworkingResultFailure(errorBytes: Int32, errorLength: Int32, code: Int32) -> Void {
    #if arch(wasm32)
    let ret = makeAPINetworkingResultFailure(_: String.bridgeJSLiftParameter(errorBytes, errorLength), _: Int.bridgeJSLiftParameter(code))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripUtilitiesResult")
@_cdecl("bjs_roundtripUtilitiesResult")
public func _bjs_roundtripUtilitiesResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripUtilitiesResult(_: Utilities.Result.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundtripAPINetworkingResult")
@_cdecl("bjs_roundtripAPINetworkingResult")
public func _bjs_roundtripAPINetworkingResult(result: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundtripAPINetworkingResult(_: API.NetworkingResult.bridgeJSLiftParameter(result))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalString")
@_cdecl("bjs_roundTripOptionalString")
public func _bjs_roundTripOptionalString(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalString(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalInt")
@_cdecl("bjs_roundTripOptionalInt")
public func _bjs_roundTripOptionalInt(valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalInt(value: Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalBool")
@_cdecl("bjs_roundTripOptionalBool")
public func _bjs_roundTripOptionalBool(flagIsSome: Int32, flagValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalBool(flag: Optional<Bool>.bridgeJSLiftParameter(flagIsSome, flagValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalFloat")
@_cdecl("bjs_roundTripOptionalFloat")
public func _bjs_roundTripOptionalFloat(numberIsSome: Int32, numberValue: Float32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalFloat(number: Optional<Float>.bridgeJSLiftParameter(numberIsSome, numberValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalDouble")
@_cdecl("bjs_roundTripOptionalDouble")
public func _bjs_roundTripOptionalDouble(precisionIsSome: Int32, precisionValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDouble(precision: Optional<Double>.bridgeJSLiftParameter(precisionIsSome, precisionValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalSyntax")
@_cdecl("bjs_roundTripOptionalSyntax")
public func _bjs_roundTripOptionalSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalMixSyntax")
@_cdecl("bjs_roundTripOptionalMixSyntax")
public func _bjs_roundTripOptionalMixSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalMixSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalSwiftSyntax")
@_cdecl("bjs_roundTripOptionalSwiftSyntax")
public func _bjs_roundTripOptionalSwiftSyntax(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalSwiftSyntax(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalWithSpaces")
@_cdecl("bjs_roundTripOptionalWithSpaces")
public func _bjs_roundTripOptionalWithSpaces(valueIsSome: Int32, valueValue: Float64) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalWithSpaces(value: Optional<Double>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTypeAlias")
@_cdecl("bjs_roundTripOptionalTypeAlias")
public func _bjs_roundTripOptionalTypeAlias(ageIsSome: Int32, ageValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTypeAlias(age: Optional<Int>.bridgeJSLiftParameter(ageIsSome, ageValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalStatus")
@_cdecl("bjs_roundTripOptionalStatus")
public func _bjs_roundTripOptionalStatus(valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalStatus(value: Optional<Status>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTheme")
@_cdecl("bjs_roundTripOptionalTheme")
public func _bjs_roundTripOptionalTheme(valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTheme(value: Optional<Theme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalHttpStatus")
@_cdecl("bjs_roundTripOptionalHttpStatus")
public func _bjs_roundTripOptionalHttpStatus(valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalHttpStatus(value: Optional<HttpStatus>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTSDirection")
@_cdecl("bjs_roundTripOptionalTSDirection")
public func _bjs_roundTripOptionalTSDirection(valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTSDirection(value: Optional<TSDirection>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalTSTheme")
@_cdecl("bjs_roundTripOptionalTSTheme")
public func _bjs_roundTripOptionalTSTheme(valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTSTheme(value: Optional<TSTheme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalNetworkingAPIMethod")
@_cdecl("bjs_roundTripOptionalNetworkingAPIMethod")
public func _bjs_roundTripOptionalNetworkingAPIMethod(methodIsSome: Int32, methodValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalNetworkingAPIMethod(_: Optional<Networking.API.Method>.bridgeJSLiftParameter(methodIsSome, methodValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIResult")
@_cdecl("bjs_roundTripOptionalAPIResult")
public func _bjs_roundTripOptionalAPIResult(valueIsSome: Int32, valueCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIResult(value: Optional<APIResult>.bridgeJSLiftParameter(valueIsSome, valueCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalComplexResult")
@_cdecl("bjs_roundTripOptionalComplexResult")
public func _bjs_roundTripOptionalComplexResult(resultIsSome: Int32, resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalComplexResult(_: Optional<ComplexResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalClass")
@_cdecl("bjs_roundTripOptionalClass")
public func _bjs_roundTripOptionalClass(valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalClass(value: Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalAPIOptionalResult")
@_cdecl("bjs_roundTripOptionalAPIOptionalResult")
public func _bjs_roundTripOptionalAPIOptionalResult(resultIsSome: Int32, resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIOptionalResult(result: Optional<APIOptionalResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_createPropertyHolder")
@_cdecl("bjs_createPropertyHolder")
public func _bjs_createPropertyHolder(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLength: Int32, jsObject: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = createPropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testPropertyHolder")
@_cdecl("bjs_testPropertyHolder")
public func _bjs_testPropertyHolder(holder: UnsafeMutableRawPointer) -> Void {
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
public func _bjs_testStringDefault(messageBytes: Int32, messageLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testStringDefault(message: String.bridgeJSLiftParameter(messageBytes, messageLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testIntDefault")
@_cdecl("bjs_testIntDefault")
public func _bjs_testIntDefault(count: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testIntDefault(count: Int.bridgeJSLiftParameter(count))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testBoolDefault")
@_cdecl("bjs_testBoolDefault")
public func _bjs_testBoolDefault(flag: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testBoolDefault(flag: Bool.bridgeJSLiftParameter(flag))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testOptionalDefault")
@_cdecl("bjs_testOptionalDefault")
public func _bjs_testOptionalDefault(nameIsSome: Int32, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testOptionalDefault(name: Optional<String>.bridgeJSLiftParameter(nameIsSome, nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testMultipleDefaults")
@_cdecl("bjs_testMultipleDefaults")
public func _bjs_testMultipleDefaults(titleBytes: Int32, titleLength: Int32, count: Int32, enabled: Int32) -> Void {
    #if arch(wasm32)
    let ret = testMultipleDefaults(title: String.bridgeJSLiftParameter(titleBytes, titleLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testSimpleEnumDefault")
@_cdecl("bjs_testSimpleEnumDefault")
public func _bjs_testSimpleEnumDefault(status: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testSimpleEnumDefault(status: Status.bridgeJSLiftParameter(status))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testDirectionDefault")
@_cdecl("bjs_testDirectionDefault")
public func _bjs_testDirectionDefault(direction: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = testDirectionDefault(direction: Direction.bridgeJSLiftParameter(direction))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testRawStringEnumDefault")
@_cdecl("bjs_testRawStringEnumDefault")
public func _bjs_testRawStringEnumDefault(themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    let ret = testRawStringEnumDefault(theme: Theme.bridgeJSLiftParameter(themeBytes, themeLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testComplexInit")
@_cdecl("bjs_testComplexInit")
public func _bjs_testComplexInit(greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = testComplexInit(greeter: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_testEmptyInit")
@_cdecl("bjs_testEmptyInit")
public func _bjs_testEmptyInit(object: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = testEmptyInit(_: StaticPropertyHolder.bridgeJSLiftParameter(object))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getAllStaticPropertyValues")
@_cdecl("bjs_getAllStaticPropertyValues")
public func _bjs_getAllStaticPropertyValues() -> Void {
    #if arch(wasm32)
    let ret = getAllStaticPropertyValues()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_init")
@_cdecl("bjs_Greeter_init")
public func _bjs_Greeter_init(nameBytes: Int32, nameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = Greeter(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_greet")
@_cdecl("bjs_Greeter_greet")
public func _bjs_Greeter_greet(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).greet()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_changeName")
@_cdecl("bjs_Greeter_changeName")
public func _bjs_Greeter_changeName(_self: UnsafeMutableRawPointer, nameBytes: Int32, nameLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).changeName(name: String.bridgeJSLiftParameter(nameBytes, nameLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_get")
@_cdecl("bjs_Greeter_name_get")
public func _bjs_Greeter_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_name_set")
@_cdecl("bjs_Greeter_name_set")
public func _bjs_Greeter_name_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    Greeter.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_prefix_get")
@_cdecl("bjs_Greeter_prefix_get")
public func _bjs_Greeter_prefix_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = Greeter.bridgeJSLiftParameter(_self).prefix
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Greeter_deinit")
@_cdecl("bjs_Greeter_deinit")
public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Greeter>.fromOpaque(pointer).release()
}

extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Greeter_wrap")
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_Calculator_square")
@_cdecl("bjs_Calculator_square")
public func _bjs_Calculator_square(_self: UnsafeMutableRawPointer, value: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).square(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_add")
@_cdecl("bjs_Calculator_add")
public func _bjs_Calculator_add(_self: UnsafeMutableRawPointer, a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = Calculator.bridgeJSLiftParameter(_self).add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Calculator_deinit")
@_cdecl("bjs_Calculator_deinit")
public func _bjs_Calculator_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Calculator>.fromOpaque(pointer).release()
}

extension Calculator: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Calculator_wrap")
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Calculator_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Calculator_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_InternalGreeter_deinit")
@_cdecl("bjs_InternalGreeter_deinit")
public func _bjs_InternalGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<InternalGreeter>.fromOpaque(pointer).release()
}

extension InternalGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    internal var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_InternalGreeter_wrap")
        func _bjs_InternalGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_InternalGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_InternalGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PublicGreeter_deinit")
@_cdecl("bjs_PublicGreeter_deinit")
public func _bjs_PublicGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PublicGreeter>.fromOpaque(pointer).release()
}

extension PublicGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    public var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PublicGreeter_wrap")
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PublicGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PublicGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PackageGreeter_deinit")
@_cdecl("bjs_PackageGreeter_deinit")
public func _bjs_PackageGreeter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PackageGreeter>.fromOpaque(pointer).release()
}

extension PackageGreeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    package var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PackageGreeter_wrap")
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PackageGreeter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PackageGreeter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
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
public func _bjs_Converter_toString(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    let ret = Utils.Converter.bridgeJSLiftParameter(_self).toString(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_Converter_deinit")
@_cdecl("bjs_Converter_deinit")
public func _bjs_Converter_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Utils.Converter>.fromOpaque(pointer).release()
}

extension Utils.Converter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_Converter_wrap")
        func _bjs_Converter_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_Converter_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_Converter_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
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
public func _bjs_HTTPServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Networking.API.HTTPServer.bridgeJSLiftParameter(_self).call(_: Networking.API.Method.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_HTTPServer_deinit")
@_cdecl("bjs_HTTPServer_deinit")
public func _bjs_HTTPServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Networking.API.HTTPServer>.fromOpaque(pointer).release()
}

extension Networking.API.HTTPServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_HTTPServer_wrap")
        func _bjs_HTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_HTTPServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_HTTPServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
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
public func _bjs_TestServer_call(_self: UnsafeMutableRawPointer, method: Int32) -> Void {
    #if arch(wasm32)
    Internal.TestServer.bridgeJSLiftParameter(_self).call(_: Internal.SupportedMethod.bridgeJSLiftParameter(method))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_TestServer_deinit")
@_cdecl("bjs_TestServer_deinit")
public func _bjs_TestServer_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<Internal.TestServer>.fromOpaque(pointer).release()
}

extension Internal.TestServer: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_TestServer_wrap")
        func _bjs_TestServer_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_TestServer_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_TestServer_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_OptionalPropertyHolder_init")
@_cdecl("bjs_OptionalPropertyHolder_init")
public func _bjs_OptionalPropertyHolder_init(optionalNameIsSome: Int32, optionalNameBytes: Int32, optionalNameLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder(optionalName: Optional<String>.bridgeJSLiftParameter(optionalNameIsSome, optionalNameBytes, optionalNameLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_get")
public func _bjs_OptionalPropertyHolder_optionalName_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalName_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalName_set")
public func _bjs_OptionalPropertyHolder_optionalName_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalName = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_get")
public func _bjs_OptionalPropertyHolder_optionalAge_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalAge_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalAge_set")
public func _bjs_OptionalPropertyHolder_optionalAge_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalAge = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_get")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_get")
public func _bjs_OptionalPropertyHolder_optionalGreeter_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_optionalGreeter_set")
@_cdecl("bjs_OptionalPropertyHolder_optionalGreeter_set")
public func _bjs_OptionalPropertyHolder_optionalGreeter_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    OptionalPropertyHolder.bridgeJSLiftParameter(_self).optionalGreeter = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_OptionalPropertyHolder_deinit")
@_cdecl("bjs_OptionalPropertyHolder_deinit")
public func _bjs_OptionalPropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<OptionalPropertyHolder>.fromOpaque(pointer).release()
}

extension OptionalPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_OptionalPropertyHolder_wrap")
        func _bjs_OptionalPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_OptionalPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_OptionalPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_SimplePropertyHolder_init")
@_cdecl("bjs_SimplePropertyHolder_init")
public func _bjs_SimplePropertyHolder_init(value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SimplePropertyHolder(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_get")
@_cdecl("bjs_SimplePropertyHolder_value_get")
public func _bjs_SimplePropertyHolder_value_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SimplePropertyHolder.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_value_set")
@_cdecl("bjs_SimplePropertyHolder_value_set")
public func _bjs_SimplePropertyHolder_value_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    SimplePropertyHolder.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SimplePropertyHolder_deinit")
@_cdecl("bjs_SimplePropertyHolder_deinit")
public func _bjs_SimplePropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<SimplePropertyHolder>.fromOpaque(pointer).release()
}

extension SimplePropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SimplePropertyHolder_wrap")
        func _bjs_SimplePropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_SimplePropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SimplePropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_PropertyHolder_init")
@_cdecl("bjs_PropertyHolder_init")
public func _bjs_PropertyHolder_init(intValue: Int32, floatValue: Float32, doubleValue: Float64, boolValue: Int32, stringValueBytes: Int32, stringValueLength: Int32, jsObject: Int32, sibling: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder(intValue: Int.bridgeJSLiftParameter(intValue), floatValue: Float.bridgeJSLiftParameter(floatValue), doubleValue: Double.bridgeJSLiftParameter(doubleValue), boolValue: Bool.bridgeJSLiftParameter(boolValue), stringValue: String.bridgeJSLiftParameter(stringValueBytes, stringValueLength), jsObject: JSObject.bridgeJSLiftParameter(jsObject), sibling: SimplePropertyHolder.bridgeJSLiftParameter(sibling))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_getAllValues")
@_cdecl("bjs_PropertyHolder_getAllValues")
public func _bjs_PropertyHolder_getAllValues(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).getAllValues()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_get")
@_cdecl("bjs_PropertyHolder_intValue_get")
public func _bjs_PropertyHolder_intValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).intValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_intValue_set")
@_cdecl("bjs_PropertyHolder_intValue_set")
public func _bjs_PropertyHolder_intValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).intValue = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_get")
@_cdecl("bjs_PropertyHolder_floatValue_get")
public func _bjs_PropertyHolder_floatValue_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).floatValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_floatValue_set")
@_cdecl("bjs_PropertyHolder_floatValue_set")
public func _bjs_PropertyHolder_floatValue_set(_self: UnsafeMutableRawPointer, value: Float32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).floatValue = Float.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_get")
@_cdecl("bjs_PropertyHolder_doubleValue_get")
public func _bjs_PropertyHolder_doubleValue_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).doubleValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_doubleValue_set")
@_cdecl("bjs_PropertyHolder_doubleValue_set")
public func _bjs_PropertyHolder_doubleValue_set(_self: UnsafeMutableRawPointer, value: Float64) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).doubleValue = Double.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_get")
@_cdecl("bjs_PropertyHolder_boolValue_get")
public func _bjs_PropertyHolder_boolValue_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).boolValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_boolValue_set")
@_cdecl("bjs_PropertyHolder_boolValue_set")
public func _bjs_PropertyHolder_boolValue_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).boolValue = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_get")
@_cdecl("bjs_PropertyHolder_stringValue_get")
public func _bjs_PropertyHolder_stringValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).stringValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_stringValue_set")
@_cdecl("bjs_PropertyHolder_stringValue_set")
public func _bjs_PropertyHolder_stringValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).stringValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyInt_get")
@_cdecl("bjs_PropertyHolder_readonlyInt_get")
public func _bjs_PropertyHolder_readonlyInt_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyInt
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyFloat_get")
@_cdecl("bjs_PropertyHolder_readonlyFloat_get")
public func _bjs_PropertyHolder_readonlyFloat_get(_self: UnsafeMutableRawPointer) -> Float32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyFloat
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyDouble_get")
@_cdecl("bjs_PropertyHolder_readonlyDouble_get")
public func _bjs_PropertyHolder_readonlyDouble_get(_self: UnsafeMutableRawPointer) -> Float64 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyDouble
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyBool_get")
@_cdecl("bjs_PropertyHolder_readonlyBool_get")
public func _bjs_PropertyHolder_readonlyBool_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyBool
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_readonlyString_get")
@_cdecl("bjs_PropertyHolder_readonlyString_get")
public func _bjs_PropertyHolder_readonlyString_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).readonlyString
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_get")
@_cdecl("bjs_PropertyHolder_jsObject_get")
public func _bjs_PropertyHolder_jsObject_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).jsObject
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_jsObject_set")
@_cdecl("bjs_PropertyHolder_jsObject_set")
public func _bjs_PropertyHolder_jsObject_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).jsObject = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_get")
@_cdecl("bjs_PropertyHolder_sibling_get")
public func _bjs_PropertyHolder_sibling_get(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).sibling
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_sibling_set")
@_cdecl("bjs_PropertyHolder_sibling_set")
public func _bjs_PropertyHolder_sibling_set(_self: UnsafeMutableRawPointer, value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).sibling = SimplePropertyHolder.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_get")
@_cdecl("bjs_PropertyHolder_lazyValue_get")
public func _bjs_PropertyHolder_lazyValue_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).lazyValue
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_lazyValue_set")
@_cdecl("bjs_PropertyHolder_lazyValue_set")
public func _bjs_PropertyHolder_lazyValue_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).lazyValue = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadonly_get")
@_cdecl("bjs_PropertyHolder_computedReadonly_get")
public func _bjs_PropertyHolder_computedReadonly_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadonly
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_get")
@_cdecl("bjs_PropertyHolder_computedReadWrite_get")
public func _bjs_PropertyHolder_computedReadWrite_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_computedReadWrite_set")
@_cdecl("bjs_PropertyHolder_computedReadWrite_set")
public func _bjs_PropertyHolder_computedReadWrite_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).computedReadWrite = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_get")
@_cdecl("bjs_PropertyHolder_observedProperty_get")
public func _bjs_PropertyHolder_observedProperty_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = PropertyHolder.bridgeJSLiftParameter(_self).observedProperty
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_observedProperty_set")
@_cdecl("bjs_PropertyHolder_observedProperty_set")
public func _bjs_PropertyHolder_observedProperty_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    PropertyHolder.bridgeJSLiftParameter(_self).observedProperty = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_PropertyHolder_deinit")
@_cdecl("bjs_PropertyHolder_deinit")
public func _bjs_PropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<PropertyHolder>.fromOpaque(pointer).release()
}

extension PropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_PropertyHolder_wrap")
        func _bjs_PropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_PropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_PropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_MathUtils_static_add")
@_cdecl("bjs_MathUtils_static_add")
public func _bjs_MathUtils_static_add(a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.add(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_static_substract")
@_cdecl("bjs_MathUtils_static_substract")
public func _bjs_MathUtils_static_substract(a: Int32, b: Int32) -> Int32 {
    #if arch(wasm32)
    let ret = MathUtils.substract(a: Int.bridgeJSLiftParameter(a), b: Int.bridgeJSLiftParameter(b))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_MathUtils_deinit")
@_cdecl("bjs_MathUtils_deinit")
public func _bjs_MathUtils_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<MathUtils>.fromOpaque(pointer).release()
}

extension MathUtils: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_MathUtils_wrap")
        func _bjs_MathUtils_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_MathUtils_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_MathUtils_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_ConstructorDefaults_init")
@_cdecl("bjs_ConstructorDefaults_init")
public func _bjs_ConstructorDefaults_init(nameBytes: Int32, nameLength: Int32, count: Int32, enabled: Int32, status: Int32, tagIsSome: Int32, tagBytes: Int32, tagLength: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ConstructorDefaults(name: String.bridgeJSLiftParameter(nameBytes, nameLength), count: Int.bridgeJSLiftParameter(count), enabled: Bool.bridgeJSLiftParameter(enabled), status: Status.bridgeJSLiftParameter(status), tag: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_describe")
@_cdecl("bjs_ConstructorDefaults_describe")
public func _bjs_ConstructorDefaults_describe(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).describe()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_get")
@_cdecl("bjs_ConstructorDefaults_name_get")
public func _bjs_ConstructorDefaults_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_name_set")
@_cdecl("bjs_ConstructorDefaults_name_set")
public func _bjs_ConstructorDefaults_name_set(_self: UnsafeMutableRawPointer, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).name = String.bridgeJSLiftParameter(valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_get")
@_cdecl("bjs_ConstructorDefaults_count_get")
public func _bjs_ConstructorDefaults_count_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_count_set")
@_cdecl("bjs_ConstructorDefaults_count_set")
public func _bjs_ConstructorDefaults_count_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_get")
@_cdecl("bjs_ConstructorDefaults_enabled_get")
public func _bjs_ConstructorDefaults_enabled_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).enabled
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_enabled_set")
@_cdecl("bjs_ConstructorDefaults_enabled_set")
public func _bjs_ConstructorDefaults_enabled_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).enabled = Bool.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_get")
@_cdecl("bjs_ConstructorDefaults_status_get")
public func _bjs_ConstructorDefaults_status_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).status
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_status_set")
@_cdecl("bjs_ConstructorDefaults_status_set")
public func _bjs_ConstructorDefaults_status_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).status = Status.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_get")
@_cdecl("bjs_ConstructorDefaults_tag_get")
public func _bjs_ConstructorDefaults_tag_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = ConstructorDefaults.bridgeJSLiftParameter(_self).tag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_tag_set")
@_cdecl("bjs_ConstructorDefaults_tag_set")
public func _bjs_ConstructorDefaults_tag_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    ConstructorDefaults.bridgeJSLiftParameter(_self).tag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ConstructorDefaults_deinit")
@_cdecl("bjs_ConstructorDefaults_deinit")
public func _bjs_ConstructorDefaults_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<ConstructorDefaults>.fromOpaque(pointer).release()
}

extension ConstructorDefaults: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_ConstructorDefaults_wrap")
        func _bjs_ConstructorDefaults_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_ConstructorDefaults_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ConstructorDefaults_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
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
public func _bjs_StaticPropertyHolder_static_staticVariable_set(value: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_staticString_set(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_staticBool_set(value: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_staticFloat_set(value: Float32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_staticDouble_set(value: Float64) -> Void {
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
public func _bjs_StaticPropertyHolder_static_computedProperty_set(valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_optionalString_set(valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_optionalInt_set(valueIsSome: Int32, valueValue: Int32) -> Void {
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
public func _bjs_StaticPropertyHolder_static_jsObjectProperty_set(value: Int32) -> Void {
    #if arch(wasm32)
    StaticPropertyHolder.jsObjectProperty = JSObject.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_StaticPropertyHolder_deinit")
@_cdecl("bjs_StaticPropertyHolder_deinit")
public func _bjs_StaticPropertyHolder_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<StaticPropertyHolder>.fromOpaque(pointer).release()
}

extension StaticPropertyHolder: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_StaticPropertyHolder_wrap")
        func _bjs_StaticPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_StaticPropertyHolder_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_StaticPropertyHolder_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

@_expose(wasm, "bjs_DataProcessorManager_init")
@_cdecl("bjs_DataProcessorManager_init")
public func _bjs_DataProcessorManager_init(processor: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = DataProcessorManager(processor: AnyDataProcessor.bridgeJSLiftParameter(processor))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_incrementByAmount")
@_cdecl("bjs_DataProcessorManager_incrementByAmount")
public func _bjs_DataProcessorManager_incrementByAmount(_self: UnsafeMutableRawPointer, amount: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).incrementByAmount(_: Int.bridgeJSLiftParameter(amount))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorLabel")
@_cdecl("bjs_DataProcessorManager_setProcessorLabel")
public func _bjs_DataProcessorManager_setProcessorLabel(_self: UnsafeMutableRawPointer, prefixBytes: Int32, prefixLength: Int32, suffixBytes: Int32, suffixLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorLabel(_: String.bridgeJSLiftParameter(prefixBytes, prefixLength), _: String.bridgeJSLiftParameter(suffixBytes, suffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_isProcessorEven")
@_cdecl("bjs_DataProcessorManager_isProcessorEven")
public func _bjs_DataProcessorManager_isProcessorEven(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).isProcessorEven()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorLabel")
@_cdecl("bjs_DataProcessorManager_getProcessorLabel")
public func _bjs_DataProcessorManager_getProcessorLabel(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorLabel()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getCurrentValue")
@_cdecl("bjs_DataProcessorManager_getCurrentValue")
public func _bjs_DataProcessorManager_getCurrentValue(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getCurrentValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_incrementBoth")
@_cdecl("bjs_DataProcessorManager_incrementBoth")
public func _bjs_DataProcessorManager_incrementBoth(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).incrementBoth()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getBackupValue")
@_cdecl("bjs_DataProcessorManager_getBackupValue")
public func _bjs_DataProcessorManager_getBackupValue(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getBackupValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_hasBackup")
@_cdecl("bjs_DataProcessorManager_hasBackup")
public func _bjs_DataProcessorManager_hasBackup(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).hasBackup()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorOptionalTag")
@_cdecl("bjs_DataProcessorManager_getProcessorOptionalTag")
public func _bjs_DataProcessorManager_getProcessorOptionalTag(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorOptionalTag()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorOptionalTag")
@_cdecl("bjs_DataProcessorManager_setProcessorOptionalTag")
public func _bjs_DataProcessorManager_setProcessorOptionalTag(_self: UnsafeMutableRawPointer, tagIsSome: Int32, tagBytes: Int32, tagLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorOptionalTag(_: Optional<String>.bridgeJSLiftParameter(tagIsSome, tagBytes, tagLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorOptionalCount")
@_cdecl("bjs_DataProcessorManager_getProcessorOptionalCount")
public func _bjs_DataProcessorManager_getProcessorOptionalCount(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorOptionalCount()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorOptionalCount")
@_cdecl("bjs_DataProcessorManager_setProcessorOptionalCount")
public func _bjs_DataProcessorManager_setProcessorOptionalCount(_self: UnsafeMutableRawPointer, countIsSome: Int32, countValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorOptionalCount(_: Optional<Int>.bridgeJSLiftParameter(countIsSome, countValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorDirection")
@_cdecl("bjs_DataProcessorManager_getProcessorDirection")
public func _bjs_DataProcessorManager_getProcessorDirection(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorDirection()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorDirection")
@_cdecl("bjs_DataProcessorManager_setProcessorDirection")
public func _bjs_DataProcessorManager_setProcessorDirection(_self: UnsafeMutableRawPointer, directionIsSome: Int32, directionValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorDirection(_: Optional<Direction>.bridgeJSLiftParameter(directionIsSome, directionValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorTheme")
@_cdecl("bjs_DataProcessorManager_getProcessorTheme")
public func _bjs_DataProcessorManager_getProcessorTheme(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorTheme()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorTheme")
@_cdecl("bjs_DataProcessorManager_setProcessorTheme")
public func _bjs_DataProcessorManager_setProcessorTheme(_self: UnsafeMutableRawPointer, themeIsSome: Int32, themeBytes: Int32, themeLength: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorTheme(_: Optional<Theme>.bridgeJSLiftParameter(themeIsSome, themeBytes, themeLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorHttpStatus")
@_cdecl("bjs_DataProcessorManager_getProcessorHttpStatus")
public func _bjs_DataProcessorManager_getProcessorHttpStatus(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorHttpStatus()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorHttpStatus")
@_cdecl("bjs_DataProcessorManager_setProcessorHttpStatus")
public func _bjs_DataProcessorManager_setProcessorHttpStatus(_self: UnsafeMutableRawPointer, statusIsSome: Int32, statusValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorHttpStatus(_: Optional<HttpStatus>.bridgeJSLiftParameter(statusIsSome, statusValue))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_getProcessorAPIResult")
@_cdecl("bjs_DataProcessorManager_getProcessorAPIResult")
public func _bjs_DataProcessorManager_getProcessorAPIResult(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).getProcessorAPIResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_setProcessorAPIResult")
@_cdecl("bjs_DataProcessorManager_setProcessorAPIResult")
public func _bjs_DataProcessorManager_setProcessorAPIResult(_self: UnsafeMutableRawPointer, apiResultIsSome: Int32, apiResultCaseId: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).setProcessorAPIResult(_: Optional<APIResult>.bridgeJSLiftParameter(apiResultIsSome, apiResultCaseId))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_processor_get")
@_cdecl("bjs_DataProcessorManager_processor_get")
public func _bjs_DataProcessorManager_processor_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = DataProcessorManager.bridgeJSLiftParameter(_self).processor as! AnyDataProcessor
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_processor_set")
@_cdecl("bjs_DataProcessorManager_processor_set")
public func _bjs_DataProcessorManager_processor_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).processor = AnyDataProcessor.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_backupProcessor_get")
@_cdecl("bjs_DataProcessorManager_backupProcessor_get")
public func _bjs_DataProcessorManager_backupProcessor_get(_self: UnsafeMutableRawPointer) -> Void {
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
public func _bjs_DataProcessorManager_backupProcessor_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    DataProcessorManager.bridgeJSLiftParameter(_self).backupProcessor = Optional<AnyDataProcessor>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_DataProcessorManager_deinit")
@_cdecl("bjs_DataProcessorManager_deinit")
public func _bjs_DataProcessorManager_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<DataProcessorManager>.fromOpaque(pointer).release()
}

extension DataProcessorManager: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_DataProcessorManager_wrap")
        func _bjs_DataProcessorManager_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_DataProcessorManager_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_DataProcessorManager_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
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
public func _bjs_SwiftDataProcessor_increment(_self: UnsafeMutableRawPointer, amount: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).increment(by: Int.bridgeJSLiftParameter(amount))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getValue")
@_cdecl("bjs_SwiftDataProcessor_getValue")
public func _bjs_SwiftDataProcessor_getValue(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getValue()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_setLabelElements")
@_cdecl("bjs_SwiftDataProcessor_setLabelElements")
public func _bjs_SwiftDataProcessor_setLabelElements(_self: UnsafeMutableRawPointer, labelPrefixBytes: Int32, labelPrefixLength: Int32, labelSuffixBytes: Int32, labelSuffixLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).setLabelElements(_: String.bridgeJSLiftParameter(labelPrefixBytes, labelPrefixLength), _: String.bridgeJSLiftParameter(labelSuffixBytes, labelSuffixLength))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getLabel")
@_cdecl("bjs_SwiftDataProcessor_getLabel")
public func _bjs_SwiftDataProcessor_getLabel(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getLabel()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_isEven")
@_cdecl("bjs_SwiftDataProcessor_isEven")
public func _bjs_SwiftDataProcessor_isEven(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).isEven()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_processGreeter")
@_cdecl("bjs_SwiftDataProcessor_processGreeter")
public func _bjs_SwiftDataProcessor_processGreeter(_self: UnsafeMutableRawPointer, greeter: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).processGreeter(_: Greeter.bridgeJSLiftParameter(greeter))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_createGreeter")
@_cdecl("bjs_SwiftDataProcessor_createGreeter")
public func _bjs_SwiftDataProcessor_createGreeter(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).createGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_processOptionalGreeter")
@_cdecl("bjs_SwiftDataProcessor_processOptionalGreeter")
public func _bjs_SwiftDataProcessor_processOptionalGreeter(_self: UnsafeMutableRawPointer, greeterIsSome: Int32, greeterValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).processOptionalGreeter(_: Optional<Greeter>.bridgeJSLiftParameter(greeterIsSome, greeterValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_createOptionalGreeter")
@_cdecl("bjs_SwiftDataProcessor_createOptionalGreeter")
public func _bjs_SwiftDataProcessor_createOptionalGreeter(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).createOptionalGreeter()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_handleAPIResult")
@_cdecl("bjs_SwiftDataProcessor_handleAPIResult")
public func _bjs_SwiftDataProcessor_handleAPIResult(_self: UnsafeMutableRawPointer, resultIsSome: Int32, resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).handleAPIResult(_: Optional<APIResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_getAPIResult")
@_cdecl("bjs_SwiftDataProcessor_getAPIResult")
public func _bjs_SwiftDataProcessor_getAPIResult(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).getAPIResult()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_count_get")
@_cdecl("bjs_SwiftDataProcessor_count_get")
public func _bjs_SwiftDataProcessor_count_get(_self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).count
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_count_set")
@_cdecl("bjs_SwiftDataProcessor_count_set")
public func _bjs_SwiftDataProcessor_count_set(_self: UnsafeMutableRawPointer, value: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).count = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_name_get")
@_cdecl("bjs_SwiftDataProcessor_name_get")
public func _bjs_SwiftDataProcessor_name_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).name
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTag_get")
@_cdecl("bjs_SwiftDataProcessor_optionalTag_get")
public func _bjs_SwiftDataProcessor_optionalTag_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTag
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTag_set")
@_cdecl("bjs_SwiftDataProcessor_optionalTag_set")
public func _bjs_SwiftDataProcessor_optionalTag_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTag = Optional<String>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalCount_get")
@_cdecl("bjs_SwiftDataProcessor_optionalCount_get")
public func _bjs_SwiftDataProcessor_optionalCount_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalCount
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalCount_set")
@_cdecl("bjs_SwiftDataProcessor_optionalCount_set")
public func _bjs_SwiftDataProcessor_optionalCount_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalCount = Optional<Int>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_direction_get")
@_cdecl("bjs_SwiftDataProcessor_direction_get")
public func _bjs_SwiftDataProcessor_direction_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).direction
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_direction_set")
@_cdecl("bjs_SwiftDataProcessor_direction_set")
public func _bjs_SwiftDataProcessor_direction_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).direction = Optional<Direction>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTheme_get")
@_cdecl("bjs_SwiftDataProcessor_optionalTheme_get")
public func _bjs_SwiftDataProcessor_optionalTheme_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTheme
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalTheme_set")
@_cdecl("bjs_SwiftDataProcessor_optionalTheme_set")
public func _bjs_SwiftDataProcessor_optionalTheme_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueBytes: Int32, valueLength: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalTheme = Optional<Theme>.bridgeJSLiftParameter(valueIsSome, valueBytes, valueLength)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_httpStatus_get")
@_cdecl("bjs_SwiftDataProcessor_httpStatus_get")
public func _bjs_SwiftDataProcessor_httpStatus_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).httpStatus
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_httpStatus_set")
@_cdecl("bjs_SwiftDataProcessor_httpStatus_set")
public func _bjs_SwiftDataProcessor_httpStatus_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).httpStatus = Optional<HttpStatus>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_apiResult_get")
@_cdecl("bjs_SwiftDataProcessor_apiResult_get")
public func _bjs_SwiftDataProcessor_apiResult_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).apiResult
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_apiResult_set")
@_cdecl("bjs_SwiftDataProcessor_apiResult_set")
public func _bjs_SwiftDataProcessor_apiResult_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueCaseId: Int32) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).apiResult = Optional<APIResult>.bridgeJSLiftParameter(valueIsSome, valueCaseId)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_helper_get")
@_cdecl("bjs_SwiftDataProcessor_helper_get")
public func _bjs_SwiftDataProcessor_helper_get(_self: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).helper
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_helper_set")
@_cdecl("bjs_SwiftDataProcessor_helper_set")
public func _bjs_SwiftDataProcessor_helper_set(_self: UnsafeMutableRawPointer, value: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).helper = Greeter.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalHelper_get")
@_cdecl("bjs_SwiftDataProcessor_optionalHelper_get")
public func _bjs_SwiftDataProcessor_optionalHelper_get(_self: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    let ret = SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalHelper
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_optionalHelper_set")
@_cdecl("bjs_SwiftDataProcessor_optionalHelper_set")
public func _bjs_SwiftDataProcessor_optionalHelper_set(_self: UnsafeMutableRawPointer, valueIsSome: Int32, valueValue: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    SwiftDataProcessor.bridgeJSLiftParameter(_self).optionalHelper = Optional<Greeter>.bridgeJSLiftParameter(valueIsSome, valueValue)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_SwiftDataProcessor_deinit")
@_cdecl("bjs_SwiftDataProcessor_deinit")
public func _bjs_SwiftDataProcessor_deinit(pointer: UnsafeMutableRawPointer) {
    Unmanaged<SwiftDataProcessor>.fromOpaque(pointer).release()
}

extension SwiftDataProcessor: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        #if arch(wasm32)
        @_extern(wasm, module: "BridgeJSRuntimeTests", name: "bjs_SwiftDataProcessor_wrap")
        func _bjs_SwiftDataProcessor_wrap(_: UnsafeMutableRawPointer) -> Int32
        #else
        func _bjs_SwiftDataProcessor_wrap(_: UnsafeMutableRawPointer) -> Int32 {
            fatalError("Only available on WebAssembly")
        }
        #endif
        return .object(JSObject(id: UInt32(bitPattern: _bjs_SwiftDataProcessor_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}