// This file is shared between BridgeTool and BridgeJSLink

// MARK: - ABI Name Generation

/// Utility for generating consistent ABI names across all exported and imported types
public struct ABINameGenerator {
    static let prefixComponent = "bjs"

    /// Generates ABI name using standardized namespace + context pattern
    public static func generateABIName(
        baseName: String,
        namespace: [String]? = nil,
        staticContext: StaticContext? = nil,
        operation: String? = nil,
        className: String? = nil
    ) -> String {

        let namespacePart: String?
        if let namespace = namespace, !namespace.isEmpty {
            namespacePart = namespace.joined(separator: "_")
        } else {
            namespacePart = nil
        }

        let contextPart: String?
        if let staticContext = staticContext {
            switch staticContext {
            case .className(let name), .enumName(let name), .structName(let name):
                contextPart = name
            case .namespaceEnum:
                contextPart = namespacePart
            }
        } else if let className = className {
            contextPart = className
        } else {
            contextPart = namespacePart
        }

        var components = [ABINameGenerator.prefixComponent]
        if let context = contextPart {
            components.append(context)
        }

        if staticContext != nil {
            components.append("static")
        }

        components.append(baseName)

        if let operation = operation {
            components.append(operation)
        }

        return components.joined(separator: "_")
    }

    static func generateImportedABIName(
        baseName: String,
        context: ImportedTypeSkeleton? = nil,
        operation: String? = nil
    ) -> String {
        return [ABINameGenerator.prefixComponent, context?.name, baseName, operation].compactMap { $0 }.joined(
            separator: "_"
        )
    }
}

// MARK: - Types

/// Context for bridge operations that determines which types are valid
public enum BridgeContext: Sendable {
    case importTS
    case exportSwift
}

public struct ClosureSignature: Codable, Equatable, Hashable, Sendable {
    public let parameters: [BridgeType]
    public let returnType: BridgeType
    /// Simplified Swift ABI-style mangling with module prefix
    // <moduleLength><module> + params + _ + return
    // Examples:
    //   - 4MainSS_Si (Main module, String->Int)
    //   - 6MyAppSiSi_y (MyApp module, Int,Int->Void)
    public let mangleName: String
    public let isAsync: Bool
    public let isThrows: Bool
    public let moduleName: String

    public init(
        parameters: [BridgeType],
        returnType: BridgeType,
        moduleName: String,
        isAsync: Bool = false,
        isThrows: Bool = false
    ) {
        self.parameters = parameters
        self.returnType = returnType
        self.moduleName = moduleName
        self.isAsync = isAsync
        self.isThrows = isThrows
        let paramPart =
            parameters.isEmpty
            ? "y"
            : parameters.map { $0.mangleTypeName }.joined()
        let signaturePart = "\(paramPart)_\(returnType.mangleTypeName)"
        self.mangleName = "\(moduleName.count)\(moduleName)\(signaturePart)"
    }
}

public enum UnsafePointerKind: String, Codable, Equatable, Hashable, Sendable {
    case unsafePointer
    case unsafeMutablePointer
    case unsafeRawPointer
    case unsafeMutableRawPointer
    case opaquePointer
}

public struct UnsafePointerType: Codable, Equatable, Hashable, Sendable {
    public let kind: UnsafePointerKind
    /// The pointee type name for generic pointer types (e.g. `UInt8` for `UnsafePointer<UInt8>`).
    public let pointee: String?

    public init(kind: UnsafePointerKind, pointee: String? = nil) {
        self.kind = kind
        self.pointee = pointee
    }
}

/// JS semantics for optional/nullable types: which value represents "absent".
public enum JSOptionalKind: String, Codable, Equatable, Hashable, Sendable {
    case null
    case undefined

    /// The JS literal for absence (e.g. in generated glue).
    public var absenceLiteral: String {
        switch self {
        case .null: return "null"
        case .undefined: return "undefined"
        }
    }

    /// JS expression that is true when the value is present. `value` is the variable name.
    public func presenceCheck(value: String) -> String {
        switch self {
        case .null: return "\(value) != null"
        case .undefined: return "\(value) !== undefined"
        }
    }
}

public enum SwiftEnumRawType: String, CaseIterable, Codable, Sendable {
    case string = "String"
    case bool = "Bool"
    case int = "Int"
    case int32 = "Int32"
    case int64 = "Int64"
    case uint = "UInt"
    case uint32 = "UInt32"
    case uint64 = "UInt64"
    case float = "Float"
    case double = "Double"

    public init?(_ rawTypeString: String?) {
        guard let rawTypeString = rawTypeString,
            let match = Self.allCases.first(where: { $0.rawValue == rawTypeString })
        else {
            return nil
        }
        self = match
    }
}

public enum BridgeType: Codable, Equatable, Hashable, Sendable {
    case int, uint, float, double, string, bool, jsObject(String?), jsValue, swiftHeapObject(String), void
    case unsafePointer(UnsafePointerType)
    indirect case nullable(BridgeType, JSOptionalKind)
    indirect case array(BridgeType)
    indirect case dictionary(BridgeType)
    case caseEnum(String)
    case rawValueEnum(String, SwiftEnumRawType)
    case associatedValueEnum(String)
    case namespaceEnum(String)
    case swiftProtocol(String)
    case swiftStruct(String)
    indirect case closure(ClosureSignature, useJSTypedClosure: Bool)
}

public enum WasmCoreType: String, Codable, Sendable {
    case i32, i64, f32, f64, pointer

    public var jsZeroLiteral: String {
        switch self {
        case .f32, .f64: return "0.0"
        case .i32, .i64, .pointer: return "0"
        }
    }

    public var swiftReturnPlaceholderStmt: String {
        switch self {
        case .i32: return "return 0"
        case .i64: return "return 0"
        case .f32: return "return 0.0"
        case .f64: return "return 0.0"
        case .pointer: return "return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped"
        }
    }
}

