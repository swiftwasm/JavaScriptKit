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
            case .className(let name), .enumName(let name):
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

public enum BridgeType: Codable, Equatable, Hashable, Sendable {
    case int, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
    indirect case optional(BridgeType)
    case caseEnum(String)
    case rawValueEnum(String, SwiftEnumRawType)
    case associatedValueEnum(String)
    case namespaceEnum(String)
    case swiftProtocol(String)
    indirect case closure(ClosureSignature)
}

public enum WasmCoreType: String, Codable, Sendable {
    case i32, i64, f32, f64, pointer
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

    public var wasmCoreType: WasmCoreType? {
        switch self {
        case .string:
            return nil
        case .bool, .int, .int32, .uint, .uint32:
            return .i32
        case .int64, .uint64:
            return .i64
        case .float:
            return .f32
        case .double:
            return .f64
        }
    }

    public init?(_ rawTypeString: String?) {
        guard let rawTypeString = rawTypeString,
            let match = Self.allCases.first(where: { $0.rawValue == rawTypeString })
        else {
            return nil
        }
        self = match
    }
}

public enum DefaultValue: Codable, Equatable, Sendable {
    case string(String)
    case int(Int)
    case float(Float)
    case double(Double)
    case bool(Bool)
    case null
    case enumCase(String, String)  // enumName, caseName
    case object(String)  // className for parameterless constructor
    case objectWithArguments(String, [DefaultValue])  // className, constructor argument values
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

// MARK: - Static Function Context

public enum StaticContext: Codable, Equatable, Sendable {
    case className(String)
    case enumName(String)
    case namespaceEnum
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
    public let name: String
    public let swiftCallName: String
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

    public init(
        name: String,
        swiftCallName: String,
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

public struct ExportedConstructor: Codable {
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
            case .className(let baseName), .enumName(let baseName):
                return "\(baseName).\(name)"
            case .namespaceEnum:
                if let namespace = namespace, !namespace.isEmpty {
                    let namespacePath = namespace.joined(separator: ".")
                    return "\(namespacePath).\(name)"
                }
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
    public let moduleName: String
    public let functions: [ExportedFunction]
    public let classes: [ExportedClass]
    public let enums: [ExportedEnum]
    public let protocols: [ExportedProtocol]

    public init(
        moduleName: String,
        functions: [ExportedFunction],
        classes: [ExportedClass],
        enums: [ExportedEnum],
        protocols: [ExportedProtocol] = []
    ) {
        self.moduleName = moduleName
        self.functions = functions
        self.classes = classes
        self.enums = enums
        self.protocols = protocols
    }
}

// MARK: - Imported Skeleton

public struct ImportedFunctionSkeleton: Codable {
    public let name: String
    public let parameters: [Parameter]
    public let returnType: BridgeType
    public let documentation: String?

    public func abiName(context: ImportedTypeSkeleton?) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context
        )
    }
}

public struct ImportedConstructorSkeleton: Codable {
    public let parameters: [Parameter]

    public func abiName(context: ImportedTypeSkeleton) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: "init",
            context: context
        )
    }
}

public struct ImportedPropertySkeleton: Codable {
    public let name: String
    public let isReadonly: Bool
    public let type: BridgeType
    public let documentation: String?

    public func getterAbiName(context: ImportedTypeSkeleton) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context,
            operation: "get"
        )
    }

    public func setterAbiName(context: ImportedTypeSkeleton) -> String {
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context,
            operation: "set"
        )
    }
}

public struct ImportedTypeSkeleton: Codable {
    public let name: String
    public let constructor: ImportedConstructorSkeleton?
    public let methods: [ImportedFunctionSkeleton]
    public let properties: [ImportedPropertySkeleton]
    public let documentation: String?
}

public struct ImportedFileSkeleton: Codable {
    public let functions: [ImportedFunctionSkeleton]
    public let types: [ImportedTypeSkeleton]
}

public struct ImportedModuleSkeleton: Codable {
    public let moduleName: String
    public var children: [ImportedFileSkeleton]

    public init(moduleName: String, children: [ImportedFileSkeleton]) {
        self.moduleName = moduleName
        self.children = children
    }
}

// MARK: - BridgeType extension

extension BridgeType {
    public var abiReturnType: WasmCoreType? {
        switch self {
        case .void: return nil
        case .bool: return .i32
        case .int: return .i32
        case .float: return .f32
        case .double: return .f64
        case .string: return nil
        case .jsObject: return .i32
        case .swiftHeapObject:
            // UnsafeMutableRawPointer is returned as an i32 pointer
            return .pointer
        case .optional(_):
            return nil
        case .caseEnum:
            return .i32
        case .rawValueEnum(_, let rawType):
            return rawType.wasmCoreType
        case .associatedValueEnum:
            return nil
        case .namespaceEnum:
            return nil
        case .swiftProtocol:
            // Protocols pass JSObject IDs as Int32
            return .i32
        case .closure:
            // Closures pass callback ID as Int32
            return .i32
        }
    }

    /// Returns true if this type is optional
    public var isOptional: Bool {
        if case .optional = self { return true }
        return false
    }

    /// Simplified Swift ABI-style mangled name
    /// https://github.com/swiftlang/swift/blob/main/docs/ABI/Mangling.rst#types
    public var mangleTypeName: String {
        switch self {
        case .int: return "Si"
        case .float: return "Sf"
        case .double: return "Sd"
        case .string: return "SS"
        case .bool: return "Sb"
        case .void: return "y"
        case .jsObject(let name):
            let typeName = name ?? "JSObject"
            return "\(typeName.count)\(typeName)C"
        case .swiftHeapObject(let name):
            return "\(name.count)\(name)C"
        case .optional(let wrapped):
            return "Sq\(wrapped.mangleTypeName)"
        case .caseEnum(let name),
            .rawValueEnum(let name, _),
            .associatedValueEnum(let name),
            .namespaceEnum(let name):
            return "\(name.count)\(name)O"
        case .swiftProtocol(let name):
            return "\(name.count)\(name)P"
        case .closure(let signature):
            let params =
                signature.parameters.isEmpty
                ? "y"
                : signature.parameters.map { $0.mangleTypeName }.joined()
            return "K\(params)_\(signature.returnType.mangleTypeName)"
        }
    }

    /// Determines if an optional type requires side-channel communication for protocol property returns
    ///
    /// Side channels are needed when the wrapped type cannot be directly returned via WASM,
    /// or when we need to distinguish null from absent value for certain primitives.
    public func usesSideChannelForOptionalReturn() -> Bool {
        guard case .optional(let wrappedType) = self else { return false }

        switch wrappedType {
        case .string, .int, .float, .double, .jsObject, .swiftProtocol:
            return true
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string, .int, .float, .double:
                return true
            default:
                return false
            }
        case .bool, .caseEnum, .swiftHeapObject, .associatedValueEnum:
            return false
        default:
            return false
        }
    }
}
