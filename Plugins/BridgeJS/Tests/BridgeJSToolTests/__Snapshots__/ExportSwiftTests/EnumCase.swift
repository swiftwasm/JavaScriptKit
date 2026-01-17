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

extension PublicStatus: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> PublicStatus {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> PublicStatus {
        return PublicStatus(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    private init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .success
        default:
            return nil
        }
    }

    private var bridgeJSRawValue: Int32 {
        switch self {
        case .success:
            return 0
        }
    }
}

@_expose(wasm, "bjs_setDirection")
@_cdecl("bjs_setDirection")
public func _bjs_setDirection(_ direction: Int32) -> Void {
    #if arch(wasm32)
    setDirection(_: Direction.bridgeJSLiftParameter(direction))
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

@_expose(wasm, "bjs_roundTripOptionalDirection")
@_cdecl("bjs_roundTripOptionalDirection")
public func _bjs_roundTripOptionalDirection(_ inputIsSome: Int32, _ inputValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalDirection(_: Optional<Direction>.bridgeJSLiftParameter(inputIsSome, inputValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_setTSDirection")
@_cdecl("bjs_setTSDirection")
public func _bjs_setTSDirection(_ direction: Int32) -> Void {
    #if arch(wasm32)
    setTSDirection(_: TSDirection.bridgeJSLiftParameter(direction))
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

@_expose(wasm, "bjs_roundTripOptionalTSDirection")
@_cdecl("bjs_roundTripOptionalTSDirection")
public func _bjs_roundTripOptionalTSDirection(_ inputIsSome: Int32, _ inputValue: Int32) -> Void {
    #if arch(wasm32)
    let ret = roundTripOptionalTSDirection(_: Optional<TSDirection>.bridgeJSLiftParameter(inputIsSome, inputValue))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}