public struct DefaultValueField: Codable, Equatable, Sendable {
    public let name: String
    public let value: DefaultValue

    public init(name: String, value: DefaultValue) {
        self.name = name
        self.value = value
    }
}

public enum DefaultValue: Codable, Equatable, Sendable {
    case string(String)
    case int(Int)
    case float(Float)
    case double(Double)
    case bool(Bool)
    case null
    case enumCase(String, String)
    case object(String)
    case objectWithArguments(String, [DefaultValue])
    case structLiteral(String, [DefaultValueField])
    indirect case array([DefaultValue])
}

public struct Parameter: Codable, Equatable, Sendable {
    public let label: String?
    public let name: String
    public let type: BridgeType
    public let defaultValue: DefaultValue?

    public var hasDefault: Bool {
        return defaultValue != nil
    }

    public init(label: String?, name: String, type: BridgeType, defaultValue: DefaultValue? = nil) {
        self.label = label
        self.name = name
        self.type = type
        self.defaultValue = defaultValue
    }
}

public struct Effects: Codable, Equatable, Sendable {
    public var isAsync: Bool
    public var isThrows: Bool
    public var isStatic: Bool

    public init(isAsync: Bool, isThrows: Bool, isStatic: Bool = false) {
        self.isAsync = isAsync
        self.isThrows = isThrows
        self.isStatic = isStatic
    }
}

public enum StaticContext: Codable, Equatable, Sendable {
    case className(String)
    case structName(String)
    case enumName(String)
    case namespaceEnum(String)
}

// MARK: - ABI Descriptor

/// How `Optional<T>` is represented at the WASM ABI boundary.
///
/// The convention is derived from T's descriptor and determines how codegen
/// handles nullable values in both the parameter and return directions.
/// Stack ABI is the general-purpose fallback that works for any T.
public enum OptionalConvention: Sendable, Equatable {
    /// Everything goes through the stack (isSome flag + payload pushed/popped).
    /// Used for types whose base representation already uses the stack (struct, array, dictionary).
    /// This is also the default fallback for unknown types.
    case stackABI

    /// isSome is passed as an inline WASM parameter alongside T's normal parameters.
    /// For returns, T's return type carries the value (no side channel needed).
    /// Used for types with compact representations where the value space has no sentinel
    /// (bool, jsValue, closure, caseEnum, associatedValueEnum).
    case inlineFlag

    /// Return value goes through a side-channel storage variable; WASM function returns void.
    /// For parameters, behaves like `.inlineFlag` (isSome + T's params as direct WASM params).
    /// Used for scalar types where Optional return needs disambiguation (int, string, jsObject, etc.).
    case sideChannelReturn(OptionalSideChannel)
}

public enum OptionalSideChannel: Sendable, Equatable {
    case none
    case storage
    case retainedObject
}

/// A bit pattern that is never a valid value for a type, usable to represent `nil`
/// without an extra `isSome` flag. Inspired by Swift's "extra inhabitant" concept.
///
/// Types with a nil sentinel can encode Optional<T> in T's own return slot:
/// the sentinel value means absent, any other value means present.
/// Types without a sentinel need either an inline isSome flag or a side channel.
public enum NilSentinel: Sendable, Equatable {
    /// No sentinel exists - all bit patterns are valid values.
    case none
    /// A specific i32 value is never valid (e.g. 0 for object IDs, -1 for enum tags).
    case i32(Int32)
    /// A null pointer (0) is the sentinel.
    case pointer

    public var jsLiteral: String {
        switch self {
        case .none: fatalError("No sentinel value for .none")
        case .i32(let value): return "\(value)"
        case .pointer: return "0"
        }
    }

    public var hasSentinel: Bool {
        self != .none
    }
}

/// Identifies which typed optional-return storage slot a scalar type uses.
///
/// On the Swift -> JS path, Swift calls `swift_js_return_optional_<kind>(isSome, value)`
/// which writes to the corresponding `tmpRetOptional<Kind>` variable in JS.
/// On the JS -> Swift path (protocol returns), the same storage and intrinsic are used
/// unless the type has a nil sentinel (in which case the sentinel path is taken instead).
public enum OptionalScalarKind: String, Sendable {
    case bool, int, float, double

    public var storageName: String { "tmpRetOptional\(rawValue.prefix(1).uppercased())\(rawValue.dropFirst())" }
    public var funcName: String { "swift_js_return_optional_\(rawValue)" }
}

/// JS-side coercion info for simple single-value ABI types.
/// Coercion strings use `$0` as a placeholder for the value expression.
/// Grouped within the type descriptor to avoid duplicate per-BridgeType switching.
public struct JSCoercion: Sendable {
    public let liftCoerce: String?
    public let lowerCoerce: String?
    public let stackLowerCoerce: String?
    public let varHint: String
    public let optionalScalarKind: OptionalScalarKind?

    public init(
        liftCoerce: String? = nil,
        lowerCoerce: String? = nil,
        stackLowerCoerce: String? = nil,
        varHint: String,
        optionalScalarKind: OptionalScalarKind? = nil
    ) {
        self.liftCoerce = liftCoerce
        self.lowerCoerce = lowerCoerce
        self.stackLowerCoerce = stackLowerCoerce
        self.varHint = varHint
        self.optionalScalarKind = optionalScalarKind
    }

    public var effectiveStackLowerCoerce: String? {
        stackLowerCoerce ?? lowerCoerce
    }
}

/// Captures the WASM ABI shape for a ``BridgeType`` so codegen can read descriptor fields
/// instead of switching on every concrete type.
///
/// `wasmReturnType` is for the export direction (Swift->JS), `importReturnType` for import
/// (JS->Swift). They differ for types like `string` and `associatedValueEnum` where the
/// import side returns a pointer/ID while the export side uses the stack.
public struct BridgeTypeDescriptor: Sendable {
    public let wasmParams: [(name: String, type: WasmCoreType)]
    public let importParams: [(name: String, type: WasmCoreType)]
    public let wasmReturnType: WasmCoreType?
    public let importReturnType: WasmCoreType?
    public let optionalConvention: OptionalConvention
    public let nilSentinel: NilSentinel
    public let usesStackLifting: Bool
    public let accessorTransform: AccessorTransform
    public let lowerMethod: LowerMethod
    public let jsCoercion: JSCoercion?

