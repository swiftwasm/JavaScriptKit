// The BridgeJS stack ABI as a wasm-bindgen-style instruction stream.
//
// # The model
//
// `BridgeABI.term` (in `BridgeJSABI.swift`) is a *description* of a type's stack layout - the
// analog of wasm-bindgen's `Descriptor` tree. This file adds the two pieces that make it an
// executable ABI in the wasm-bindgen sense:
//
//   1. a flat instruction program (`StackOp`), the analog of wasm-bindgen's `Instruction`
//      list, and
//   2. a compiler that lowers a `BridgeABI.term` into one, `compile(_:as:)`.
//
// A backend then *interprets* the program with a stack machine that keeps an operand stack of
// backend values (JS expression strings for the JS glue, Swift expression strings for the
// runtime intrinsics). This is exactly wasm-bindgen's `JsBuilder`: each op pops the operands
// it consumes and pushes the ones it produces.
//
// # Why a program and not just the tree
//
// The original goal was that BridgeJSTool (Swift) and BridgeJSLink (JS) both be interpreter
// loops over *one* ABI description. Compiling to a shared instruction program is what makes
// that literal: the traversal of the type lives in the compiler, written once, and each
// backend is a thin per-op renderer. It also mirrors a proven design rather than inventing one.
//
// # Two programs, not one walked backwards
//
// Lowering (a value goes onto the stacks) and lifting (a value comes back off) are compiled as
// *separate* programs, following wasm-bindgen's incoming/outgoing split. The reversal that the
// pop order needs is baked into the lift program at compile time, so the interpreter is always
// a straight forward pass and never has to know about LIFO ordering. This also fits the ABI's
// real direction-asymmetry (a `String` has different wire formats each way) without any
// "walk it in reverse" cleverness.
//
// # Honest about recursion
//
// wasm-bindgen's instruction list is strictly flat because its containers bottom out at a
// closed set of primitive element kinds. BridgeJS containers nest arbitrarily
// (`Array<Array<String>>`, `Dictionary<Array<Bool>>`), so the container ops here carry a
// nested sub-program. The list is flat at the top level; recursion lives inside the compound
// ops, just as wasm-bindgen's `VectorToMemory` handles its element internally.

/// One instruction of the stack-ABI VM.
///
/// A `Program` is `[StackOp]`, executed front to back. Primitive ops move one value between
/// the operand stack and a typed channel; compound ops carry the irregular, hand-shaped parts
/// of the ABI (the wasm-bindgen "one dedicated opcode per awkward type" approach) and, where
/// the type is recursive, a nested program for the element/payload.
public indirect enum StackOp: Equatable, Sendable {

    // MARK: Primitive ops

    /// Lower: pop a value, apply `coerce`, push it onto `channel`.
    case push(ABIStackChannel, coerce: ABICoercion)
    /// Lift: pop `channel`, apply `coerce`, push the result onto the operand stack. `hint`
    /// seeds the generated variable name.
    case pop(ABIStackChannel, coerce: ABICoercion, hint: String)

    // MARK: Compound ops (the codec leaves)
    //
    // Each corresponds 1:1 to an `ABICodec`. They exist because the ABI is not uniform; naming
    // them keeps the irregularity enumerable. `lower*`/`lift*` are distinct ops (not one op run
    // two ways) because the two directions genuinely differ - `lowerString` pushes two i32
    // slots, `liftString` pops one host-decoded string slot.

    case lowerString
    case liftString
    case lowerJSValue
    case liftJSValue
    /// jsObject or a protocol existential: a retained object id.
    case lowerObject
    case liftObject
    case lowerHeapObject
    case liftHeapObject(className: String)
    case lowerStruct(fullName: String)
    case liftStruct(fullName: String)
    case lowerEnum(fullName: String)
    case liftEnum(fullName: String)

    /// A type that has no stack ABI (e.g. a closure). Backends reject it, matching the
    /// hand-written fragments' error rather than emitting something plausible-but-wrong.
    case unsupported(reason: String)

    /// Lower an array: pop the JS array, run `element` per item, then push the count. JS->Swift
    /// always uses the counted form (a JS array can't be handed over as a typed array cheaply).
    case lowerArray(element: Program)
    /// Lift a counted array: pop the count, then run `element` that many times. Used for every
    /// element type that the runtime never bulk-transfers, i.e. everything non-numeric. No
    /// discriminator is emitted, because these arrays can never take the typed-array path.
    case liftArray(element: Program)
    /// Lift an array whose element *might* be bulk-transferred as a typed array: pop the count;
    /// `-1` means Swift pushed one typed array onto `taStack`, anything else is a counted
    /// element sequence. Emitted only for numeric-looking elements (see
    /// `isPossiblyBulkNumericElement`), which is where the runtime's typed-array fast path can
    /// actually apply. The runtime emits the discriminator, so the codegen does not have to
    /// know whether a given numeric-looking element (e.g. a `@JS(as: Int)` alias) really bulks.
    case liftMaybeBulkArray(element: Program)

    case lowerDict(key: Program, value: Program)
    case liftDict(key: Program, value: Program)

    /// Lower an optional with the presence-flag encoding: run `payload` only when present,
    /// then push the flag.
    case lowerOptional(absence: JSOptionalKind, payload: Program)
    case liftOptional(absence: JSOptionalKind, payload: Program)

    public typealias Program = [StackOp]
}

