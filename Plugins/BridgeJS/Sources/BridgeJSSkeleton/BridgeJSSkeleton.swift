// This file is shared between BridgeTool and BridgeJSLink

// MARK: - Types

public enum Constants {
    public static let supportedRawTypes = [
        "String", "Bool", "Int", "Int32", "Int64", "UInt", "UInt32", "UInt64", "Float", "Double",
    ]
}

public enum BridgeType: Codable, Equatable {
    case int, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
    case caseEnum(String)
    case rawValueEnum(String, String)
    case associatedValueEnum(String)
    case namespaceEnum(String)
}

public enum WasmCoreType: String, Codable {
    case i32, i64, f32, f64, pointer
}

public struct Parameter: Codable {
    public let label: String?
    public let name: String
    public let type: BridgeType

    public init(label: String?, name: String, type: BridgeType) {
        self.label = label
        self.name = name
        self.type = type
    }
}

public struct Effects: Codable {
    public var isAsync: Bool
    public var isThrows: Bool

    public init(isAsync: Bool, isThrows: Bool) {
        self.isAsync = isAsync
        self.isThrows = isThrows
    }
}

// MARK: - Enum Skeleton

public struct AssociatedValue: Codable, Equatable {
    public let label: String?
    public let type: BridgeType

    public init(label: String?, type: BridgeType) {
        self.label = label
        self.type = type
    }
}

public struct EnumCase: Codable, Equatable {
    public let name: String
    public let rawValue: String?
    public let associatedValues: [AssociatedValue]

    public var isSimple: Bool {
        associatedValues.isEmpty
    }

    public init(name: String, rawValue: String?, associatedValues: [AssociatedValue]) {
        self.name = name
        self.rawValue = rawValue
        self.associatedValues = associatedValues
    }
}

public struct ExportedEnum: Codable, Equatable {
    public let name: String
    public let cases: [EnumCase]
    public let rawType: String?
    public let namespace: [String]?
    public let nestedTypes: [String]

    public var enumType: EnumType {
        if cases.isEmpty {
            return .namespace
        } else if cases.allSatisfy(\.isSimple) {
            return rawType != nil ? .rawValue : .simple
        } else {
            return .associatedValue
        }
    }

    public init(name: String, cases: [EnumCase], rawType: String?, namespace: [String]?, nestedTypes: [String]) {
        self.name = name
        self.cases = cases
        self.rawType = rawType
        self.namespace = namespace
        self.nestedTypes = nestedTypes
    }
}

public enum EnumType: String, Codable {
    case simple  // enum Direction { case north, south, east }
    case rawValue  // enum Mode: String { case light = "light" }
    case associatedValue  // enum Result { case success(String), failure(Int) }
    case namespace  // enum Utils { } (empty, used as namespace)
}

// MARK: - Exported Skeleton

public struct ExportedFunction: Codable {
    public var name: String
    public var abiName: String
    public var parameters: [Parameter]
    public var returnType: BridgeType
    public var effects: Effects
    public var namespace: [String]?

    public init(
        name: String,
        abiName: String,
        parameters: [Parameter],
        returnType: BridgeType,
        effects: Effects,
        namespace: [String]? = nil
    ) {
        self.name = name
        self.abiName = abiName
        self.parameters = parameters
        self.returnType = returnType
        self.effects = effects
        self.namespace = namespace
    }
}

public struct ExportedClass: Codable {
    public var name: String
    public var constructor: ExportedConstructor?
    public var methods: [ExportedFunction]
    public var namespace: [String]?

    public init(
        name: String,
        constructor: ExportedConstructor? = nil,
        methods: [ExportedFunction],
        namespace: [String]? = nil
    ) {
        self.name = name
        self.constructor = constructor
        self.methods = methods
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
        case .caseEnum:
            return .i32
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case "String":
                return nil  // String uses special handling
            case "Bool", "Int", "Int32", "UInt", "UInt32":
                return .i32
            case "Int64", "UInt64":
                return .i64
            case "Float":
                return .f32
            case "Double":
                return .f64
            default:
                return nil
            }
        case .associatedValueEnum:
            return nil
        case .namespaceEnum:
            return nil
        }
    }

    /// Returns the Swift type name for this bridge type
    var swiftTypeName: String {
        switch self {
        case .void: return "Void"
        case .bool: return "Bool"
        case .int: return "Int"
        case .float: return "Float"
        case .double: return "Double"
        case .string: return "String"
        case .jsObject(let name): return name ?? "JSObject"
        case .swiftHeapObject(let name): return name
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .namespaceEnum(let name): return name
        }
    }

    /// Returns the TypeScript type name for this bridge type
    var tsTypeName: String {
        switch self {
        case .void: return "void"
        case .bool: return "boolean"
        case .int, .float, .double: return "number"
        case .string: return "string"
        case .jsObject(let name): return name ?? "any"
        case .swiftHeapObject(let name): return name
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .namespaceEnum(let name): return name
        }
    }
}