    public init(
        wasmParams: [(name: String, type: WasmCoreType)],
        importParams: [(name: String, type: WasmCoreType)]? = nil,
        wasmReturnType: WasmCoreType?,
        importReturnType: WasmCoreType? = nil,
        optionalConvention: OptionalConvention,
        nilSentinel: NilSentinel = .none,
        usesStackLifting: Bool = false,
        accessorTransform: AccessorTransform,
        lowerMethod: LowerMethod,
        jsCoercion: JSCoercion? = nil
    ) {
        self.wasmParams = wasmParams
        self.importParams = importParams ?? wasmParams
        self.wasmReturnType = wasmReturnType
        self.importReturnType = importReturnType ?? wasmReturnType
        self.optionalConvention = optionalConvention
        self.nilSentinel = nilSentinel
        self.usesStackLifting = usesStackLifting
        self.accessorTransform = accessorTransform
        self.lowerMethod = lowerMethod
        self.jsCoercion = jsCoercion
    }
}

/// Describes how to transform a Swift accessor expression before passing it to bridge methods.
///
/// Most types use `.identity` - the value is passed as-is. Two patterns require transformation:
/// - `@JSClass` types expose their underlying `JSObject` via a `.jsObject` member.
/// - `@JS protocol` wrapper types require a downcast from the existential to the concrete wrapper.
///
/// Codegen uses this instead of switching on `jsObject(className)` / `swiftProtocol` cases.
public enum AccessorTransform: Sendable, Equatable {
    /// Pass the value unchanged (e.g. `ret`).
    case identity
    /// Access a member on the value (e.g. `ret.jsObject`). Used by `@JSClass` types.
    case member(String)
    /// Downcast the value (e.g. `(ret as! AnyDrawable)`). Used by `@JS protocol` types.
    case cast(String)

    /// Applies the transform to an accessor expression string.
    public func apply(_ accessor: String) -> String {
        switch self {
        case .identity: return accessor
        case .member(let member): return "\(accessor).\(member)"
        case .cast(let typeName): return "(\(accessor) as! \(typeName))"
        }
    }

    public var mapClosure: String? {
        switch self {
        case .identity: return nil
        case .member(let member): return "$0.\(member)"
        case .cast(let typeName): return "$0 as! \(typeName)"
        }
    }

    public var flatMapClosure: String? {
        switch self {
        case .identity: return nil
        case .member(let member): return "$0.\(member)"
        case .cast(let typeName): return "$0 as? \(typeName)"
        }
    }

    public func applyToReturnBinding(_ expr: String, isOptional: Bool) -> String {
        switch self {
        case .cast:
            if isOptional {
                return "let ret = (\(expr)).flatMap { \(flatMapClosure!) }"
            }
            return "let ret = \(apply(expr))"
        case .identity, .member:
            return "let ret = \(expr)"
        }
    }
}

/// Which bridge protocol method the codegen calls to lower a value in the export direction.
public enum LowerMethod: Sendable, Equatable {
    /// Calls `bridgeJSLowerStackReturn()` - pushes a scalar onto the stack (used within composites like optionals, struct fields).
    case stackReturn
    /// Calls `bridgeJSLowerReturn()` - serializes the entire value onto the stack (struct, array, dictionary).
    case fullReturn
    /// Calls `bridgeJSLowerParameter()` and pushes the i32 result. Used by associated value enums (tag + stack payload).
    case pushParameter
    /// No lowering (void, namespace enums).
    case none
}

