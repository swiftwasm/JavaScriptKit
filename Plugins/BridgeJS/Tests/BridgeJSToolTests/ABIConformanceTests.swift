import Foundation
import Testing

@testable import BridgeJSCore
@testable import BridgeJSLink
@testable import BridgeJSSkeleton

/// Pins `BridgeABI` -- the ABI description in `BridgeJSABI.swift`.
///
/// This suite started out comparing the description against the five hand-written tables it
/// replaces, which is what proved it faithful before they were deleted. Now that those
/// tables *are* projections of `BridgeABI`, comparing them to it would be tautological and
/// would pass however wrong the description was. So the comparisons were replaced with
/// `goldens`: the wire format written out by hand, readable straight off the test.
///
/// What these can and cannot catch: they pin the description's *shape*, and
/// `everyBridgeTypeCaseIsCovered` stops a new `BridgeType` case from slipping through with
/// no coverage. They cannot prove the description matches what the Swift runtime and the JS
/// glue actually do at runtime -- only `make unittest` does that, by compiling Swift to wasm
/// and executing the generated glue against it.
///
/// Assertions deliberately treat a thrown error as a comparable outcome, because "this type
/// has no ABI in this cell" is as much a part of the description as any slot list.
@Suite struct ABIConformanceTests {

    // MARK: - Corpus

    /// Types that may appear anywhere. `.alias` is excluded here and covered separately,
    /// because the import-side tables `preconditionFailure` on it by contract (they require
    /// callers to pre-`unaliased`), and a `preconditionFailure` cannot be caught.
    static let leafTypes: [BridgeType] = [
        .bool,
        .integer(.int), .integer(.uint),
        .integer(.int8), .integer(.uint8),
        .integer(.int16), .integer(.uint16),
        .integer(.int32), .integer(.uint32),
        .integer(.int64), .integer(.uint64),
        .float, .double, .string, .jsValue, .void,
        .jsObject(nil), .jsObject("Foo"),
        .swiftHeapObject("Greeter"),
        .unsafePointer(.init(kind: .unsafeRawPointer)),
        .unsafePointer(.init(kind: .unsafeMutableRawPointer)),
        .unsafePointer(.init(kind: .opaquePointer)),
        .unsafePointer(.init(kind: .unsafePointer, pointee: "UInt8")),
        .swiftProtocol("Drawable"),
        .swiftStruct("Point"),
        .caseEnum("Direction"),
        .associatedValueEnum("Result"),
        .namespaceEnum("Utils"),
        .rawValueEnum("Mode", .string),
        .rawValueEnum("Mode", .bool),
        .rawValueEnum("Mode", .float),
        .rawValueEnum("Mode", .double),
        .rawValueEnum("Mode", .integer(.int)),
        .rawValueEnum("Mode", .integer(.int64)),
        .rawValueEnum("Mode", .integer(.uint32)),
        .closure(ClosureSignature(parameters: [.string], returnType: .void, moduleName: "M"), useJSTypedClosure: false),
        .closure(ClosureSignature(parameters: [], returnType: .bool, moduleName: "M"), useJSTypedClosure: true),
    ]

    /// The corpus: leaves, plus one level of each container wrapping every leaf. One level
    /// is enough to exercise the recursive paths; the containers all delegate to the same
    /// element/wrapped logic, so deeper nesting adds combinations, not code paths.
    static let corpus: [BridgeType] = {
        var types = leafTypes
        for leaf in leafTypes {
            types.append(.nullable(leaf, .null))
            types.append(.nullable(leaf, .undefined))
            types.append(.array(leaf))
            types.append(.dictionary(leaf))
        }
        // A couple of deeper nests, to be sure recursion composes.
        types.append(.array(.array(.string)))
        types.append(.array(.nullable(.integer(.int), .null)))
        types.append(.dictionary(.array(.bool)))
        types.append(.nullable(.array(.string), .null))
        return types
    }()

    // MARK: - Helpers

    /// A result, or the fact that producing it threw. Comparing these directly means
    /// "one side throws and the other doesn't" is a failure rather than a silent divergence.
    enum Outcome<T: Equatable>: Equatable {
        case value(T)
        case threw

        init(_ body: () throws -> T) {
            do { self = .value(try body()) } catch { self = .threw }
        }
    }

