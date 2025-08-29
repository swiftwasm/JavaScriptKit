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

    // MARK: - ExportSwift

    /// Returns a fragment that lowers a JS value to Wasm core values for parameters
    static func lowerParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double, .bool: return .identity
        case .string: return .stringLowerParameter
        case .jsObject: return .jsObjectLowerParameter
        case .swiftHeapObject:
            return .swiftHeapObjectLowerParameter
        case .void: return .void
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
        case .void: return .void
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
    static func liftParameter(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double: return .identity
        case .bool: return .boolLiftParameter
        case .string: return .stringLiftParameter
        case .jsObject: return .jsObjectLiftParameter
        case .swiftHeapObject(let name):
            throw BridgeJSLinkError(
                message:
                    "Swift heap objects are not supported to be passed as parameters to imported JS functions: \(name)"
            )
        case .void:
            throw BridgeJSLinkError(
                message: "Void can't appear in parameters of imported JS functions"
            )
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLiftParameter
            case .bool: return .boolLiftParameter
            default: return .identity
            }
        case .associatedValueEnum(let string):
            throw BridgeJSLinkError(
                message:
                    "Associated value enums are not supported to be passed as parameters to imported JS functions: \(string)"
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message:
                    "Namespace enums are not supported to be passed as parameters to imported JS functions: \(string)"
            )
        }
    }

    /// Returns a fragment that lowers a JS value to Wasm core values for return values
    static func lowerReturn(type: BridgeType) throws -> IntrinsicJSFragment {
        switch type {
        case .int, .float, .double: return .identity
        case .bool: return .boolLowerReturn
        case .string: return .stringLowerReturn
        case .jsObject: return .jsObjectLowerReturn
        case .swiftHeapObject:
            throw BridgeJSLinkError(
                message: "Swift heap objects are not supported to be returned from imported JS functions"
            )
        case .void: return .void
        case .caseEnum: return .identity
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string: return .stringLowerReturn
            case .bool: return .boolLowerReturn
            default: return .identity
            }
        case .associatedValueEnum(let string):
            throw BridgeJSLinkError(
                message: "Associated value enums are not supported to be returned from imported JS functions: \(string)"
            )
        case .namespaceEnum(let string):
            throw BridgeJSLinkError(
                message: "Namespace enums are not supported to be returned from imported JS functions: \(string)"
            )
        }
    }
}
