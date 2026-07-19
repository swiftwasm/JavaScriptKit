#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// The JavaScript backend of the stack-ABI VM: a stack machine that interprets a `StackOp`
/// program and emits the push/pop JS glue.
///
/// This is wasm-bindgen's `JsBuilder` shape. It keeps an operand stack of JS expression
/// strings; each op pops the operands it consumes and pushes the ones it produces. Impure
/// work (memory retains, loops) is written into the printer and only the resulting variable
/// name is pushed onto the operand stack, exactly as wasm-bindgen requires its stack entries
/// to be pure expressions.
///
/// Lowering and lifting are two *separate* programs compiled by `StackOp.compile(_:as:)`, so
/// this interpreter is always a straight forward pass - it never reasons about LIFO order,
/// because the compiler already reversed the lift program.
///
/// The Swift half of the boundary is not an interpreter: the scalar conformances are
/// generated from the same ABI description by `SwiftRuntimeABIEmitter` (see its header for
/// what is and isn't generated), and the container codecs are the generic
/// `_BridgedSwiftStackType` defaults in `BridgeJSIntrinsics.swift`, composed at runtime by
/// protocol dispatch.
final class JSStackMachine {
    private let context: IntrinsicJSFragment.PrintCodeContext
    private var scope: JSGlueVariableScope { context.scope }
    private var printer: CodeFragmentPrinter { context.printer }

    /// The operand stack of JS expression strings.
    private var stack: [String] = []

    init(_ context: IntrinsicJSFragment.PrintCodeContext) {
        self.context = context
    }

    // MARK: - Entry points

    /// Lowers `value` onto the stacks by running `program`. The operand stack must drain to
    /// empty - a leftover would mean the program forgot to consume something.
    static func lower(_ program: [StackOp], _ value: String, _ context: IntrinsicJSFragment.PrintCodeContext) throws {
        let machine = JSStackMachine(context)
        machine.stack.append(value)
        try machine.run(program)
    }

    /// Lifts a value by running `program`, returning the single operand left on the stack
    /// (nil for a `.unit`/void program).
    static func lift(_ program: [StackOp], _ context: IntrinsicJSFragment.PrintCodeContext) throws -> String? {
        let machine = JSStackMachine(context)
        try machine.run(program)
        return machine.stack.last
    }

    // MARK: - The interpreter loop

    private func run(_ program: [StackOp]) throws {
        for op in program {
            try step(op)
        }
    }

    private func push(_ expr: String) { stack.append(expr) }
    private func pop() -> String { stack.removeLast() }

    private func step(_ op: StackOp) throws {
        switch op {
        case .push(let channel, let coerce):
            emitPush(channel: channel, value: apply(coerce, to: pop()))
        case .pop(let channel, let coerce, let hint):
            let popped = popExpression(for: channel)
            let name = scope.variable(hint)
            printer.write("const \(name) = \(apply(coerce, to: popped));")
            push(name)

        case .lowerString: try stepLowerString()
        case .liftString: stepLiftString()
        case .lowerJSValue: try stepLowerJSValue()
        case .liftJSValue: stepLiftJSValue()
        case .lowerObject: stepLowerObject()
        case .liftObject: stepLiftObject()
        case .lowerHeapObject: stepLowerHeapObject()
        case .liftHeapObject(let className): stepLiftHeapObject(className)
        case .lowerStruct(let fullName): stepLowerStruct(fullName)
        case .liftStruct(let fullName): stepLiftStruct(fullName)
        case .lowerEnum(let fullName): stepLowerEnum(fullName)
        case .liftEnum(let fullName): stepLiftEnum(fullName)
        case .lowerArray(let element): try stepLowerArray(element)
        case .liftArray(let element): try stepLiftArray(element)
        case .liftMaybeBulkArray(let element): try stepLiftMaybeBulkArray(element)
        case .lowerDict(let key, let value): try stepLowerDict(key: key, value: value)
        case .liftDict(let key, let value): try stepLiftDict(key: key, value: value)
        case .lowerOptional(let absence, let payload): try stepLowerOptional(absence, payload)
        case .liftOptional(let absence, let payload): try stepLiftOptional(absence, payload)

        case .unsupported(let reason):
            throw BridgeJSLinkError(message: reason)
        }
    }