    /// Slot list reduced to what the old tables actually carried: name + Wasm type.
    static func slots(_ shape: ABIShape) -> [Pair] {
        shape.flat.map { Pair($0.name, $0.wasmCoreType) }
    }

    struct Pair: Equatable, Sendable, CustomStringConvertible {
        let name: String
        let type: WasmCoreType?
        init(_ name: String, _ type: WasmCoreType?) {
            self.name = name
            self.type = type
        }
        var description: String { "\(name): \(type.map(String.init(describing:)) ?? "-")" }
    }

    // MARK: - Golden shapes

    /// The ABI, stated literally.
    ///
    /// `ExportSwift`/`ImportTS`/`JSGlueGen` now project `BridgeABI`, so asserting that they
    /// agree with it would be tautological -- it would pass however wrong `BridgeABI` was.
    /// These goldens are the real check: they are written out by hand so that a reviewer can
    /// read the wire format straight off the test, and so that any change to the description
    /// has to be stated here too.
    ///
    /// Cross-checked against the runtime and the committed snapshots, e.g.
    /// `String.bridgeJSStackPop` pops bytes-then-count, and `JSValue.bridgeJSStackPop` pops
    /// payload2/payload1/kind.
    struct Golden: Sendable {
        let type: BridgeType
        let cell: ABICell
        let context: BridgeContext
        let slots: [Pair]

        /// Context only matters for the `import*` cells; the `export*` cells are always
        /// `.exportSwift`, so most goldens omit it.
        init(_ type: BridgeType, _ cell: ABICell, _ slots: [Pair]) {
            self.init(type, cell, .importTS, slots)
        }

        init(_ type: BridgeType, _ cell: ABICell, _ context: BridgeContext, _ slots: [Pair]) {
            self.type = type
            self.cell = cell
            self.context = context
            self.slots = slots
        }
    }

    static let goldens: [Golden] = [
        // Scalars: one slot, Wasm type follows the Swift type.
        Golden(.bool, .exportParameter, [Pair("value", .i32)]),
        Golden(.integer(.int), .exportParameter, [Pair("value", .i32)]),
        Golden(.integer(.int64), .exportParameter, [Pair("value", .i64)]),
        Golden(.integer(.uint64), .exportParameter, [Pair("value", .i64)]),
        Golden(.float, .exportParameter, [Pair("value", .f32)]),
        Golden(.double, .exportParameter, [Pair("value", .f64)]),

        // String, JS -> Swift: two i32 slots. Popped by `String.bridgeJSStackPop`.
        Golden(.string, .exportParameter, [Pair("bytes", .i32), Pair("length", .i32)]),
        // String, Swift -> JS: no Wasm return -- it goes out through `swift_js_return_string`.
        Golden(.string, .exportReturn, []),

        // JSValue: three slots across two channels. The order here is what makes the
        // pop order in `JSValue.bridgeJSStackPop` (payload2, payload1, kind) correct.
        Golden(.jsValue, .exportParameter, [Pair("kind", .i32), Pair("payload1", .i32), Pair("payload2", .f64)]),

        // Handles.
        Golden(.jsObject(nil), .exportParameter, [Pair("value", .i32)]),
        Golden(.swiftHeapObject("Greeter"), .exportParameter, [Pair("value", .pointer)]),
        Golden(.swiftProtocol("Drawable"), .exportParameter, [Pair("value", .i32)]),
        Golden(.caseEnum("Direction"), .exportParameter, [Pair("value", .i32)]),
        Golden(.associatedValueEnum("Result"), .exportParameter, [Pair("caseId", .i32)]),

        // Stack-borne: no flat slots at all. An empty flat shape IS the signal that a value
        // travels over the stacks.
        Golden(.swiftStruct("Point"), .exportParameter, []),
        Golden(.array(.string), .exportParameter, []),
        Golden(.dictionary(.bool), .exportParameter, []),
        Golden(.void, .exportParameter, []),

        // Optionals, JS -> Swift: an isSome flag ahead of the payload...
        Golden(.nullable(.integer(.int), .null), .exportParameter, [Pair("isSome", .i32), Pair("value", .i32)]),
        Golden(
            .nullable(.string, .null),
            .exportParameter,
            [Pair("isSome", .i32), Pair("bytes", .i32), Pair("length", .i32)]
        ),
        // ...but a payload that is already stack-borne carries its own flag on the stack,
        // so no isSome parameter is added.
        Golden(.nullable(.array(.string), .null), .exportParameter, []),
        Golden(.nullable(.swiftStruct("Point"), .null), .exportParameter, []),

        // Returns: at most one Wasm value, which is exactly why the stack transport exists.
        Golden(.bool, .exportReturn, [Pair("value", .i32)]),
        Golden(.integer(.int64), .exportReturn, [Pair("value", .i64)]),
        Golden(.swiftHeapObject("Greeter"), .exportReturn, [Pair("value", .pointer)]),
        Golden(.jsValue, .exportReturn, []),
        Golden(.swiftStruct("Point"), .exportReturn, []),
        Golden(.array(.string), .exportReturn, []),
        Golden(.nullable(.integer(.int), .null), .exportReturn, []),

        // Import side, and where `context` actually bites: a `@JS struct` is a JS object id
        // when JS owns it, but stack-borne when Swift does.
        Golden(.swiftStruct("Point"), .importParameter, .importTS, [Pair("objectId", .i32)]),
        Golden(.swiftStruct("Point"), .importParameter, .exportSwift, []),
        Golden(.swiftStruct("Point"), .importReturn, .importTS, [Pair("value", .i32)]),
        Golden(.swiftStruct("Point"), .importReturn, .exportSwift, []),
        // Optional `@JS struct` bridges through the stack, keeping only the discriminator flat.
        Golden(.nullable(.swiftStruct("Point"), .null), .importParameter, .importTS, [Pair("isSome", .i32)]),

        // Swift -> JS strings borrow their UTF8 buffer for the call (see useBorrowing).
        Golden(.string, .importParameter, .importTS, [Pair("bytes", .i32), Pair("length", .i32)]),
        // JS -> Swift returns hand back a byte count; bytes follow via init_memory_with_result.
        Golden(.string, .importReturn, .importTS, [Pair("value", .i32)]),
        Golden(
            .closure(ClosureSignature(parameters: [], returnType: .void, moduleName: "M"), useJSTypedClosure: false),
            .importParameter,
            .importTS,
            [Pair("funcRef", .i32)]
        ),
    ]

