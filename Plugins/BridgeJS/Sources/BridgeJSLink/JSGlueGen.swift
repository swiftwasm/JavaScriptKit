#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
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
    static let reservedTmpRetTag = "tmpRetTag"
    static let reservedTmpRetStrings = "tmpRetStrings"
    static let reservedTmpRetInts = "tmpRetInts"
    static let reservedTmpRetF32s = "tmpRetF32s"
    static let reservedTmpRetF64s = "tmpRetF64s"
    static let reservedTmpParamInts = "tmpParamInts"
    static let reservedTmpParamF32s = "tmpParamF32s"
    static let reservedTmpParamF64s = "tmpParamF64s"
    static let reservedTmpRetPointers = "tmpRetPointers"
    static let reservedTmpParamPointers = "tmpParamPointers"
    static let reservedTmpStructCleanups = "tmpStructCleanups"
    static let reservedEnumHelpers = "enumHelpers"
    static let reservedStructHelpers = "structHelpers"

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
        reservedTmpRetTag,
        reservedTmpRetStrings,
        reservedTmpRetInts,
        reservedTmpRetF32s,
        reservedTmpRetF64s,
        reservedTmpParamInts,
        reservedTmpParamF32s,
        reservedTmpParamF64s,
        reservedTmpRetPointers,
        reservedTmpParamPointers,
        reservedTmpStructCleanups,
        reservedEnumHelpers,
        reservedStructHelpers,
    ]

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
}

/// A fragment of JS code used to convert a value between Swift and JS.
///
/// See `BridgeJSIntrinsics.swift` in the main JavaScriptKit module for Swift side lowering/lifting implementation.
struct IntrinsicJSFragment: Sendable {
    /// The names of the parameters that the fragment expects.
    let parameters: [String]

    /// Prints the fragment code.
    ///
    /// - Parameters:
    ///   - arguments: The arguments that the fragment expects. An argument may be an expression with side effects,
    ///     so the callee is responsible for evaluating the arguments only once.
    ///   - scope: The scope of the variables.
    ///   - printer: The printer to print the main fragment code.
    ///   - cleanupCode: The printer to print the code that is expected to be executed at the end of the caller of the
    ///     fragment.
    /// - Returns: List of result expressions.
    let printCode:
        @Sendable (
            _ arguments: [String],
            _ scope: JSGlueVariableScope,
            _ printer: CodeFragmentPrinter,
            _ cleanupCode: CodeFragmentPrinter
        ) -> [String]

    /// A fragment that does nothing
    static let void = IntrinsicJSFragment(
        parameters: [],
        printCode: { _, _, _, _ in
            return []
        }
    )

