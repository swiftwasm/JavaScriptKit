#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// A scope for variables for JS glue code
final class JSGlueVariableScope {
    // MARK: - Reserved variables

    static let reservedSwift = "swift"
    static let reservedInstance = "instance"
    static let reservedMemory = "memory"
    static let reservedSetException = "setException"
    static let reservedStorageToReturnString = "tmpRetString"
    static let reservedStorageToReturnBytes = "tmpRetBytes"
    static let reservedStorageToReturnException = "tmpRetException"
    static let reservedStorageToReturnOptionalBool = "tmpRetOptionalBool"
    static let reservedStorageToReturnOptionalInt = "tmpRetOptionalInt"
    static let reservedStorageToReturnOptionalFloat = "tmpRetOptionalFloat"
    static let reservedStorageToReturnOptionalDouble = "tmpRetOptionalDouble"
    static let reservedStorageToReturnOptionalHeapObject = "tmpRetOptionalHeapObject"
    static let reservedTextEncoder = "textEncoder"
    static let reservedTextDecoder = "textDecoder"
    static let reservedStringStack = "strStack"
    static let reservedI32Stack = "i32Stack"
    static let reservedF32Stack = "f32Stack"
    static let reservedF64Stack = "f64Stack"
    static let reservedPointerStack = "ptrStack"
    static let reservedEnumHelpers = "enumHelpers"
    static let reservedStructHelpers = "structHelpers"
    static let reservedSwiftClosureRegistry = "swiftClosureRegistry"
    static let reservedMakeSwiftClosure = "makeClosure"

    private let intrinsicRegistry: JSIntrinsicRegistry

    private var variables: Set<String> = [
        reservedSwift,
        reservedInstance,
        reservedMemory,
        reservedSetException,
        reservedStorageToReturnString,
        reservedStorageToReturnBytes,
        reservedStorageToReturnException,
        reservedStorageToReturnOptionalBool,
        reservedStorageToReturnOptionalInt,
        reservedStorageToReturnOptionalFloat,
        reservedStorageToReturnOptionalDouble,
        reservedStorageToReturnOptionalHeapObject,
        reservedTextEncoder,
        reservedTextDecoder,
        reservedStringStack,
        reservedI32Stack,
        reservedF32Stack,
        reservedF64Stack,
        reservedPointerStack,
        reservedEnumHelpers,
        reservedStructHelpers,
        reservedSwiftClosureRegistry,
        reservedMakeSwiftClosure,
    ]

    init(intrinsicRegistry: JSIntrinsicRegistry) {
        self.intrinsicRegistry = intrinsicRegistry
    }

    /// Returns a unique variable name in the scope based on the given name hint.
    ///
    /// - Parameter hint: A hint for the variable name.
    /// - Returns: A unique variable name.
    func variable(_ hint: String) -> String {
        if variables.insert(hint).inserted {
            return hint
        }
        var suffixedName: String
        var suffix = 1
        repeat {
            suffixedName = hint + suffix.description
            suffix += 1
        } while !variables.insert(suffixedName).inserted
        return suffixedName
    }

    func registerIntrinsic(_ name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        try intrinsicRegistry.register(name: name, build: build)
    }

    func makeChildScope() -> JSGlueVariableScope {
        JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
    }

}

extension JSGlueVariableScope {
    // MARK: Parameter

    func emitPushI32Parameter(_ value: String, printer: CodeFragmentPrinter) {
        printer.write("\(JSGlueVariableScope.reservedI32Stack).push(\(value));")
    }
    func emitPushF64Parameter(_ value: String, printer: CodeFragmentPrinter) {
        printer.write("\(JSGlueVariableScope.reservedF64Stack).push(\(value));")
    }
    func emitPushF32Parameter(_ value: String, printer: CodeFragmentPrinter) {
        printer.write("\(JSGlueVariableScope.reservedF32Stack).push(\(value));")
    }
    func emitPushPointerParameter(_ value: String, printer: CodeFragmentPrinter) {
        printer.write("\(JSGlueVariableScope.reservedPointerStack).push(\(value));")
    }

    // MARK: Pop
    func popString() -> String {
        return "\(JSGlueVariableScope.reservedStringStack).pop()"
    }
    func popI32() -> String {
        return "\(JSGlueVariableScope.reservedI32Stack).pop()"
    }
    func popF64() -> String {
        return "\(JSGlueVariableScope.reservedF64Stack).pop()"
    }
    func popF32() -> String {
        return "\(JSGlueVariableScope.reservedF32Stack).pop()"
    }
    func popPointer() -> String {
        return "\(JSGlueVariableScope.reservedPointerStack).pop()"
    }
}

/// A fragment of JS code used to convert a value between Swift and JS.
///
/// See `BridgeJSIntrinsics.swift` in the main JavaScriptKit module for Swift side lowering/lifting implementation.
struct IntrinsicJSFragment: Sendable {

    struct PrintCodeContext {
        /// The scope of the variables.
        var scope: JSGlueVariableScope
        /// The printer to print the main fragment code.
        var printer: CodeFragmentPrinter
        /// Whether the fragment has direct access to the SwiftHeapObject classes.
        /// If false, the fragment needs to use `_exports["<class name>"]` to access the class.
        var hasDirectAccessToSwiftClass: Bool = true

        func with<T>(_ keyPath: WritableKeyPath<PrintCodeContext, T>, _ value: T) -> PrintCodeContext {
            var new = self
            new[keyPath: keyPath] = value
            return new
        }
    }

    /// A function that prints the fragment code.
    ///
    /// - Parameters:
    ///   - arguments: The arguments that the fragment expects. An argument may be an expression with side effects,
    ///     so the callee is responsible for evaluating the arguments only once.
    ///   - context: The context of the printing.
    /// - Returns: List of result expressions.
    typealias PrintCode =
        @Sendable (
            _ arguments: [String],
            _ context: PrintCodeContext
        ) throws -> [String]

    /// The names of the parameters that the fragment expects.
    let parameters: [String]

    /// Prints the fragment code.
    let printCode: PrintCode

    init(parameters: [String], printCode: @escaping PrintCode) {
        self.parameters = parameters
        self.printCode = printCode
    }

    func printCode(_ arguments: [String], _ context: PrintCodeContext) throws -> [String] {
        return try printCode(arguments, context)
    }

    /// A fragment that does nothing
    static let void = IntrinsicJSFragment(
        parameters: [],
        printCode: { _, _ in
            return []
        }
    )