extension BridgeType {
    /// The ABI descriptor for this type's non-optional representation.
    ///
    /// This is the single source of truth for how each `BridgeType` maps to WASM ABI.
    /// Codegen reads descriptor fields rather than switching on individual types.
    /// For `.nullable`, returns the wrapped type's descriptor.
    public var descriptor: BridgeTypeDescriptor {
        switch self {
        case .bool:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .inlineFlag,
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    liftCoerce: "$0 !== 0",
                    lowerCoerce: "$0 ? 1 : 0",
                    varHint: "bool",
                    optionalScalarKind: .bool
                )
            )
        case .int:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .sideChannelReturn(.none),
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    stackLowerCoerce: "($0 | 0)",
                    varHint: "int",
                    optionalScalarKind: .int
                )
            )
        case .uint:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .sideChannelReturn(.none),
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    liftCoerce: "$0 >>> 0",
                    stackLowerCoerce: "($0 | 0)",
                    varHint: "int",
                    optionalScalarKind: .int
                )
            )
        case .float:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .f32)],
                wasmReturnType: .f32,
                optionalConvention: .sideChannelReturn(.none),
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    stackLowerCoerce: "Math.fround($0)",
                    varHint: "f32",
                    optionalScalarKind: .float
                )
            )
        case .double:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .f64)],
                wasmReturnType: .f64,
                optionalConvention: .sideChannelReturn(.none),
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    varHint: "f64",
                    optionalScalarKind: .double
                )
            )
        case .string:
            return BridgeTypeDescriptor(
                wasmParams: [("bytes", .i32), ("length", .i32)],
                importParams: [("value", .i32)],
                wasmReturnType: nil,
                importReturnType: .i32,
                optionalConvention: .sideChannelReturn(.storage),
                accessorTransform: .identity,
                lowerMethod: .stackReturn
            )
        case .jsObject(let className):
            let transform: AccessorTransform =
                if let className, className != "JSObject" { .member("jsObject") } else { .identity }
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .sideChannelReturn(.retainedObject),
                nilSentinel: .i32(0),
                accessorTransform: transform,
                lowerMethod: .stackReturn
            )
        case .jsValue:
            return BridgeTypeDescriptor(
                wasmParams: [("kind", .i32), ("payload1", .i32), ("payload2", .f64)],
                wasmReturnType: nil,
                optionalConvention: .inlineFlag,
                accessorTransform: .identity,
                lowerMethod: .stackReturn
            )
        case .swiftHeapObject:
            return BridgeTypeDescriptor(
                wasmParams: [("pointer", .pointer)],
                wasmReturnType: .pointer,
                optionalConvention: .inlineFlag,
                nilSentinel: .pointer,
                accessorTransform: .identity,
                lowerMethod: .stackReturn
            )
        case .unsafePointer:
            return BridgeTypeDescriptor(
                wasmParams: [("pointer", .pointer)],
                wasmReturnType: .pointer,
                optionalConvention: .inlineFlag,
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(stackLowerCoerce: "($0 | 0)", varHint: "pointer")
            )
        case .swiftProtocol(let protocolName):
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .sideChannelReturn(.retainedObject),
                nilSentinel: .i32(0),
                accessorTransform: .cast("Any\(protocolName)"),
                lowerMethod: .stackReturn
            )
        case .caseEnum:
            return BridgeTypeDescriptor(
                wasmParams: [("value", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .inlineFlag,
                nilSentinel: .i32(-1),
                accessorTransform: .identity,
                lowerMethod: .stackReturn,
                jsCoercion: JSCoercion(
                    stackLowerCoerce: "($0 | 0)",
                    varHint: "caseId",
                    optionalScalarKind: .int
                )
            )
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return BridgeTypeDescriptor(
                    wasmParams: [("bytes", .i32), ("length", .i32)],
                    importParams: [("value", .i32)],
                    wasmReturnType: nil,
                    importReturnType: .i32,
                    optionalConvention: .sideChannelReturn(.storage),
                    accessorTransform: .identity,
                    lowerMethod: .stackReturn
                )
            case .float:
                return BridgeTypeDescriptor(
                    wasmParams: [("value", .f32)],
                    wasmReturnType: .f32,
                    optionalConvention: .sideChannelReturn(.none),
                    accessorTransform: .identity,
                    lowerMethod: .stackReturn,
                    jsCoercion: JSCoercion(
                        stackLowerCoerce: "Math.fround($0)",
                        varHint: "rawValue",
                        optionalScalarKind: .float
                    )
                )
            case .double:
                return BridgeTypeDescriptor(
                    wasmParams: [("value", .f64)],
                    wasmReturnType: .f64,
                    optionalConvention: .sideChannelReturn(.none),
                    accessorTransform: .identity,
                    lowerMethod: .stackReturn,
                    jsCoercion: JSCoercion(
                        varHint: "rawValue",
                        optionalScalarKind: .double
                    )
                )
            case .bool:
                return BridgeTypeDescriptor(
                    wasmParams: [("value", .i32)],
                    wasmReturnType: .i32,
                    optionalConvention: .inlineFlag,
                    accessorTransform: .identity,
                    lowerMethod: .stackReturn,
                    jsCoercion: JSCoercion(
                        liftCoerce: "$0 !== 0",
                        lowerCoerce: "$0 ? 1 : 0",
                        stackLowerCoerce: "$0 ? 1 : 0",
                        varHint: "rawValue",
                        optionalScalarKind: .bool
                    )
                )
            case .int, .int32, .int64, .uint, .uint32, .uint64:
                return BridgeTypeDescriptor(
                    wasmParams: [("value", .i32)],
                    wasmReturnType: .i32,
                    optionalConvention: .sideChannelReturn(.none),
                    accessorTransform: .identity,
                    lowerMethod: .stackReturn,
                    jsCoercion: JSCoercion(
                        stackLowerCoerce: "($0 | 0)",
                        varHint: "rawValue",
                        optionalScalarKind: .int
                    )
                )
            }
        case .associatedValueEnum:
            return BridgeTypeDescriptor(
                wasmParams: [("caseId", .i32)],
                wasmReturnType: nil,
                importReturnType: .i32,
                optionalConvention: .inlineFlag,
                nilSentinel: .i32(-1),
                usesStackLifting: true,
                accessorTransform: .identity,
                lowerMethod: .pushParameter
            )
        case .closure(_, _):
            return BridgeTypeDescriptor(
                wasmParams: [("funcRef", .i32)],
                wasmReturnType: .i32,
                optionalConvention: .inlineFlag,
                accessorTransform: .identity,
                lowerMethod: .stackReturn
            )
        case .swiftStruct:
            return BridgeTypeDescriptor(
                wasmParams: [],
                importParams: [("objectId", .i32)],
                wasmReturnType: nil,
                importReturnType: .i32,
                optionalConvention: .stackABI,
                usesStackLifting: true,
                accessorTransform: .identity,
                lowerMethod: .fullReturn
            )
        case .array:
            return BridgeTypeDescriptor(
                wasmParams: [],
                wasmReturnType: nil,
                optionalConvention: .stackABI,
                usesStackLifting: true,
                accessorTransform: .identity,
                lowerMethod: .fullReturn
            )
        case .dictionary:
            return BridgeTypeDescriptor(
                wasmParams: [],
                wasmReturnType: nil,
                optionalConvention: .stackABI,
                accessorTransform: .identity,
                lowerMethod: .fullReturn
            )
        case .void, .namespaceEnum:
            return BridgeTypeDescriptor(
                wasmParams: [],
                wasmReturnType: nil,
                optionalConvention: .stackABI,
                accessorTransform: .identity,
                lowerMethod: .none
            )
        case .nullable(let wrapped, _):
            return wrapped.descriptor
        }
    }

    public var needsInlineCollectionHandling: Bool {
        if case .nullable = self { return true }
        if case .closure = self { return true }
        return false
    }
}

// MARK: - BridgeType Visitor

public protocol BridgeTypeVisitor {
    mutating func visitClosure(_ signature: ClosureSignature, useJSTypedClosure: Bool)
}

