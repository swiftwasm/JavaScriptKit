// This file is shared between BridgeTool and BridgeJSLink

// MARK: - Types

public enum BridgeType: Codable, Equatable {
    case int, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
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

    public init(moduleName: String, functions: [ExportedFunction], classes: [ExportedClass]) {
        self.moduleName = moduleName
        self.functions = functions
        self.classes = classes
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
        }
    }
}
