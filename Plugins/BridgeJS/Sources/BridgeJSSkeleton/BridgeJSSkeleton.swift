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

public enum BridgeType: Codable, Equatable, Hashable, Sendable {
    case int, uint, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
    case unsafePointer(UnsafePointerType)
    indirect case nullable(BridgeType, JSOptionalKind)
    indirect case array(BridgeType)
    case caseEnum(String)
    case rawValueEnum(String, SwiftEnumRawType)
    case associatedValueEnum(String)
    case namespaceEnum(String)
    case swiftProtocol(String)
    case swiftStruct(String)
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

/// Represents a struct field with name and default value for default parameter values
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
    case enumCase(String, String)  // enumName, caseName
    case object(String)  // className for parameterless constructor
    case objectWithArguments(String, [DefaultValue])  // className, constructor argument values
    case structLiteral(String, [DefaultValueField])  // structName, field name/value pairs
    indirect case array([DefaultValue])  // array literal with element values
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
    case structName(String)
    case enumName(String)
    case namespaceEnum(String)
}

// MARK: - Struct Skeleton

public struct StructField: Codable, Equatable, Sendable {
    public let name: String
    public let type: BridgeType

    public init(name: String, type: BridgeType) {
        self.name = name
        self.type = type
    }
}

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

    public mutating func append(_ other: ExportedSkeleton) {
        self.functions.append(contentsOf: other.functions)
        self.classes.append(contentsOf: other.classes)
        self.enums.append(contentsOf: other.enums)
        self.structs.append(contentsOf: other.structs)
        self.protocols.append(contentsOf: other.protocols)
        assert(self.exposeToGlobal == other.exposeToGlobal)
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
        return ABINameGenerator.generateImportedABIName(
            baseName: name,
            context: context
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
    public let getters: [ImportedGetterSkeleton]
    public let setters: [ImportedSetterSkeleton]
    public let documentation: String?

    public init(
        name: String,
        jsName: String? = nil,
        from: JSImportFrom? = nil,
        constructor: ImportedConstructorSkeleton? = nil,
        methods: [ImportedFunctionSkeleton],
        getters: [ImportedGetterSkeleton] = [],
        setters: [ImportedSetterSkeleton] = [],
        documentation: String? = nil
    ) {
        self.name = name
        self.jsName = jsName
        self.from = from
        self.constructor = constructor
        self.methods = methods
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

// MARK: - BridgeType extension

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

    public var abiReturnType: WasmCoreType? {
        switch self {
        case .void: return nil
        case .bool: return .i32
        case .int, .uint: return .i32
        case .float: return .f32
        case .double: return .f64
        case .string: return nil
        case .jsObject: return .i32
        case .swiftHeapObject:
            // UnsafeMutableRawPointer is returned as an i32 pointer
            return .pointer
        case .unsafePointer:
            return .pointer
        case .nullable:
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
        case .swiftStruct:
            // Structs use stack-based return (no direct WASM return type)
            return nil
        case .closure:
            // Closures pass callback ID as Int32
            return .i32
        case .array:
            // Arrays use stack-based return with length prefix (no direct WASM return type)
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
        case .closure(let signature):
            let params =
                signature.parameters.isEmpty
                ? "y"
                : signature.parameters.map { $0.mangleTypeName }.joined()
            return "K\(params)_\(signature.returnType.mangleTypeName)"
        case .array(let elementType):
            // Array mangling: "Sa" prefix followed by element type
            return "Sa\(elementType.mangleTypeName)"
        }
    }

    /// Determines if an optional type requires side-channel communication for protocol property returns
    ///
    /// Side channels are needed when the wrapped type cannot be directly returned via WASM,
    /// or when we need to distinguish null from absent value for certain primitives.
    public func usesSideChannelForOptionalReturn() -> Bool {
        guard case .nullable(let wrappedType, _) = self else {
            return false
        }

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