    // MARK: - String

    private func stepLowerString() throws {
        // Two i32 slots: length, then a retained handle to the encoded bytes. Swift's
        // `String.bridgeJSStackPop` pops them back and copies out of the retained array.
        let value = pop()
        let bytesVar = scope.variable("bytes")
        let idVar = scope.variable("id")
        printer.write("const \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));")
        printer.write("const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
        scope.emitPushI32Parameter("\(bytesVar).length", printer: printer)
        scope.emitPushI32Parameter(idVar, printer: printer)
    }

    private func stepLiftString() {
        // One slot: the host already decoded ptr/len into a JS string when Swift called
        // `swift_js_push_string`, so there is nothing to reassemble.
        let strVar = scope.variable("string")
        printer.write("const \(strVar) = \(scope.popString());")
        push(strVar)
    }

    // MARK: - JSValue

    private func stepLowerJSValue() throws {
        let value = pop()
        IntrinsicJSFragment.registerJSValueHelpers(scope: scope)
        let lowered = try IntrinsicJSFragment.jsValueLower.printCode([value], context)
        scope.emitPushI32Parameter(lowered[0], printer: printer)
        scope.emitPushI32Parameter(lowered[1], printer: printer)
        scope.emitPushF64Parameter(lowered[2], printer: printer)
    }

    private func stepLiftJSValue() {
        // Popped in reverse of the push order (kind, payload1, payload2) -- the reason these
        // three lines are in this order.
        let payload2Var = scope.variable("jsValuePayload2")
        let payload1Var = scope.variable("jsValuePayload1")
        let kindVar = scope.variable("jsValueKind")
        printer.write("const \(payload2Var) = \(scope.popF64());")
        printer.write("const \(payload1Var) = \(scope.popI32());")
        printer.write("const \(kindVar) = \(scope.popI32());")
        let resultVar = scope.variable("jsValue")
        IntrinsicJSFragment.registerJSValueHelpers(scope: scope)
        printer.write(
            "const \(resultVar) = \(IntrinsicJSFragment.jsValueLiftHelperName)(\(kindVar), \(payload1Var), \(payload2Var));"
        )
        push(resultVar)
    }

    // MARK: - Object refs

    private func stepLowerObject() {
        let value = pop()
        let idVar = scope.variable("objId")
        printer.write("const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));")
        scope.emitPushI32Parameter(idVar, printer: printer)
    }

    private func stepLiftObject() {
        let idVar = scope.variable("objId")
        let objVar = scope.variable("obj")
        printer.write("const \(idVar) = \(scope.popI32());")
        printer.write("const \(objVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(idVar));")
        printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
        push(objVar)
    }

    private func stepLowerHeapObject() {
        let value = pop()
        scope.emitPushPointerParameter("\(value).pointer", printer: printer)
    }

    private func stepLiftHeapObject(_ className: String) {
        let ptrVar = scope.variable("ptr")
        let objVar = scope.variable("obj")
        let classRef = context.classReference(forQualifiedName: className)
        printer.write("const \(ptrVar) = \(scope.popPointer());")
        printer.write("const \(objVar) = \(classRef).__construct(\(ptrVar));")
        push(objVar)
    }

    // MARK: - Struct / enum helpers

    private func stepLowerStruct(_ fullName: String) {
        let base = fullName.replacingOccurrences(of: ".", with: "_")
        printer.write("\(JSGlueVariableScope.reservedStructHelpers).\(base).lower(\(pop()));")
    }

    private func stepLiftStruct(_ fullName: String) {
        let base = fullName.replacingOccurrences(of: ".", with: "_")
        let resultVar = scope.variable("struct")
        printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lift();")
        push(resultVar)
    }

    private func stepLowerEnum(_ fullName: String) {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        let caseIdVar = scope.variable("caseId")
        printer.write("const \(caseIdVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(pop()));")
        scope.emitPushI32Parameter(caseIdVar, printer: printer)
    }

    private func stepLiftEnum(_ fullName: String) {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        let resultVar = scope.variable("enumValue")
        printer.write(
            "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(scope.popI32()));"
        )
        push(resultVar)
    }

    // MARK: - Arrays

    private func stepLowerArray(_ element: [StackOp]) throws {
        let value = pop()
        let elemVar = scope.variable("elem")
        printer.write("for (const \(elemVar) of \(value)) {")
        try printer.indent {
            push(elemVar)
            try run(element)
        }
        printer.write("}")
        scope.emitPushI32Parameter("\(value).length", printer: printer)
    }

    /// Counted lift (every element type the runtime never bulks): pop the count, then that many
    /// elements. Elements come back in reverse push order, so the result is reversed. No
    /// discriminator - these arrays can never take the typed-array path.
    private func stepLiftArray(_ element: [StackOp]) throws {
        let resultVar = scope.variable("arrayResult")
        let lenVar = scope.variable("arrayLen")
        printer.write("const \(lenVar) = \(scope.popI32());")
        printer.write("const \(resultVar) = [];")
        try emitCountedLoop(into: resultVar, count: lenVar, element: element)
        push(resultVar)
    }

    /// Lift where the element might be bulk-transferred: pop the count; `-1` means Swift pushed
    /// a single typed array onto `taStack`, otherwise it is a counted element sequence. The
    /// runtime chose which, so this handles both.
    private func stepLiftMaybeBulkArray(_ element: [StackOp]) throws {
        let resultVar = scope.variable("arrayResult")
        let lenVar = scope.variable("arrayLen")
        printer.write("const \(lenVar) = \(scope.popI32());")
        printer.write("let \(resultVar);")
        printer.write("if (\(lenVar) === -1) {")
        printer.indent {
            printer.write("\(resultVar) = \(JSGlueVariableScope.reservedTaStack).pop();")
        }
        printer.write("} else {")
        try printer.indent {
            printer.write("\(resultVar) = [];")
            try emitCountedLoop(into: resultVar, count: lenVar, element: element)
        }
        printer.write("}")
        push(resultVar)
    }

    /// The shared "pop `count` elements into `resultVar`, then reverse" loop.
    private func emitCountedLoop(into resultVar: String, count lenVar: String, element: [StackOp]) throws {
        let iVar = scope.variable("i")
        printer.write("for (let \(iVar) = 0; \(iVar) < \(lenVar); \(iVar)++) {")
        try printer.indent {
            try run(element)
            printer.write("\(resultVar).push(\(pop()));")
        }
        printer.write("}")
        printer.write("\(resultVar).reverse();")
    }

    // MARK: - Dictionaries

    private func stepLowerDict(key: [StackOp], value: [StackOp]) throws {
        let accessor = pop()
        let entriesVar = scope.variable("entries")
        let entryVar = scope.variable("entry")
        printer.write("const \(entriesVar) = Object.entries(\(accessor));")
        printer.write("for (const \(entryVar) of \(entriesVar)) {")
        try printer.indent {
            let keyVar = scope.variable("key")
            let valueVar = scope.variable("value")
            printer.write("const [\(keyVar), \(valueVar)] = \(entryVar);")
            push(keyVar)
            try run(key)
            push(valueVar)
            try run(value)
        }
        printer.write("}")
        scope.emitPushI32Parameter("\(entriesVar).length", printer: printer)
    }

    private func stepLiftDict(key: [StackOp], value: [StackOp]) throws {
        let resultVar = scope.variable("dictResult")
        let countVar = scope.variable("dictLen")
        printer.write("const \(countVar) = \(scope.popI32());")
        printer.write("const \(resultVar) = {};")
        let iVar = scope.variable("i")
        printer.write("for (let \(iVar) = 0; \(iVar) < \(countVar); \(iVar)++) {")
        try printer.indent {
            // Value before key: the pair was pushed key-then-value, so LIFO returns it
            // value-first. The compiler put value's program first in the lift dict.
            try run(value)
            let valueExpr = pop()
            try run(key)
            let keyExpr = pop()
            printer.write("\(resultVar)[\(keyExpr)] = \(valueExpr);")
        }
        printer.write("}")
        push(resultVar)
    }

    // MARK: - Optionals

    private func stepLowerOptional(_ absence: JSOptionalKind, _ payload: [StackOp]) throws {
        // Payload first, then the flag -- so a lifting reader pops the flag first and knows
        // whether to expect a payload. Nothing is pushed when absent, so the pushed slot count
        // is runtime-dependent. Mirrors `_BridgedSwiftStackType.bridgeJSStackPushAsOptional`.
        let value = pop()
        let isSomeVar = scope.variable("isSome")
        printer.write("const \(isSomeVar) = \(absence.presenceCheck(value: value)) ? 1 : 0;")
        printer.write("if (\(isSomeVar)) {")
        try printer.indent {
            push(value)
            try run(payload)
        }
        printer.write("}")
        scope.emitPushI32Parameter(isSomeVar, printer: printer)
    }

    private func stepLiftOptional(_ absence: JSOptionalKind, _ payload: [StackOp]) throws {
        let isSomeVar = scope.variable("isSome")
        let resultVar = scope.variable("optValue")
        printer.write("const \(isSomeVar) = \(scope.popI32());")
        printer.write("let \(resultVar);")
        printer.write("if (\(isSomeVar) === 0) {")
        printer.indent {
            printer.write("\(resultVar) = \(absence.absenceLiteral);")
        }
        printer.write("} else {")
        try printer.indent {
            try run(payload)
            printer.write("\(resultVar) = \(pop());")
        }
        printer.write("}")
        push(resultVar)
    }

    // MARK: - Channels and coercions

    private func apply(_ coercion: ABICoercion, to value: String) -> String {
        switch coercion {
        case .none: return value
        case .boolToI32: return "\(value) ? 1 : 0"
        case .i32ToBool: return "\(value) !== 0"
        case .truncToI32: return "(\(value) | 0)"
        case .zeroExtendU32: return "\(value) >>> 0"
        case .fround: return "Math.fround(\(value))"
        }
    }

    private func popExpression(for channel: ABIStackChannel) -> String {
        switch channel {
        case .i32: return scope.popI32()
        case .i64: return scope.popI64()
        case .f32: return scope.popF32()
        case .f64: return scope.popF64()
        case .pointer: return scope.popPointer()
        case .string: return scope.popString()
        case .typedArray: return "\(JSGlueVariableScope.reservedTaStack).pop()"
        }
    }

    private func emitPush(channel: ABIStackChannel, value: String) {
        switch channel {
        case .i32: scope.emitPushI32Parameter(value, printer: printer)
        case .i64: scope.emitPushI64Parameter(value, printer: printer)
        case .f32: scope.emitPushF32Parameter(value, printer: printer)
        case .f64: scope.emitPushF64Parameter(value, printer: printer)
        case .pointer: scope.emitPushPointerParameter(value, printer: printer)
        case .string, .typedArray:
            // No generated JS pushes these: `strStack`/`taStack` are filled by the
            // `swift_js_push_string`/`swift_js_push_typed_array` imports, i.e. by Swift.
            printer.write("throw new Error(\"BridgeJS: cannot push onto the \(channel) stack from JS\");")
        }
    }
}
