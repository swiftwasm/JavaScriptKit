#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

/// Index of `@JS` types from dependencies.
public struct ExternalModuleIndex {
    public struct ExternalType: Equatable {
        public let moduleName: String
        public let bridgeType: BridgeType
    }

    public enum LookupResult: Equatable {
        case unique(ExternalType)
        case ambiguous(candidates: [ExternalType])
    }

    public static var empty: ExternalModuleIndex {
        ExternalModuleIndex(dependencies: [])
    }

    private let byModuleAndPath: [String: [String: ExternalType]]
    private let byPath: [String: [ExternalType]]
    /// Dot-paths that name a *namespace* (empty `@JS enum`) rather than a value type, mapped to
    /// the modules that declare them. Kept separately from value types precisely so that using
    /// one in a value position can be diagnosed as "X is a namespace" rather than reported as an
    /// unknown type - the declaration identity is retained even though there is no value ABI.
    private let namespacesByPath: [String: Set<String>]
    private let namespacesByModule: [String: Set<String>]

    public var moduleNames: Set<String> { Set(byModuleAndPath.keys) }

    public init(dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)]) {
        var entriesByModule: [String: [String: ExternalType]] = [:]
        var entriesByDotPath: [String: [ExternalType]] = [:]
        var namespacesByPath: [String: Set<String>] = [:]
        var namespacesByModule: [String: Set<String>] = [:]

        for (moduleName, skeleton) in dependencies {
            guard let exported = skeleton.exported else { continue }
            var moduleEntries = entriesByModule[moduleName] ?? [:]

            func register(dotPath: String, bridgeType: BridgeType) {
                let externalType = ExternalType(moduleName: moduleName, bridgeType: bridgeType)
                if moduleEntries[dotPath] == nil {
                    moduleEntries[dotPath] = externalType
                    entriesByDotPath[dotPath, default: []].append(externalType)
                }
            }

            for klass in exported.classes {
                register(dotPath: klass.swiftCallName, bridgeType: .swiftHeapObject(klass.swiftCallName))
            }
            for structDef in exported.structs {
                register(dotPath: structDef.swiftCallName, bridgeType: .swiftStruct(structDef.swiftCallName))
            }
            for enumDef in exported.enums {
                let bridgeType: BridgeType
                switch enumDef.enumType {
                case .simple:
                    bridgeType = .caseEnum(enumDef.swiftCallName)
                case .rawValue:
                    guard let rawType = enumDef.rawType else { continue }
                    bridgeType = .rawValueEnum(enumDef.swiftCallName, rawType)
                case .associatedValue:
                    bridgeType = .associatedValueEnum(enumDef.swiftCallName)
                case .namespace:
                    // A namespace has no value type, so it registers no resolvable value. But we
                    // keep its identity, so a value-position use gets a helpful "X is a
                    // namespace" diagnostic instead of a generic "unknown type".
                    namespacesByPath[enumDef.swiftCallName, default: []].insert(moduleName)
                    namespacesByModule[moduleName, default: []].insert(enumDef.swiftCallName)
                    continue
                }
                register(dotPath: enumDef.swiftCallName, bridgeType: bridgeType)
            }
            for proto in exported.protocols {
                register(dotPath: proto.name, bridgeType: .swiftProtocol(proto.name))
            }
            for alias in exported.aliases {
                register(
                    dotPath: alias.swiftCallName,
                    bridgeType: .alias(name: alias.swiftCallName, underlying: alias.underlying)
                )
            }

            entriesByModule[moduleName] = moduleEntries
        }

        self.byModuleAndPath = entriesByModule
        self.byPath = entriesByDotPath
        self.namespacesByPath = namespacesByPath
        self.namespacesByModule = namespacesByModule
    }

    public var isEmpty: Bool { byModuleAndPath.isEmpty }

    public func isKnownModule(_ name: String) -> Bool {
        byModuleAndPath[name] != nil
    }

    public func lookup(dotPath: String) -> LookupResult? {
        guard let matches = byPath[dotPath], !matches.isEmpty else { return nil }
        if matches.count == 1 {
            return .unique(matches[0])
        }
        return .ambiguous(candidates: matches)
    }

    public func lookup(dotPath: String, module moduleName: String) -> LookupResult? {
        guard let moduleEntries = byModuleAndPath[moduleName] else { return nil }
        guard let externalType = moduleEntries[dotPath] else { return nil }
        return .unique(externalType)
    }

    /// Whether `dotPath` names a known external namespace (in `module` if given, else any).
    public func isNamespace(dotPath: String, module moduleName: String?) -> Bool {
        if let moduleName {
            return namespacesByModule[moduleName]?.contains(dotPath) ?? false
        }
        return namespacesByPath[dotPath] != nil
    }
}