// MARK: - Compiling a type into a program

extension StackOp {

    /// Which way a value is crossing, from the operand stack's point of view.
    ///
    /// This also fixes the wire-format direction, because the two are the same axis: lowering
    /// only ever happens JS->Swift, and lifting only ever Swift->JS. (That is why there is no
    /// separate `direction` parameter - it would always be redundant with `operation`.)
    public enum Operation: Sendable {
        /// A value on the operand stack is being written onto the typed channels (JS->Swift).
        case lower
        /// A value is being read off the typed channels onto the operand stack (Swift->JS).
        case lift
    }

    /// Compiles a `BridgeType` directly into a stack-ABI instruction program.
    ///
    /// `BridgeType` already plays the role wasm-bindgen's `Descriptor` does - a structured
    /// description of the type - so this is the analog of wasm-bindgen's incoming/outgoing
    /// lowering (`InstructionBuilder`): one function per direction, flattening the type into a
    /// program. There is no intermediate description tree; the direction-specific choices
    /// (which channel, which coercion, which wire format for `String`) are made right here.
    public static func compile(_ type: BridgeType, as operation: Operation) -> Program {
        let lowering = operation == .lower
        switch type {
        case .bool:
            return [lowering ? .push(.i32, coerce: .boolToI32) : .pop(.i32, coerce: .i32ToBool, hint: "bool")]
        case .integer(let t):
            let channel = ABIStackChannel(t.wasmCoreType)
            return [
                lowering
                    ? .push(channel, coerce: integerLowerCoercion(t))
                    : .pop(channel, coerce: integerLiftCoercion(t), hint: "int")
            ]
        case .float:
            return [lowering ? .push(.f32, coerce: .fround) : .pop(.f32, coerce: .none, hint: "f32")]
        case .double:
            return [lowering ? .push(.f64, coerce: .none) : .pop(.f64, coerce: .none, hint: "f64")]
        case .unsafePointer:
            return [lowering ? .push(.pointer, coerce: .truncToI32) : .pop(.pointer, coerce: .none, hint: "pointer")]
        case .caseEnum:
            return [lowering ? .push(.i32, coerce: .truncToI32) : .pop(.i32, coerce: .none, hint: "caseId")]

        case .string:
            // The one directional wire-format split: JS->Swift is two i32 slots, Swift->JS is
            // one host-decoded string slot.
            return [lowering ? .lowerString : .liftString]
        case .jsValue:
            return [lowering ? .lowerJSValue : .liftJSValue]
        case .jsObject, .swiftProtocol:
            return [lowering ? .lowerObject : .liftObject]
        case .swiftHeapObject(let name):
            return [lowering ? .lowerHeapObject : .liftHeapObject(className: name)]
        case .swiftStruct(let name):
            return [lowering ? .lowerStruct(fullName: name) : .liftStruct(fullName: name)]
        case .associatedValueEnum(let name):
            return [lowering ? .lowerEnum(fullName: name) : .liftEnum(fullName: name)]
        case .rawValueEnum(_, let rawType):
            // A raw-value enum has exactly its raw type's ABI; only the lifted variable name
            // reads better as `rawValue`.
            return compile(rawType.bridgeType, as: operation).renamingLiftHint(to: "rawValue")
        case .closure:
            return [.unsupported(reason: "Closures are not supported on the stack ABI")]

        case .nullable(let wrapped, let kind):
            let payload = compile(wrapped, as: operation)
            return [
                lowering
                    ? .lowerOptional(absence: kind, payload: payload)
                    : .liftOptional(absence: kind, payload: payload)
            ]
        case .array(let element):
            if lowering {
                return [.lowerArray(element: compile(element, as: .lower))]
            }
            // On lift, keep the runtime bulk/counted discriminator only where the typed-array
            // fast path can apply (numeric-looking elements). Every other element type is
            // counted with no discriminator, which is the common case.
            let e = compile(element, as: .lift)
            return [isPossiblyBulkNumericElement(element) ? .liftMaybeBulkArray(element: e) : .liftArray(element: e)]
        case .dictionary(let value):
            // Keys are always strings.
            let key: Program = [lowering ? .lowerString : .liftString]
            let v = compile(value, as: operation)
            return [lowering ? .lowerDict(key: key, value: v) : .liftDict(key: key, value: v)]

        case .void:
            return []
        case .alias(_, let underlying):
            return compile(underlying, as: operation)
        }
    }

