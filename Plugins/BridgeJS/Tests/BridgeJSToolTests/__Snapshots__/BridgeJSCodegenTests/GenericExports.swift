extension ExportNamespace.Level: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension ExportNamespace.Level: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportNamespace_Level")
}

extension ExportMode: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
}

extension ExportMode: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportMode")
}

extension ExportColor: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> ExportColor {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> ExportColor {
        return ExportColor(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .red
        case 1:
            self = .green
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .red:
            return 0
        case .green:
            return 1
        }
    }
}

extension ExportColor: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportColor")
}

extension ExportTagged: _BridgedSwiftAssociatedValueEnum {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> ExportTagged {
        switch caseId {
        case 0:
            return .number(value: Int.bridgeJSStackPop())
        case 1:
            return .text(value: String.bridgeJSStackPop())
        default:
            fatalError("Unknown ExportTagged case ID: \(caseId)")
        }
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {
        switch self {
        case .number(let value):
            value.bridgeJSStackPush()
            return Int32(0)
        case .text(let value):
            value.bridgeJSStackPush()
            return Int32(1)
        }
    }
}

extension ExportTagged: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportTagged")
}

extension GenericFactory: _BridgedSwiftCaseEnum {
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
        return bridgeJSRawValue
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> GenericFactory {
        return bridgeJSLiftParameter(value)
    }
    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> GenericFactory {
        return GenericFactory(bridgeJSRawValue: value)!
    }
    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
        return bridgeJSLowerParameter()
    }

    @_spi(BridgeJS) @usableFromInline init?(bridgeJSRawValue: Int32) {
        switch bridgeJSRawValue {
        case 0:
            self = .primary
        default:
            return nil
        }
    }

    @_spi(BridgeJS) @usableFromInline var bridgeJSRawValue: Int32 {
        switch self {
        case .primary:
            return 0
        }
    }
}

