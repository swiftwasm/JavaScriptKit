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
            return .status(Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 3:
            return .coordinates(Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter())
        case 4:
            return .comprehensive(Bool.bridgeJSLiftParameter(), Bool.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), Double.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter(), String.bridgeJSLiftParameter())
        case 5:
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
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(2)
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            return Int32(3)
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
            return Int32(4)
        case .info:
            return Int32(5)
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
        case .status(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(2))
        case .coordinates(let param0, let param1, let param2):
            param0.bridgeJSLowerStackReturn()
            param1.bridgeJSLowerStackReturn()
            param2.bridgeJSLowerStackReturn()
            _swift_js_push_i32(Int32(3))
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
            _swift_js_push_i32(Int32(4))
        case .info:
            _swift_js_push_i32(Int32(5))
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

extension NetworkingResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> NetworkingResult {
        switch caseId {
        case 0:
            return .success(String.bridgeJSLiftParameter())
        case 1:
            return .failure(String.bridgeJSLiftParameter(), Int.bridgeJSLiftParameter())
        default:
            fatalError("Unknown NetworkingResult case ID: \(caseId)")
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

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> NetworkingResult {
        return _bridgeJSLiftFromCaseId(caseId)
    }

    // MARK: ExportSwift

    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> NetworkingResult {
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

extension Precision: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension CardinalDirection: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> CardinalDirection {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> CardinalDirection {
        return CardinalDirection(bridgeJSRawValue: value)!
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

extension TypedPayloadResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> TypedPayloadResult {
        switch caseId {
        case 0:
            return .precision(Precision.bridgeJSLiftParameter(_swift_js_pop_f32()))
        case 1:
            return .direction(CardinalDirection.bridgeJSLiftParameter(_swift_js_pop_i32()))
        case 2:
            return .optPrecision(Optional<Precision>.bridgeJSLiftParameter())
        case 3:
            return .optDirection(Optional<CardinalDirection>.bridgeJSLiftParameter())
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

extension AllTypesResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> AllTypesResult {
        switch caseId {
        case 0:
            return .structPayload(Point.bridgeJSLiftParameter())
        case 1:
            return .classPayload(User.bridgeJSLiftParameter())
        case 2:
            return .jsObjectPayload(JSObject.bridgeJSLiftParameter())
        case 3:
            return .nestedEnum(APIResult.bridgeJSLiftParameter(_swift_js_pop_i32()))
        case 4:
            return .arrayPayload([Int].bridgeJSLiftParameter())
        case 5:
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
        case .empty:
            return Int32(5)
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
        case .empty:
            _swift_js_push_i32(Int32(5))
        }
    }
}

extension OptionalAllTypesResult: _BridgedSwiftAssociatedValueEnum {
    private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> OptionalAllTypesResult {
        switch caseId {
        case 0:
            return .optStruct(Optional<Point>.bridgeJSLiftParameter())
        case 1:
            return .optClass(Optional<User>.bridgeJSLiftParameter())
        case 2:
            return .optJSObject(Optional<JSObject>.bridgeJSLiftParameter())
        case 3:
            return .optNestedEnum(Optional<APIResult>.bridgeJSLiftParameter())
        case 4:
            return .optArray(Optional<[Int]>.bridgeJSLiftParameter())
        case 5:
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
        case .empty:
            return Int32(5)
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
        case .empty:
            _swift_js_push_i32(Int32(5))
        }
    }
}

extension Point: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> Point {
        let y = Double.bridgeJSLiftParameter()
        let x = Double.bridgeJSLiftParameter()
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

@_expose(wasm, "bjs_handle")
@_cdecl("bjs_handle")
public func _bjs_handle(_ result: Int32) -> Void {
    #if arch(wasm32)
    handle(result: APIResult.bridgeJSLiftParameter(result))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getResult")
@_cdecl("bjs_getResult")
public func _bjs_getResult() -> Void {
    #if arch(wasm32)
    let ret = getResult()
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

@_expose(wasm, "bjs_roundTripOptionalAPIResult")
@_cdecl("bjs_roundTripOptionalAPIResult")
public func _bjs_roundTripOptionalAPIResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalAPIResult(result: Optional<APIResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_handleComplex")
@_cdecl("bjs_handleComplex")
public func _bjs_handleComplex(_ result: Int32) -> Void {
    #if arch(wasm32)
    handleComplex(result: ComplexResult.bridgeJSLiftParameter(result))
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_getComplexResult")
@_cdecl("bjs_getComplexResult")
public func _bjs_getComplexResult() -> Void {
    #if arch(wasm32)
    let ret = getComplexResult()
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

@_expose(wasm, "bjs_roundTripOptionalComplexResult")
@_cdecl("bjs_roundTripOptionalComplexResult")
public func _bjs_roundTripOptionalComplexResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalComplexResult(result: Optional<ComplexResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalUtilitiesResult")
@_cdecl("bjs_roundTripOptionalUtilitiesResult")
public func _bjs_roundTripOptionalUtilitiesResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalUtilitiesResult(result: Optional<Utilities.Result>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_roundTripOptionalNetworkingResult")
@_cdecl("bjs_roundTripOptionalNetworkingResult")
public func _bjs_roundTripOptionalNetworkingResult(_ resultIsSome: Int32, _ resultCaseId: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalNetworkingResult(result: Optional<NetworkingResult>.bridgeJSLiftParameter(resultIsSome, resultCaseId))
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

@_expose(wasm, "bjs_compareAPIResults")
@_cdecl("bjs_compareAPIResults")
public func _bjs_compareAPIResults(_ result1IsSome: Int32, _ result1CaseId: Int32, _ result2IsSome: Int32, _ result2CaseId: Int32) -> Void {
    #if arch(wasm32)
    let _tmp_result2 = Optional<APIOptionalResult>.bridgeJSLiftParameter(result2IsSome, result2CaseId)
    let _tmp_result1 = Optional<APIOptionalResult>.bridgeJSLiftParameter(result1IsSome, result1CaseId)
    let ret = compareAPIResults(result1: _tmp_result1, result2: _tmp_result2)
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

@_expose(wasm, "bjs_User_deinit")
@_cdecl("bjs_User_deinit")
public func _bjs_User_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<User>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension User: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_User_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_User_wrap")
fileprivate func _bjs_User_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_User_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif