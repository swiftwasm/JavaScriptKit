// This file is shared between BridgeJSTool and BridgeJSLink.
//
// MARK: - The BridgeJS ABI description
//
// This file describes how a `BridgeType` crosses the Swift/JS boundary. `BridgeType` is the
// structured type IR (wasm-bindgen's `Descriptor`); this file turns it into two things every
// emitter reads instead of re-deriving the ABI by hand:
//
//   - `ABIShape` / `shape(of:cell:context:)` - the flat Wasm signature (params, single return
//     value, whether lowering borrows). This is the part `ExportSwift`/`ImportTS`/`JSGlueGen`
//     project into their thunk signatures.
//   - the **stack** layout, which is not modelled here as data at all. It is compiled straight
//     from `BridgeType` into a `StackOp` instruction program (see `StackABIProgram.swift`) and
//     interpreted by a stack machine. `StackOp` is where the stack ABI's shape lives now.
//
// # Why this exists
//
// The same ABI facts used to be spelled out independently in five places (four tables in
// `ExportSwift.swift`/`ImportTS.swift`, plus `wasmParams` in `JSGlueGen.swift`) and
// implemented a sixth time by hand in `Sources/JavaScriptKit/BridgeJSIntrinsics.swift`.
// Nothing checked that they agreed, and they had already diverged. Adding one `BridgeType`
// case meant editing all of them.
//
// # Two transports
//
// A value crosses the boundary over one of two transports:
//
// - **flat**: Wasm function parameters, or the single Wasm return value. Fixed arity, known at
//   compile time. Described here by `ABIShape.flat`.
// - **stack**: the parallel typed push/pop channels (`i32Stack`, `f64Stack`, `strStack`,
//   `taStack`, ...) declared in `BridgeJSLink.generateVariableDeclarations`. Used when a
//   value's size isn't statically known (arrays, dictionaries, struct fields), because the
//   Wasm ABI here returns at most one core value per function. Described by the `StackOp`
//   program a type compiles to. On the flat side, a type that travels entirely over the stack
//   shows up as an empty `ABIShape.flat`.
//
// # Honesty about irregularity
//
// The ABI is not uniform, and the `StackOp` compound cases name the irregularities rather than
// smoothing them over, so they are enumerable in one place:
//
// - `String` has two different wire formats depending on direction.
// - `Array` overloads its count slot as a bulk/typed-array discriminator.
// - Optionals encode presence with a flag on the stack.
//
// Naming them keeps consolidating them later a reviewable diff instead of an archaeology
// exercise.

// MARK: - Channels and slots

/// A typed stack channel. Mirrors the `*Stack` arrays in the generated JS glue.
///
/// `string` and `typedArray` are stack-only: there is no such thing as a `strStack` Wasm
/// parameter. They exist because the host can hold a JS value that has no Wasm core
/// representation.
public enum ABIStackChannel: String, Codable, Equatable, Hashable, Sendable {
    case i32, i64, f32, f64, pointer, string, typedArray

    /// The Wasm core type carried on this channel, or nil for host-only channels.
    public var wasmCoreType: WasmCoreType? {
        switch self {
        case .i32: return .i32
        case .i64: return .i64
        case .f32: return .f32
        case .f64: return .f64
        case .pointer: return .pointer
        case .string, .typedArray: return nil
        }
    }

    public init(_ wasmCoreType: WasmCoreType) {
        switch wasmCoreType {
        case .i32: self = .i32
        case .i64: self = .i64
        case .f32: self = .f32
        case .f64: self = .f64
        case .pointer: self = .pointer
        }
    }
}

/// A value conversion applied at a slot boundary, from the **JS side's** point of view.
///
/// Which one applies follows the `StackOp.Operation`: a `.push` (JS writes the slot) lowers,
/// a `.pop` (JS reads the slot) lifts. Wasm core types are untyped relative to the Swift/JS
/// types riding them -- a `Bool` travels as an i32 -- so somebody has to say which way to
/// convert.
///
/// Only **stack** slots carry a meaningful coercion today; flat slots leave this `.none`.
/// That is not an oversight: flat coercions are position-dependent in a way the stack ones
/// are not (`UInt64` read from a flat return gets `BigInt.asUintN(64, ...)`, but read from a
/// stack slot gets nothing), so they still live in the emitters. Describing them uniformly
/// here would state something false.
public enum ABICoercion: String, Codable, Equatable, Hashable, Sendable {
    /// No conversion.
    case none
    /// `Bool` -> i32: `value ? 1 : 0`
    case boolToI32
    /// i32 -> `Bool`: `value !== 0`
    case i32ToBool
    /// Narrow to a signed 32-bit int: `value | 0`
    case truncToI32
    /// Reinterpret as unsigned 32-bit: `value >>> 0`
    case zeroExtendU32
    /// Round to f32 precision: `Math.fround(value)`
    case fround
    /// Reinterpret as unsigned 64-bit: `BigInt.asUintN(64, value)`
    case asUintN64
}

/// One slot: a single value on one channel.
///
/// `name` is load-bearing, not cosmetic - it becomes the parameter name in generated Swift
/// thunk signatures, so it appears in snapshots. Different cells historically use different
/// names for the same slot (`value` vs `objectId`, `callbackId` vs `funcRef`); that
/// divergence is preserved here rather than unified, to keep this change behaviour-preserving.
public struct ABISlot: Codable, Equatable, Hashable, Sendable {
    public let name: String
    public let channel: ABIStackChannel
    public let coerce: ABICoercion

    public init(_ name: String, _ channel: ABIStackChannel, coerce: ABICoercion = .none) {
        self.name = name
        self.channel = channel
        self.coerce = coerce
    }

    /// Convenience for the common case of a slot carrying a Wasm core type.
    ///
    /// Deliberately labelled: an unlabelled overload would be ambiguous with the
    /// `ABIStackChannel` initializer, since both enums spell `.i32` the same way.
    public init(_ name: String, wasm wasmCoreType: WasmCoreType, coerce: ABICoercion = .none) {
        self.init(name, ABIStackChannel(wasmCoreType), coerce: coerce)
    }

    /// The Wasm core type of this slot, or nil if it is a host-only channel.
    public var wasmCoreType: WasmCoreType? { channel.wasmCoreType }
}

// MARK: - The ABI matrix cell

/// One cell of the ABI matrix. There are exactly four, and they correspond 1:1 with the
/// four hand-written tables this description replaces.
public enum ABICell: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    /// JS -> Swift, Wasm params. Was `BridgeType.liftParameterInfo` in `ExportSwift.swift`.
    case exportParameter
    /// Swift -> JS, Wasm return. Was `BridgeType.loweringReturnInfo` in `ExportSwift.swift`.
    case exportReturn
    /// Swift -> JS, Wasm params. Was `BridgeType.loweringParameterInfo` in `ImportTS.swift`.
    case importParameter
    /// JS -> Swift, Wasm return. Was `BridgeType.liftingReturnInfo` in `ImportTS.swift`.
    case importReturn
}

// MARK: - Shapes

/// What a value looks like in one cell of the ABI matrix.
public struct ABIShape: Equatable, Sendable {
    /// The Wasm slots. For a `.parameter` cell this is the parameter list; for a
    /// `.returnValue` cell it holds zero or one slot (the Wasm ABI returns at most one
    /// core value, which is precisely why the stack transport exists).
    public let flat: [ABISlot]
    /// Whether lowering must go through `bridgeJSWithLoweredParameter { ... }` because the
    /// lowered representation borrows memory that has to stay alive across the call.
    public let useBorrowing: Bool

    public init(flat: [ABISlot] = [], useBorrowing: Bool = false) {
        self.flat = flat
        self.useBorrowing = useBorrowing
    }

    /// The single Wasm return type for a `.returnValue` cell, or nil if the value is
    /// returned via the stack / a side channel / not at all.
    public var returnValue: WasmCoreType? { flat.first?.wasmCoreType }

    /// The flat slots as a Wasm parameter list.
    ///
    /// Host-only channels (`string`, `typedArray`) can never appear in `flat` -- they have
    /// no Wasm core type -- so this drops nothing in practice; the `compactMap` is just how
    /// that invariant is spelled.
    public var wasmParameters: [(name: String, type: WasmCoreType)] {
        flat.compactMap { slot in slot.wasmCoreType.map { (slot.name, $0) } }
    }
}

/// Errors raised when a type has no ABI in the requested cell.
public struct BridgeABIError: Error, CustomStringConvertible {
    public let description: String
    public init(_ description: String) { self.description = description }
}

// MARK: - The description

/// The single source of truth for BridgeJS's ABI.
///
/// Every emitter reads its facts from here:
///
/// - `ExportSwift.swift` / `ImportTS.swift` project `shape(of:cell:context:)` into Wasm thunk
///   signatures.
/// - `JSGlueGen.swift` compiles types into `StackOp` programs (`StackOp.compile`) and
///   interprets them with `JSStackMachine` to emit push/pop sequences.
/// - The scalar runtime conformances in `Sources/JavaScriptKit/Generated/BridgeJSIntrinsics+ABI.swift`
///   are generated from the same description (`SwiftRuntimeABIEmitter`), so the two sides of
///   the boundary cannot drift apart on the slot layouts.
public enum BridgeABI {

    // MARK: Flat shape (Wasm params / return)

    /// The Wasm-level shape of `type` in one cell of the ABI matrix.
    ///
    /// `.alias` is sugar to this layer: every cell sees through it to the underlying type
    /// (see `BridgeType.unaliased`), so callers pass types as spelled and never pre-desugar.
    ///
    /// - Parameters:
    ///   - context: Modulates the *representation* of some types independently of direction.
    ///     `.swiftStruct` is an object id under `.importTS` (JS holds a real JS object) but
    ///     travels over the stack under `.exportSwift`. Only the `import*` cells consult it;
    ///     the `export*` cells are always in `.exportSwift`.
    public static func shape(
        of type: BridgeType,
        cell: ABICell,
        context: BridgeContext = .importTS
    ) throws -> ABIShape {
        switch cell {
        case .exportParameter: return try exportParameterShape(of: type)
        case .exportReturn: return try exportReturnShape(of: type)
        case .importParameter: return try importParameterShape(of: type, context: context)
        case .importReturn: return try importReturnShape(of: type, context: context)
        }
    }

    // MARK: exportParameter -- JS -> Swift, Wasm params

    private static func exportParameterShape(of type: BridgeType) throws -> ABIShape {
        switch type {
        case .bool:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .integer(let t):
            return ABIShape(flat: [ABISlot("value", wasm: t.wasmCoreType)])
        case .float:
            return ABIShape(flat: [ABISlot("value", .f32)])
        case .double:
            return ABIShape(flat: [ABISlot("value", .f64)])
        case .string:
            return ABIShape(flat: [ABISlot("bytes", .i32), ABISlot("length", .i32)])
        case .jsObject:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .jsValue:
            return ABIShape(flat: [ABISlot("kind", .i32), ABISlot("payload1", .i32), ABISlot("payload2", .f64)])
        case .swiftHeapObject:
            return ABIShape(flat: [ABISlot("value", .pointer)])
        case .unsafePointer:
            return ABIShape(flat: [ABISlot("pointer", .pointer)])
        case .swiftProtocol:
            // Protocols pass JSObject ids as i32.
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .void:
            return ABIShape()
        case .nullable(let wrappedType, _):
            let wrapped = try exportParameterShape(of: wrappedType)
            // A wrapped type with no flat slots is entirely stack-borne, and its optional
            // discriminator rides the stack with it -- so no `isSome` parameter is added.
            if wrapped.flat.isEmpty { return ABIShape() }
            return ABIShape(flat: [ABISlot("isSome", .i32)] + wrapped.flat)
        case .caseEnum:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .rawValueEnum(_, let rawType):
            return try exportParameterShape(of: rawType.bridgeType)
        case .associatedValueEnum:
            return ABIShape(flat: [ABISlot("caseId", .i32)])
        case .swiftStruct:
            return ABIShape()
        case .closure:
            return ABIShape(flat: [ABISlot("callbackId", .i32)])
        case .array:
            return ABIShape()
        case .dictionary:
            return ABIShape()
        case .alias(_, let underlying):
            return try exportParameterShape(of: underlying)
        }
    }

    // MARK: exportReturn -- Swift -> JS, Wasm return

    private static func exportReturnShape(of type: BridgeType) throws -> ABIShape {
        func ret(_ slot: ABISlot) -> ABIShape { ABIShape(flat: [slot]) }
        switch type {
        case .bool:
            return ret(ABISlot("value", .i32))
        case .integer(let t):
            return ret(ABISlot("value", wasm: t.wasmCoreType))
        case .float:
            return ret(ABISlot("value", .f32))
        case .double:
            return ret(ABISlot("value", .f64))
        case .string:
            // Returned through the `swift_js_return_string` side channel, not a Wasm return.
            return ABIShape()
        case .jsObject:
            return ret(ABISlot("value", .i32))
        case .jsValue:
            return ABIShape()
        case .swiftHeapObject:
            // UnsafeMutableRawPointer is returned as a pointer.
            return ret(ABISlot("value", .pointer))
        case .unsafePointer:
            return ret(ABISlot("pointer", .pointer))
        case .swiftProtocol:
            return ret(ABISlot("value", .i32))
        case .void:
            return ABIShape()
        case .nullable:
            // Every optional return travels over the stack, so the wrapped type's *flat*
            // shape is never consulted here.
            return ABIShape()
        case .caseEnum:
            return ret(ABISlot("value", .i32))
        case .rawValueEnum(_, let rawType):
            return try exportReturnShape(of: rawType.bridgeType)
        case .associatedValueEnum:
            return ABIShape()
        case .swiftStruct:
            // Structs use stack-based return (no direct Wasm return type).
            return ABIShape()
        case .closure:
            // Closures pass a callback id as i32.
            return ret(ABISlot("value", .i32))
        case .array:
            return ABIShape()
        case .dictionary:
            return ABIShape()
        case .alias(_, let underlying):
            return try exportReturnShape(of: underlying)
        }
    }

    // MARK: importParameter -- Swift -> JS, Wasm params

    private static func importParameterShape(of type: BridgeType, context: BridgeContext) throws -> ABIShape {
        switch type {
        case .bool:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .integer(let t):
            return ABIShape(flat: [ABISlot("value", wasm: t.wasmCoreType)])
        case .float:
            return ABIShape(flat: [ABISlot("value", .f32)])
        case .double:
            return ABIShape(flat: [ABISlot("value", .f64)])
        case .string:
            // Borrows the string's UTF8 buffer for the duration of the call.
            return ABIShape(flat: [ABISlot("bytes", .i32), ABISlot("length", .i32)], useBorrowing: true)
        case .jsObject:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .jsValue:
            return ABIShape(flat: [ABISlot("kind", .i32), ABISlot("payload1", .i32), ABISlot("payload2", .f64)])
        case .void:
            return ABIShape()
        case .closure:
            // A Swift closure is passed to JS as a JS function reference.
            return ABIShape(flat: [ABISlot("funcRef", .i32)])
        case .unsafePointer:
            return ABIShape(flat: [ABISlot("pointer", .pointer)])
        case .swiftHeapObject:
            return ABIShape(flat: [ABISlot("pointer", .pointer)])
        case .swiftProtocol:
            switch context {
            case .importTS:
                throw BridgeABIError("swiftProtocol is not supported in imported signatures")
            case .exportSwift:
                return ABIShape(flat: [ABISlot("objectId", .i32)])
            }
        case .caseEnum:
            return ABIShape(flat: [ABISlot("value", .i32)])
        case .rawValueEnum(_, let rawType):
            if rawType == .string {
                return ABIShape(flat: [ABISlot("bytes", .i32), ABISlot("length", .i32)], useBorrowing: true)
            }
            return ABIShape(flat: [ABISlot("value", wasm: rawType.wasmCoreType ?? .i32)])
        case .associatedValueEnum:
            return ABIShape(flat: [ABISlot("caseId", .i32)])
        case .swiftStruct:
            switch context {
            case .importTS:
                // Swift structs are bridged as JS objects (object ids) in imported signatures.
                return ABIShape(flat: [ABISlot("objectId", .i32)])
            case .exportSwift:
                return ABIShape()
            }
        case .nullable(let wrappedType, _):
            // Optional `@JS struct`s bridge through the stack (isSome discriminator + fields),
            // like optional arrays/dictionaries, rather than the non-optional object-id ABI.
            // Matched on the canonical wrapped type, so an alias of a struct takes the same path.
            if case .swiftStruct = wrappedType.unaliased, context == .importTS {
                return ABIShape(flat: [ABISlot("isSome", .i32)])
            }
            let wrapped = try importParameterShape(of: wrappedType, context: context)
            return ABIShape(flat: [ABISlot("isSome", .i32)] + wrapped.flat, useBorrowing: wrapped.useBorrowing)
        case .array:
            return ABIShape()
        case .dictionary:
            return ABIShape()
        case .alias(_, let underlying):
            return try importParameterShape(of: underlying, context: context)
        }
    }

    // MARK: importReturn -- JS -> Swift, Wasm return

    private static func importReturnShape(of type: BridgeType, context: BridgeContext) throws -> ABIShape {
        func ret(_ slot: ABISlot) -> ABIShape { ABIShape(flat: [slot]) }
        switch type {
        case .bool:
            return ret(ABISlot("value", .i32))
        case .integer(let t):
            return ret(ABISlot("value", wasm: t.wasmCoreType))
        case .float:
            return ret(ABISlot("value", .f32))
        case .double:
            return ret(ABISlot("value", .f64))
        case .string:
            // JS returns the byte count; the bytes come back through `swift_js_init_memory_with_result`.
            return ret(ABISlot("value", .i32))
        case .jsObject:
            return ret(ABISlot("value", .i32))
        case .jsValue:
            return ABIShape()
        case .void:
            return ABIShape()
        case .closure:
            // JS returns a callback id for closures, which Swift lifts to a typed closure.
            return ret(ABISlot("value", .i32))
        case .unsafePointer:
            return ret(ABISlot("pointer", .pointer))
        case .swiftHeapObject:
            return ret(ABISlot("pointer", .pointer))
        case .swiftProtocol:
            switch context {
            case .importTS:
                throw BridgeABIError("swiftProtocol is not supported in imported signatures")
            case .exportSwift:
                return ret(ABISlot("value", .i32))
            }
        case .caseEnum:
            return ret(ABISlot("value", .i32))
        case .rawValueEnum(_, let rawType):
            return ret(ABISlot("value", wasm: rawType.wasmCoreType ?? .i32))
        case .associatedValueEnum:
            return ret(ABISlot("caseId", .i32))
        case .swiftStruct:
            switch context {
            case .importTS:
                // Swift structs are bridged as JS objects (object ids) in imported signatures.
                return ret(ABISlot("value", .i32))
            case .exportSwift:
                return ABIShape()
            }
        case .nullable(let wrappedType, _):
            // jsObject and `@JS struct` use the stack ABI for optionals -- the thunk returns
            // void and the value (plus isSome discriminator) flows through the stacks.
            // Matched on the canonical wrapped type, so aliases of either take the same path.
            switch wrappedType.unaliased {
            case .jsObject:
                return ABIShape()
            case .swiftStruct where context == .importTS:
                return ABIShape()
            default:
                break
            }
            let wrapped = try importReturnShape(of: wrappedType, context: context)
            return ABIShape(flat: wrapped.flat)
        case .array:
            return ABIShape()
        case .dictionary:
            return ABIShape()
        case .alias(_, let underlying):
            return try importReturnShape(of: underlying, context: context)
        }
    }

    /// The flat slots carrying a *payload*, with any optional presence flag stripped.
    ///
    /// This is what the JS glue asks for when it needs a wrapped/element type's arity and
    /// Wasm types -- e.g. how many placeholder zeros to emit on an absent optional's `else`
    /// branch. It differs from `shape(of:cell: .exportParameter).flat` only for `.nullable`,
    /// where the `isSome` flag is the optional's own, not the payload's.
    ///
    /// Non-throwing on purpose: callers only want arity here, and reach this from
    /// non-throwing contexts.
    public static func payloadSlots(of type: BridgeType) -> [ABISlot] {
        switch type {
        case .nullable(let wrappedType, _):
            return payloadSlots(of: wrappedType)
        case .alias(_, let underlying):
            return payloadSlots(of: underlying)
        default:
            return ((try? exportParameterShape(of: type)) ?? ABIShape()).flat
        }
    }

}

extension SwiftEnumRawType {
    /// The `BridgeType` a raw-value enum's payload travels as.
    ///
    /// Raw-value enums have exactly their raw type's ABI, which is why every table
    /// delegated to the raw type rather than restating it.
    public var bridgeType: BridgeType {
        switch self {
        case .string: return .string
        case .bool: return .bool
        case .integer(let t): return .integer(t)
        case .float: return .float
        case .double: return .double
        }
    }
}