extension GenericFactory: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericFactory")
}

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericFactory_static_one")
@_cdecl("bjs_GenericFactory_static_one")
public func _bjs_GenericFactory_static_one(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericFactory_static_one")
@_cdecl("bjs_GenericFactory_static_one")
public func _bjs_GenericFactory_static_one(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericFactory_static_one_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericFactory_static_one_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let ret = GenericFactory.one(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericNamespace_static_make")
@_cdecl("bjs_GenericNamespace_static_make")
public func _bjs_GenericNamespace_static_make(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericNamespace_static_make")
@_cdecl("bjs_GenericNamespace_static_make")
public func _bjs_GenericNamespace_static_make(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericNamespace_static_make_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericNamespace_static_make_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let ret = GenericNamespace.make(value)
    ret.bridgeJSStackPush()
}
#endif

extension ExportPoint: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ExportPoint {
        let y = Int.bridgeJSStackPop()
        let x = Int.bridgeJSStackPop()
        return ExportPoint(x: x, y: y)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.x.bridgeJSStackPush()
        self.y.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ExportPoint(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ExportPoint()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ExportPoint")
fileprivate func _bjs_struct_lower_ExportPoint_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ExportPoint_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ExportPoint(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ExportPoint_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ExportPoint")
fileprivate func _bjs_struct_lift_ExportPoint_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ExportPoint_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ExportPoint() -> Int32 {
    return _bjs_struct_lift_ExportPoint_extern()
}

extension ExportPoint: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportPoint")
}

extension ExportNamespace.Metadata: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> ExportNamespace.Metadata {
        let count = Int.bridgeJSStackPop()
        let label = String.bridgeJSStackPop()
        return ExportNamespace.Metadata(label: label, count: count)
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
        self.label.bridgeJSStackPush()
        self.count.bridgeJSStackPush()
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_ExportNamespace_Metadata(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_ExportNamespace_Metadata()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_ExportNamespace_Metadata")
fileprivate func _bjs_struct_lower_ExportNamespace_Metadata_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_ExportNamespace_Metadata_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_ExportNamespace_Metadata(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_ExportNamespace_Metadata_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_ExportNamespace_Metadata")
fileprivate func _bjs_struct_lift_ExportNamespace_Metadata_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_ExportNamespace_Metadata_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_ExportNamespace_Metadata() -> Int32 {
    return _bjs_struct_lift_ExportNamespace_Metadata_extern()
}

extension ExportNamespace.Metadata: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportNamespace_Metadata")
}

extension GenericPair: _BridgedSwiftStruct {
    @_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> GenericPair {
        return GenericPair()
    }

    @_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {
    }

    init(unsafelyCopying jsObject: JSObject) {
        _bjs_struct_lower_GenericPair(jsObject.bridgeJSLowerParameter())
        self = Self.bridgeJSStackPop()
    }

    func toJSObject() -> JSObject {
        let __bjs_self = self
        __bjs_self.bridgeJSStackPush()
        return JSObject(id: UInt32(bitPattern: _bjs_struct_lift_GenericPair()))
    }
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lower_GenericPair")
fileprivate func _bjs_struct_lower_GenericPair_extern(_ objectId: Int32) -> Void
#else
fileprivate func _bjs_struct_lower_GenericPair_extern(_ objectId: Int32) -> Void {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lower_GenericPair(_ objectId: Int32) -> Void {
    return _bjs_struct_lower_GenericPair_extern(objectId)
}

#if arch(wasm32)
@_extern(wasm, module: "bjs", name: "swift_js_struct_lift_GenericPair")
fileprivate func _bjs_struct_lift_GenericPair_extern() -> Int32
#else
fileprivate func _bjs_struct_lift_GenericPair_extern() -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_struct_lift_GenericPair() -> Int32 {
    return _bjs_struct_lift_GenericPair_extern()
}

extension GenericPair: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericPair")
}

@_expose(wasm, "bjs_GenericPair_init")
@_cdecl("bjs_GenericPair_init")
public func _bjs_GenericPair_init() -> Void {
    #if arch(wasm32)
    let ret = GenericPair()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericPair_first")
@_cdecl("bjs_GenericPair_first")
public func _bjs_GenericPair_first(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericPair_first")
@_cdecl("bjs_GenericPair_first")
public func _bjs_GenericPair_first(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericPair_first_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericPair_first_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let _tmp__self = GenericPair.bridgeJSLiftParameter()
    let ret = _tmp__self.first(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericPair_combine")
@_cdecl("bjs_GenericPair_combine")
public func _bjs_GenericPair_combine(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericPair_combine")
@_cdecl("bjs_GenericPair_combine")
public func _bjs_GenericPair_combine(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    guard let _generic1Type = _bridgeJSExportTypeRegistry[_generic1TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic1TypeId)")
    }
    _bjs_GenericPair_combine_open1(_generic0Type, _generic1Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericPair_combine_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _generic1Type: any BridgedSwiftGenericBridgeable.Type) {
    _bjs_GenericPair_combine_open2(_generic1Type, asT: T.self)
}
private func _bjs_GenericPair_combine_open2<t: BridgedSwiftGenericBridgeable, T: BridgedSwiftGenericBridgeable>(_ _generic1Type: t.Type, asT _generic0Type: T.Type) {
    let b = t.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let _tmp__self = GenericPair.bridgeJSLiftParameter()
    let ret = _tmp__self.combine(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericPair_maybe")
@_cdecl("bjs_GenericPair_maybe")
public func _bjs_GenericPair_maybe(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericPair_maybe")
@_cdecl("bjs_GenericPair_maybe")
public func _bjs_GenericPair_maybe(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericPair_maybe_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericPair_maybe_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let _tmp__self = GenericPair.bridgeJSLiftParameter()
    let ret = _tmp__self.maybe(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericPair_dict")
@_cdecl("bjs_GenericPair_dict")
public func _bjs_GenericPair_dict(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericPair_dict")
@_cdecl("bjs_GenericPair_dict")
public func _bjs_GenericPair_dict(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericPair_dict_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericPair_dict_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let _tmp__self = GenericPair.bridgeJSLiftParameter()
    let ret = _tmp__self.dict(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericPair_static_wrap")
@_cdecl("bjs_GenericPair_static_wrap")
public func _bjs_GenericPair_static_wrap(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericPair_static_wrap")
@_cdecl("bjs_GenericPair_static_wrap")
public func _bjs_GenericPair_static_wrap(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericPair_static_wrap_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericPair_static_wrap_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let ret = GenericPair.wrap(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportIdentity")
@_cdecl("bjs_genericExportIdentity")
public func _bjs_genericExportIdentity(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportIdentity")
@_cdecl("bjs_genericExportIdentity")
public func _bjs_genericExportIdentity(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportIdentity_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportIdentity_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let ret = genericExportIdentity(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportArray")
@_cdecl("bjs_genericExportArray")
public func _bjs_genericExportArray(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportArray")
@_cdecl("bjs_genericExportArray")
public func _bjs_genericExportArray(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportArray_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportArray_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let values = Array<T>.bridgeJSStackPop()
    let ret = genericExportArray(values)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportOptional")
@_cdecl("bjs_genericExportOptional")
public func _bjs_genericExportOptional(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportOptional")
@_cdecl("bjs_genericExportOptional")
public func _bjs_genericExportOptional(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportOptional_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportOptional_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = Optional<T>.bridgeJSStackPop()
    let ret = genericExportOptional(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportDictionary")
@_cdecl("bjs_genericExportDictionary")
public func _bjs_genericExportDictionary(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportDictionary")
@_cdecl("bjs_genericExportDictionary")
public func _bjs_genericExportDictionary(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportDictionary_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportDictionary_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let values = Dictionary<String, T>.bridgeJSStackPop()
    let ret = genericExportDictionary(values)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportEcho")
@_cdecl("bjs_genericExportEcho")
public func _bjs_genericExportEcho(_ tag: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportEcho")
@_cdecl("bjs_genericExportEcho")
public func _bjs_genericExportEcho(_ tag: Int32, _ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportEcho_open1(_generic0Type, tag)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportEcho_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ tag: Int32) {
    let value = T.bridgeJSStackPop()
    let _val_tag = Int.bridgeJSLiftParameter(tag)
    let ret = genericExportEcho(value, tag: _val_tag)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportStructConcreteLeading")
@_cdecl("bjs_genericExportStructConcreteLeading")
public func _bjs_genericExportStructConcreteLeading(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportStructConcreteLeading")
@_cdecl("bjs_genericExportStructConcreteLeading")
public func _bjs_genericExportStructConcreteLeading(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportStructConcreteLeading_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportStructConcreteLeading_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let v = T.bridgeJSStackPop()
    let _tmp_p = ExportPoint.bridgeJSLiftParameter()
    let ret = genericExportStructConcreteLeading(v, _tmp_p)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportStructAndScalar")
@_cdecl("bjs_genericExportStructAndScalar")
public func _bjs_genericExportStructAndScalar(_ tag: Int32, _ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportStructAndScalar")
@_cdecl("bjs_genericExportStructAndScalar")
public func _bjs_genericExportStructAndScalar(_ tag: Int32, _ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportStructAndScalar_open1(_generic0Type, tag)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportStructAndScalar_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ tag: Int32) {
    let v = T.bridgeJSStackPop()
    let _tmp_p = ExportPoint.bridgeJSLiftParameter()
    let _val_tag = Int.bridgeJSLiftParameter(tag)
    let ret = genericExportStructAndScalar(_tmp_p, tag: _val_tag, v)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportPair")
@_cdecl("bjs_genericExportPair")
public func _bjs_genericExportPair(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportPair")
@_cdecl("bjs_genericExportPair")
public func _bjs_genericExportPair(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_genericExportPair_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportPair_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let b = T.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let ret = genericExportPair(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportCombine")
@_cdecl("bjs_genericExportCombine")
public func _bjs_genericExportCombine(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportCombine")
@_cdecl("bjs_genericExportCombine")
public func _bjs_genericExportCombine(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    guard let _generic1Type = _bridgeJSExportTypeRegistry[_generic1TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic1TypeId)")
    }
    _bjs_genericExportCombine_open1(_generic0Type, _generic1Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportCombine_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _generic1Type: any BridgedSwiftGenericBridgeable.Type) {
    _bjs_genericExportCombine_open2(_generic1Type, asT: T.self)
}
private func _bjs_genericExportCombine_open2<U: BridgedSwiftGenericBridgeable, T: BridgedSwiftGenericBridgeable>(_ _generic1Type: U.Type, asT _generic0Type: T.Type) {
    let b = U.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let ret = genericExportCombine(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportCombineReturnU")
@_cdecl("bjs_genericExportCombineReturnU")
public func _bjs_genericExportCombineReturnU(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportCombineReturnU")
@_cdecl("bjs_genericExportCombineReturnU")
public func _bjs_genericExportCombineReturnU(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    guard let _generic1Type = _bridgeJSExportTypeRegistry[_generic1TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic1TypeId)")
    }
    _bjs_genericExportCombineReturnU_open1(_generic0Type, _generic1Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportCombineReturnU_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _generic1Type: any BridgedSwiftGenericBridgeable.Type) {
    _bjs_genericExportCombineReturnU_open2(_generic1Type, asT: T.self)
}
private func _bjs_genericExportCombineReturnU_open2<U: BridgedSwiftGenericBridgeable, T: BridgedSwiftGenericBridgeable>(_ _generic1Type: U.Type, asT _generic0Type: T.Type) {
    let b = U.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let ret = genericExportCombineReturnU(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_genericExportCaseDistinct")
@_cdecl("bjs_genericExportCaseDistinct")
public func _bjs_genericExportCaseDistinct(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_genericExportCaseDistinct")
@_cdecl("bjs_genericExportCaseDistinct")
public func _bjs_genericExportCaseDistinct(_ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    guard let _generic1Type = _bridgeJSExportTypeRegistry[_generic1TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic1TypeId)")
    }
    _bjs_genericExportCaseDistinct_open1(_generic0Type, _generic1Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_genericExportCaseDistinct_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _generic1Type: any BridgedSwiftGenericBridgeable.Type) {
    _bjs_genericExportCaseDistinct_open2(_generic1Type, asT: T.self)
}
private func _bjs_genericExportCaseDistinct_open2<t: BridgedSwiftGenericBridgeable, T: BridgedSwiftGenericBridgeable>(_ _generic1Type: t.Type, asT _generic0Type: T.Type) {
    let b = t.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let ret = genericExportCaseDistinct(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if !hasFeature(Embedded)
private let _bridgeJSExportTypeRegistry: [Int32: any BridgedSwiftGenericBridgeable.Type] = {
    var registry: [Int32: any BridgedSwiftGenericBridgeable.Type] = [:]
    func register<T: BridgedSwiftGenericBridgeable>(_ type: T.Type) {
        registry[T.bridgeJSTypeID] = type
    }
    register(Bool.self)
    register(Int.self)
    register(Int8.self)
    register(UInt8.self)
    register(Int16.self)
    register(UInt16.self)
    register(Int32.self)
    register(UInt32.self)
    register(UInt.self)
    register(Int64.self)
    register(UInt64.self)
    register(Float.self)
    register(Double.self)
    register(String.self)
    register(JSValue.self)
    register(ExportPoint.self)
    register(ExportNamespace.Metadata.self)
    register(GenericPair.self)
    register(ExportBox.self)
    register(GenericBox.self)
    register(ExportNamespace.Level.self)
    register(ExportMode.self)
    register(ExportColor.self)
    register(ExportTagged.self)
    register(GenericFactory.self)
    return registry
}()
#endif

@_expose(wasm, "bjs_ExportBox_init")
@_cdecl("bjs_ExportBox_init")
public func _bjs_ExportBox_init(_ value: Int32) -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = ExportBox(value: Int.bridgeJSLiftParameter(value))
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExportBox_get")
@_cdecl("bjs_ExportBox_get")
public func _bjs_ExportBox_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ExportBox.bridgeJSLiftParameter(_self).get()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExportBox_value_get")
@_cdecl("bjs_ExportBox_value_get")
public func _bjs_ExportBox_value_get(_ _self: UnsafeMutableRawPointer) -> Int32 {
    #if arch(wasm32)
    let ret = ExportBox.bridgeJSLiftParameter(_self).value
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExportBox_value_set")
@_cdecl("bjs_ExportBox_value_set")
public func _bjs_ExportBox_value_set(_ _self: UnsafeMutableRawPointer, _ value: Int32) -> Void {
    #if arch(wasm32)
    ExportBox.bridgeJSLiftParameter(_self).value = Int.bridgeJSLiftParameter(value)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

@_expose(wasm, "bjs_ExportBox_deinit")
@_cdecl("bjs_ExportBox_deinit")
public func _bjs_ExportBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<ExportBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension ExportBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_ExportBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_ExportBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_ExportBox_wrap")
fileprivate func _bjs_ExportBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_ExportBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_ExportBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_ExportBox_wrap_extern(pointer)
}

extension ExportBox: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("ExportBox")
}

@_expose(wasm, "bjs_GenericBox_init")
@_cdecl("bjs_GenericBox_init")
public func _bjs_GenericBox_init() -> UnsafeMutableRawPointer {
    #if arch(wasm32)
    let ret = GenericBox()
    return ret.bridgeJSLowerReturn()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericBox_wrap")
@_cdecl("bjs_GenericBox_wrap")
public func _bjs_GenericBox_wrap(_ _self: UnsafeMutableRawPointer, _ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericBox_wrap")
@_cdecl("bjs_GenericBox_wrap")
public func _bjs_GenericBox_wrap(_ _self: UnsafeMutableRawPointer, _ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericBox_wrap_open1(_generic0Type, _self)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericBox_wrap_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _self: UnsafeMutableRawPointer) {
    let value = T.bridgeJSStackPop()
    let _val__self = GenericBox.bridgeJSLiftParameter(_self)
    let ret = _val__self.wrap(value)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericBox_combine")
@_cdecl("bjs_GenericBox_combine")
public func _bjs_GenericBox_combine(_ _self: UnsafeMutableRawPointer, _ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericBox_combine")
@_cdecl("bjs_GenericBox_combine")
public func _bjs_GenericBox_combine(_ _self: UnsafeMutableRawPointer, _ _generic0TypeId: Int32, _ _generic1TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    guard let _generic1Type = _bridgeJSExportTypeRegistry[_generic1TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic1TypeId)")
    }
    _bjs_GenericBox_combine_open1(_generic0Type, _generic1Type, _self)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericBox_combine_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type, _ _generic1Type: any BridgedSwiftGenericBridgeable.Type, _ _self: UnsafeMutableRawPointer) {
    _bjs_GenericBox_combine_open2(_generic1Type, asT: T.self, _self)
}
private func _bjs_GenericBox_combine_open2<t: BridgedSwiftGenericBridgeable, T: BridgedSwiftGenericBridgeable>(_ _generic1Type: t.Type, asT _generic0Type: T.Type, _ _self: UnsafeMutableRawPointer) {
    let b = t.bridgeJSStackPop()
    let a = T.bridgeJSStackPop()
    let _val__self = GenericBox.bridgeJSLiftParameter(_self)
    let ret = _val__self.combine(a, b)
    ret.bridgeJSStackPush()
}
#endif

#if hasFeature(Embedded)
@_expose(wasm, "bjs_GenericBox_static_makeArray")
@_cdecl("bjs_GenericBox_static_makeArray")
public func _bjs_GenericBox_static_makeArray(_ _generic0TypeId: Int32) -> Void {
    fatalError("Generic @JS exported functions are not supported in Embedded Swift")
}
#else
@_expose(wasm, "bjs_GenericBox_static_makeArray")
@_cdecl("bjs_GenericBox_static_makeArray")
public func _bjs_GenericBox_static_makeArray(_ _generic0TypeId: Int32) -> Void {
    #if arch(wasm32)
    guard let _generic0Type = _bridgeJSExportTypeRegistry[_generic0TypeId] else {
        fatalError("BridgeJS: unknown generic type id \(_generic0TypeId)")
    }
    _bjs_GenericBox_static_makeArray_open1(_generic0Type)
    #else
    fatalError("Only available on WebAssembly")
    #endif
}
private func _bjs_GenericBox_static_makeArray_open1<T: BridgedSwiftGenericBridgeable>(_ _generic0Type: T.Type) {
    let value = T.bridgeJSStackPop()
    let ret = GenericBox.makeArray(value)
    ret.bridgeJSStackPush()
}
#endif

@_expose(wasm, "bjs_GenericBox_deinit")
@_cdecl("bjs_GenericBox_deinit")
public func _bjs_GenericBox_deinit(_ pointer: UnsafeMutableRawPointer) -> Void {
    #if arch(wasm32)
    Unmanaged<GenericBox>.fromOpaque(pointer).release()
    #else
    fatalError("Only available on WebAssembly")
    #endif
}

extension GenericBox: ConvertibleToJSValue, _BridgedSwiftHeapObject, _BridgedSwiftProtocolExportable {
    var jsValue: JSValue {
        return .object(JSObject(id: UInt32(bitPattern: _bjs_GenericBox_wrap(Unmanaged.passRetained(self).toOpaque()))))
    }
    consuming func bridgeJSLowerAsProtocolReturn() -> Int32 {
        _bjs_GenericBox_wrap(Unmanaged.passRetained(self).toOpaque())
    }
}

#if arch(wasm32)
@_extern(wasm, module: "TestModule", name: "bjs_GenericBox_wrap")
fileprivate func _bjs_GenericBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32
#else
fileprivate func _bjs_GenericBox_wrap_extern(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    fatalError("Only available on WebAssembly")
}
#endif
@inline(never) fileprivate func _bjs_GenericBox_wrap(_ pointer: UnsafeMutableRawPointer) -> Int32 {
    return _bjs_GenericBox_wrap_extern(pointer)
}

extension GenericBox: BridgedSwiftGenericBridgeable {
    @_spi(BridgeJS) public static let bridgeJSTypeID: Int32 = _swift_js_resolve_type_id("GenericBox")
}