public struct BridgeTypeWalker<Visitor: BridgeTypeVisitor> {
    public var visitor: Visitor

    public init(visitor: Visitor) {
        self.visitor = visitor
    }

    public mutating func walk(_ type: BridgeType) {
        switch type {
        case .closure(let signature, let useJSTypedClosure):
            visitor.visitClosure(signature, useJSTypedClosure: useJSTypedClosure)
            for paramType in signature.parameters {
                walk(paramType)
            }
            walk(signature.returnType)
        case .nullable(let wrapped, _):
            walk(wrapped)
        case .array(let element):
            walk(element)
        case .dictionary(let value):
            walk(value)
        default:
            break
        }
    }
    public mutating func walk(_ parameters: [Parameter]) {
        for param in parameters {
            walk(param.type)
        }
    }
    public mutating func walk(_ function: ExportedFunction) {
        walk(function.parameters)
        walk(function.returnType)
    }
    public mutating func walk(_ constructor: ExportedConstructor) {
        walk(constructor.parameters)
    }
    public mutating func walk(_ skeleton: ExportedSkeleton) {
        for function in skeleton.functions {
            walk(function)
        }
        for klass in skeleton.classes {
            if let constructor = klass.constructor {
                walk(constructor.parameters)
            }
            for method in klass.methods {
                walk(method)
            }
            for property in klass.properties {
                walk(property.type)
            }
        }
        for proto in skeleton.protocols {
            for method in proto.methods {
                walk(method)
            }
            for property in proto.properties {
                walk(property.type)
            }
        }
        for structDecl in skeleton.structs {
            for property in structDecl.properties {
                walk(property.type)
            }
            if let constructor = structDecl.constructor {
                walk(constructor.parameters)
            }
            for method in structDecl.methods {
                walk(method)
            }
        }
        for enumDecl in skeleton.enums {
            for enumCase in enumDecl.cases {
                for associatedValue in enumCase.associatedValues {
                    walk(associatedValue.type)
                }
            }
            for method in enumDecl.staticMethods {
                walk(method)
            }
            for property in enumDecl.staticProperties {
                walk(property.type)
            }
        }
    }
    public mutating func walk(_ function: ImportedFunctionSkeleton) {
        walk(function.parameters)
        walk(function.returnType)
    }
    public mutating func walk(_ skeleton: ImportedModuleSkeleton) {
        for fileSkeleton in skeleton.children {
            for getter in fileSkeleton.globalGetters {
                walk(getter.type)
            }
            for setter in fileSkeleton.globalSetters {
                walk(setter.type)
            }
            for function in fileSkeleton.functions {
                walk(function)
            }
            for type in fileSkeleton.types {
                if let constructor = type.constructor {
                    walk(constructor.parameters)
                }
                for getter in type.getters {
                    walk(getter.type)
                }
                for setter in type.setters {
                    walk(setter.type)
                }
                for method in type.methods + type.staticMethods {
                    walk(method)
                }
            }
        }
    }
    public mutating func walk(_ skeleton: BridgeJSSkeleton) {
        if let exported = skeleton.exported {
            walk(exported)
        }
        if let imported = skeleton.imported {
            walk(imported)
        }
    }
}

public struct ClosureSignatureCollectorVisitor: BridgeTypeVisitor {
    public var signatures: Set<ClosureSignature> = []

    public init(signatures: Set<ClosureSignature> = []) {
        self.signatures = signatures
    }

    public mutating func visitClosure(_ signature: ClosureSignature, useJSTypedClosure: Bool) {
        signatures.insert(signature)
    }
}

// MARK: - Struct Skeleton

public struct ExportedStruct: Codable, Equatable, Sendable {
    public let name: String
    public let swiftCallName: String
    public let explicitAccessControl: String?
    public var properties: [ExportedProperty]
    public var constructor: ExportedConstructor?
    public var methods: [ExportedFunction]
    public let namespace: [String]?

    public init(
        name: String,
        swiftCallName: String,
        explicitAccessControl: String?,
        properties: [ExportedProperty] = [],
        constructor: ExportedConstructor? = nil,
        methods: [ExportedFunction] = [],
        namespace: [String]?
    ) {
        self.name = name
        self.swiftCallName = swiftCallName
        self.explicitAccessControl = explicitAccessControl
        self.properties = properties
        self.constructor = constructor
        self.methods = methods
        self.namespace = namespace
    }
}

// MARK: - Enum Skeleton

public struct AssociatedValue: Codable, Equatable, Sendable {
    public let label: String?
    public let type: BridgeType

    public init(label: String?, type: BridgeType) {
        self.label = label
        self.type = type
    }
}

public struct EnumCase: Codable, Equatable, Sendable {
    public let name: String
    public let rawValue: String?
    public let associatedValues: [AssociatedValue]

    public var isSimple: Bool {
        associatedValues.isEmpty
    }
    public init(name: String, rawValue: String?, associatedValues: [AssociatedValue] = []) {
        self.name = name
        self.rawValue = rawValue
        self.associatedValues = associatedValues
    }
}

extension EnumCase {
    /// Generates JavaScript/TypeScript value representation for this enum case
    public func jsValue(rawType: SwiftEnumRawType?, index: Int) -> String {
        guard let rawType = rawType else {
            return "\(index)"
        }
        let rawValue = self.rawValue ?? self.name
        switch rawType {
        case .string:
            return "\"\(rawValue)\""
        case .bool:
            return rawValue.lowercased() == "true" ? "true" : "false"
        case .float, .double, .int, .int32, .int64, .uint, .uint32, .uint64:
            return rawValue
        }
    }
}

public enum EnumEmitStyle: String, Codable, Sendable {
    case const
    case tsEnum
}

public struct ExportedEnum: Codable, Equatable, Sendable {
    public static let valuesSuffix = "Values"
    public static let objectSuffix = "Object"

