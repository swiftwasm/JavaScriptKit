// This file is shared between BridgeTool and BridgeJSLink

// MARK: - Types

public enum BridgeType: Codable, Equatable, Sendable {
    case int, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
    indirect case optional(BridgeType)
    case caseEnum(String)
    case rawValueEnum(String, SwiftEnumRawType)
    case associatedValueEnum(String)
    case namespaceEnum(String)
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

    public static func from(_ rawTypeString: String) -> SwiftEnumRawType? {
        return Self.allCases.first { $0.rawValue == rawTypeString }
    }

    public static func formatValue(_ rawValue: String, rawType: String) -> String {
        if let enumType = from(rawType) {
            switch enumType {
            case .string:
                return "\"\(rawValue)\""
            case .bool:
                return rawValue.lowercased() == "true" ? "true" : "false"
            case .float, .double, .int, .int32, .int64, .uint, .uint32, .uint64:
                return rawValue
            }
        } else {
            return rawValue
        }
    }
}

public struct Parameter: Codable, Equatable, Sendable {
    public let label: String?
    public let name: String
    public let type: BridgeType

    public init(label: String?, name: String, type: BridgeType) {
        self.label = label
        self.name = name
        self.type = type
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
    case namespaceEnum(String)
    case explicitNamespace([String])
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

public enum EnumEmitStyle: String, Codable, Sendable {
    case const
    case tsEnum
}

public struct ExportedEnum: Codable, Equatable, Sendable {
    public let name: String
    public let swiftCallName: String
    public let explicitAccessControl: String?
    public let cases: [EnumCase]
    public let rawType: String?
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
        rawType: String?,
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
    public var isStatic: Bool = false
    public var staticContext: StaticContext?

    public init(name: String, type: BridgeType, isReadonly: Bool = false, isStatic: Bool = false, staticContext: StaticContext? = nil) {
        self.name = name
        self.type = type
        self.isReadonly = isReadonly
        self.isStatic = isStatic
        self.staticContext = staticContext
    }

    public func getterAbiName(className: String) -> String {
        if isStatic, let staticContext = staticContext {
            // Generate context-aware ABI names for static properties
            switch staticContext {
            case .className(let className):
                return "bjs_\(className)_static_\(name)_get"
            case .enumName(let enumName):
                return "bjs_\(enumName)_static_\(name)_get"
            case .namespaceEnum(let enumName):
                // Convert dots to underscores for namespace enums
                let abiEnumName = enumName.split(separator: ".").joined(separator: "_")
                return "bjs_\(abiEnumName)_static_\(name)_get"
            case .explicitNamespace(let namespace):
                let abiNamespace = namespace.joined(separator: "_")
                return "bjs_\(abiNamespace)_static_\(name)_get"
            }
        } else if isStatic {
            return "bjs_\(className)_static_\(name)_get"
        } else {
            return "bjs_\(className)_\(name)_get"
        }
    }

    public func setterAbiName(className: String) -> String {
        if isStatic, let staticContext = staticContext {
            // Generate context-aware ABI names for static properties
            switch staticContext {
            case .className(let className):
                return "bjs_\(className)_static_\(name)_set"
            case .enumName(let enumName):
                return "bjs_\(enumName)_static_\(name)_set"
            case .namespaceEnum(let enumName):
                // Convert dots to underscores for namespace enums
                let abiEnumName = enumName.split(separator: ".").joined(separator: "_")
                return "bjs_\(abiEnumName)_static_\(name)_set"
            case .explicitNamespace(let namespace):
                let abiNamespace = namespace.joined(separator: "_")
                return "bjs_\(abiNamespace)_static_\(name)_set"
            }
        } else if isStatic {
            return "bjs_\(className)_static_\(name)_set"
        } else {
            return "bjs_\(className)_\(name)_set"
        }
    }
}

public struct ExportedSkeleton: Codable {
    public let moduleName: String
    public let functions: [ExportedFunction]
    public let classes: [ExportedClass]
    public let enums: [ExportedEnum]

    public init(moduleName: String, functions: [ExportedFunction], classes: [ExportedClass], enums: [ExportedEnum]) {
        self.moduleName = moduleName
        self.functions = functions
        self.classes = classes
        self.enums = enums
    }
}

// MARK: - Imported Skeleton

public struct ImportedFunctionSkeleton: Codable {
    public let name: String
    public let parameters: [Parameter]
    public let returnType: BridgeType
    public let documentation: String?

    public func abiName(context: ImportedTypeSkeleton?) -> String {
        return context.map { "bjs_\($0.name)_\(name)" } ?? "bjs_\(name)"
    }
}

public struct ImportedConstructorSkeleton: Codable {
    public let parameters: [Parameter]

    public func abiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_init"
    }
}

public struct ImportedPropertySkeleton: Codable {
    public let name: String
    public let isReadonly: Bool
    public let type: BridgeType
    public let documentation: String?

    public func getterAbiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_\(name)_get"
    }

    public func setterAbiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_\(name)_set"
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
        }
    }

    /// Returns true if this type is optional
    public var isOptional: Bool {
        if case .optional = self { return true }
        return false
    }
}