    /// A fragment that returns the argument as is.
    static let identity = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return [arguments[0]]
        }
    )

    // MARK: - Scalar Coercion Fragments

    static let boolLiftReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(arguments[0]) !== 0"]
        }
    )
    static let boolLiftParameter = boolLiftReturn
    static let boolLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(arguments[0]) ? 1 : 0"]
        }
    )
    static let uintLiftReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(arguments[0]) >>> 0"]
        }
    )
    static let uintLiftParameter = uintLiftReturn

    // MARK: - String Fragments

    static let stringLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, context in
            let (scope, printer) = (context.scope, context.printer)
            let argument = arguments[0]
            let bytesLabel = scope.variable("\(argument)Bytes")
            let bytesIdLabel = scope.variable("\(argument)Id")
            printer.write("const \(bytesLabel) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(argument));")
            printer.write("const \(bytesIdLabel) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesLabel));")
            return [bytesIdLabel, "\(bytesLabel).length"]
        }
    )
    static let stringLiftReturn = IntrinsicJSFragment(
        parameters: [],
        printCode: { arguments, context in
            let (scope, printer) = (context.scope, context.printer)
            let resultLabel = scope.variable("ret")
            printer.write("const \(resultLabel) = \(JSGlueVariableScope.reservedStorageToReturnString);")
            printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
            return [resultLabel]
        }
    )
    static let stringLiftParameter = IntrinsicJSFragment(
        parameters: ["objectId"],
        printCode: { arguments, context in
            let (scope, printer) = (context.scope, context.printer)
            let objectId = arguments[0]
            let objectLabel = scope.variable("\(objectId)Object")
            // TODO: Implement "take" operation
            printer.write(
                "const \(objectLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectId));"
            )
            printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectId));")
            return [objectLabel]
        }
    )
    static let stringLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, context in
            let printer = context.printer
            printer.write(
                "\(JSGlueVariableScope.reservedStorageToReturnBytes) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(arguments[0]));"
            )
            return ["\(JSGlueVariableScope.reservedStorageToReturnBytes).length"]
        }
    )

    // MARK: - JSObject Fragments

    static let jsObjectLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["swift.memory.retain(\(arguments[0]))"]
        }
    )
    private static func jsObjectTakeRetained(hint: String = "ret") -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["objectId"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                // TODO: Implement "take" operation
                let resultLabel = scope.variable(hint)
                let objectId = arguments[0]
                printer.write(
                    "const \(resultLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectId));"
                )
                printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectId));")
                return [resultLabel]
            }
        )
    }
    static let jsObjectLiftReturn = jsObjectTakeRetained(hint: "ret")
    static let jsObjectLiftRetainedObjectId = jsObjectTakeRetained(hint: "value")
    static let jsObjectLiftParameter = IntrinsicJSFragment(
        parameters: ["objectId"],
        printCode: { arguments, _ in
            return ["\(JSGlueVariableScope.reservedSwift).memory.getObject(\(arguments[0]))"]
        }
    )
    static let jsObjectLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(JSGlueVariableScope.reservedSwift).memory.retain(\(arguments[0]))"]
        }
    )

    // MARK: - JSValue Fragments

    private static let jsValueLowerHelperName = "__bjs_jsValueLower"
    private static let jsValueLiftHelperName = "__bjs_jsValueLift"

    private static func registerJSValueHelpers(scope: JSGlueVariableScope) {
        scope.registerIntrinsic("jsValueHelpers") { helperPrinter in
            helperPrinter.write("function \(jsValueLowerHelperName)(value) {")
            helperPrinter.indent {
                emitJSValueLowerBody(
                    value: "value",
                    kindVar: "kind",
                    payload1Var: "payload1",
                    payload2Var: "payload2",
                    printer: helperPrinter
                )
                helperPrinter.write("return [kind, payload1, payload2];")
            }
            helperPrinter.write("}")
            helperPrinter.write("function \(jsValueLiftHelperName)(kind, payload1, payload2) {")
            helperPrinter.indent {
                let helperScope = scope.makeChildScope()
                let resultVar = emitJSValueConstruction(
                    kind: "kind",
                    payload1: "payload1",
                    payload2: "payload2",
                    scope: helperScope,
                    printer: helperPrinter
                )
                helperPrinter.write("return \(resultVar);")
            }
            helperPrinter.write("}")
        }
    }

    private static func emitJSValueLowerBody(
        value: String,
        kindVar: String,
        payload1Var: String,
        payload2Var: String,
        printer: CodeFragmentPrinter
    ) {
        printer.write("let \(kindVar);")
        printer.write("let \(payload1Var);")
        printer.write("let \(payload2Var);")
        printer.write("if (\(value) === null) {")
        printer.indent {
            printer.write("\(kindVar) = 4;")
            printer.write("\(payload1Var) = 0;")
            printer.write("\(payload2Var) = 0;")
        }
        printer.write("} else {")
        printer.indent {
            printer.write("switch (typeof \(value)) {")
            printer.indent {
                printer.write("case \"boolean\":")
                printer.indent {
                    printer.write("\(kindVar) = 0;")
                    printer.write("\(payload1Var) = \(value) ? 1 : 0;")
                    printer.write("\(payload2Var) = 0;")
                    printer.write("break;")
                }
                printer.write("case \"number\":")
                printer.indent {
                    printer.write("\(kindVar) = 2;")
                    printer.write("\(payload1Var) = 0;")
                    printer.write("\(payload2Var) = \(value);")
                    printer.write("break;")
                }
                func emitRetainCase(_ caseName: String, kind: Int) {
                    printer.write("case \"\(caseName)\":")
                    printer.indent {
                        printer.write("\(kindVar) = \(kind);")
                        printer.write(
                            "\(payload1Var) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));"
                        )
                        printer.write("\(payload2Var) = 0;")
                        printer.write("break;")
                    }
                }
                emitRetainCase("string", kind: 1)
                printer.write("case \"undefined\":")
                printer.indent {
                    printer.write("\(kindVar) = 5;")
                    printer.write("\(payload1Var) = 0;")
                    printer.write("\(payload2Var) = 0;")
                    printer.write("break;")
                }
                emitRetainCase("object", kind: 3)
                emitRetainCase("function", kind: 3)
                emitRetainCase("symbol", kind: 7)
                emitRetainCase("bigint", kind: 8)
                printer.write("default:")
                printer.indent {
                    printer.write("throw new TypeError(\"Unsupported JSValue type\");")
                }
            }
            printer.write("}")
        }
        printer.write("}")
    }

    static let jsValueLower = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, context in
            let (scope, printer) = (context.scope, context.printer)
            let value = arguments[0]
            let kindVar = scope.variable("\(value)Kind")
            let payload1Var = scope.variable("\(value)Payload1")
            let payload2Var = scope.variable("\(value)Payload2")
            registerJSValueHelpers(scope: scope)
            printer.write(
                "const [\(kindVar), \(payload1Var), \(payload2Var)] = \(jsValueLowerHelperName)(\(value));"
            )
            return [kindVar, payload1Var, payload2Var]
        }
    )

    private static func emitJSValueConstruction(
        kind: String,
        payload1: String,
        payload2: String,
        scope: JSGlueVariableScope,
        printer: CodeFragmentPrinter
    ) -> String {
        let resultVar = scope.variable("jsValue")
        printer.write("let \(resultVar);")
        printer.write("switch (\(kind)) {")
        printer.indent {
            printer.write("case 0:")
            printer.indent {
                printer.write("\(resultVar) = \(payload1) !== 0;")
                printer.write("break;")
            }
            printer.write("case 1:")
            printer.indent {
                printer.write(
                    "\(resultVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(payload1));"
                )
                printer.write("break;")
            }
            printer.write("case 2:")
            printer.indent {
                printer.write("\(resultVar) = \(payload2);")
                printer.write("break;")
            }
            printer.write("case 3:")
            printer.indent {
                printer.write(
                    "\(resultVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(payload1));"
                )
                printer.write("break;")
            }
            printer.write("case 4:")
            printer.indent {
                printer.write("\(resultVar) = null;")
                printer.write("break;")
            }
            printer.write("case 5:")
            printer.indent {
                printer.write("\(resultVar) = undefined;")
                printer.write("break;")
            }
            printer.write("case 7:")
            printer.indent {
                printer.write(
                    "\(resultVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(payload1));"
                )
                printer.write("break;")
            }
            printer.write("case 8:")
            printer.indent {
                printer.write(
                    "\(resultVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(payload1));"
                )
                printer.write("break;")
            }
            printer.write("default:")
            printer.indent {
                printer.write("throw new TypeError(\"Unsupported JSValue kind \" + \(kind));")
            }
        }
        printer.write("}")
        return resultVar
    }

    static func jsValueLowerReturn(context: BridgeContext) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let lowered = try jsValueLower.printCode(arguments, context)
                let kindVar = lowered[0]
                let payload1Var = lowered[1]
                let payload2Var = lowered[2]
                scope.emitPushI32Parameter(kindVar, printer: printer)
                scope.emitPushI32Parameter(payload1Var, printer: printer)
                scope.emitPushF64Parameter(payload2Var, printer: printer)
                return []
            }
        )
    }

    static let jsValueLift = IntrinsicJSFragment(
        parameters: [],
        printCode: { _, context in
            let (scope, printer) = (context.scope, context.printer)
            let payload2 = scope.variable("jsValuePayload2")
            let payload1 = scope.variable("jsValuePayload1")
            let kind = scope.variable("jsValueKind")
            printer.write("const \(payload2) = \(scope.popF64());")
            printer.write("const \(payload1) = \(scope.popI32());")
            printer.write("const \(kind) = \(scope.popI32());")
            let resultVar = scope.variable("jsValue")
            registerJSValueHelpers(scope: scope)
            printer.write(
                "const \(resultVar) = \(jsValueLiftHelperName)(\(kind), \(payload1), \(payload2));"
            )
            return [resultVar]
        }
    )
    static let jsValueLiftParameter = IntrinsicJSFragment(
        parameters: ["kind", "payload1", "payload2"],
        printCode: { arguments, context in
            let (scope, printer) = (context.scope, context.printer)
            let resultVar = scope.variable("jsValue")
            registerJSValueHelpers(scope: scope)
            printer.write(
                "const \(resultVar) = \(jsValueLiftHelperName)(\(arguments[0]), \(arguments[1]), \(arguments[2]));"
            )
            return [resultVar]
        }
    )

    // MARK: - SwiftHeapObject Fragments

    static let swiftHeapObjectLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(arguments[0]).pointer"]
        }
    )
    static let swiftHeapObjectLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, _ in
            return ["\(arguments[0]).pointer"]
        }
    )

    static func swiftHeapObjectLiftReturn(_ name: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                return [
                    "\(context.hasDirectAccessToSwiftClass ? name : "_exports['\(name)']").__construct(\(arguments[0]))"
                ]
            }
        )
    }
    static func swiftHeapObjectLiftParameter(_ name: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["pointer"],
            printCode: { arguments, context in
                return ["_exports['\(name)'].__construct(\(arguments[0]))"]
            }
        )
    }

    // MARK: - Associated Enum Fragments

    static func associatedEnumLowerParameter(enumBase: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let caseIdName = scope.variable("\(value)CaseId")
                printer.write(
                    "const \(caseIdName) = \(JSGlueVariableScope.reservedEnumHelpers).\(enumBase).lower(\(value));"
                )
                return [caseIdName]
            }
        )
    }

    static func associatedEnumLiftReturn(enumBase: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let retName = scope.variable("ret")
                printer.write(
                    "const \(retName) = \(JSGlueVariableScope.reservedEnumHelpers).\(enumBase).lift(\(scope.popI32()));"
                )
                return [retName]
            }
        )
    }

    // MARK: - Optional Handling

    static func optionalLiftParameter(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        context bridgeContext: BridgeContext = .importTS
    ) throws -> IntrinsicJSFragment {
        if wrappedType.isSingleParamScalar {
            let coerce = wrappedType.liftCoerce
            return IntrinsicJSFragment(
                parameters: ["isSome", "wrappedValue"],
                printCode: { arguments, _ in
                    let isSome = arguments[0]
                    let wrappedValue = arguments[1]
                    let absenceLiteral = kind.absenceLiteral
                    if let coerce {
                        let coerced = coerce.replacingOccurrences(of: "$0", with: wrappedValue)
                        return ["\(isSome) ? \(coerced) : \(absenceLiteral)"]
                    }
                    return ["\(isSome) ? \(wrappedValue) : \(absenceLiteral)"]
                }
            )
        }

        let innerFragment = try liftParameter(type: wrappedType, context: bridgeContext)
        return compositeOptionalLiftParameter(
            wrappedType: wrappedType,
            kind: kind,
            innerFragment: innerFragment
        )
    }

    private static func compositeOptionalLiftParameter(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        innerFragment: IntrinsicJSFragment
    ) -> IntrinsicJSFragment {
        let isStackConvention = wrappedType.optionalConvention == .stackABI
        let absenceLiteral = kind.absenceLiteral

        let outerParams: [String]
        if isStackConvention {
            outerParams = ["isSome"]
        } else {
            outerParams = ["isSome"] + innerFragment.parameters
        }

        return IntrinsicJSFragment(
            parameters: outerParams,
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let isSome = arguments[0]
                let innerArgs = isStackConvention ? [] : Array(arguments.dropFirst())

                let bufferPrinter = CodeFragmentPrinter()
                let innerResults = try innerFragment.printCode(
                    innerArgs,
                    context.with(\.printer, bufferPrinter)
                )

                let hasSideEffects = !bufferPrinter.lines.isEmpty
                let innerExpr = innerResults.first ?? "undefined"

                if hasSideEffects {
                    let resultVar = scope.variable("optResult")
                    printer.write("let \(resultVar);")
                    printer.write("if (\(isSome)) {")
                    printer.indent {
                        for line in bufferPrinter.lines {
                            printer.write(line)
                        }
                        printer.write("\(resultVar) = \(innerExpr);")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(resultVar) = \(absenceLiteral);")
                    }
                    printer.write("}")
                    return [resultVar]
                } else {
                    return ["\(isSome) ? \(innerExpr) : \(absenceLiteral)"]
                }
            }
        )
    }

    static func optionalLowerParameter(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) throws -> IntrinsicJSFragment {
        if wrappedType.isSingleParamScalar {
            let wasmType = wrappedType.wasmParams[0].type
            let coerce = wrappedType.lowerCoerce
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let isSomeVar = scope.variable("isSome")
                    let presenceExpr = kind.presenceCheck(value: value)
                    printer.write("const \(isSomeVar) = \(presenceExpr);")
                    let coerced: String
                    if let coerce {
                        coerced = coerce.replacingOccurrences(of: "$0", with: value)
                    } else {
                        coerced = value
                    }
                    return ["+\(isSomeVar)", "\(isSomeVar) ? \(coerced) : \(wasmType.jsZeroLiteral)"]
                }
            )
        }

        let innerFragment = try lowerParameter(type: wrappedType)
        return try compositeOptionalLowerParameter(
            wrappedType: wrappedType,
            kind: kind,
            innerFragment: innerFragment
        )
    }

    private static func compositeOptionalLowerParameter(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        innerFragment: IntrinsicJSFragment
    ) throws -> IntrinsicJSFragment {
        let isStackConvention = wrappedType.optionalConvention == .stackABI

        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                printer.write("const \(isSomeVar) = \(kind.presenceCheck(value: value));")

                let ifBodyPrinter = CodeFragmentPrinter()
                let innerResults = try innerFragment.printCode(
                    [value],
                    context.with(\.printer, ifBodyPrinter)
                )

                let resultVars = innerResults.map { _ in scope.variable("result") }
                assert(
                    isStackConvention || resultVars.count == wrappedType.wasmParams.count,
                    "Inner fragment result count (\(resultVars.count)) must match wasmParams count (\(wrappedType.wasmParams.count)) for \(wrappedType)"
                )
                if !resultVars.isEmpty {
                    printer.write("let \(resultVars.joined(separator: ", "));")
                }

                printer.write("if (\(isSomeVar)) {")
                printer.indent {
                    for line in ifBodyPrinter.lines {
                        printer.write(line)
                    }
                    for (resultVar, innerResult) in zip(resultVars, innerResults) {
                        printer.write("\(resultVar) = \(innerResult);")
                    }
                }

                let hasPlaceholders = !isStackConvention && !wrappedType.wasmParams.isEmpty
                if hasPlaceholders {
                    printer.write("} else {")
                    printer.indent {
                        for (resultVar, param) in zip(resultVars, wrappedType.wasmParams) {
                            printer.write("\(resultVar) = \(param.type.jsZeroLiteral);")
                        }
                    }
                }
                printer.write("}")

                if isStackConvention {
                    scope.emitPushI32Parameter("+\(isSomeVar)", printer: printer)
                    return []
                } else {
                    return ["+\(isSomeVar)"] + resultVars
                }
            }
        )
    }

    private static func optionalLiftReturnFromStorage(storage: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("optResult")
                printer.write("const \(resultVar) = \(storage);")
                printer.write("\(storage) = undefined;")
                return [resultVar]
            }
        )
    }

    private static func optionalLiftReturnWithPresenceFlag(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        let absenceLiteral = kind.absenceLiteral
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let isSomeVar = scope.variable("isSome")
                printer.write("const \(isSomeVar) = \(scope.popI32());")

                let innerFragment = try liftReturn(type: wrappedType)

                let innerPrinter = CodeFragmentPrinter()
                let innerResults = try innerFragment.printCode([], context.with(\.printer, innerPrinter))
                let innerExpr = innerResults.first ?? "undefined"

                if innerPrinter.lines.isEmpty {
                    return ["\(isSomeVar) ? \(innerExpr) : \(absenceLiteral)"]
                }

                let resultVar = scope.variable("optResult")
                printer.write("let \(resultVar);")
                printer.write("if (\(isSomeVar)) {")
                printer.indent {
                    for line in innerPrinter.lines {
                        printer.write(line)
                    }
                    printer.write("\(resultVar) = \(innerExpr);")
                }
                printer.write("} else {")
                printer.indent {
                    printer.write("\(resultVar) = \(absenceLiteral);")
                }
                printer.write("}")
                return [resultVar]
            }
        )
    }

    private static func optionalLiftReturnAssociatedEnum(
        fullName: String,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        let absenceLiteral = kind.absenceLiteral
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("optResult")
                let tagVar = scope.variable("tag")
                printer.write("const \(tagVar) = \(scope.popI32());")
                printer.write(
                    "const \(resultVar) = \(tagVar) === -1 ? \(absenceLiteral) : \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(tagVar));"
                )
                return [resultVar]
            }
        )
    }

    private static func optionalLiftReturnHeapObject(
        className: String,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        let absenceLiteral = kind.absenceLiteral
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("optResult")
                let pointerVar = scope.variable("pointer")
                printer.write(
                    "const \(pointerVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject);"
                )
                printer.write(
                    "\(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject) = undefined;"
                )
                let constructExpr =
                    context.hasDirectAccessToSwiftClass
                    ? "\(className).__construct(\(pointerVar))"
                    : "_exports['\(className)'].__construct(\(pointerVar))"
                printer.write(
                    "const \(resultVar) = \(pointerVar) === null ? \(absenceLiteral) : \(constructExpr);"
                )
                return [resultVar]
            }
        )
    }

    private static func optionalLiftReturnStruct(
        fullName: String,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        let absenceLiteral = kind.absenceLiteral
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { _, context in
                let (scope, printer) = (context.scope, context.printer)
                let isSomeVar = scope.variable("isSome")
                let resultVar = scope.variable("optResult")
                printer.write("const \(isSomeVar) = \(scope.popI32());")
                printer.write(
                    "const \(resultVar) = \(isSomeVar) ? \(JSGlueVariableScope.reservedStructHelpers).\(base).lift() : \(absenceLiteral);"
                )
                return [resultVar]
            }
        )
    }

    static func optionalLiftReturn(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        if let scalarKind = wrappedType.optionalScalarKind {
            return optionalLiftReturnFromStorage(storage: scalarKind.storageName)
        }
        if case .sideChannelReturn(let mode) = wrappedType.optionalConvention, mode != .none {
            return optionalLiftReturnFromStorage(storage: JSGlueVariableScope.reservedStorageToReturnString)
        }

        if case .swiftHeapObject(let className) = wrappedType {
            return optionalLiftReturnHeapObject(className: className, kind: kind)
        }

        if case .swiftStruct(let fullName) = wrappedType {
            return optionalLiftReturnStruct(fullName: fullName, kind: kind)
        }

        if wrappedType.nilSentinel.hasSentinel, case .associatedValueEnum(let fullName) = wrappedType {
            return optionalLiftReturnAssociatedEnum(fullName: fullName, kind: kind)
        }

        return optionalLiftReturnWithPresenceFlag(wrappedType: wrappedType, kind: kind)
    }

    private static func optionalLowerReturnToSideChannel(
        mode: OptionalSideChannel,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                let presenceExpr = kind.presenceCheck(value: value)
                printer.write("const \(isSomeVar) = \(presenceExpr);")

                if mode == .storage {
                    printer.write(
                        "\(JSGlueVariableScope.reservedStorageToReturnString) = \(isSomeVar) ? \(value) : \(kind.absenceLiteral);"
                    )
                } else {
                    let idVar = scope.variable("id")
                    printer.write("let \(idVar) = 0;")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write(
                            "\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));"
                        )
                    }
                    printer.write("}")
                    printer.write("bjs[\"swift_js_return_optional_object\"](\(isSomeVar) ? 1 : 0, \(idVar));")
                }

                return []
            }
        )
    }

    private static func optionalLowerReturnWithPresenceFlag(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        innerFragment: IntrinsicJSFragment
    ) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                let presenceExpr = kind.presenceCheck(value: value)
                printer.write("const \(isSomeVar) = \(presenceExpr);")

                let innerPrinter = CodeFragmentPrinter()
                let innerResults = try innerFragment.printCode(
                    [value],
                    context.with(\.printer, innerPrinter)
                )
                if !innerResults.isEmpty {
                    throw BridgeJSLinkError(
                        message: "Unsupported wrapped type for returning from JS function: \(wrappedType)"
                    )
                }

                printer.write("if (\(isSomeVar)) {")
                printer.indent {
                    for line in innerPrinter.lines {
                        printer.write(line)
                    }
                }
                printer.write("}")

                scope.emitPushI32Parameter("\(isSomeVar) ? 1 : 0", printer: printer)
                return []
            }
        )
    }

    static func optionalLowerReturn(wrappedType: BridgeType, kind: JSOptionalKind) throws -> IntrinsicJSFragment {
        switch wrappedType {
        case .void, .nullable, .namespaceEnum, .closure:
            throw BridgeJSLinkError(message: "Unsupported optional wrapped type for protocol export: \(wrappedType)")
        default: break
        }

        if let scalarKind = wrappedType.optionalScalarKind,
            !wrappedType.nilSentinel.hasSentinel, wrappedType.wasmParams.count == 1
        {
            let wasmType = wrappedType.wasmParams[0].type
            let funcName = scalarKind.funcName
            let stackCoerce = wrappedType.stackLowerCoerce
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let isSomeVar = scope.variable("isSome")
                    let presenceExpr = kind.presenceCheck(value: value)
                    printer.write("const \(isSomeVar) = \(presenceExpr);")
                    var coerced: String
                    if let coerce = stackCoerce {
                        coerced = coerce.replacingOccurrences(of: "$0", with: value)
                        if coerced.contains("?") && !coerced.hasPrefix("(") {
                            coerced = "(\(coerced))"
                        }
                    } else {
                        coerced = value
                    }
                    printer.write(
                        "bjs[\"\(funcName)\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? \(coerced) : \(wasmType.jsZeroLiteral));"
                    )
                    return []
                }
            )
        }

        if case .sideChannelReturn(let mode) = wrappedType.optionalConvention {
            if mode == .none {
                throw BridgeJSLinkError(
                    message: "Unsupported wrapped type for returning from JS function: \(wrappedType)"
                )
            }
            return optionalLowerReturnToSideChannel(mode: mode, kind: kind)
        }

        if wrappedType.nilSentinel.hasSentinel {
            let innerFragment = try lowerReturn(type: wrappedType, context: .exportSwift)
            return sentinelOptionalLowerReturn(
                wrappedType: wrappedType,
                kind: kind,
                innerFragment: innerFragment
            )
        }

        let innerFragment = try lowerReturn(type: wrappedType, context: .exportSwift)
        return optionalLowerReturnWithPresenceFlag(
            wrappedType: wrappedType,
            kind: kind,
            innerFragment: innerFragment
        )
    }

    private static func sentinelOptionalLowerReturn(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        innerFragment: IntrinsicJSFragment
    ) -> IntrinsicJSFragment {
        let sentinelLiteral = wrappedType.nilSentinel.jsLiteral

        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                let presenceExpr = kind.presenceCheck(value: value)
                printer.write("const \(isSomeVar) = \(presenceExpr);")

                let bufferPrinter = CodeFragmentPrinter()
                let innerResults = try innerFragment.printCode(
                    [value],
                    context.with(\.printer, bufferPrinter)
                )

                let hasSideEffects = !bufferPrinter.lines.isEmpty
                let innerExpr = innerResults.first

                if hasSideEffects {
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        for line in bufferPrinter.lines {
                            printer.write(line)
                        }
                        if let expr = innerExpr {
                            printer.write("return \(expr);")
                        }
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("return \(sentinelLiteral);")
                    }
                    printer.write("}")
                } else if let expr = innerExpr {
                    printer.write("return \(isSomeVar) ? \(expr) : \(sentinelLiteral);")
                }

                return []
            }
        )
    }

    // MARK: - Protocol Support

    static func protocolPropertyOptionalToSideChannel(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        if let scalarKind = wrappedType.optionalScalarKind {
            let storage = scalarKind.storageName
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    context.printer.write("\(storage) = \(arguments[0]);")
                    return []
                }
            )
        }

        if case .sideChannelReturn(let mode) = wrappedType.optionalConvention,
            mode != .none
        {
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let printer = context.printer
                    let value = arguments[0]

                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = \(value);")

                    return []
                }
            )
        }

        throw BridgeJSLinkError(
            message: "Type \(wrappedType) does not use side channel for protocol property returns"
        )
    }

    // MARK: - JS Glue Descriptor Helpers

    private static func popExpression(for wasmType: WasmCoreType, scope: JSGlueVariableScope) -> String {
        switch wasmType {
        case .i32: return scope.popI32()
        case .f32: return scope.popF32()
        case .f64: return scope.popF64()
        case .pointer: return scope.popPointer()
        case .i64: return scope.popI32()
        }
    }

    private static func emitPush(
        for wasmType: WasmCoreType,
        value: String,
        scope: JSGlueVariableScope,
        printer: CodeFragmentPrinter
    ) {
        switch wasmType {
        case .i32: scope.emitPushI32Parameter(value, printer: printer)
        case .f32: scope.emitPushF32Parameter(value, printer: printer)
        case .f64: scope.emitPushF64Parameter(value, printer: printer)
        case .pointer: scope.emitPushPointerParameter(value, printer: printer)
        case .i64: scope.emitPushI32Parameter(value, printer: printer)
        }
    }

    @discardableResult
    private static func emitOptionalPlaceholders(
        for wrappedType: BridgeType,
        scope: JSGlueVariableScope,
        printer: CodeFragmentPrinter
    ) -> Bool {
        let params = wrappedType.wasmParams
        if params.isEmpty {
            return false
        }
        for param in params {
            emitPush(for: param.type, value: param.type.jsZeroLiteral, scope: scope, printer: printer)
        }
        return true
    }

    private static func stackOptionalLower(
        wrappedType: BridgeType,
        kind: JSOptionalKind,
        innerFragment: IntrinsicJSFragment
    ) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                printer.write("const \(isSomeVar) = \(kind.presenceCheck(value: value));")

                let ifBodyPrinter = CodeFragmentPrinter()
                try ifBodyPrinter.indent {
                    let _ = try innerFragment.printCode(
                        [value],
                        context.with(\.printer, ifBodyPrinter)
                    )
                }
                printer.write("if (\(isSomeVar)) {")
                for line in ifBodyPrinter.lines {
                    printer.write(line)
                }
                let placeholderPrinter = CodeFragmentPrinter()
                let hasPlaceholders = emitOptionalPlaceholders(
                    for: wrappedType,
                    scope: scope,
                    printer: placeholderPrinter
                )
                if hasPlaceholders {
                    printer.write("} else {")
                    printer.indent {
                        for line in placeholderPrinter.lines {
                            printer.write(line)
                        }
                    }
                    printer.write("}")
                } else {
                    printer.write("}")
                }
                scope.emitPushI32Parameter("\(isSomeVar) ? 1 : 0", printer: printer)
                return []
            }
        )
    }

    // MARK: - ExportSwift

    /// Returns a fragment that lowers a JS value to Wasm core values for parameters
    static func lowerParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .bool, .int, .uint, .float, .double, .unsafePointer, .caseEnum:
            return .identity
        case .rawValueEnum(_, let rawType) where rawType != .string:
            return .identity
        case .string: return .stringLowerParameter
        case .jsObject: return .jsObjectLowerParameter
        case .jsValue: return .jsValueLower
        case .swiftHeapObject: return .swiftHeapObjectLowerParameter
        case .swiftProtocol: return .jsObjectLowerParameter
        case .void: return .void
        case .nullable(let wrappedType, let kind):
            return try .optionalLowerParameter(wrappedType: wrappedType, kind: kind)
        case .rawValueEnum(_, .string): return .stringLowerParameter
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return .associatedEnumLowerParameter(enumBase: base)
        case .swiftStruct(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return swiftStructLowerParameter(structBase: base)
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["closure"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let closure = arguments[0]
                    let callbackIdVar = scope.variable("callbackId")
                    printer.write(
                        "const \(callbackIdVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(closure));"
                    )
                    return [callbackIdVar]
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(message: "Namespace enums are not supported to be passed as parameters: \(string)")
        case .array(let elementType):
            return try arrayLower(elementType: elementType)
        case .dictionary(let valueType):
            return try dictionaryLower(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unhandled type in lowerParameter: \(type)")
        }
    }

    /// Returns a fragment that lifts a Wasm core value to a JS value for return values
    static func liftReturn(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .bool, .rawValueEnum(_, .bool):
            return .boolLiftReturn
        case .uint:
            return .uintLiftReturn
        case .int, .float, .double, .unsafePointer, .caseEnum:
            return .identity
        case .rawValueEnum(_, let rawType) where rawType != .string && rawType != .bool:
            return .identity
        case .string: return .stringLiftReturn
        case .jsObject: return .jsObjectLiftReturn
        case .jsValue: return .jsValueLift
        case .swiftHeapObject(let name): return .swiftHeapObjectLiftReturn(name)
        case .swiftProtocol: return .jsObjectLiftReturn
        case .void: return .void
        case .nullable(let wrappedType, let kind):
            return .optionalLiftReturn(wrappedType: wrappedType, kind: kind)
        case .rawValueEnum(_, .string): return .stringLiftReturn
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return .associatedEnumLiftReturn(enumBase: base)
        case .swiftStruct(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return swiftStructLiftReturn(structBase: base)
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["funcRef"],
                printCode: { arguments, context in
                    let funcRef = arguments[0]
                    return ["\(JSGlueVariableScope.reservedSwift).memory.getObject(\(funcRef))"]
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message: "Namespace enums are not supported to be returned from functions: \(string)"
            )
        case .array(let elementType):
            return try arrayLift(elementType: elementType)
        case .dictionary(let valueType):
            return try dictionaryLift(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unhandled type in liftReturn: \(type)")
        }
    }

    // MARK: - ImportedJS

    /// Returns a fragment that lifts Wasm core values to JS values for parameters
    static func liftParameter(type: BridgeType, context: BridgeContext = .importTS) throws -> IntrinsicJSFragment {
        switch type {
        case .bool, .rawValueEnum(_, .bool):
            return .boolLiftParameter
        case .uint:
            return .uintLiftParameter
        case .int, .float, .double, .unsafePointer, .caseEnum:
            return .identity
        case .rawValueEnum(_, let rawType) where rawType != .string && rawType != .bool:
            return .identity
        case .string: return .stringLiftParameter
        case .jsObject: return .jsObjectLiftParameter
        case .jsValue: return .jsValueLiftParameter
        case .swiftHeapObject(let name):
            return .swiftHeapObjectLiftParameter(name)
        case .swiftProtocol: return .jsObjectLiftParameter
        case .void:
            throw BridgeJSLinkError(
                message: "Void can't appear in parameters of imported JS functions"
            )
        case .nullable(let wrappedType, let kind):
            return try .optionalLiftParameter(wrappedType: wrappedType, kind: kind, context: context)
        case .rawValueEnum(_, .string): return .stringLiftParameter
        case .associatedValueEnum(let fullName):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message:
                        "Associated value enums are not supported to be passed as parameters to imported JS functions: \(fullName)"
                )
            case .exportSwift:
                let base = fullName.components(separatedBy: ".").last ?? fullName
                return IntrinsicJSFragment(
                    parameters: ["caseId"],
                    printCode: { arguments, context in
                        let (scope, printer) = (context.scope, context.printer)
                        let caseId = arguments[0]
                        let resultVar = scope.variable("enumValue")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseId));"
                        )
                        return [resultVar]
                    }
                )
            }
        case .swiftStruct(let fullName):
            switch context {
            case .importTS:
                return .jsObjectLiftRetainedObjectId
            case .exportSwift:
                let base = fullName.components(separatedBy: ".").last ?? fullName
                return IntrinsicJSFragment(
                    parameters: [],
                    printCode: { arguments, context in
                        let (scope, printer) = (context.scope, context.printer)
                        let resultVar = scope.variable("structValue")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lift();"
                        )
                        return [resultVar]
                    }
                )
            }
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["funcRef"],
                printCode: { arguments, context in
                    let funcRef = arguments[0]
                    return ["\(JSGlueVariableScope.reservedSwift).memory.getObject(\(funcRef))"]
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message:
                    "Namespace enums are not supported to be passed as parameters to imported JS functions: \(string)"
            )
        case .array(let elementType):
            return try arrayLift(elementType: elementType)
        case .dictionary(let valueType):
            return try dictionaryLift(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unhandled type in liftParameter: \(type)")
        }
    }

    /// Returns a fragment that lowers a JS value to Wasm core values for return values
    static func lowerReturn(type: BridgeType, context: BridgeContext = .importTS) throws -> IntrinsicJSFragment {
        switch type {
        case .bool, .rawValueEnum(_, .bool):
            return .boolLowerReturn
        case .int, .uint, .float, .double, .unsafePointer, .caseEnum:
            return .identity
        case .rawValueEnum(_, let rawType) where rawType != .string && rawType != .bool:
            return .identity
        case .string: return .stringLowerReturn
        case .jsObject: return .jsObjectLowerReturn
        case .jsValue: return .jsValueLowerReturn(context: context)
        case .swiftHeapObject: return .swiftHeapObjectLowerReturn
        case .swiftProtocol: return .jsObjectLowerReturn
        case .void: return .void
        case .nullable(let wrappedType, let kind):
            return try .optionalLowerReturn(wrappedType: wrappedType, kind: kind)
        case .rawValueEnum(_, .string): return .stringLowerReturn
        case .associatedValueEnum(let fullName):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message:
                        "Associated value enums are not supported to be returned from imported JS functions: \(fullName)"
                )
            case .exportSwift:
                return associatedValueLowerReturn(fullName: fullName)
            }
        case .swiftStruct(let fullName):
            switch context {
            case .importTS:
                return .jsObjectLowerReturn
            case .exportSwift:
                return swiftStructLowerReturn(fullName: fullName)
            }
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let printer = context.printer
                    let value = arguments[0]
                    printer.write("if (typeof \(value) !== \"function\") {")
                    printer.indent {
                        printer.write("throw new TypeError(\"Expected a function\")")
                    }
                    printer.write("}")
                    return ["\(JSGlueVariableScope.reservedSwift).memory.retain(\(value))"]
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message: "Namespace enums are not supported to be returned from imported JS functions: \(string)"
            )
        case .array(let elementType):
            return try arrayLower(elementType: elementType)
        case .dictionary(let valueType):
            return try dictionaryLower(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unhandled type in lowerReturn: \(type)")
        }
    }

    // MARK: - Enums Payload Fragments

    static func associatedValueLowerReturn(fullName: String) -> IntrinsicJSFragment {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let caseIdVar = scope.variable("caseId")
                printer.write(
                    "const \(caseIdVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                )
                printer.write("return \(caseIdVar);")
                return []
            }
        )
    }
    /// Fragment for generating an entire associated value enum helper
    /// Generates the enum tag constants (e.g. `const XValues = { Tag: { ... } }`)
    /// This is placed at module level for exports/imports.
    static func associatedValueEnumValues(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, context in
                let printer = context.printer
                let enumName = arguments[0]

                printer.write("const \(enumName) = {")
                printer.indent {
                    printer.write("Tag: {")
                    printer.indent {
                        for (index, enumCase) in enumDefinition.cases.enumerated() {
                            let caseName = enumCase.name.capitalizedFirstLetter
                            printer.write("\(caseName): \(index),")
                        }
                    }
                    printer.write("},")
                }
                printer.write("};")

                return []
            }
        )
    }

    /// Generates the enum helper factory function (lower/lift closures).
    /// This is placed inside `createInstantiator` alongside struct helpers,
    /// so it has access to `_exports` for class references.
    static func associatedValueEnumHelperFactory(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let enumName = arguments[0]

                printer.write("const __bjs_create\(enumName)Helpers = () => ({")
                try printer.indent {
                    printer.write("lower: (value) => {")
                    try printer.indent {
                        printer.write("const enumTag = value.tag;")
                        printer.write("switch (enumTag) {")
                        try printer.indent {
                            let lowerPrinter = CodeFragmentPrinter()
                            for enumCase in enumDefinition.cases {
                                let caseName = enumCase.name.capitalizedFirstLetter
                                let caseScope = scope.makeChildScope()
                                let fragment = IntrinsicJSFragment.associatedValuePushPayload(
                                    enumCase: enumCase
                                )
                                _ = try fragment.printCode(
                                    ["value", enumName, caseName],
                                    context.with(\.scope, caseScope).with(\.printer, lowerPrinter)
                                )
                            }

                            for line in lowerPrinter.lines {
                                printer.write(line)
                            }

                            printer.write(
                                "default: throw new Error(\"Unknown \(enumName) tag: \" + String(enumTag));"
                            )
                        }
                        printer.write("}")
                    }
                    printer.write("},")

                    printer.write("lift: (tag) => {")
                    try printer.indent {
                        printer.write("tag = tag | 0;")
                        printer.write("switch (tag) {")
                        try printer.indent {
                            let liftPrinter = CodeFragmentPrinter()
                            for enumCase in enumDefinition.cases {
                                let caseName = enumCase.name.capitalizedFirstLetter
                                let caseScope = scope.makeChildScope()

                                let fragment = IntrinsicJSFragment.associatedValuePopPayload(
                                    enumCase: enumCase
                                )
                                _ = try fragment.printCode(
                                    [enumName, caseName],
                                    context.with(\.scope, caseScope).with(\.printer, liftPrinter)
                                )
                            }

                            for line in liftPrinter.lines {
                                printer.write(line)
                            }

                            printer.write(
                                "default: throw new Error(\"Unknown \(enumName) tag returned from Swift: \" + String(tag));"
                            )
                        }
                        printer.write("}")
                    }
                    printer.write("}")
                }
                printer.write("});")

                return []
            }
        )
    }

    static func caseEnumHelper(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, context in
                let printer = context.printer
                let enumName = arguments[0]
                printer.write("const \(enumName) = {")
                printer.indent {
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let value = enumCase.jsValue(
                            rawType: enumDefinition.rawType,
                            index: index
                        )
                        printer.write("\(caseName): \(value),")
                    }
                }
                printer.write("};")
                printer.nextLine()

                return []
            }
        )
    }

    private static func associatedValuePushPayload(enumCase: EnumCase) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value", "enumName", "caseName"],
            printCode: { arguments, context in
                let printer = context.printer
                let enumName = arguments[1]
                let caseName = arguments[2]

                printer.write("case \(enumName).Tag.\(caseName): {")

                try printer.indent {
                    if enumCase.associatedValues.isEmpty {
                        printer.write("return \(enumName).Tag.\(caseName);")
                    } else {
                        let reversedValues = enumCase.associatedValues.enumerated().reversed()

                        for (associatedValueIndex, associatedValue) in reversedValues {
                            let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                            let fragment = try IntrinsicJSFragment.associatedValuePushPayload(
                                type: associatedValue.type
                            )

                            _ = try fragment.printCode(["value.\(prop)"], context)
                        }

                        printer.write("return \(enumName).Tag.\(caseName);")
                    }
                }

                printer.write("}")

                return []
            }
        )
    }

    private static func associatedValuePopPayload(enumCase: EnumCase) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName", "caseName"],
            printCode: { arguments, context in
                let printer = context.printer
                let enumName = arguments[0]
                let caseName = arguments[1]

                if enumCase.associatedValues.isEmpty {
                    printer.write("case \(enumName).Tag.\(caseName): return { tag: \(enumName).Tag.\(caseName) };")
                } else {
                    var fieldPairs: [String] = []
                    let casePrinter = CodeFragmentPrinter()

                    // Process associated values in reverse order (to match the order they'll be popped)
                    for (associatedValueIndex, associatedValue) in enumCase.associatedValues.enumerated().reversed() {
                        let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                        let fragment = try IntrinsicJSFragment.associatedValuePopPayload(type: associatedValue.type)

                        let result = try fragment.printCode([], context.with(\.printer, casePrinter))
                        let varName = result.first ?? "value_\(associatedValueIndex)"

                        fieldPairs.append("\(prop): \(varName)")
                    }

                    printer.write("case \(enumName).Tag.\(caseName): {")
                    printer.indent {
                        for line in casePrinter.lines {
                            printer.write(line)
                        }
                        printer.write(
                            "return { tag: \(enumName).Tag.\(caseName), \(fieldPairs.reversed().joined(separator: ", ")) };"
                        )
                    }
                    printer.write("}")
                }

                return []
            }
        )
    }

    private static func associatedValuePushPayload(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .nullable(let wrappedType, let kind):
            return try associatedValueOptionalPushPayload(wrappedType: wrappedType, kind: kind)
        default:
            return try stackLowerFragment(elementType: type)
        }
    }

    private static func associatedValueOptionalPushPayload(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) throws -> IntrinsicJSFragment {
        if wrappedType.isSingleParamScalar {
            let wasmType = wrappedType.wasmParams[0].type
            let stackCoerce = wrappedType.stackLowerCoerce
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let isSomeVar = scope.variable("isSome")
                    printer.write("const \(isSomeVar) = \(kind.presenceCheck(value: value));")
                    var coerced: String
                    if let coerce = stackCoerce {
                        coerced = coerce.replacingOccurrences(of: "$0", with: value)
                        if coerced.contains("?") && !coerced.hasPrefix("(") {
                            coerced = "(\(coerced))"
                        }
                    } else {
                        coerced = value
                    }
                    emitPush(
                        for: wasmType,
                        value: "\(isSomeVar) ? \(coerced) : \(wasmType.jsZeroLiteral)",
                        scope: scope,
                        printer: printer
                    )
                    scope.emitPushI32Parameter("\(isSomeVar) ? 1 : 0", printer: printer)
                    return []
                }
            )
        }

        let innerFragment = try stackLowerFragment(elementType: wrappedType)
        return stackOptionalLower(
            wrappedType: wrappedType,
            kind: kind,
            innerFragment: innerFragment
        )
    }

    private static func associatedValuePopPayload(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .nullable(let wrappedType, let kind):
            return associatedValueOptionalPopPayload(wrappedType: wrappedType, kind: kind)
        default:
            return try stackLiftFragment(elementType: type)
        }
    }

    private static func associatedValueOptionalPopPayload(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let optVar = scope.variable("optional")
                let isSomeVar = scope.variable("isSome")

                printer.write("const \(isSomeVar) = \(scope.popI32());")
                printer.write("let \(optVar);")
                printer.write("if (\(isSomeVar)) {")
                try printer.indent {
                    // For optional associated value enums, Swift uses bridgeJSLowerParameter()
                    // which pushes caseId to i32Stack (same as bridgeJSLowerReturn()).
                    if case .associatedValueEnum(let fullName) = wrappedType {
                        let base = fullName.components(separatedBy: ".").last ?? fullName
                        let caseIdVar = scope.variable("caseId")
                        printer.write("const \(caseIdVar) = \(scope.popI32());")
                        printer.write(
                            "\(optVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseIdVar));"
                        )
                    } else {
                        let wrappedFragment = try associatedValuePopPayload(type: wrappedType)
                        let wrappedResults = try wrappedFragment.printCode([], context)
                        if let wrappedResult = wrappedResults.first {
                            printer.write("\(optVar) = \(wrappedResult);")
                        } else {
                            printer.write("\(optVar) = undefined;")
                        }
                    }
                }
                printer.write("} else {")
                printer.indent {
                    printer.write("\(optVar) = \(kind.absenceLiteral);")
                }
                printer.write("}")

                return [optVar]
            }
        )
    }

    private static func swiftStructLower(structBase: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let printer = context.printer
                let value = arguments[0]
                printer.write(
                    "\(JSGlueVariableScope.reservedStructHelpers).\(structBase).lower(\(value));"
                )
                return []
            }
        )
    }

    static func swiftStructLowerReturn(fullName: String) -> IntrinsicJSFragment {
        swiftStructLower(structBase: fullName.components(separatedBy: ".").last ?? fullName)
    }

    static func swiftStructLowerParameter(structBase: String) -> IntrinsicJSFragment {
        swiftStructLower(structBase: structBase)
    }

    static func swiftStructLiftReturn(structBase: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("structValue")
                printer.write(
                    "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(structBase).lift();"
                )
                return [resultVar]
            }
        )
    }

    // MARK: - Array Helpers

    /// Lowers an array from JS to Swift by iterating elements and pushing to stacks
    static func arrayLower(elementType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["arr"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let arr = arguments[0]

                let elemVar = scope.variable("elem")
                printer.write("for (const \(elemVar) of \(arr)) {")
                try printer.indent {
                    let elementFragment = try stackLowerFragment(elementType: elementType)
                    let _ = try elementFragment.printCode(
                        [elemVar],
                        context
                    )
                }
                printer.write("}")
                scope.emitPushI32Parameter("\(arr).length", printer: printer)
                return []
            }
        )
    }

    /// Lowers a dictionary from JS to Swift by iterating entries and pushing to stacks
    static func dictionaryLower(valueType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["dict"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let dict = arguments[0]

                let entriesVar = scope.variable("entries")
                let entryVar = scope.variable("entry")
                printer.write("const \(entriesVar) = Object.entries(\(dict));")
                printer.write("for (const \(entryVar) of \(entriesVar)) {")
                try printer.indent {
                    let keyVar = scope.variable("key")
                    let valueVar = scope.variable("value")
                    printer.write("const [\(keyVar), \(valueVar)] = \(entryVar);")

                    let keyFragment = try stackLowerFragment(elementType: .string)
                    let _ = try keyFragment.printCode(
                        [keyVar],
                        context
                    )

                    let valueFragment = try stackLowerFragment(elementType: valueType)
                    let _ = try valueFragment.printCode(
                        [valueVar],
                        context
                    )
                }
                printer.write("}")
                scope.emitPushI32Parameter("\(entriesVar).length", printer: printer)
                return []
            }
        )
    }

    /// Lifts an array from Swift to JS by popping elements from stacks
    static func arrayLift(elementType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("arrayResult")
                let lenVar = scope.variable("arrayLen")
                let iVar = scope.variable("i")

                printer.write("const \(lenVar) = \(scope.popI32());")
                printer.write("const \(resultVar) = [];")
                printer.write("for (let \(iVar) = 0; \(iVar) < \(lenVar); \(iVar)++) {")
                try printer.indent {
                    let elementFragment = try stackLiftFragment(elementType: elementType)
                    let elementResults = try elementFragment.printCode([], context)
                    if let elementExpr = elementResults.first {
                        printer.write("\(resultVar).push(\(elementExpr));")
                    }
                }
                printer.write("}")
                printer.write("\(resultVar).reverse();")
                return [resultVar]
            }
        )
    }

    /// Lifts a dictionary from Swift to JS by popping key/value pairs from stacks
    static func dictionaryLift(valueType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let resultVar = scope.variable("dictResult")
                let lenVar = scope.variable("dictLen")
                let iVar = scope.variable("i")

                printer.write("const \(lenVar) = \(scope.popI32());")
                printer.write("const \(resultVar) = {};")
                printer.write("for (let \(iVar) = 0; \(iVar) < \(lenVar); \(iVar)++) {")
                try printer.indent {
                    let valueFragment = try stackLiftFragment(elementType: valueType)
                    let valueResults = try valueFragment.printCode([], context)
                    let keyFragment = try stackLiftFragment(elementType: .string)
                    let keyResults = try keyFragment.printCode([], context)
                    if let keyExpr = keyResults.first, let valueExpr = valueResults.first {
                        printer.write("\(resultVar)[\(keyExpr)] = \(valueExpr);")
                    }
                }
                printer.write("}")
                return [resultVar]
            }
        )
    }

    private static func stackLiftFragment(elementType: BridgeType) throws -> IntrinsicJSFragment {
        if case .nullable(let wrappedType, let kind) = elementType {
            return try optionalElementRaiseFragment(wrappedType: wrappedType, kind: kind)
        }
        if elementType.isSingleParamScalar {
            let wasmType = elementType.wasmParams[0].type
            let coerce = elementType.liftCoerce
            let varHint = elementType.varHint
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { _, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let popExpr = popExpression(for: wasmType, scope: scope)
                    let varName = scope.variable(varHint)
                    if let transform = coerce {
                        let inlined = transform.replacingOccurrences(of: "$0", with: popExpr)
                        printer.write("const \(varName) = \(inlined);")
                    } else {
                        printer.write("const \(varName) = \(popExpr);")
                    }
                    return [varName]
                }
            )
        }
        switch elementType {
        case .jsValue:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { _, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let payload2Var = scope.variable("jsValuePayload2")
                    let payload1Var = scope.variable("jsValuePayload1")
                    let kindVar = scope.variable("jsValueKind")
                    printer.write("const \(payload2Var) = \(scope.popF64());")
                    printer.write("const \(payload1Var) = \(scope.popI32());")
                    printer.write("const \(kindVar) = \(scope.popI32());")
                    let resultVar = scope.variable("jsValue")
                    registerJSValueHelpers(scope: scope)
                    printer.write(
                        "const \(resultVar) = \(jsValueLiftHelperName)(\(kindVar), \(payload1Var), \(payload2Var));"
                    )
                    return [resultVar]
                }
            )
        case .string:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let strVar = scope.variable("string")
                    printer.write("const \(strVar) = \(scope.popString());")
                    return [strVar]
                }
            )
        case .rawValueEnum(_, .string):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let varName = scope.variable("rawValue")
                    printer.write("const \(varName) = \(scope.popString());")
                    return [varName]
                }
            )
        case .swiftStruct(let fullName):
            let structBase = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let resultVar = scope.variable("struct")
                    printer.write(
                        "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(structBase).lift();"
                    )
                    return [resultVar]
                }
            )
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let resultVar = scope.variable("enumValue")
                    printer.write(
                        "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(scope.popI32()));"
                    )
                    return [resultVar]
                }
            )
        case .swiftHeapObject(let className):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let ptrVar = scope.variable("ptr")
                    let objVar = scope.variable("obj")
                    printer.write("const \(ptrVar) = \(scope.popPointer());")
                    printer.write("const \(objVar) = _exports['\(className)'].__construct(\(ptrVar));")
                    return [objVar]
                }
            )
        case .jsObject, .swiftProtocol:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let idVar = scope.variable("objId")
                    let objVar = scope.variable("obj")
                    printer.write("const \(idVar) = \(scope.popI32());")
                    printer.write(
                        "const \(objVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(idVar));"
                    )
                    printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                    return [objVar]
                }
            )
        case .array(let innerElementType):
            return try arrayLift(elementType: innerElementType)
        case .dictionary(let valueType):
            return try dictionaryLift(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unsupported array element type: \(elementType)")
        }
    }

    private static func stackLowerFragment(elementType: BridgeType) throws -> IntrinsicJSFragment {
        if case .nullable(let wrappedType, let kind) = elementType {
            return try optionalElementLowerFragment(wrappedType: wrappedType, kind: kind)
        }
        if elementType.isSingleParamScalar {
            let wasmType = elementType.wasmParams[0].type
            let stackCoerce = elementType.stackLowerCoerce
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let pushExpr: String
                    if let coerce = stackCoerce {
                        pushExpr = coerce.replacingOccurrences(of: "$0", with: value)
                    } else {
                        pushExpr = value
                    }
                    emitPush(for: wasmType, value: pushExpr, scope: scope, printer: printer)
                    return []
                }
            )
        }
        switch elementType {
        case .jsValue:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    registerJSValueHelpers(scope: scope)
                    let lowered = try jsValueLower.printCode([arguments[0]], context)
                    let kindVar = lowered[0]
                    let payload1Var = lowered[1]
                    let payload2Var = lowered[2]
                    scope.emitPushI32Parameter(kindVar, printer: printer)
                    scope.emitPushI32Parameter(payload1Var, printer: printer)
                    scope.emitPushF64Parameter(payload2Var, printer: printer)
                    return []
                }
            )
        case .string, .rawValueEnum(_, .string):
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let bytesVar = scope.variable("bytes")
                    let idVar = scope.variable("id")
                    printer.write(
                        "const \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));"
                    )
                    printer.write(
                        "const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));"
                    )
                    scope.emitPushI32Parameter("\(bytesVar).length", printer: printer)
                    scope.emitPushI32Parameter(idVar, printer: printer)
                    return []
                }
            )
        case .swiftStruct(let fullName):
            let structBase = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let printer = context.printer
                    let value = arguments[0]
                    printer.write(
                        "\(JSGlueVariableScope.reservedStructHelpers).\(structBase).lower(\(value));"
                    )
                    return []
                }
            )

        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let caseIdVar = scope.variable("caseId")
                    printer.write(
                        "const \(caseIdVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                    )
                    scope.emitPushI32Parameter(caseIdVar, printer: printer)
                    return []
                }
            )
        case .swiftHeapObject:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    scope.emitPushPointerParameter("\(value).pointer", printer: printer)
                    return []
                }
            )
        case .jsObject, .swiftProtocol:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let idVar = scope.variable("objId")
                    printer.write(
                        "const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));"
                    )
                    scope.emitPushI32Parameter(idVar, printer: printer)
                    return []
                }
            )
        case .array(let innerElementType):
            return try arrayLower(elementType: innerElementType)
        case .dictionary(let valueType):
            return try dictionaryLower(valueType: valueType)
        default:
            throw BridgeJSLinkError(message: "Unsupported array element type for lowering: \(elementType)")
        }
    }

    private static func optionalElementRaiseFragment(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) throws -> IntrinsicJSFragment {
        let absenceLiteral = kind.absenceLiteral
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let isSomeVar = scope.variable("isSome")
                let resultVar = scope.variable("optValue")

                printer.write("const \(isSomeVar) = \(scope.popI32());")
                printer.write("let \(resultVar);")
                printer.write("if (\(isSomeVar) === 0) {")
                printer.indent {
                    printer.write("\(resultVar) = \(absenceLiteral);")
                }
                printer.write("} else {")
                try printer.indent {
                    let innerFragment = try stackLiftFragment(elementType: wrappedType)
                    let innerResults = try innerFragment.printCode([], context)
                    if let innerResult = innerResults.first {
                        printer.write("\(resultVar) = \(innerResult);")
                    } else {
                        printer.write("\(resultVar) = undefined;")
                    }
                }
                printer.write("}")

                return [resultVar]
            }
        )
    }

    private static func optionalElementLowerFragment(
        wrappedType: BridgeType,
        kind: JSOptionalKind
    ) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, context in
                let (scope, printer) = (context.scope, context.printer)
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")

                let presenceExpr = kind.presenceCheck(value: value)
                printer.write("const \(isSomeVar) = \(presenceExpr) ? 1 : 0;")
                printer.write("if (\(isSomeVar)) {")
                try printer.indent {
                    let innerFragment = try stackLowerFragment(elementType: wrappedType)
                    let _ = try innerFragment.printCode(
                        [value],
                        context
                    )
                }
                let placeholderPrinter = CodeFragmentPrinter()
                let hasPlaceholders = emitOptionalPlaceholders(
                    for: wrappedType,
                    scope: scope,
                    printer: placeholderPrinter
                )
                if hasPlaceholders {
                    printer.write("} else {")
                    printer.indent {
                        for line in placeholderPrinter.lines {
                            printer.write(line)
                        }
                    }
                    printer.write("}")
                } else {
                    printer.write("}")
                }
                scope.emitPushI32Parameter(isSomeVar, printer: printer)

                return []
            }
        )
    }

    // MARK: - Struct Helpers

    static func structHelper(structDefinition: ExportedStruct, allStructs: [ExportedStruct]) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["structName"],
            printCode: { arguments, context in
                let printer = context.printer
                let structName = arguments[0]
                let capturedStructDef = structDefinition
                let capturedAllStructs = allStructs

                printer.write("const __bjs_create\(structName)Helpers = () => ({")
                try printer.indent {
                    printer.write("lower: (value) => {")
                    try printer.indent {
                        try generateStructLowerCode(
                            structDef: capturedStructDef,
                            allStructs: capturedAllStructs,
                            context: context
                        )
                    }
                    printer.write("},")

                    printer.write("lift: () => {")
                    try printer.indent {
                        try generateStructLiftCode(
                            structDef: capturedStructDef,
                            allStructs: capturedAllStructs,
                            context: context,
                            attachMethods: true
                        )
                    }
                    printer.write("}")
                }
                printer.write("});")

                return []
            }
        )
    }

    private static func generateStructLowerCode(
        structDef: ExportedStruct,
        allStructs: [ExportedStruct],
        context: IntrinsicJSFragment.PrintCodeContext
    ) throws {
        let (scope, printer) = (context.scope, context.printer)
        let lowerPrinter = CodeFragmentPrinter()
        let lowerScope = scope.makeChildScope()

        let instanceProps = structDef.properties.filter { !$0.isStatic }
        for property in instanceProps {
            let fragment = try structFieldLowerFragment(
                type: property.type,
                fieldName: property.name,
                allStructs: allStructs
            )
            let fieldValue = "value.\(property.name)"
            _ = try fragment.printCode(
                [fieldValue],
                context.with(\.scope, lowerScope).with(\.printer, lowerPrinter)
            )
        }

        for line in lowerPrinter.lines {
            printer.write(line)
        }
    }

    private static func generateStructLiftCode(
        structDef: ExportedStruct,
        allStructs: [ExportedStruct],
        context: IntrinsicJSFragment.PrintCodeContext,
        attachMethods: Bool = false
    ) throws {
        let printer = context.printer
        let liftScope = context.scope.makeChildScope()

        var fieldExpressions: [(name: String, expression: String)] = []

        let instanceProps = structDef.properties.filter { !$0.isStatic }
        for property in instanceProps.reversed() {
            let fragment = try structFieldLiftFragment(field: property, allStructs: allStructs)
            let results = try fragment.printCode([], context)

            if let resultExpr = results.first {
                fieldExpressions.append((property.name, resultExpr))
            } else {
                fieldExpressions.append((property.name, "undefined"))
            }
        }

        // Construct struct object with fields in original order
        let reconstructedFields = instanceProps.map { property in
            let expr = fieldExpressions.first(where: { $0.name == property.name })?.expression ?? "undefined"
            return "\(property.name): \(expr)"
        }

        if attachMethods && !structDef.methods.filter({ !$0.effects.isStatic }).isEmpty {
            let instanceVar = liftScope.variable("instance")
            printer.write("const \(instanceVar) = { \(reconstructedFields.joined(separator: ", ")) };")

            // Attach instance methods to the struct instance
            for method in structDef.methods where !method.effects.isStatic {
                let paramList = DefaultValueUtils.formatParameterList(method.parameters)
                printer.write(
                    "\(instanceVar).\(method.name) = function(\(paramList)) {"
                )
                try printer.indent {
                    printer.write(
                        "\(JSGlueVariableScope.reservedStructHelpers).\(structDef.name).lower(this);"
                    )

                    var paramForwardings: [String] = []
                    for param in method.parameters {
                        let fragment = try IntrinsicJSFragment.lowerParameter(type: param.type)
                        let loweredValues = try fragment.printCode([param.name], context)
                        paramForwardings.append(contentsOf: loweredValues)
                    }

                    let callExpr = "instance.exports.\(method.abiName)(\(paramForwardings.joined(separator: ", ")))"
                    if method.returnType == .void {
                        printer.write("\(callExpr);")
                    } else {
                        printer.write("const ret = \(callExpr);")
                    }

                    // Lift return value if needed
                    if method.returnType != .void {
                        let liftFragment = try IntrinsicJSFragment.liftReturn(type: method.returnType)
                        let liftArgs = liftFragment.parameters.isEmpty ? [] : ["ret"]
                        let lifted = try liftFragment.printCode(liftArgs, context)
                        if let liftedValue = lifted.first {
                            printer.write("return \(liftedValue);")
                        }
                    }
                }
                printer.write("}.bind(\(instanceVar));")
            }

            printer.write("return \(instanceVar);")
        } else {
            printer.write("return { \(reconstructedFields.joined(separator: ", ")) };")
        }
    }

    private static func structFieldLowerFragment(
        type: BridgeType,
        fieldName: String,
        allStructs: [ExportedStruct]
    ) throws -> IntrinsicJSFragment {
        switch type {
        case .jsValue:
            preconditionFailure("Struct field of JSValue is not supported yet")
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let value = arguments[0]
                    let idVar = scope.variable("id")
                    printer.write("let \(idVar);")
                    printer.write("if (\(value) != null) {")
                    printer.indent {
                        printer.write(
                            "\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));"
                        )
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(idVar) = undefined;")
                    }
                    printer.write("}")
                    scope.emitPushI32Parameter("\(idVar) !== undefined ? \(idVar) : 0", printer: printer)
                    return [idVar]
                }
            )
        case .nullable(let wrappedType, let kind):
            if wrappedType.isSingleParamScalar {
                let wasmType = wrappedType.wasmParams[0].type
                let stackCoerce = wrappedType.stackLowerCoerce
                return IntrinsicJSFragment(
                    parameters: ["value"],
                    printCode: { arguments, context in
                        let (scope, printer) = (context.scope, context.printer)
                        let value = arguments[0]
                        let isSomeVar = scope.variable("isSome")
                        printer.write("const \(isSomeVar) = \(kind.presenceCheck(value: value));")
                        let coerced: String
                        if let coerce = stackCoerce {
                            coerced = coerce.replacingOccurrences(of: "$0", with: value)
                        } else {
                            coerced = value
                        }
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            emitPush(for: wasmType, value: coerced, scope: scope, printer: printer)
                        }
                        printer.write("} else {")
                        printer.indent {
                            emitPush(for: wasmType, value: wasmType.jsZeroLiteral, scope: scope, printer: printer)
                        }
                        printer.write("}")
                        scope.emitPushI32Parameter("\(isSomeVar) ? 1 : 0", printer: printer)
                        return []
                    }
                )
            }

            let innerFragment = try structFieldLowerFragment(
                type: wrappedType,
                fieldName: fieldName,
                allStructs: allStructs
            )
            return stackOptionalLower(
                wrappedType: wrappedType,
                kind: kind,
                innerFragment: innerFragment
            )
        case .swiftStruct(let nestedName):
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    let printer = context.printer
                    let value = arguments[0]
                    printer.write(
                        "\(JSGlueVariableScope.reservedStructHelpers).\(nestedName).lower(\(value));"
                    )
                    return []
                }
            )
        case .void, .swiftProtocol, .namespaceEnum, .closure:
            // These types should not appear as struct fields - return error fragment
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, context in
                    context.printer.write(
                        "throw new Error(\"Unsupported struct field type for lowering: \(type)\");"
                    )
                    return []
                }
            )
        default:
            return try stackLowerFragment(elementType: type)
        }
    }

    /// Helper to push optional primitive values to stack-based parameters
    private static func structFieldLiftFragment(
        field: ExportedProperty,
        allStructs: [ExportedStruct]
    ) throws -> IntrinsicJSFragment {
        switch field.type {
        case .jsValue:
            preconditionFailure("Struct field of JSValue is not supported yet")
        case .nullable(let wrappedType, let kind):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let isSomeVar = scope.variable("isSome")
                    let optVar = scope.variable("optional")
                    printer.write("const \(isSomeVar) = \(scope.popI32());")
                    printer.write("let \(optVar);")
                    printer.write("if (\(isSomeVar)) {")
                    try printer.indent {
                        // Special handling for associated value enum - in struct fields, case ID is pushed to i32Stack
                        if case .associatedValueEnum(let enumName) = wrappedType {
                            let base = enumName.components(separatedBy: ".").last ?? enumName
                            let caseIdVar = scope.variable("enumCaseId")
                            printer.write("const \(caseIdVar) = \(scope.popI32());")
                            printer.write(
                                "\(optVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseIdVar));"
                            )
                        } else {
                            let wrappedFragment = try structFieldLiftFragment(
                                field: ExportedProperty(
                                    name: field.name,
                                    type: wrappedType,
                                    isReadonly: true,
                                    isStatic: false
                                ),
                                allStructs: allStructs
                            )
                            let wrappedResults = try wrappedFragment.printCode([], context)
                            if let wrappedResult = wrappedResults.first {
                                printer.write("\(optVar) = \(wrappedResult);")
                            } else {
                                printer.write("\(optVar) = undefined;")
                            }
                        }
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(optVar) = \(kind.absenceLiteral);")
                    }
                    printer.write("}")
                    return [optVar]
                }
            )
        case .swiftStruct(let nestedName):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let structVar = scope.variable("struct")
                    printer.write(
                        "const \(structVar) = \(JSGlueVariableScope.reservedStructHelpers).\(nestedName).lift();"
                    )
                    return [structVar]
                }
            )
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    let (scope, printer) = (context.scope, context.printer)
                    let objectIdVar = scope.variable("objectId")
                    let varName = scope.variable("value")
                    printer.write("const \(objectIdVar) = \(scope.popI32());")
                    printer.write("let \(varName);")
                    printer.write("if (\(objectIdVar) !== 0) {")
                    printer.indent {
                        printer.write(
                            "\(varName) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectIdVar));"
                        )
                        printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectIdVar));")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(varName) = null;")
                    }
                    printer.write("}")
                    return [varName]
                }
            )
        case .void, .swiftProtocol, .namespaceEnum, .closure:
            // These types should not appear as struct fields
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, context in
                    context.printer.write("throw new Error(\"Unsupported struct field type: \(field.type)\");")
                    return []
                }
            )
        default:
            return try stackLiftFragment(elementType: field.type)
        }
    }
}

