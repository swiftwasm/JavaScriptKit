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

    public var moduleNames: Set<String> { Set(byModuleAndPath.keys) }

    public init(dependencies: [(moduleName: String, skeleton: BridgeJSSkeleton)]) {
        var entriesByModule: [String: [String: ExternalType]] = [:]
        var entriesByDotPath: [String: [ExternalType]] = [:]

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
                    bridgeType = .namespaceEnum(enumDef.swiftCallName)
                }
                register(dotPath: enumDef.swiftCallName, bridgeType: bridgeType)
            }
            for proto in exported.protocols {
                register(dotPath: proto.name, bridgeType: .swiftProtocol(proto.name))
            }

            entriesByModule[moduleName] = moduleEntries
        }

        self.byModuleAndPath = entriesByModule
        self.byPath = entriesByDotPath
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
}
