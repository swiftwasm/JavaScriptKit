#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

/// The `@available` attributes of the `@JS` and `@JSClass` types of a module and its dependencies.
public struct AvailabilityIndex {
    public static var empty: AvailabilityIndex { AvailabilityIndex(skeletons: []) }

    private static let uniqueArrayAvailability = "@available(anyAppleOS 27.0, *)"

    private var attributesByTypeName: [String: [String]] = [:]

    /// Indexes the types of `skeletons`; a type name that several of them declare keeps the first one's attributes.
    public init(skeletons: [BridgeJSSkeleton]) {
        func register(_ name: String, _ availability: [String]?) {
            guard let availability, attributesByTypeName[name] == nil else { return }
            attributesByTypeName[name] = availability
        }
        for skeleton in skeletons {
            if let exported = skeleton.exported {
                for klass in exported.classes { register(klass.swiftCallName, klass.availability) }
                for structDef in exported.structs { register(structDef.swiftCallName, structDef.availability) }
                for enumDef in exported.enums { register(enumDef.swiftCallName, enumDef.availability) }
                for proto in exported.protocols { register(proto.name, proto.availability) }
                for alias in exported.aliases { register(alias.swiftCallName, alias.availability) }
            }
            for file in skeleton.imported?.children ?? [] {
                for type in file.types { register(type.name, type.availability) }
            }
        }
    }

    /// The attributes a generated declaration needs when it names `types`.
    func attributes(for types: [BridgeType]) -> [String] {
        var attributes: [String] = []
        func add(_ name: String) {
            for attribute in attributesByTypeName[name] ?? [] where !attributes.contains(attribute) {
                attributes.append(attribute)
            }
        }
        func visit(_ type: BridgeType) {
            switch type {
            case .swiftHeapObject(let name), .swiftStruct(let name), .swiftProtocol(let name), .caseEnum(let name),
                .rawValueEnum(let name, _), .associatedValueEnum(let name), .namespaceEnum(let name),
                .jsObject(let name?), .jsUniqueObject(let name?):
                add(name)
            case .alias(let name, let underlying):
                add(name)
                visit(underlying)
            case .array(let element):
                if element.isNoncopyable, !attributes.contains(Self.uniqueArrayAvailability) {
                    attributes.append(Self.uniqueArrayAvailability)
                }
                visit(element)
            case .nullable(let wrapped, _):
                visit(wrapped)
            case .dictionary(let value):
                visit(value)
            case .closure(let signature, _):
                signature.parameters.forEach(visit)
                visit(signature.returnType)
            case .integer, .float, .double, .string, .bool, .jsObject(nil), .jsValue, .void, .jsUniqueObject(nil),
                .unsafePointer, .generic:
                break
            }
        }
        types.forEach(visit)
        return attributes
    }
}