    /// Whether an array of `type` *might* be bulk-transferred Swift->JS as a typed array, and so
    /// needs the runtime bulk/counted discriminator kept on the lift.
    ///
    /// This is deliberately a "might", not a "does". The runtime's actual bulk-eligibility is
    /// `_BridgedNumericArray` conformance (bare non-64-bit integers, `Float`, `Double`), but a
    /// `@JS(as: Int)` alias looks numeric here while its array bridges through the *counted*
    /// path - so the codegen cannot statically tell the two apart. Keeping the discriminator
    /// for every numeric-looking element is correct either way (the `-1` branch handles bulk,
    /// the else-branch handles counted), and lets the runtime remain the single authority on
    /// which arrays actually bulk. Everything not numeric-looking never bulks, so it skips the
    /// discriminator entirely.
    static func isPossiblyBulkNumericElement(_ type: BridgeType) -> Bool {
        switch type {
        case .integer(let t): return !t.is64Bit
        case .float, .double: return true
        case .alias(_, let underlying): return isPossiblyBulkNumericElement(underlying)
        default: return false
        }
    }

    /// JS-side coercion when *lifting* an integer out of a stack slot.
    ///
    /// 64-bit integers get nothing: they arrive as BigInt, already in the right value domain.
    /// Only sub-64-bit unsigned values need `>>> 0`, because they ride a *signed* i32 channel
    /// and would otherwise come back negative. This is the **stack** rule, deliberately
    /// narrower than the flat-return rule where `UInt64` gets `BigInt.asUintN(64, ...)`.
    private static func integerLiftCoercion(_ t: BridgeIntegerType) -> ABICoercion {
        if t.is64Bit { return .none }
        return t.isSigned ? .none : .zeroExtendU32
    }

    /// JS-side coercion when *lowering* an integer into a stack slot. 64-bit integers pass
    /// through as BigInt without narrowing.
    private static func integerLowerCoercion(_ t: BridgeIntegerType) -> ABICoercion {
        t.is64Bit ? .none : .truncToI32
    }
}

extension Array where Element == StackOp {
    /// Renames the variable hint of a single-`pop` lift program.
    ///
    /// Only a `.pop` carries a name (a `.push` has none, and a compound op names its own
    /// result), so this is a no-op for anything else - matching the old behaviour where a
    /// raw-value enum backed by `String` kept the string codec's own variable name.
    func renamingLiftHint(to name: String) -> [StackOp] {
        guard count == 1, case .pop(let channel, let coerce, _) = self[0] else { return self }
        return [.pop(channel, coerce: coerce, hint: name)]
    }
}