// MARK: - Local type helpers

fileprivate extension WasmCoreType {
    var jsZeroLiteral: String {
        switch self {
        case .f32, .f64: return "0.0"
        case .i32, .i64, .pointer: return "0"
        }
    }
}

private enum OptionalConvention: Equatable {
    case stackABI
    case inlineFlag
    case sideChannelReturn(OptionalSideChannel)
}

private enum OptionalSideChannel: Equatable {
    case none
    case storage
    case retainedObject
}

private enum NilSentinel: Equatable {
    case none
    case i32(Int32)
    case pointer

    var jsLiteral: String {
        switch self {
        case .none: fatalError("No sentinel value for .none")
        case .i32(let value): return "\(value)"
        case .pointer: return "0"
        }
    }

    var hasSentinel: Bool {
        self != .none
    }
}

private enum OptionalScalarKind: String {
    case bool, int, float, double

    var storageName: String { "tmpRetOptional\(rawValue.prefix(1).uppercased())\(rawValue.dropFirst())" }
    var funcName: String { "swift_js_return_optional_\(rawValue)" }
}

private extension BridgeType {
    var optionalConvention: OptionalConvention {
        switch self {
        case .bool:
            return .inlineFlag
        case .int, .uint:
            return .sideChannelReturn(.none)
        case .float:
            return .sideChannelReturn(.none)
        case .double:
            return .sideChannelReturn(.none)
        case .string:
            return .sideChannelReturn(.storage)
        case .jsObject:
            return .sideChannelReturn(.retainedObject)
        case .jsValue:
            return .inlineFlag
        case .swiftHeapObject:
            return .inlineFlag
        case .unsafePointer:
            return .inlineFlag
        case .swiftProtocol:
            return .sideChannelReturn(.retainedObject)
        case .caseEnum:
            return .inlineFlag
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return .sideChannelReturn(.storage)
            case .float, .double:
                return .sideChannelReturn(.none)
            case .bool:
                return .inlineFlag
            case .int, .int32, .int64, .uint, .uint32, .uint64:
                return .sideChannelReturn(.none)
            }
        case .associatedValueEnum:
            return .inlineFlag
        case .closure:
            return .inlineFlag
        case .swiftStruct, .array, .dictionary, .void, .namespaceEnum:
            return .stackABI
        case .nullable(let wrapped, _):
            return wrapped.optionalConvention
        }
    }

    var nilSentinel: NilSentinel {
        switch self {
        case .jsObject, .swiftProtocol:
            return .i32(0)
        case .swiftHeapObject:
            return .pointer
        case .caseEnum, .associatedValueEnum:
            return .i32(-1)
        case .nullable(let wrapped, _):
            return wrapped.nilSentinel
        default:
            return .none
        }
    }

    var optionalScalarKind: OptionalScalarKind? {
        switch self {
        case .bool, .rawValueEnum(_, .bool): return .bool
        case .int, .uint, .caseEnum,
            .rawValueEnum(_, .int), .rawValueEnum(_, .int32), .rawValueEnum(_, .int64),
            .rawValueEnum(_, .uint), .rawValueEnum(_, .uint32), .rawValueEnum(_, .uint64):
            return .int
        case .float, .rawValueEnum(_, .float): return .float
        case .double, .rawValueEnum(_, .double): return .double
        case .nullable(let wrapped, _): return wrapped.optionalScalarKind
        default: return nil
        }
    }

    var wasmParams: [(name: String, type: WasmCoreType)] {
        switch self {
        case .bool, .int, .uint:
            return [("value", .i32)]
        case .float:
            return [("value", .f32)]
        case .double:
            return [("value", .f64)]
        case .string:
            return [("bytes", .i32), ("length", .i32)]
        case .jsObject:
            return [("value", .i32)]
        case .jsValue:
            return [("kind", .i32), ("payload1", .i32), ("payload2", .f64)]
        case .swiftHeapObject:
            return [("pointer", .pointer)]
        case .unsafePointer:
            return [("pointer", .pointer)]
        case .swiftProtocol:
            return [("value", .i32)]
        case .caseEnum:
            return [("value", .i32)]
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return [("bytes", .i32), ("length", .i32)]
            case .float:
                return [("value", .f32)]
            case .double:
                return [("value", .f64)]
            case .bool, .int, .int32, .int64, .uint, .uint32, .uint64:
                return [("value", .i32)]
            }
        case .associatedValueEnum:
            return [("caseId", .i32)]
        case .closure:
            return [("funcRef", .i32)]
        case .void, .namespaceEnum, .swiftStruct, .array, .dictionary:
            return []
        case .nullable(let wrapped, _):
            return wrapped.wasmParams
        }
    }

    var isSingleParamScalar: Bool {
        switch self {
        case .bool, .int, .uint, .float, .double, .unsafePointer, .caseEnum: return true
        case .rawValueEnum(_, let rawType): return rawType != .string
        default: return false
        }
    }

    var stackLowerCoerce: String? {
        switch self {
        case .bool, .rawValueEnum(_, .bool): return "$0 ? 1 : 0"
        case .int, .uint, .unsafePointer, .caseEnum,
            .rawValueEnum(_, .int), .rawValueEnum(_, .int32), .rawValueEnum(_, .int64),
            .rawValueEnum(_, .uint), .rawValueEnum(_, .uint32), .rawValueEnum(_, .uint64):
            return "($0 | 0)"
        case .float, .rawValueEnum(_, .float): return "Math.fround($0)"
        case .double, .rawValueEnum(_, .double): return nil
        default: return nil
        }
    }

    var liftCoerce: String? {
        switch self {
        case .bool, .rawValueEnum(_, .bool): return "$0 !== 0"
        case .uint: return "$0 >>> 0"
        default: return nil
        }
    }

    var lowerCoerce: String? {
        switch self {
        case .bool, .rawValueEnum(_, .bool): return "$0 ? 1 : 0"
        default: return nil
        }
    }

    var varHint: String {
        switch self {
        case .bool: return "bool"
        case .int, .uint: return "int"
        case .float: return "f32"
        case .double: return "f64"
        case .unsafePointer: return "pointer"
        case .caseEnum: return "caseId"
        case .rawValueEnum: return "rawValue"
        default: return "value"
        }
    }
}
