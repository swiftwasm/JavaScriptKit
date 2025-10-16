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

    private var variables: Set<String> = [
        reservedSwift,
        reservedMemory,
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
/// See `BridgeJSInstrincics.swift` in the main JavaScriptKit module for Swift side lowering/lifting implementation.
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
                    "const { caseId: \(caseIdName), cleanup: \(cleanupName) } = enumHelpers.\(enumBase).lower(\(value));"
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
                    "const \(retName) = enumHelpers.\(enumBase).raise(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
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
                            "\(enumVar) = enumHelpers.\(base).raise(\(wrappedValue), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                        )
                    }
                    printer.write("}")
                    resultExpr = "\(isSome) ? \(enumVar) : null"
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
                        printer.write("const \(resultVar) = enumHelpers.\(base).lower(\(value));")
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

    static func optionalLiftReturn(wrappedType: BridgeType) -> IntrinsicJSFragment {
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
                    printer.write(
                        "const \(resultVar) = \(pointerVar) === null ? null : \(className).__construct(\(pointerVar));"
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
                            "\(resultVar) = enumHelpers.\(base).raise(\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                        )
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
        case .void, .optional, .namespaceEnum:
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
                            "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = enumHelpers.\(base).lower(\(value));"
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

    // MARK: - ExportSwift

    /// Returns a fragment that lowers a JS value to Wasm core values for parameters
    static func lowerParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double, .bool: return .identity
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
        case .swiftHeapObject(let name):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "swiftHeapObject '\(name)' can only be used in protocol exports, not in \(context)"
                )
            case .protocolExport:
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
            case .protocolExport:
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
            case .protocolExport:
                let base = fullName.components(separatedBy: ".").last ?? fullName
                return IntrinsicJSFragment(
                    parameters: ["caseId"],
                    printCode: { arguments, scope, printer, cleanupCode in
                        let caseId = arguments[0]
                        let resultVar = scope.variable("enumValue")
                        printer.write(
                            "const \(resultVar) = enumHelpers.\(base).raise(\(caseId), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s));"
                        )
                        return [resultVar]
                    }
                )
            }
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
        case .swiftHeapObject(let name):
            switch context {
            case .importTS:
                throw BridgeJSLinkError(
                    message: "swiftHeapObject '\(name)' can only be used in protocol exports, not in \(context)"
                )
            case .protocolExport:
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
            case .protocolExport:
                // Protocol exports support Optional - use side channel approach for return values
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
            case .protocolExport:
                return associatedValueLowerReturn(fullName: fullName)
            }
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
                    "const { caseId: \(caseIdVar), cleanup: \(cleanupVar) } = enumHelpers.\(base).lower(\(value));"
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

                // Generate raise function
                printer.write(
                    "raise: (\(JSGlueVariableScope.reservedTmpRetTag), \(JSGlueVariableScope.reservedTmpRetStrings), \(JSGlueVariableScope.reservedTmpRetInts), \(JSGlueVariableScope.reservedTmpRetF32s), \(JSGlueVariableScope.reservedTmpRetF64s)) => {"
                )
                printer.indent {
                    printer.write("const tag = tmpRetTag | 0;")
                    printer.write("switch (tag) {")
                    printer.indent {
                        let raisePrinter = CodeFragmentPrinter()
                        for enumCase in enumDefinition.cases {
                            let caseName = enumCase.name.capitalizedFirstLetter
                            let caseScope = JSGlueVariableScope()
                            let caseCleanup = CodeFragmentPrinter()

                            let fragment = IntrinsicJSFragment.associatedValuePopPayload(enumCase: enumCase)
                            _ = fragment.printCode([enumName, caseName], caseScope, raisePrinter, caseCleanup)
                        }

                        for line in raisePrinter.lines {
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
}