    public let name: String
    public let swiftCallName: String
    public let tsFullPath: String
    public let explicitAccessControl: String?
    public var cases: [EnumCase]
    public let rawType: SwiftEnumRawType?
    public let namespace: [String]?
    public let emitStyle: EnumEmitStyle
    public var staticMethods: [ExportedFunction]
    public var staticProperties: [ExportedProperty] = []
    public var enumType: EnumType {
        if cases.isEmpty {
            return .namespace
        } else if cases.allSatisfy(\.isSimple) {
            return rawType != nil ? .rawValue : .simple
        } else {
            return .associatedValue
        }
    }

    public var valuesName: String {
        emitStyle == .tsEnum ? name : "\(name)\(Self.valuesSuffix)"
    }

    public var objectTypeName: String {
        "\(name)\(Self.objectSuffix)"
    }

    public init(
        name: String,
        swiftCallName: String,
        tsFullPath: String,
        explicitAccessControl: String?,
        cases: [EnumCase],
        rawType: SwiftEnumRawType?,
        namespace: [String]?,
        emitStyle: EnumEmitStyle,
        staticMethods: [ExportedFunction] = [],
        staticProperties: [ExportedProperty] = []
    ) {
        self.name = name
        self.swiftCallName = swiftCallName
        self.tsFullPath = tsFullPath
        self.explicitAccessControl = explicitAccessControl
        self.cases = cases
        self.rawType = rawType
        self.namespace = namespace
        self.emitStyle = emitStyle
        self.staticMethods = staticMethods
        self.staticProperties = staticProperties
    }
}

public enum EnumType: String, Codable, Sendable {
    case simple  // enum Direction { case north, south, east }
    case rawValue  // enum Mode: String { case light = "light" }
    case associatedValue  // enum Result { case success(String), failure(Int) }
    case namespace  // enum Utils { } (empty, used as namespace)
}

// MARK: - Exported Skeleton

public struct ExportedProtocolProperty: Codable, Equatable, Sendable {
    public let name: String
    public let type: BridgeType
    public let isReadonly: Bool

    public init(
        name: String,
        type: BridgeType,
        isReadonly: Bool
    ) {
        self.name = name
        self.type = type
        self.isReadonly = isReadonly
    }
}

public struct ExportedProtocol: Codable, Equatable {
    public let name: String
    public let methods: [ExportedFunction]
    public let properties: [ExportedProtocolProperty]
    public let namespace: [String]?

    public init(
        name: String,
        methods: [ExportedFunction],
        properties: [ExportedProtocolProperty] = [],
        namespace: [String]? = nil
    ) {
        self.name = name
        self.methods = methods
        self.properties = properties
        self.namespace = namespace
    }
}

public struct ExportedFunction: Codable, Equatable, Sendable {
    public var name: String
    public var abiName: String
    public var parameters: [Parameter]
    public var returnType: BridgeType
    public var effects: Effects
    public var namespace: [String]?
    public var staticContext: StaticContext?

    public init(
        name: String,
        abiName: String,
        parameters: [Parameter],
        returnType: BridgeType,
        effects: Effects,
        namespace: [String]? = nil,
        staticContext: StaticContext? = nil
    ) {
        self.name = name
        self.abiName = abiName
        self.parameters = parameters
        self.returnType = returnType
        self.effects = effects
        self.namespace = namespace
        self.staticContext = staticContext
    }
}

public struct ExportedClass: Codable {
    public var name: String
    public var swiftCallName: String
    public var explicitAccessControl: String?
    public var constructor: ExportedConstructor?
    public var methods: [ExportedFunction]
    public var properties: [ExportedProperty]
    public var namespace: [String]?

    public init(
        name: String,
        swiftCallName: String,
        explicitAccessControl: String?,
        constructor: ExportedConstructor? = nil,
        methods: [ExportedFunction],
        properties: [ExportedProperty] = [],
        namespace: [String]? = nil
    ) {
        self.name = name
        self.swiftCallName = swiftCallName
        self.explicitAccessControl = explicitAccessControl
        self.constructor = constructor
        self.methods = methods
        self.properties = properties
        self.namespace = namespace
    }
}

public struct ExportedConstructor: Codable, Equatable, Sendable {
    public var abiName: String
    public var parameters: [Parameter]
    public var effects: Effects
    public var namespace: [String]?

    public init(abiName: String, parameters: [Parameter], effects: Effects, namespace: [String]? = nil) {
        self.abiName = abiName
        self.parameters = parameters
        self.effects = effects
        self.namespace = namespace
    }
}

public struct ExportedProperty: Codable, Equatable, Sendable {
    public var name: String
    public var type: BridgeType
    public var isReadonly: Bool
    public var isStatic: Bool
    public var namespace: [String]?
    public var staticContext: StaticContext?

    public init(
        name: String,
        type: BridgeType,
        isReadonly: Bool = false,
        isStatic: Bool = false,
        namespace: [String]? = nil,
        staticContext: StaticContext? = nil
    ) {
        self.name = name
        self.type = type
        self.isReadonly = isReadonly
        self.isStatic = isStatic
        self.namespace = namespace
        self.staticContext = staticContext
    }

    public func callName(prefix: String? = nil) -> String {
        if let staticContext = staticContext {
            switch staticContext {
            case .className(let baseName), .enumName(let baseName), .structName(let baseName),
                .namespaceEnum(let baseName):
                return "\(baseName).\(name)"
            }
        }
        if let prefix = prefix {
            return "\(prefix).\(name)"
        }
        return name
    }

    public func getterAbiName(className: String = "") -> String {
        return ABINameGenerator.generateABIName(
            baseName: name,
            namespace: namespace,
            staticContext: isStatic ? staticContext : nil,
            operation: "get",
            className: isStatic ? nil : className
        )
    }

    public func setterAbiName(className: String = "") -> String {
        return ABINameGenerator.generateABIName(
            baseName: name,
            namespace: namespace,
            staticContext: isStatic ? staticContext : nil,
            operation: "set",
            className: isStatic ? nil : className
        )
    }
}