    /// A fragment that returns the argument as is.
    static let identity = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return [arguments[0]]
        }
    )

    /// NOTE: JavaScript engine itself converts booleans to integers when passing them to
    /// Wasm functions, so we don't need to do anything here
    static let boolLowerParameter = identity
    static let boolLiftReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(arguments[0]) !== 0"]
        }
    )
    static let boolLiftParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(arguments[0]) !== 0"]
        }
    )
    static let boolLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(arguments[0]) ? 1 : 0"]
        }
    )

    static let stringLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            let argument = arguments[0]
            let bytesLabel = scope.variable("\(argument)Bytes")
            let bytesIdLabel = scope.variable("\(argument)Id")
            printer.write("const \(bytesLabel) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(argument));")
            printer.write("const \(bytesIdLabel) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesLabel));")
            cleanupCode.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(bytesIdLabel));")
            return [bytesIdLabel, "\(bytesLabel).length"]
        }
    )
    static let stringLiftReturn = IntrinsicJSFragment(
        parameters: [],
        printCode: { arguments, scope, printer, cleanupCode in
            let resultLabel = scope.variable("ret")
            printer.write("const \(resultLabel) = \(JSGlueVariableScope.reservedStorageToReturnString);")
            printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
            return [resultLabel]
        }
    )
    static let stringLiftParameter = IntrinsicJSFragment(
        parameters: ["objectId"],
        printCode: { arguments, scope, printer, cleanupCode in
            let objectId = arguments[0]
            let objectLabel = scope.variable("\(objectId)Object")
            // TODO: Implement "take" operation
            printer.write("const \(objectLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectId));")
            printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectId));")
            return [objectLabel]
        }
    )
    static let stringLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            printer.write(
                "\(JSGlueVariableScope.reservedStorageToReturnBytes) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(arguments[0]));"
            )
            return ["\(JSGlueVariableScope.reservedStorageToReturnBytes).length"]
        }
    )

    static let jsObjectLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["swift.memory.retain(\(arguments[0]))"]
        }
    )
    static let jsObjectLiftReturn = IntrinsicJSFragment(
        parameters: ["retId"],
        printCode: { arguments, scope, printer, cleanupCode in
            // TODO: Implement "take" operation
            let resultLabel = scope.variable("ret")
            let retId = arguments[0]
            printer.write("const \(resultLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(retId));")
            printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(retId));")
            return [resultLabel]
        }
    )
    static let jsObjectLiftRetainedObjectId = IntrinsicJSFragment(
        parameters: ["objectId"],
        printCode: { arguments, scope, printer, cleanupCode in
            let resultLabel = scope.variable("value")
            let objectId = arguments[0]
            printer.write(
                "const \(resultLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectId));"
            )
            printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectId));")
            return [resultLabel]
        }
    )
    static let jsObjectLiftParameter = IntrinsicJSFragment(
        parameters: ["objectId"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(JSGlueVariableScope.reservedSwift).memory.getObject(\(arguments[0]))"]
        }
    )
    static let jsObjectLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(JSGlueVariableScope.reservedSwift).memory.retain(\(arguments[0]))"]
        }
    )

    static let swiftHeapObjectLowerParameter = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(arguments[0]).pointer"]
        }
    )
    static func swiftHeapObjectLiftReturn(_ name: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                return ["\(name).__construct(\(arguments[0]))"]
            }
        )
    }
    static func swiftHeapObjectLiftParameter(_ name: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["pointer"],
            printCode: { arguments, scope, printer, cleanupCode in
                return ["\(name).__construct(\(arguments[0]))"]
            }
        )
    }
    static let swiftHeapObjectLowerReturn = IntrinsicJSFragment(
        parameters: ["value"],
        printCode: { arguments, scope, printer, cleanupCode in
            return ["\(arguments[0]).pointer"]
        }
    )

    static func associatedEnumLowerParameter(enumBase: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanup in
                let value = arguments[0]
                let caseIdName = "\(value)CaseId"
                let cleanupName = "\(value)Cleanup"
                printer.write(
                    "const { caseId: \(caseIdName), cleanup: \(cleanupName) } = \(JSGlueVariableScope.reservedEnumHelpers).\(enumBase).lower(\(value));"
                )
                cleanup.write("if (\(cleanupName)) { \(cleanupName)(); }")
                return [caseIdName]
            }
        )
    }

    static func associatedEnumLiftReturn(enumBase: String) -> IntrinsicJSFragment {
        IntrinsicJSFragment(
            parameters: [],
            printCode: { _, scope, printer, _ in
                let retName = scope.variable("ret")
                printer.write(
                    "const \(retName) = \(JSGlueVariableScope.reservedEnumHelpers).\(enumBase).lift(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                )
                return [retName]
            }
        )
    }

    static func optionalLiftParameter(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["isSome", "wrappedValue"],
            printCode: { arguments, scope, printer, cleanupCode in
                let isSome = arguments[0]
                let wrappedValue = arguments[1]
                let resultExpr: String

                switch wrappedType {
                case .int, .float, .double, .caseEnum:
                    resultExpr = "\(isSome) ? \(wrappedValue) : null"
                case .bool:
                    resultExpr = "\(isSome) ? \(wrappedValue) !== 0 : null"
                case .string:
                    let objectLabel = scope.variable("obj")
                    printer.write("let \(objectLabel);")
                    printer.write("if (\(isSome)) {")
                    printer.indent {
                        printer.write(
                            "\(objectLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(wrappedValue));"
                        )
                        printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(wrappedValue));")
                    }
                    printer.write("}")
                    resultExpr = "\(isSome) ? \(objectLabel) : null"
                case .swiftHeapObject(let name):
                    resultExpr = "\(isSome) ? \(name).__construct(\(wrappedValue)) : null"
                case .jsObject:
                    resultExpr =
                        "\(isSome) ? \(JSGlueVariableScope.reservedSwift).memory.getObject(\(wrappedValue)) : null"
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .string:
                        let objectLabel = scope.variable("obj")
                        printer.write("let \(objectLabel);")
                        printer.write("if (\(isSome)) {")
                        printer.indent {
                            printer.write(
                                "\(objectLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(wrappedValue));"
                            )
                            printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(wrappedValue));")
                        }
                        printer.write("}")
                        resultExpr = "\(isSome) ? \(objectLabel) : null"
                    case .bool:
                        resultExpr = "\(isSome) ? \(wrappedValue) !== 0 : null"
                    default:
                        resultExpr = "\(isSome) ? \(wrappedValue) : null"
                    }
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let enumVar = scope.variable("enumValue")
                    printer.write("let \(enumVar);")
                    printer.write("if (\(isSome)) {")
                    printer.indent {
                        printer.write(
                            "\(enumVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(wrappedValue), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                        )
                    }
                    printer.write("}")
                    resultExpr = "\(isSome) ? \(enumVar) : null"
                case .swiftStruct(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let structVar = scope.variable("structValue")
                    printer.write("let \(structVar);")
                    printer.write("if (\(isSome)) {")
                    printer.indent {
                        printer.write(
                            "\(structVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers));"
                        )
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(structVar) = null;")
                    }
                    printer.write("}")
                    resultExpr = structVar
                default:
                    resultExpr = "\(isSome) ? \(wrappedValue) : null"
                }

                return [resultExpr]
            }
        )
    }

    static func optionalLowerParameter(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                printer.write("const \(isSomeVar) = \(value) != null;")

                switch wrappedType {
                case .swiftStruct(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let cleanupVar = scope.variable("\(value)Cleanup")
                    printer.write("let \(cleanupVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        let resultVar = scope.variable("structResult")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lower(\(value));"
                        )
                        printer.write("\(cleanupVar) = \(resultVar).cleanup;")
                    }
                    printer.write("}")
                    cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                    return ["+\(isSomeVar)"]
                case .string, .rawValueEnum(_, .string):
                    let bytesVar = scope.variable("\(value)Bytes")
                    let idVar = scope.variable("\(value)Id")

                    printer.write("let \(idVar), \(bytesVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write("\(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));")
                        printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
                    }
                    printer.write("}")
                    cleanupCode.write("if (\(idVar) != undefined) {")
                    cleanupCode.indent {
                        cleanupCode.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                    }
                    cleanupCode.write("}")

                    return ["+\(isSomeVar)", "\(isSomeVar) ? \(idVar) : 0", "\(isSomeVar) ? \(bytesVar).length : 0"]
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let caseIdVar = scope.variable("\(value)CaseId")
                    let cleanupVar = scope.variable("\(value)Cleanup")

                    printer.write("let \(caseIdVar), \(cleanupVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        let resultVar = scope.variable("enumResult")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                        )
                        printer.write("\(caseIdVar) = \(resultVar).caseId;")
                        printer.write("\(cleanupVar) = \(resultVar).cleanup;")
                    }
                    printer.write("}")
                    cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")

                    return ["+\(isSomeVar)", "\(isSomeVar) ? \(caseIdVar) : 0"]
                case .rawValueEnum:
                    // Raw value enums with optional - falls through to handle based on raw type
                    return ["+\(isSomeVar)", "\(isSomeVar) ? \(value) : 0"]
                default:
                    switch wrappedType {
                    case .swiftHeapObject:
                        return ["+\(isSomeVar)", "\(isSomeVar) ? \(value).pointer : 0"]
                    case .swiftProtocol:
                        return [
                            "+\(isSomeVar)",
                            "\(isSomeVar) ? \(JSGlueVariableScope.reservedSwift).memory.retain(\(value)) : 0",
                        ]
                    case .jsObject:
                        let idVar = scope.variable("id")
                        printer.write("let \(idVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));")
                        }
                        printer.write("}")
                        cleanupCode.write("if (\(idVar) !== undefined) {")
                        cleanupCode.indent {
                            cleanupCode.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                        }
                        cleanupCode.write("}")
                        return ["+\(isSomeVar)", "\(isSomeVar) ? \(idVar) : 0"]
                    default:
                        return ["+\(isSomeVar)", "\(isSomeVar) ? \(value) : 0"]
                    }
                }
            }
        )
    }

    static func optionalLiftReturn(
        wrappedType: BridgeType,
        context: BridgeContext = .exportSwift
    ) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, scope, printer, cleanupCode in
                let resultVar = scope.variable("optResult")
                switch wrappedType {
                case .bool:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalBool);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = undefined;")
                case .int:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalInt);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = undefined;")
                case .float:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalFloat);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = undefined;")
                case .double:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalDouble);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = undefined;")
                case .string:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnString);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
                case .jsObject, .swiftProtocol:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnString);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
                case .swiftHeapObject(let className):
                    let pointerVar = scope.variable("pointer")
                    printer.write(
                        "const \(pointerVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject);"
                    )
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject) = undefined;")
                    let constructExpr =
                        context == .exportSwift
                        ? "\(className).__construct(\(pointerVar))"
                        : "_exports['\(className)'].__construct(\(pointerVar))"
                    printer.write(
                        "const \(resultVar) = \(pointerVar) === null ? null : \(constructExpr);"
                    )
                case .caseEnum:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalInt);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = undefined;")
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .string:
                        printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnString);")
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
                    case .bool:
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalBool);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = undefined;")
                    case .float:
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalFloat);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = undefined;")
                    case .double:
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalDouble);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = undefined;")
                    default:
                        printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnOptionalInt);")
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = undefined;")
                    }
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let isNullVar = scope.variable("isNull")
                    printer.write("const \(isNullVar) = (\(JSGlueVariableScope.reservedTmpRetTag) === -1);")
                    printer.write("let \(resultVar);")
                    printer.write("if (\(isNullVar)) {")
                    printer.indent {
                        printer.write("\(resultVar) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write(
                            "\(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                        )
                    }
                    printer.write("}")
                case .swiftStruct(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let isSomeVar = scope.variable("isSome")
                    printer.write("const \(isSomeVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    printer.write("let \(resultVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write(
                            "\(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers));"
                        )
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(resultVar) = null;")
                    }
                    printer.write("}")
                default:
                    printer.write("const \(resultVar) = \(JSGlueVariableScope.reservedStorageToReturnString);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
                }
                return [resultVar]
            }
        )
    }

    static func optionalLowerReturn(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        switch wrappedType {
        case .void, .optional, .namespaceEnum, .closure:
            throw BridgeJSLinkError(message: "Unsupported optional wrapped type for protocol export: \(wrappedType)")
        default: break
        }

        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]
                let isSomeVar = scope.variable("isSome")
                printer.write("const \(isSomeVar) = \(value) != null;")

                switch wrappedType {
                case .bool:
                    printer.write(
                        "bjs[\"swift_js_return_optional_bool\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? (\(value) ? 1 : 0) : 0);"
                    )
                case .int:
                    printer.write(
                        "bjs[\"swift_js_return_optional_int\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? (\(value) | 0) : 0);"
                    )
                case .caseEnum:
                    printer.write("return \(isSomeVar) ? (\(value) | 0) : -1;")
                case .float:
                    printer.write(
                        "bjs[\"swift_js_return_optional_float\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? Math.fround(\(value)) : 0.0);"
                    )
                case .double:
                    printer.write(
                        "bjs[\"swift_js_return_optional_double\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? \(value) : 0.0);"
                    )
                case .string:
                    let bytesVar = scope.variable("bytes")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write(
                            "const \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));"
                        )
                        printer.write("bjs[\"swift_js_return_optional_string\"](1, \(bytesVar), \(bytesVar).length);")
                        printer.write("return \(bytesVar).length;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("bjs[\"swift_js_return_optional_string\"](0, 0, 0);")
                        printer.write("return -1;")
                    }
                    printer.write("}")
                case .jsObject, .swiftProtocol:
                    let idVar = scope.variable("id")
                    printer.write("let \(idVar) = 0;")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));")
                    }
                    printer.write("}")
                    printer.write("bjs[\"swift_js_return_optional_object\"](\(isSomeVar) ? 1 : 0, \(idVar));")
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .string:
                        let bytesVar = scope.variable("bytes")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            printer.write(
                                "const \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));"
                            )
                            printer.write(
                                "bjs[\"swift_js_return_optional_string\"](1, \(bytesVar), \(bytesVar).length);"
                            )
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("bjs[\"swift_js_return_optional_string\"](0, 0, 0);")
                        }
                        printer.write("}")
                    default:
                        switch rawType {
                        case .bool:
                            printer.write(
                                "bjs[\"swift_js_return_optional_bool\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? (\(value) ? 1 : 0) : 0);"
                            )
                        case .float:
                            printer.write(
                                "bjs[\"swift_js_return_optional_float\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? Math.fround(\(value)) : 0.0);"
                            )
                        case .double:
                            printer.write(
                                "bjs[\"swift_js_return_optional_double\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? \(value) : 0.0);"
                            )
                        default:
                            printer.write(
                                "bjs[\"swift_js_return_optional_int\"](\(isSomeVar) ? 1 : 0, \(isSomeVar) ? (\(value) | 0) : 0);"
                            )
                        }
                    }
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let caseIdVar = scope.variable("caseId")
                    let cleanupVar = scope.variable("cleanup")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        printer.write(
                            "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                        )
                        printer.write("return \(caseIdVar);")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("return -1;")
                    }
                    printer.write("}")
                    cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                default:
                    ()
                }

                return []
            }
        )
    }

    // MARK: - Protocol Support

    static func protocolPropertyOptionalToSideChannel(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        switch wrappedType {
        case .string, .int, .float, .double, .jsObject, .swiftProtocol:
            break
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string, .int, .float, .double:
                break
            default:
                throw BridgeJSLinkError(
                    message: "Unsupported raw value enum type for protocol property side channel: \(rawType)"
                )
            }
        default:
            throw BridgeJSLinkError(
                message: "Type \(wrappedType) does not use side channel for protocol property returns"
            )
        }

        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]

                switch wrappedType {
                case .string, .rawValueEnum(_, .string):
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = \(value);")
                case .int, .rawValueEnum(_, .int):
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = \(value);")
                case .float, .rawValueEnum(_, .float):
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = \(value);")
                case .double, .rawValueEnum(_, .double):
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = \(value);")
                case .jsObject, .swiftProtocol:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = \(value);")
                default:
                    fatalError("Unsupported type in protocolPropertyOptionalToSideChannel: \(wrappedType)")
                }

                return []
            }
        )
    }

    // MARK: - Closure Support

    /// Lifts a WASM parameter to JS for passing to a JS callback (invoke_js_callback_*)
    static func closureLiftParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double, .caseEnum:
            return IntrinsicJSFragment(
                parameters: ["value", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("let \(arguments[1]) = \(arguments[0]);")
                    return []
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: ["value", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = boolLiftParameter
                    let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("let \(arguments[1]) = \(lifted[0]);")
                    return []
                }
            )
        case .string:
            return IntrinsicJSFragment(
                parameters: ["objectId", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = stringLiftParameter
                    let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("let \(arguments[1]) = String(\(lifted[0]));")
                    return []
                }
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return IntrinsicJSFragment(
                    parameters: ["objectId", "targetVar"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let baseFragment = stringLiftParameter
                        let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                        printer.write("let \(arguments[1]) = String(\(lifted[0]));")
                        return []
                    }
                )
            case .bool:
                return IntrinsicJSFragment(
                    parameters: ["value", "targetVar"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let baseFragment = boolLiftParameter
                        let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                        printer.write("let \(arguments[1]) = \(lifted[0]);")
                        return []
                    }
                )
            default:
                return IntrinsicJSFragment(
                    parameters: ["value", "targetVar"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        printer.write("let \(arguments[1]) = \(arguments[0]);")
                        return []
                    }
                )
            }
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: ["objectId", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let objectId = arguments[0]
                    let targetVar = arguments[1]
                    printer.write(
                        "let \(targetVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(objectId));"
                    )
                    printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(objectId));")
                    return []
                }
            )
        case .swiftHeapObject(let name):
            return IntrinsicJSFragment(
                parameters: ["pointer", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let pointer = arguments[0]
                    let targetVar = arguments[1]
                    printer.write("let \(targetVar) = _exports['\(name)'].__construct(\(pointer));")
                    return []
                }
            )
        case .associatedValueEnum(let fullName):
            return IntrinsicJSFragment(
                parameters: ["caseId", "targetVar"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let caseId = arguments[0]
                    let targetVar = arguments[1]
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    printer.write(
                        "let \(targetVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseId), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                    )
                    return []
                }
            )
        case .optional(let wrappedType):
            return try closureOptionalLiftParameter(wrappedType: wrappedType)
        default:
            throw BridgeJSLinkError(message: "Unsupported closure parameter type for lifting: \(type)")
        }
    }

    /// Handles optional parameter lifting for closure invocation
    private static func closureOptionalLiftParameter(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        switch wrappedType {
        case .string, .rawValueEnum, .int, .bool, .double, .float, .jsObject, .swiftHeapObject, .caseEnum,
            .associatedValueEnum:
            break
        default:
            throw BridgeJSLinkError(
                message: "Unsupported optional wrapped type in closure parameter lifting: \(wrappedType)"
            )
        }

        return IntrinsicJSFragment(
            parameters: ["isSome", "value", "targetVar"],
            printCode: { arguments, scope, printer, cleanupCode in
                let isSome = arguments[0]
                let value = arguments[1]
                let targetVar = arguments[2]

                printer.write("let \(targetVar);")
                printer.write("if (\(isSome)) {")
                printer.indent()
                switch wrappedType {
                case .string, .rawValueEnum(_, .string):
                    let objectLabel = scope.variable("\(targetVar)Object")
                    printer.write(
                        "const \(objectLabel) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(value));"
                    )
                    printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(value));")
                    printer.write("\(targetVar) = String(\(objectLabel));")
                case .int:
                    printer.write("\(targetVar) = \(value) | 0;")
                case .bool:
                    printer.write("\(targetVar) = \(value) !== 0;")
                case .double:
                    printer.write("\(targetVar) = \(value);")
                case .float:
                    printer.write("\(targetVar) = Math.fround(\(value));")
                case .jsObject:
                    printer.write("\(targetVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(value));")
                    printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(value));")
                case .swiftHeapObject(let typeName):
                    printer.write("\(targetVar) = _exports['\(typeName)'].__construct(\(value));")
                case .caseEnum:
                    printer.write("\(targetVar) = \(value);")
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .bool:
                        printer.write("\(targetVar) = \(value) !== 0;")
                    default:
                        printer.write("\(targetVar) = \(value);")
                    }
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    printer.write(
                        "\(targetVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(value), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                    )
                default:
                    fatalError("Unsupported optional wrapped type in closure parameter lifting: \(wrappedType)")
                }
                printer.unindent()
                printer.write("} else {")
                printer.indent()
                printer.write("\(targetVar) = null;")
                printer.unindent()
                printer.write("}")

                return []
            }
        )
    }

    /// Lowers a JS return value to WASM for returning from callback (invoke_js_callback_*)
    static func closureLowerReturn(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .void:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { _, _, printer, _ in
                    printer.write("return;")
                    return []
                }
            )
        case .int, .caseEnum:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("return \(arguments[0]) | 0;")
                    return []
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = boolLowerReturn
                    let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("return \(lowered[0]);")
                    return []
                }
            )
        case .float:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("return Math.fround(\(arguments[0]));")
                    return []
                }
            )
        case .double:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("return \(arguments[0]);")
                    return []
                }
            )
        case .string:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = stringLowerReturn
                    let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("return \(lowered[0]);")
                    return []
                }
            )
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = jsObjectLowerReturn
                    let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("return \(lowered[0]);")
                    return []
                }
            )
        case .swiftHeapObject:
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = swiftHeapObjectLowerReturn
                    let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("return \(lowered[0]);")
                    return []
                }
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return IntrinsicJSFragment(
                    parameters: ["result"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let baseFragment = stringLowerReturn
                        let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                        printer.write("return \(lowered[0]);")
                        return []
                    }
                )
            case .bool:
                return IntrinsicJSFragment(
                    parameters: ["result"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let baseFragment = boolLowerReturn
                        let lowered = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                        printer.write("return \(lowered[0]);")
                        return []
                    }
                )
            default:
                return IntrinsicJSFragment(
                    parameters: ["result"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        printer.write("return \(arguments[0]) | 0;")
                        return []
                    }
                )
            }
        case .associatedValueEnum(let fullName):
            return IntrinsicJSFragment(
                parameters: ["result"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let result = arguments[0]
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let caseIdVar = scope.variable("caseId")
                    let cleanupVar = scope.variable("cleanup")
                    printer.write(
                        "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(result));"
                    )
                    cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                    printer.write("return \(caseIdVar);")
                    return []
                }
            )
        case .optional(let wrappedType):
            return try closureOptionalLowerReturn(wrappedType: wrappedType)
        default:
            throw BridgeJSLinkError(message: "Unsupported closure return type for lowering: \(type)")
        }
    }

    /// Handles optional return lowering for closure invocation
    private static func closureOptionalLowerReturn(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["result"],
            printCode: { arguments, scope, printer, cleanupCode in
                let result = arguments[0]

                switch wrappedType {
                case .swiftHeapObject:
                    printer.write("return \(result) ? \(result).pointer : 0;")
                case .string:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = \(result);")
                    printer.write("return;")
                case .int:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = \(result);")
                    printer.write("return;")
                case .bool:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = \(result);")
                    printer.write("return;")
                case .float:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = \(result);")
                    printer.write("return;")
                case .double:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = \(result);")
                    printer.write("return;")
                case .caseEnum:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = \(result);")
                    printer.write("return;")
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .string:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = \(result);")
                        printer.write("return;")
                    case .bool:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = \(result);")
                        printer.write("return;")
                    case .float:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = \(result);")
                        printer.write("return;")
                    case .double:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = \(result);")
                        printer.write("return;")
                    default:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = \(result);")
                        printer.write("return;")
                    }
                case .associatedValueEnum(let fullName):
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let caseIdVar = scope.variable("caseId")
                    let cleanupVar = scope.variable("cleanup")
                    printer.write("if (\(result)) {")
                    printer.indent()
                    printer.write(
                        "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(result));"
                    )
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = \(caseIdVar);")
                    cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                    printer.unindent()
                    printer.write("} else {")
                    printer.indent()
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = null;")
                    printer.unindent()
                    printer.write("}")
                    printer.write("return;")
                default:
                    fatalError("Unsupported optional wrapped type in closure return lowering: \(wrappedType)")
                }

                return []
            }
        )
    }

    /// Lifts a WASM return value to JS from Swift closure (lower_closure_*)
    static func closureLiftReturn(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .void:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("\(arguments[0]);")
                    printer.write("return;")
                    return []
                }
            )
        case .int, .caseEnum:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("return \(arguments[0]) | 0;")
                    return []
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let baseFragment = boolLiftReturn
                    let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                    printer.write("return \(lifted[0]);")
                    return []
                }
            )
        case .float, .double:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("return \(arguments[0]);")
                    return []
                }
            )
        case .string:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("const resultLen = \(arguments[0]);")
                    let baseFragment = stringLiftReturn
                    let lifted = baseFragment.printCode([], scope, printer, cleanupCode)
                    printer.write("return \(lifted[0]);")
                    return []
                }
            )
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("const resultId = \(arguments[0]);")
                    let baseFragment = jsObjectLiftReturn
                    let lifted = baseFragment.printCode(["resultId"], scope, printer, cleanupCode)
                    printer.write("return \(lifted[0]);")
                    return []
                }
            )
        case .swiftHeapObject(let className):
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("const resultPtr = \(arguments[0]);")
                    printer.write("return _exports['\(className)'].__construct(resultPtr);")
                    return []
                }
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return IntrinsicJSFragment(
                    parameters: ["invokeCall"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        printer.write("const resultLen = \(arguments[0]);")
                        let baseFragment = stringLiftReturn
                        let lifted = baseFragment.printCode([], scope, printer, cleanupCode)
                        printer.write("return \(lifted[0]);")
                        return []
                    }
                )
            case .bool:
                return IntrinsicJSFragment(
                    parameters: ["invokeCall"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let baseFragment = boolLiftReturn
                        let lifted = baseFragment.printCode([arguments[0]], scope, printer, cleanupCode)
                        printer.write("return \(lifted[0]);")
                        return []
                    }
                )
            default:
                return IntrinsicJSFragment(
                    parameters: ["invokeCall"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        printer.write("return \(arguments[0]) | 0;")
                        return []
                    }
                )
            }
        case .associatedValueEnum(let fullName):
            return IntrinsicJSFragment(
                parameters: ["invokeCall"],
                printCode: { arguments, scope, printer, cleanupCode in
                    printer.write("\(arguments[0]);")
                    let base = fullName.components(separatedBy: ".").last ?? fullName
                    let resultVar = scope.variable("result")
                    printer.write(
                        "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                    )
                    printer.write("return \(resultVar);")
                    return []
                }
            )
        case .optional(let wrappedType):
            return try closureOptionalLiftReturn(wrappedType: wrappedType)
        default:
            throw BridgeJSLinkError(message: "Unsupported closure return type for lifting: \(type)")
        }
    }

    /// Handles optional return lifting for Swift closure returns
    private static func closureOptionalLiftReturn(wrappedType: BridgeType) throws -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["invokeCall"],
            printCode: { arguments, scope, printer, cleanupCode in
                let invokeCall = arguments[0]
                printer.write("\(invokeCall);")
                let baseFragment = optionalLiftReturn(wrappedType: wrappedType, context: .importTS)
                let lifted = baseFragment.printCode([], scope, printer, cleanupCode)
                if !lifted.isEmpty {
                    printer.write("return \(lifted[0]);")
                }
                return []
            }
        )
    }

    /// Provides appropriate default values for error cases in closure invocation
    static func closureErrorReturn(type: BridgeType) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, scope, printer, cleanupCode in
                switch type {
                case .void:
                    printer.write("return;")
                case .string:
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnBytes) = new Uint8Array(0);")
                    printer.write("return 0;")
                case .int, .bool, .caseEnum:
                    printer.write("return 0;")
                case .float, .double:
                    printer.write("return 0.0;")
                case .jsObject, .swiftHeapObject:
                    printer.write("return 0;")
                case .rawValueEnum(_, let rawType):
                    switch rawType {
                    case .string:
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnBytes) = new Uint8Array(0);")
                        printer.write("return 0;")
                    case .bool, .int, .int32, .int64, .uint, .uint32, .uint64:
                        printer.write("return 0;")
                    case .float, .double:
                        printer.write("return 0.0;")
                    }
                case .associatedValueEnum:
                    printer.write("return;")
                case .optional(let wrappedType):
                    switch wrappedType {
                    case .swiftHeapObject:
                        printer.write("return 0;")
                    default:
                        printer.write("return;")
                    }
                default:
                    printer.write("return 0;")
                }

                return []
            }
        )
    }

    // MARK: - ExportSwift

    /// Returns a fragment that lowers a JS value to Wasm core values for parameters
    static func lowerParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double, .bool, .unsafePointer: return .identity
        case .string: return .stringLowerParameter
        case .jsObject: return .jsObjectLowerParameter
        case .swiftHeapObject:
            return .swiftHeapObjectLowerParameter
        case .swiftProtocol: return .jsObjectLowerParameter
        case .void: return .void
        case .optional(let wrappedType):
            return try .optionalLowerParameter(wrappedType: wrappedType)
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLowerParameter
            default: return .identity
            }
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return .associatedEnumLowerParameter(enumBase: base)
        case .swiftStruct(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return swiftStructLowerParameter(structBase: base)
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["closure"],
                printCode: { arguments, scope, printer, cleanupCode in
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
        }
    }

    /// Returns a fragment that lifts a Wasm core value to a JS value for return values
    static func liftReturn(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double: return .identity
        case .bool: return .boolLiftReturn
        case .string: return .stringLiftReturn
        case .jsObject: return .jsObjectLiftReturn
        case .swiftHeapObject(let name): return .swiftHeapObjectLiftReturn(name)
        case .unsafePointer: return .identity
        case .swiftProtocol: return .jsObjectLiftReturn
        case .void: return .void
        case .optional(let wrappedType): return .optionalLiftReturn(wrappedType: wrappedType)
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLiftReturn
            case .bool: return .boolLiftReturn
            default: return .identity
            }
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return .associatedEnumLiftReturn(enumBase: base)
        case .swiftStruct(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return swiftStructLiftReturn(structBase: base)
        case .closure(let signature):
            let lowerFuncName = "lower_closure_\(signature.moduleName)_\(signature.mangleName)"
            return IntrinsicJSFragment(
                parameters: ["boxPtr"],
                printCode: { arguments, scope, printer, cleanupCode in
                    let boxPtr = arguments[0]
                    printer.write("return bjs[\"\(lowerFuncName)\"](\(boxPtr));")
                    return []
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message: "Namespace enums are not supported to be returned from functions: \(string)"
            )
        }
    }

    // MARK: - ImportedJS

    /// Returns a fragment that lifts Wasm core values to JS values for parameters
    static func liftParameter(type: BridgeType, context: BridgeContext = .importTS) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double: return .identity
        case .bool: return .boolLiftParameter
        case .string: return .stringLiftParameter
        case .jsObject: return .jsObjectLiftParameter
        case .unsafePointer: return .identity
        case .swiftHeapObject(let name):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "swiftHeapObject '\(name)' can only be used in protocol exports, not in \(context)"
                )
            case .exportSwift:
                return .swiftHeapObjectLiftParameter(name)
            }
        case .swiftProtocol: return .jsObjectLiftParameter
        case .void:
            throw BridgeJSLinkError(
                message: "Void can't appear in parameters of imported JS functions"
            )
        case .optional(let wrappedType):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "Optional types are not supported for imported JS functions: \(wrappedType)"
                )
            case .exportSwift:
                return try .optionalLiftParameter(wrappedType: wrappedType)
            }
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLiftParameter
            case .bool: return .boolLiftParameter
            default: return .identity
            }
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
                    printCode: { arguments, scope, printer, cleanupCode in
                        let caseId = arguments[0]
                        let resultVar = scope.variable("enumValue")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseId), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
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
                    printCode: { arguments, scope, printer, cleanupCode in
                        let resultVar = scope.variable("structValue")
                        printer.write(
                            "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers));"
                        )
                        return [resultVar]
                    }
                )
            }
        case .closure(let signature):
            let lowerFuncName = "lower_closure_\(signature.moduleName)_\(signature.mangleName)"
            return IntrinsicJSFragment(
                parameters: ["boxPtr"],
                printCode: { arguments, scope, printer, cleanupCode in
                    return ["bjs[\"\(lowerFuncName)\"](\(arguments[0]))"]
                }
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message:
                    "Namespace enums are not supported to be passed as parameters to imported JS functions: \(string)"
            )
        }
    }

    /// Returns a fragment that lowers a JS value to Wasm core values for return values
    static func lowerReturn(type: BridgeType, context: BridgeContext = .importTS) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double: return .identity
        case .bool: return .boolLowerReturn
        case .string: return .stringLowerReturn
        case .jsObject: return .jsObjectLowerReturn
        case .unsafePointer: return .identity
        case .swiftHeapObject(let name):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "swiftHeapObject '\(name)' can only be used in protocol exports, not in \(context)"
                )
            case .exportSwift:
                return .swiftHeapObjectLowerReturn
            }
        case .swiftProtocol: return .jsObjectLowerReturn
        case .void: return .void
        case .optional(let wrappedType):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "Optional types are not supported for imported JS functions: \(wrappedType)"
                )
            case .exportSwift:
                return try .optionalLowerReturn(wrappedType: wrappedType)
            }
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLowerReturn
            case .bool: return .boolLowerReturn
            default: return .identity
            }
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
                // ImportTS expects Swift structs to come back as a retained JS object ID.
                return .jsObjectLowerReturn
            case .exportSwift:
                return swiftStructLowerReturn(fullName: fullName)
            }
        case .closure:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanupCode in
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
        }
    }

    // MARK: - Enums Payload Fragments

    static func associatedValueLowerReturn(fullName: String) -> IntrinsicJSFragment {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]
                let caseIdVar = scope.variable("caseId")
                let cleanupVar = scope.variable("cleanup")
                printer.write(
                    "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                )
                cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                printer.write("return \(caseIdVar);")
                return []
            }
        )
    }
    /// Fragment for generating an entire associated value enum helper
    static func associatedValueEnumHelper(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, scope, printer, cleanup in
                let enumName = arguments[0]

                // Generate the enum tag object
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
                printer.nextLine()

                // Generate the helper function
                printer.write("const __bjs_create\(enumName)Helpers = () => {")
                printer.indent()
                printer.write(
                    "return (\(JSGlueVariableScope.reservedTmpParamInts), \(JSGlueVariableScope.reservedTmpParamF32s), \(JSGlueVariableScope.reservedTmpParamF64s), textEncoder, \(JSGlueVariableScope.reservedSwift)) => ({"
                )
                printer.indent()

                // Generate lower function
                printer.write("lower: (value) => {")
                printer.indent {
                    printer.write("const enumTag = value.tag;")
                    printer.write("switch (enumTag) {")
                    printer.indent {
                        let lowerPrinter = CodeFragmentPrinter()
                        for enumCase in enumDefinition.cases {
                            let caseName = enumCase.name.capitalizedFirstLetter
                            let caseScope = JSGlueVariableScope()
                            let caseCleanup = CodeFragmentPrinter()
                            caseCleanup.indent()
                            let fragment = IntrinsicJSFragment.associatedValuePushPayload(enumCase: enumCase)
                            _ = fragment.printCode(["value", enumName, caseName], caseScope, lowerPrinter, caseCleanup)
                        }

                        for line in lowerPrinter.lines {
                            printer.write(line)
                        }

                        printer.write("default: throw new Error(\"Unknown \(enumName) tag: \" + String(enumTag));")
                    }
                    printer.write("}")
                }
                printer.write("},")

                // Generate lift function
                printer.write(
                    "lift: (\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s)) => {"
                )
                printer.indent {
                    printer.write("const tag = tmpRetTag | 0;")
                    printer.write("switch (tag) {")
                    printer.indent {
                        let liftPrinter = CodeFragmentPrinter()
                        for enumCase in enumDefinition.cases {
                            let caseName = enumCase.name.capitalizedFirstLetter
                            let caseScope = JSGlueVariableScope()
                            let caseCleanup = CodeFragmentPrinter()

                            let fragment = IntrinsicJSFragment.associatedValuePopPayload(enumCase: enumCase)
                            _ = fragment.printCode([enumName, caseName], caseScope, liftPrinter, caseCleanup)
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
                printer.unindent()
                printer.write("});")
                printer.unindent()
                printer.write("};")

                return []
            }
        )
    }

    static func simpleEnumHelper(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, scope, printer, cleanup in
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

    static func rawValueEnumHelper(enumDefinition: ExportedEnum) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["enumName"],
            printCode: { arguments, scope, printer, cleanup in
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
            printCode: { arguments, scope, printer, cleanup in
                let enumName = arguments[1]
                let caseName = arguments[2]

                printer.write("case \(enumName).Tag.\(caseName): {")

                printer.indent {
                    if enumCase.associatedValues.isEmpty {
                        printer.write("const cleanup = undefined;")
                        printer.write("return { caseId: \(enumName).Tag.\(caseName), cleanup };")
                    } else {
                        // Process associated values in reverse order (to match the order they'll be popped)
                        let reversedValues = enumCase.associatedValues.enumerated().reversed()

                        for (associatedValueIndex, associatedValue) in reversedValues {
                            let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                            let fragment = IntrinsicJSFragment.associatedValuePushPayload(type: associatedValue.type)

                            _ = fragment.printCode(["value.\(prop)"], scope, printer, cleanup)
                        }

                        if cleanup.lines.isEmpty {
                            printer.write("const cleanup = undefined;")
                        } else {
                            printer.write("const cleanup = () => {")
                            printer.write(contentsOf: cleanup)
                            printer.write("};")
                        }
                        printer.write("return { caseId: \(enumName).Tag.\(caseName), cleanup };")
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
            printCode: { arguments, scope, printer, cleanup in
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
                        let fragment = IntrinsicJSFragment.associatedValuePopPayload(type: associatedValue.type)

                        let result = fragment.printCode([], scope, casePrinter, cleanup)
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

    private static func associatedValuePushPayload(type: BridgeType) -> IntrinsicJSFragment {
        switch type {
        case .string:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let bytesVar = scope.variable("bytes")
                    let idVar = scope.variable("id")
                    printer.write("const \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));")
                    printer.write("const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                    cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                    return []
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(arguments[0]) ? 1 : 0);")
                    return []
                }
            )
        case .int:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(arguments[0]) | 0));")
                    return []
                }
            )
        case .float:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamF32s).push(Math.fround(\(arguments[0])));")
                    return []
                }
            )
        case .double:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamF64s).push(\(arguments[0]));")
                    return []
                }
            )
        case .optional(let wrappedType):
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let isSomeVar = scope.variable("isSome")
                    printer.write("const \(isSomeVar) = \(value) != null;")

                    switch wrappedType {
                    case .string:
                        let idVar = scope.variable("id")
                        printer.write("let \(idVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            let bytesVar = scope.variable("bytes")
                            printer.write(
                                "let \(bytesVar) = \(JSGlueVariableScope.reservedTextEncoder).encode(\(value));"
                            )
                            printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        cleanup.write("if(\(idVar)) {")
                        cleanup.indent {
                            cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                        }
                        cleanup.write("}")
                    case .int:
                        printer.write(
                            "\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? (\(value) | 0) : 0);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                    case .bool:
                        printer.write(
                            "\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? (\(value) ? 1 : 0) : 0);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                    case .float:
                        printer.write(
                            "\(JSGlueVariableScope.reservedTmpParamF32s).push(\(isSomeVar) ? Math.fround(\(value)) : 0.0);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                    case .double:
                        printer.write(
                            "\(JSGlueVariableScope.reservedTmpParamF64s).push(\(isSomeVar) ? \(value) : 0.0);"
                        )
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                    default:
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                    }

                    return []
                }
            )
        default:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    return []
                }
            )
        }
    }

    private static func associatedValuePopPayload(type: BridgeType) -> IntrinsicJSFragment {
        switch type {
        case .string:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let strVar = scope.variable("string")
                    printer.write("const \(strVar) = \(JSGlueVariableScope.reservedTmpRetStrings).pop();")
                    return [strVar]
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let bVar = scope.variable("bool")
                    printer.write("const \(bVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    return [bVar]
                }
            )
        case .int:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let iVar = scope.variable("int")
                    printer.write("const \(iVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    return [iVar]
                }
            )
        case .float:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let fVar = scope.variable("f32")
                    printer.write("const \(fVar) = \(JSGlueVariableScope.reservedTmpRetF32s).pop();")
                    return [fVar]
                }
            )
        case .double:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let dVar = scope.variable("f64")
                    printer.write("const \(dVar) = \(JSGlueVariableScope.reservedTmpRetF64s).pop();")
                    return [dVar]
                }
            )
        case .optional(let wrappedType):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let optVar = scope.variable("optional")
                    let isSomeVar = scope.variable("isSome")

                    printer.write("const \(isSomeVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    printer.write("let \(optVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        let wrappedFragment = associatedValuePopPayload(type: wrappedType)
                        let wrappedResults = wrappedFragment.printCode([], scope, printer, cleanup)
                        if let wrappedResult = wrappedResults.first {
                            printer.write("\(optVar) = \(wrappedResult);")
                        } else {
                            printer.write("\(optVar) = undefined;")
                        }
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(optVar) = null;")
                    }
                    printer.write("}")

                    return [optVar]
                }
            )
        default:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    return ["undefined"]
                }
            )
        }
    }

    static func swiftStructLowerReturn(fullName: String) -> IntrinsicJSFragment {
        let base = fullName.components(separatedBy: ".").last ?? fullName
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]
                let cleanupVar = scope.variable("cleanup")
                printer.write(
                    "const { cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedStructHelpers).\(base).lower(\(value));"
                )
                cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                return []
            }
        )
    }

    static func swiftStructLowerParameter(structBase: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["value"],
            printCode: { arguments, scope, printer, cleanupCode in
                let value = arguments[0]
                let cleanupVar = scope.variable("cleanup")
                printer.write(
                    "const { cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedStructHelpers).\(structBase).lower(\(value));"
                )
                cleanupCode.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                return []
            }
        )
    }

    static func swiftStructLiftReturn(structBase: String) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: [],
            printCode: { arguments, scope, printer, cleanupCode in
                let resultVar = scope.variable("structValue")
                printer.write(
                    "const \(resultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(structBase).lift(\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers));"
                )
                return [resultVar]
            }
        )
    }

    static func structHelper(structDefinition: ExportedStruct, allStructs: [ExportedStruct]) -> IntrinsicJSFragment {
        return IntrinsicJSFragment(
            parameters: ["structName"],
            printCode: { arguments, scope, printer, cleanup in
                let structName = arguments[0]
                let capturedStructDef = structDefinition
                let capturedAllStructs = allStructs

                printer.write("const __bjs_create\(structName)Helpers = () => {")
                printer.indent()
                printer.write(
                    "return (\(JSGlueVariableScope.reservedTmpParamInts), \(JSGlueVariableScope.reservedTmpParamF32s), \(JSGlueVariableScope.reservedTmpParamF64s), \(JSGlueVariableScope.reservedTmpParamPointers), \(JSGlueVariableScope.reservedTmpRetPointers), textEncoder, \(JSGlueVariableScope.reservedSwift), \(JSGlueVariableScope.reservedEnumHelpers)) => ({"
                )
                printer.indent()

                printer.write("lower: (value) => {")
                printer.indent {
                    generateStructLowerCode(
                        structDef: capturedStructDef,
                        allStructs: capturedAllStructs,
                        printer: printer
                    )
                }
                printer.write("},")

                printer.write(
                    "lift: (\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers)) => {"
                )
                printer.indent {
                    generateStructLiftCode(
                        structDef: capturedStructDef,
                        allStructs: capturedAllStructs,
                        printer: printer,
                        attachMethods: true
                    )
                }
                printer.write("}")
                printer.unindent()
                printer.write("});")
                printer.unindent()
                printer.write("};")

                return []
            }
        )
    }

    private static func findStruct(name: String, structs: [ExportedStruct]) -> ExportedStruct? {
        return structs.first(where: { $0.swiftCallName == name || $0.name == name })
    }

    private static func generateStructLowerCode(
        structDef: ExportedStruct,
        allStructs: [ExportedStruct],
        printer: CodeFragmentPrinter
    ) {
        let lowerPrinter = CodeFragmentPrinter()
        let lowerScope = JSGlueVariableScope()
        let lowerCleanup = CodeFragmentPrinter()
        lowerCleanup.indent()

        let instanceProps = structDef.properties.filter { !$0.isStatic }
        for property in instanceProps {
            let fragment = structFieldLowerFragment(field: property, allStructs: allStructs)
            let fieldValue = "value.\(property.name)"
            _ = fragment.printCode([fieldValue], lowerScope, lowerPrinter, lowerCleanup)
        }

        for line in lowerPrinter.lines {
            printer.write(line)
        }

        if !lowerCleanup.lines.isEmpty {
            printer.write("const cleanup = () => {")
            printer.write(contentsOf: lowerCleanup)
            printer.write("};")
            printer.write("return { cleanup };")
        } else {
            printer.write("return { cleanup: undefined };")
        }
    }

    private static func generateStructLiftCode(
        structDef: ExportedStruct,
        allStructs: [ExportedStruct],
        printer: CodeFragmentPrinter,
        attachMethods: Bool = false
    ) {
        let liftScope = JSGlueVariableScope()
        let liftCleanup = CodeFragmentPrinter()

        var fieldExpressions: [(name: String, expression: String)] = []

        let instanceProps = structDef.properties.filter { !$0.isStatic }
        for property in instanceProps.reversed() {
            let fragment = structFieldLiftFragment(field: property, allStructs: allStructs)
            let results = fragment.printCode([], liftScope, printer, liftCleanup)

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
                printer.indent {
                    let methodScope = JSGlueVariableScope()
                    let methodCleanup = CodeFragmentPrinter()

                    // Lower the struct instance (this) using the helper's lower function
                    let structCleanupVar = methodScope.variable("structCleanup")
                    printer.write(
                        "const { cleanup: \(structCleanupVar) } = \(JSGlueVariableScope.reservedStructHelpers).\(structDef.name).lower(this);"
                    )

                    // Lower each parameter and collect forwarding expressions
                    var paramForwardings: [String] = []
                    for param in method.parameters {
                        let fragment = try! IntrinsicJSFragment.lowerParameter(type: param.type)
                        let loweredValues = fragment.printCode([param.name], methodScope, printer, methodCleanup)
                        paramForwardings.append(contentsOf: loweredValues)
                    }

                    // Call the Swift function with all lowered parameters
                    let callExpr = "instance.exports.\(method.abiName)(\(paramForwardings.joined(separator: ", ")))"
                    if method.returnType == .void {
                        printer.write("\(callExpr);")
                    } else {
                        printer.write("const ret = \(callExpr);")
                    }

                    // Cleanup
                    printer.write("if (\(structCleanupVar)) { \(structCleanupVar)(); }")
                    printer.write(contentsOf: methodCleanup)

                    // Lift return value if needed
                    if method.returnType != .void {
                        let liftFragment = try! IntrinsicJSFragment.liftReturn(type: method.returnType)
                        if !liftFragment.parameters.isEmpty {
                            let lifted = liftFragment.printCode(["ret"], methodScope, printer, methodCleanup)
                            if let liftedValue = lifted.first {
                                printer.write("return \(liftedValue);")
                            }
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
        field: ExportedProperty,
        allStructs: [ExportedStruct]
    ) -> IntrinsicJSFragment {
        switch field.type {
        case .string:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let bytesVar = scope.variable("bytes")
                    let idVar = scope.variable("id")
                    printer.write("const \(bytesVar) = textEncoder.encode(\(value));")
                    printer.write("const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                    cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                    return [idVar]
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(arguments[0]) ? 1 : 0);")
                    return []
                }
            )
        case .int:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(arguments[0]) | 0));")
                    return []
                }
            )
        case .float:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamF32s).push(Math.fround(\(arguments[0])));")
                    return []
                }
            )
        case .double:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamF64s).push(\(arguments[0]));")
                    return []
                }
            )
        case .unsafePointer:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamPointers).push((\(arguments[0]) | 0));")
                    return []
                }
            )
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let idVar = scope.variable("id")
                    printer.write("let \(idVar);")
                    printer.write("if (\(value) != null) {")
                    printer.indent {
                        printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(idVar) = undefined;")
                    }
                    printer.write("}")
                    printer.write(
                        "\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar) !== undefined ? \(idVar) : 0);"
                    )
                    cleanup.write("if(\(idVar) !== undefined && \(idVar) !== 0) {")
                    cleanup.indent {
                        cleanup.write("try {")
                        cleanup.indent {
                            cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.getObject(\(idVar));")
                            cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                        }
                        cleanup.write("} catch(e) {}")
                    }
                    cleanup.write("}")
                    return [idVar]
                }
            )
        case .optional(let wrappedType):
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let isSomeVar = scope.variable("isSome")
                    printer.write("const \(isSomeVar) = \(value) != null;")

                    if case .caseEnum = wrappedType {
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(value) | 0));")
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        return []
                    } else if case .rawValueEnum(_, let rawType) = wrappedType {
                        switch rawType {
                        case .string:
                            let idVar = scope.variable("id")
                            printer.write("let \(idVar);")
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                let bytesVar = scope.variable("bytes")
                                printer.write("const \(bytesVar) = textEncoder.encode(\(value));")
                                printer.write(
                                    "\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));"
                                )
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                            }
                            printer.write("} else {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                            cleanup.write(
                                "if(\(idVar) !== undefined) { \(JSGlueVariableScope.reservedSwift).memory.release(\(idVar)); }"
                            )
                            return [idVar]
                        case .float:
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                printer.write(
                                    "\(JSGlueVariableScope.reservedTmpParamF32s).push(Math.fround(\(value)));"
                                )
                            }
                            printer.write("} else {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamF32s).push(0.0);")
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                            return []
                        case .double:
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamF64s).push(\(value));")
                            }
                            printer.write("} else {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamF64s).push(0.0);")
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                            return []
                        default:
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(value) | 0));")
                            }
                            printer.write("} else {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                            return []
                        }
                    } else if case .swiftHeapObject = wrappedType {
                        let ptrVar = scope.variable("ptr")
                        printer.write("let \(ptrVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            printer.write("\(ptrVar) = \(value).pointer;")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamPointers).push(\(ptrVar));")
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("\(JSGlueVariableScope.reservedTmpParamPointers).push(0);")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        return []
                    } else if case .swiftStruct(let structName) = wrappedType {
                        let nestedCleanupVar = scope.variable("nestedCleanup")
                        printer.write("let \(nestedCleanupVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            let structResultVar = scope.variable("structResult")
                            printer.write(
                                "const \(structResultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(structName).lower(\(value));"
                            )
                            printer.write("\(nestedCleanupVar) = \(structResultVar).cleanup;")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        cleanup.write("if (\(nestedCleanupVar)) { \(nestedCleanupVar)(); }")
                        return []
                    } else if case .string = wrappedType {
                        let idVar = scope.variable("id")
                        printer.write("let \(idVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            let bytesVar = scope.variable("bytes")
                            printer.write("const \(bytesVar) = textEncoder.encode(\(value));")
                            printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        cleanup.write(
                            "if(\(idVar) !== undefined) { \(JSGlueVariableScope.reservedSwift).memory.release(\(idVar)); }"
                        )
                        return [idVar]
                    } else if case .jsObject = wrappedType {
                        let idVar = scope.variable("id")
                        printer.write("let \(idVar);")
                        printer.write("if (\(isSomeVar)) {")
                        printer.indent {
                            printer.write("\(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(value));")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                        }
                        printer.write("} else {")
                        printer.indent {
                            printer.write("\(idVar) = undefined;")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                        }
                        printer.write("}")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        cleanup.write("if(\(idVar) !== undefined && \(idVar) !== 0) {")
                        cleanup.indent {
                            cleanup.write("try {")
                            cleanup.indent {
                                cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.getObject(\(idVar));")
                                cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                            }
                            cleanup.write("} catch(e) {}")
                        }
                        cleanup.write("}")
                        return [idVar]
                    } else {
                        // Handle optional primitive types using helper
                        switch wrappedType {
                        case .int:
                            pushOptionalPrimitive(
                                value: value,
                                isSomeVar: isSomeVar,
                                stack: .tmpParamInts,
                                convert: "| 0",
                                zeroValue: "0",
                                printer: printer
                            )
                        case .bool:
                            pushOptionalPrimitive(
                                value: value,
                                isSomeVar: isSomeVar,
                                stack: .tmpParamInts,
                                convert: "? 1 : 0",
                                zeroValue: "0",
                                printer: printer
                            )
                        case .float:
                            pushOptionalPrimitive(
                                value: value,
                                isSomeVar: isSomeVar,
                                stack: .tmpParamF32s,
                                convert: "Math.fround",
                                zeroValue: "0.0",
                                printer: printer
                            )
                        case .double:
                            pushOptionalPrimitive(
                                value: value,
                                isSomeVar: isSomeVar,
                                stack: .tmpParamF64s,
                                convert: nil,
                                zeroValue: "0.0",
                                printer: printer
                            )
                        case .associatedValueEnum(let enumName):
                            let base = enumName.components(separatedBy: ".").last ?? enumName
                            let caseIdVar = scope.variable("enumCaseId")
                            let enumCleanupVar = scope.variable("enumCleanup")
                            printer.write("let \(caseIdVar), \(enumCleanupVar);")
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                let enumResultVar = scope.variable("enumResult")
                                printer.write(
                                    "const \(enumResultVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                                )
                                printer.write("\(caseIdVar) = \(enumResultVar).caseId;")
                                printer.write("\(enumCleanupVar) = \(enumResultVar).cleanup;")
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(caseIdVar));")
                            }
                            printer.write("} else {")
                            printer.indent {
                                printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(0);")
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                            cleanup.write("if (\(enumCleanupVar)) { \(enumCleanupVar)(); }")
                        default:
                            // For other types (nested structs, etc.), original logic applies
                            let wrappedFragment = structFieldLowerFragment(
                                field: ExportedProperty(
                                    name: field.name,
                                    type: wrappedType,
                                    isReadonly: true,
                                    isStatic: false
                                ),
                                allStructs: allStructs
                            )
                            printer.write("if (\(isSomeVar)) {")
                            printer.indent {
                                _ = wrappedFragment.printCode([value], scope, printer, cleanup)
                            }
                            printer.write("}")
                            printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
                        }
                        return []
                    }
                }
            )
        case .swiftStruct(let nestedName):
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let structResultVar = scope.variable("structResult")
                    printer.write(
                        "const \(structResultVar) = \(JSGlueVariableScope.reservedStructHelpers).\(nestedName).lower(\(value));"
                    )
                    cleanup.write("if (\(structResultVar).cleanup) { \(structResultVar).cleanup(); }")
                    return []
                }
            )
        case .swiftHeapObject:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    printer.write("\(JSGlueVariableScope.reservedTmpParamPointers).push(\(value).pointer);")
                    return []
                }
            )
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    let value = arguments[0]
                    let caseIdVar = scope.variable("caseId")
                    let cleanupVar = scope.variable("enumCleanup")
                    printer.write(
                        "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lower(\(value));"
                    )
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(caseIdVar));")
                    cleanup.write("if (\(cleanupVar)) { \(cleanupVar)(); }")
                    return [cleanupVar]
                }
            )
        case .caseEnum:
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(arguments[0]) | 0));")
                    return []
                }
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return IntrinsicJSFragment(
                    parameters: ["value"],
                    printCode: { arguments, scope, printer, cleanup in
                        let value = arguments[0]
                        let bytesVar = scope.variable("bytes")
                        let idVar = scope.variable("id")
                        printer.write("const \(bytesVar) = textEncoder.encode(\(value));")
                        printer.write(
                            "const \(idVar) = \(JSGlueVariableScope.reservedSwift).memory.retain(\(bytesVar));"
                        )
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(bytesVar).length);")
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(idVar));")
                        cleanup.write("\(JSGlueVariableScope.reservedSwift).memory.release(\(idVar));")
                        return [idVar]
                    }
                )
            case .float:
                return IntrinsicJSFragment(
                    parameters: ["value"],
                    printCode: { arguments, scope, printer, cleanup in
                        printer.write("\(JSGlueVariableScope.reservedTmpParamF32s).push(Math.fround(\(arguments[0])));")
                        return []
                    }
                )
            case .double:
                return IntrinsicJSFragment(
                    parameters: ["value"],
                    printCode: { arguments, scope, printer, cleanup in
                        printer.write("\(JSGlueVariableScope.reservedTmpParamF64s).push(\(arguments[0]));")
                        return []
                    }
                )
            default:
                return IntrinsicJSFragment(
                    parameters: ["value"],
                    printCode: { arguments, scope, printer, cleanup in
                        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push((\(arguments[0]) | 0));")
                        return []
                    }
                )
            }
        case .void, .swiftProtocol, .namespaceEnum, .closure:
            // These types should not appear as struct fields - return error fragment
            return IntrinsicJSFragment(
                parameters: ["value"],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("throw new Error(\"Unsupported struct field type for lowering: \(field.type)\");")
                    return []
                }
            )
        }
    }

    /// Helper to push optional primitive values to stack-based parameters
    private static func pushOptionalPrimitive(
        value: String,
        isSomeVar: String,
        stack: StackType,
        convert: String?,
        zeroValue: String,
        printer: CodeFragmentPrinter
    ) {
        let stackName: String
        switch stack {
        case .tmpParamInts: stackName = JSGlueVariableScope.reservedTmpParamInts
        case .tmpParamF32s: stackName = JSGlueVariableScope.reservedTmpParamF32s
        case .tmpParamF64s: stackName = JSGlueVariableScope.reservedTmpParamF64s
        }

        printer.write("if (\(isSomeVar)) {")
        printer.indent {
            let converted: String
            if let convert = convert {
                if convert.starts(with: "Math.") {
                    converted = "\(convert)(\(value))"
                } else {
                    converted = "\(value) \(convert)"
                }
            } else {
                converted = value
            }
            printer.write("\(stackName).push(\(converted));")
        }
        printer.write("} else {")
        printer.indent {
            printer.write("\(stackName).push(\(zeroValue));")
        }
        printer.write("}")
        printer.write("\(JSGlueVariableScope.reservedTmpParamInts).push(\(isSomeVar) ? 1 : 0);")
    }

    private enum StackType {
        case tmpParamInts
        case tmpParamF32s
        case tmpParamF64s
    }

    private static func structFieldLiftFragment(
        field: ExportedProperty,
        allStructs: [ExportedStruct]
    ) -> IntrinsicJSFragment {
        switch field.type {
        case .string:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let strVar = scope.variable("string")
                    printer.write("const \(strVar) = \(JSGlueVariableScope.reservedTmpRetStrings).pop();")
                    return [strVar]
                }
            )
        case .bool:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let bVar = scope.variable("bool")
                    printer.write("const \(bVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop() !== 0;")
                    return [bVar]
                }
            )
        case .int:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let iVar = scope.variable("int")
                    printer.write("const \(iVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    return [iVar]
                }
            )
        case .float:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let fVar = scope.variable("f32")
                    printer.write("const \(fVar) = \(JSGlueVariableScope.reservedTmpRetF32s).pop();")
                    return [fVar]
                }
            )
        case .double:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let dVar = scope.variable("f64")
                    printer.write("const \(dVar) = \(JSGlueVariableScope.reservedTmpRetF64s).pop();")
                    return [dVar]
                }
            )
        case .unsafePointer:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let pVar = scope.variable("pointer")
                    printer.write("const \(pVar) = \(JSGlueVariableScope.reservedTmpRetPointers).pop();")
                    return [pVar]
                }
            )
        case .optional(let wrappedType):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let isSomeVar = scope.variable("isSome")
                    let optVar = scope.variable("optional")
                    printer.write("const \(isSomeVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    printer.write("let \(optVar);")
                    printer.write("if (\(isSomeVar)) {")
                    printer.indent {
                        // Special handling for associated value enum - in struct fields, case ID is pushed to tmpRetInts
                        if case .associatedValueEnum(let enumName) = wrappedType {
                            let base = enumName.components(separatedBy: ".").last ?? enumName
                            let caseIdVar = scope.variable("enumCaseId")
                            printer.write("const \(caseIdVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                            printer.write(
                                "\(optVar) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(caseIdVar), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                            )
                        } else {
                            let wrappedFragment = structFieldLiftFragment(
                                field: ExportedProperty(
                                    name: field.name,
                                    type: wrappedType,
                                    isReadonly: true,
                                    isStatic: false
                                ),
                                allStructs: allStructs
                            )
                            let wrappedResults = wrappedFragment.printCode([], scope, printer, cleanup)
                            if let wrappedResult = wrappedResults.first {
                                printer.write("\(optVar) = \(wrappedResult);")
                            } else {
                                printer.write("\(optVar) = undefined;")
                            }
                        }
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(optVar) = null;")
                    }
                    printer.write("}")
                    return [optVar]
                }
            )
        case .swiftStruct(let nestedName):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let structVar = scope.variable("struct")
                    printer.write(
                        "const \(structVar) = \(JSGlueVariableScope.reservedStructHelpers).\(nestedName).lift(\(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s), \(JSGlueVariableScope.reservedTmpRetPointers));"
                    )
                    return [structVar]
                }
            )
        case .caseEnum:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let varName = scope.variable("value")
                    printer.write("const \(varName) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                    return [varName]
                }
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return IntrinsicJSFragment(
                    parameters: [],
                    printCode: { arguments, scope, printer, cleanup in
                        let varName = scope.variable("value")
                        printer.write("const \(varName) = \(JSGlueVariableScope.reservedTmpRetStrings).pop();")
                        return [varName]
                    }
                )
            case .float:
                return IntrinsicJSFragment(
                    parameters: [],
                    printCode: { arguments, scope, printer, cleanup in
                        let varName = scope.variable("value")
                        printer.write("const \(varName) = \(JSGlueVariableScope.reservedTmpRetF32s).pop();")
                        return [varName]
                    }
                )
            case .double:
                return IntrinsicJSFragment(
                    parameters: [],
                    printCode: { arguments, scope, printer, cleanup in
                        let varName = scope.variable("value")
                        printer.write("const \(varName) = \(JSGlueVariableScope.reservedTmpRetF64s).pop();")
                        return [varName]
                    }
                )
            default:
                return IntrinsicJSFragment(
                    parameters: [],
                    printCode: { arguments, scope, printer, cleanup in
                        let varName = scope.variable("value")
                        printer.write("const \(varName) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
                        return [varName]
                    }
                )
            }
        case .swiftHeapObject(let className):
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let ptrVar = scope.variable("ptr")
                    let varName = scope.variable("value")
                    printer.write("const \(ptrVar) = \(JSGlueVariableScope.reservedTmpRetPointers).pop();")
                    printer.write("const \(varName) = _exports['\(className)'].__construct(\(ptrVar));")
                    return [varName]
                }
            )
        case .jsObject:
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let objectIdVar = scope.variable("objectId")
                    let varName = scope.variable("value")
                    printer.write("const \(objectIdVar) = \(JSGlueVariableScope.reservedTmpRetInts).pop();")
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
        case .associatedValueEnum(let fullName):
            let base = fullName.components(separatedBy: ".").last ?? fullName
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    let varName = scope.variable("value")
                    printer.write(
                        "const \(varName) = \(JSGlueVariableScope.reservedEnumHelpers).\(base).lift(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                    )
                    return [varName]
                }
            )
        case .void, .swiftProtocol, .namespaceEnum, .closure:
            // These types should not appear as struct fields
            return IntrinsicJSFragment(
                parameters: [],
                printCode: { arguments, scope, printer, cleanup in
                    printer.write("throw new Error(\"Unsupported struct field type: \(field.type)\");")
                    return []
                }
            )
        }
    }
}
