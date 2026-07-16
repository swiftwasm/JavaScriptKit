import Foundation
import Testing

@testable import BridgeJSSkeleton

/// Pins the shape of the compiled stack-ABI instruction programs.
///
/// `StackOp.compile` is the analog of wasm-bindgen's Descriptor→Instruction lowering: it turns
/// a `BridgeType` (the description) directly into a flat program a stack machine can interpret.
/// The JS glue and the runtime intrinsics both run these programs, so it is worth reading the
/// program a type compiles to straight off a test.
@Suite struct StackABIProgramTests {

    /// Compiles the stack program for `type` in one operation. `operation` also fixes the wire
    /// direction (lower is JS->Swift, lift is Swift->JS - the same axis).
    private func program(_ type: BridgeType, _ operation: StackOp.Operation) -> [StackOp] {
        StackOp.compile(type, as: operation)
    }

    // MARK: Scalars -- a single push/pop with a coercion

    @Test func scalarBoolIsOneSlot() throws {
        #expect(program(.bool, .lower) == [.push(.i32, coerce: .boolToI32)])
        #expect(program(.bool, .lift) == [.pop(.i32, coerce: .i32ToBool, hint: "bool")])
    }

    @Test func unsignedIntegerCarriesItsCoercion() throws {
        // UInt32 rides a signed i32 channel, so lifting reinterprets with `>>> 0`.
        #expect(program(.integer(.uint32), .lift) == [.pop(.i32, coerce: .zeroExtendU32, hint: "int")])
        #expect(program(.integer(.uint32), .lower) == [.push(.i32, coerce: .truncToI32)])
    }

    // MARK: Strings are direction-split, not one op run two ways

    @Test func stringHasTwoDistinctPrograms() throws {
        #expect(program(.string, .lower) == [.lowerString])
        #expect(program(.string, .lift) == [.liftString])
    }

    // MARK: Compound ops carry nested sub-programs (BridgeJS containers nest)

    @Test func arrayCarriesItsElementProgram() throws {
        #expect(program(.array(.string), .lift) == [.liftArray(element: [.liftString])])
        #expect(program(.array(.bool), .lower) == [.lowerArray(element: [.push(.i32, coerce: .boolToI32)])])
    }

    @Test func nestedArrayComposes() throws {
        #expect(
            program(.array(.array(.string)), .lift)
                == [.liftArray(element: [.liftArray(element: [.liftString])])]
        )
    }

    @Test func dictionaryCarriesKeyAndValuePrograms() throws {
        #expect(
            program(.dictionary(.bool), .lower)
                == [.lowerDict(key: [.lowerString], value: [.push(.i32, coerce: .boolToI32)])]
        )
    }

    @Test func optionalCarriesAbsenceAndPayload() throws {
        #expect(
            program(.nullable(.integer(.int), .null), .lift)
                == [.liftOptional(absence: .null, payload: [.pop(.i32, coerce: .none, hint: "int")])]
        )
        #expect(
            program(.nullable(.string, .undefined), .lift)
                == [.liftOptional(absence: .undefined, payload: [.liftString])]
        )
    }

    // MARK: Lower and lift are different programs, per direction

    /// A scalar's two programs differ in push-vs-pop and in coercion; a string's differ in the
    /// op itself (`lowerString` vs `liftString`). This is the "separate incoming/outgoing
    /// programs" property - the two directions are never the same program run backwards.
    @Test func lowerAndLiftAreDistinctPrograms() {
        #expect(program(.string, .lower) != program(.string, .lift))
        #expect(program(.integer(.uint32), .lower) != program(.integer(.uint32), .lift))
    }

    // MARK: Types with no stack ABI compile to a rejecting op

    @Test func closureCompilesToUnsupported() {
        let closure = BridgeType.closure(
            ClosureSignature(parameters: [], returnType: .void, moduleName: "M"),
            useJSTypedClosure: false
        )
        // Closures never travel on the stack, so the program must reject them rather than emit
        // something plausible-but-wrong.
        #expect(
            program(closure, .lower) == [.unsupported(reason: "Closures are not supported on the stack ABI")]
        )
    }
}