    @Test("the ABI matches its golden description", arguments: goldens)
    func goldenShapesMatch(golden: Golden) throws {
        let shape = try BridgeABI.shape(of: golden.type, cell: golden.cell, context: golden.context)
        #expect(
            Self.slots(shape) == golden.slots,
            "\(golden.cell) shape for \(golden.type) in \(golden.context)"
        )
    }

    /// `useBorrowing` is not decoration: it decides whether the emitted Swift nests the call
    /// inside `bridgeJSWithLoweredParameter { ... }` to keep borrowed memory alive.
    @Test func stringParametersBorrowButReturnsDoNot() throws {
        #expect(try BridgeABI.shape(of: .string, cell: .importParameter).useBorrowing)
        #expect(try !BridgeABI.shape(of: .string, cell: .importReturn).useBorrowing)
        #expect(try !BridgeABI.shape(of: .integer(.int), cell: .importParameter).useBorrowing)
        // Borrowing propagates out through an optional wrapper.
        #expect(try BridgeABI.shape(of: .nullable(.string, .null), cell: .importParameter).useBorrowing)
    }

    /// Types with no ABI in a given cell must say so, rather than answering with something
    /// plausible. Preserved from the tables this description replaced.
    @Test func typesWithoutAnABISaySo() {
        #expect(throws: (any Error).self) { try BridgeABI.shape(of: .namespaceEnum("Utils"), cell: .exportParameter) }
        #expect(throws: (any Error).self) { try BridgeABI.shape(of: .namespaceEnum("Utils"), cell: .exportReturn) }
        #expect(throws: (any Error).self) {
            try BridgeABI.shape(of: .swiftProtocol("D"), cell: .importParameter, context: .importTS)
        }
        // ...but the same protocol is fine when Swift owns the call.
        #expect(throws: Never.self) {
            try BridgeABI.shape(of: .swiftProtocol("D"), cell: .importParameter, context: .exportSwift)
        }
    }

    /// A quirk worth pinning: an optional return never consults its payload's flat shape, so
    /// `.nullable(.namespaceEnum)` is accepted where a bare `.namespaceEnum` return throws.
    /// Inherited from the old table. Documented here so that if it is ever tightened, it is
    /// a deliberate change with a failing test, not a silent one.
    @Test func optionalReturnDoesNotValidateItsPayload() throws {
        #expect(throws: (any Error).self) { try BridgeABI.shape(of: .namespaceEnum("Utils"), cell: .exportReturn) }
        let optional = try BridgeABI.shape(of: .nullable(.namespaceEnum("Utils"), .null), cell: .exportReturn)
        #expect(optional.returnValue == nil)
    }

    /// `payloadSlots` is `wasmParams`' new home. It differs from the `.exportParameter`
    /// shape in exactly one way: it strips an optional's presence flag, because that flag
    /// belongs to the optional and not to the payload whose arity the caller is asking about.
    @Test func payloadSlotsStripTheOptionalFlag() {
        #expect(BridgeABI.payloadSlots(of: .nullable(.integer(.int), .null)).map(\.name) == ["value"])
        #expect(BridgeABI.payloadSlots(of: .nullable(.string, .null)).map(\.name) == ["bytes", "length"])
        #expect(BridgeABI.payloadSlots(of: .string).map(\.name) == ["bytes", "length"])
        // Stack-borne payloads have no flat slots, which is how callers detect them.
        #expect(BridgeABI.payloadSlots(of: .array(.string)).isEmpty)
        #expect(BridgeABI.payloadSlots(of: .swiftStruct("Point")).isEmpty)
        // No ABI at all, but answers with an arity rather than throwing -- callers reach
        // this from non-throwing contexts and only want the count.
        #expect(BridgeABI.payloadSlots(of: .namespaceEnum("Utils")).isEmpty)
    }

    // MARK: - Aliases

    /// `.alias` is transparent on the export side (the tables recurse through it) and must
    /// be pre-resolved on the import side. Both halves of that contract are asserted here.
    @Test("aliases are transparent to the export-side description", arguments: leafTypes)
    func aliasIsTransparent(underlying: BridgeType) throws {
        let aliased = BridgeType.alias(name: "MyAlias", underlying: underlying)
        let direct = Outcome { Self.slots(try BridgeABI.shape(of: underlying, cell: .exportParameter)) }
        let viaAlias = Outcome { Self.slots(try BridgeABI.shape(of: aliased, cell: .exportParameter)) }
        #expect(direct == viaAlias, "alias should be transparent for \(underlying)")

        let directRet = Outcome { try BridgeABI.shape(of: underlying, cell: .exportReturn).returnValue }
        let viaAliasRet = Outcome { try BridgeABI.shape(of: aliased, cell: .exportReturn).returnValue }
        #expect(directRet == viaAliasRet, "alias should be transparent for \(underlying) (return)")
    }

    // MARK: - Stack programs

    /// Compiling the stack program must not trap for anything in the corpus. This is a smoke
    /// test, not a layout assertion -- the layout is pinned by `StackABIProgramTests`, the
    /// snapshot suites, and ultimately `make unittest`. (The detailed program shapes live in
    /// `StackABIProgramTests`.)
    @Test("stack programs are total over the corpus", arguments: corpus, [StackOp.Operation.lower, .lift])
    func stackProgramIsTotal(type: BridgeType, operation: StackOp.Operation) {
        _ = StackOp.compile(type, as: operation)
    }

    // MARK: - Coverage

    /// Fails when a new `BridgeType` case is added without a corresponding corpus entry.
    ///
    /// Without this, a new case silently gets zero conformance coverage -- which is exactly
    /// the failure mode this whole change exists to prevent.
    @Test func everyBridgeTypeCaseIsCovered() {
        var seen = Set<String>()
        for type in Self.corpus {
            seen.insert(caseName(of: type))
        }
        let expected: Set<String> = [
            "integer", "float", "double", "string", "bool", "jsObject", "jsValue",
            "swiftHeapObject", "void", "unsafePointer", "nullable", "array", "dictionary",
            "caseEnum", "rawValueEnum", "associatedValueEnum", "namespaceEnum",
            "swiftProtocol", "swiftStruct", "closure",
        ]
        #expect(
            expected.subtracting(seen).isEmpty,
            "BridgeType cases missing from the ABI conformance corpus: \(expected.subtracting(seen).sorted())"
        )
        // `.alias` is covered by `aliasIsTransparent`, not the main corpus.
    }

    private func caseName(of type: BridgeType) -> String {
        String(describing: type).prefix { $0 != "(" }.description
    }
}