public struct ExportedSkeleton: Codable {
    public var functions: [ExportedFunction]
    public var classes: [ExportedClass]
    public var enums: [ExportedEnum]
    public var structs: [ExportedStruct]
    public var protocols: [ExportedProtocol]
    /// Whether to expose exported APIs to the global namespace.
    ///
    /// When `true`, exported functions, classes, and namespaces are available
    /// via `globalThis` in JavaScript. When `false`, they are only available
    /// through the exports object.
    public var exposeToGlobal: Bool

    public init(
        functions: [ExportedFunction],
        classes: [ExportedClass],
        enums: [ExportedEnum],
        structs: [ExportedStruct] = [],
        protocols: [ExportedProtocol] = [],
        exposeToGlobal: Bool
    ) {
        self.functions = functions
        self.classes = classes
        self.enums = enums
        self.structs = structs
        self.protocols = protocols
        self.exposeToGlobal = exposeToGlobal
    }

    public var isEmpty: Bool {
        functions.isEmpty && classes.isEmpty && enums.isEmpty && structs.isEmpty && protocols.isEmpty
    }
}

// MARK: - Imported Skeleton

/// Controls where BridgeJS reads imported JS values from.
///
/// - `global`: Read from `globalThis`.
public enum JSImportFrom: String, Codable {
    case global
}

public struct ImportedFunctionSkeleton: Codable {
    public let name: String
    /// The JavaScript function/method name to call, if different from `name`.
    public let jsName: String?
    /// Where this function is looked up from in JavaScript.
    public let from: JSImportFrom?
    public let parameters: [Parameter]
    public let returnType: BridgeType
    public let documentation: String?

    public init(
        name: String,
        jsName: String? = nil,
        from: JSImportFrom? = nil,
        parameters: [Parameter],
        returnType: BridgeType,
        documentation: String? = nil
    ) {
        self.name = name
        self.jsName = jsName
        self.from = from
        self.parameters = parameters
        self.returnType = returnType
        self.documentation = documentation
    }

    public func abiName(context: ImportedTypeSkeleton?) -> String {
        return abiName(context: context, operation: nil)
    }

    public func abiName(context: ImportedTypeSkeleton?, operation: String?) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context,
            operation: operation
        )
    }
}

public struct ImportedConstructorSkeleton: Codable {
    public let parameters: [Parameter]

    public init(parameters: [Parameter]) {
        self.parameters = parameters
    }

    public func abiName(context: ImportedTypeSkeleton) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: "init",
            context: context
        )
    }
}

public struct ImportedGetterSkeleton: Codable {
    public let name: String
    /// The JavaScript property name to read from, if different from `name`.
    public let jsName: String?
    /// Where this property is looked up from in JavaScript (only used for global getters).
    public let from: JSImportFrom?
    public let type: BridgeType
    public let documentation: String?
    /// Name of the getter function if it's a separate function (from @JSGetter)
    public let functionName: String?

    public init(
        name: String,
        jsName: String? = nil,
        from: JSImportFrom? = nil,
        type: BridgeType,
        documentation: String? = nil,
        functionName: String? = nil
    ) {
        self.name = name
        self.jsName = jsName
        self.from = from
        self.type = type
        self.documentation = documentation
        self.functionName = functionName
    }

    public func abiName(context: ImportedTypeSkeleton?) -> String {
        if let functionName = functionName {
            return ABINameGenerator.generateImportedABIName(
                baseName: functionName,
                context: context,
                operation: nil
            )
        }
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context,
            operation: "get"
        )
    }
}

public struct ImportedSetterSkeleton: Codable {
    public let name: String
    /// The JavaScript property name to write to, if different from `name`.
    public let jsName: String?
    public let type: BridgeType
    public let documentation: String?
    /// Name of the setter function if it's a separate function (from @JSSetter)
    public let functionName: String?

    public init(
        name: String,
        jsName: String? = nil,
        type: BridgeType,
        documentation: String? = nil,
        functionName: String? = nil
    ) {
        self.name = name
        self.jsName = jsName
        self.type = type
        self.documentation = documentation
        self.functionName = functionName
    }

    public func abiName(context: ImportedTypeSkeleton?) -> String {
        if let functionName = functionName {
            return ABINameGenerator.generateImportedABIName(
                baseName: functionName,
                context: context,
                operation: nil
            )
        }
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context,
            operation: "set"
        )
    }
}

public struct ImportedTypeSkeleton: Codable {
    public let name: String
    /// The JavaScript constructor name to use for `init(...)`, if different from `name`.
    public let jsName: String?
    /// Where this constructor is looked up from in JavaScript.
    public let from: JSImportFrom?
    public let constructor: ImportedConstructorSkeleton?
    public let methods: [ImportedFunctionSkeleton]
    /// Static methods available on the JavaScript constructor.
    public var staticMethods: [ImportedFunctionSkeleton]
    public let getters: [ImportedGetterSkeleton]
    public let setters: [ImportedSetterSkeleton]
    public let documentation: String?

    public init(
        name: String,
        jsName: String? = nil,
        from: JSImportFrom? = nil,
        constructor: ImportedConstructorSkeleton? = nil,
        methods: [ImportedFunctionSkeleton] = [],
        staticMethods: [ImportedFunctionSkeleton] = [],
        getters: [ImportedGetterSkeleton] = [],
        setters: [ImportedSetterSkeleton] = [],
        documentation: String? = nil
    ) {
        self.name = name
        self.jsName = jsName
        self.from = from
        self.constructor = constructor
        self.methods = methods
        self.staticMethods = staticMethods
        self.getters = getters
        self.setters = setters
        self.documentation = documentation
    }
}

public struct ImportedFileSkeleton: Codable {
    public let functions: [ImportedFunctionSkeleton]
    public let types: [ImportedTypeSkeleton]
    /// Global-scope imported properties (e.g. `@JSGetter var console: JSConsole`)
    public let globalGetters: [ImportedGetterSkeleton]
    /// Global-scope imported properties (future use; not currently emitted by macros)
    public let globalSetters: [ImportedSetterSkeleton]

    public init(
        functions: [ImportedFunctionSkeleton],
        types: [ImportedTypeSkeleton],
        globalGetters: [ImportedGetterSkeleton] = [],
        globalSetters: [ImportedSetterSkeleton] = []
    ) {
        self.functions = functions
        self.types = types
        self.globalGetters = globalGetters
        self.globalSetters = globalSetters
    }

    private enum CodingKeys: String, CodingKey {
        case functions
        case types
        case globalGetters
        case globalSetters
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.functions = try container.decode([ImportedFunctionSkeleton].self, forKey: .functions)
        self.types = try container.decode([ImportedTypeSkeleton].self, forKey: .types)
        self.globalGetters = try container.decodeIfPresent([ImportedGetterSkeleton].self, forKey: .globalGetters) ?? []
        self.globalSetters = try container.decodeIfPresent([ImportedSetterSkeleton].self, forKey: .globalSetters) ?? []
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(functions, forKey: .functions)
        try container.encode(types, forKey: .types)
        if !globalGetters.isEmpty {
            try container.encode(globalGetters, forKey: .globalGetters)
        }
        if !globalSetters.isEmpty {
            try container.encode(globalSetters, forKey: .globalSetters)
        }
    }

    public var isEmpty: Bool {
        functions.isEmpty && types.isEmpty && globalGetters.isEmpty && globalSetters.isEmpty
    }
}

public struct ImportedModuleSkeleton: Codable {
    public var children: [ImportedFileSkeleton]

    public init(children: [ImportedFileSkeleton]) {
        self.children = children
    }
}

// MARK: - Unified Skeleton

/// Unified skeleton containing both exported and imported API definitions
public struct BridgeJSSkeleton: Codable {
    public let moduleName: String
    public let exported: ExportedSkeleton?
    public let imported: ImportedModuleSkeleton?

    public init(moduleName: String, exported: ExportedSkeleton? = nil, imported: ImportedModuleSkeleton? = nil) {
        self.moduleName = moduleName
        self.exported = exported
        self.imported = imported
    }
}

// MARK: - BridgeType Extension

extension BridgeType {
    /// Maps Swift primitive type names to BridgeType. Returns nil for unknown types.
    public init?(swiftType: String) {
        switch swiftType {
        case "Int":
            self = .int
        case "UInt":
            self = .uint
        case "Float":
            self = .float
        case "Double":
            self = .double
        case "String":
            self = .string
        case "Bool":
            self = .bool
        case "JSValue":
            self = .jsValue
        case "Void":
            self = .void
        case "JSObject":
            self = .jsObject(nil)
        case "UnsafeRawPointer":
            self = .unsafePointer(.init(kind: .unsafeRawPointer))
        case "UnsafeMutableRawPointer":
            self = .unsafePointer(.init(kind: .unsafeMutableRawPointer))
        case "OpaquePointer":
            self = .unsafePointer(.init(kind: .opaquePointer))
        default:
            return nil
        }
    }

    /// Returns true if this type is optional (nullable with null or undefined).
    public var isOptional: Bool {
        if case .nullable = self { return true }
        return false
    }

    /// Simplified Swift ABI-style mangled name
    /// https://github.com/swiftlang/swift/blob/main/docs/ABI/Mangling.rst#types
    public var mangleTypeName: String {
        switch self {
        case .int: return "Si"
        case .uint: return "Su"
        case .float: return "Sf"
        case .double: return "Sd"
        case .string: return "SS"
        case .bool: return "Sb"
        case .void: return "y"
        case .jsObject(let name):
            let typeName = name ?? "JSObject"
            return "\(typeName.count)\(typeName)C"
        case .jsValue:
            return "7JSValueV"
        case .swiftHeapObject(let name):
            return "\(name.count)\(name)C"
        case .unsafePointer(let ptr):
            func sanitize(_ s: String) -> String {
                s.filter { $0.isNumber || $0.isLetter }
            }
            let kindCode: String =
                switch ptr.kind {
                case .unsafePointer: "Sup"
                case .unsafeMutablePointer: "Sump"
                case .unsafeRawPointer: "Surp"
                case .unsafeMutableRawPointer: "Sumrp"
                case .opaquePointer: "Sop"
                }
            if let pointee = ptr.pointee, !pointee.isEmpty {
                let p = sanitize(pointee)
                return "\(kindCode)\(p.count)\(p)"
            }
            return kindCode
        case .nullable(let wrapped, let kind):
            let prefix = kind == .null ? "Sq" : "Su"
            return "\(prefix)\(wrapped.mangleTypeName)"
        case .caseEnum(let name),
            .rawValueEnum(let name, _),
            .associatedValueEnum(let name),
            .namespaceEnum(let name):
            return "\(name.count)\(name)O"
        case .swiftProtocol(let name):
            return "\(name.count)\(name)P"
        case .swiftStruct(let name):
            return "\(name.count)\(name)V"
        case .closure(let signature, let useJSTypedClosure):
            let params =
                signature.parameters.isEmpty
                ? "y"
                : signature.parameters.map { $0.mangleTypeName }.joined()
            return "K\(params)_\(signature.returnType.mangleTypeName)\(useJSTypedClosure ? "J" : "")"
        case .array(let elementType):
            // Array mangling: "Sa" prefix followed by element type
            return "Sa\(elementType.mangleTypeName)"
        case .dictionary(let valueType):
            // Dictionary mangling: "SD" prefix followed by value type (key is always String)
            return "SD\(valueType.mangleTypeName)"
        }
    }

    public var usesSideChannelForOptionalReturn: Bool {
        guard case .nullable = self else { return false }
        if case .sideChannelReturn = descriptor.optionalConvention { return true }
        return false
    }
}
