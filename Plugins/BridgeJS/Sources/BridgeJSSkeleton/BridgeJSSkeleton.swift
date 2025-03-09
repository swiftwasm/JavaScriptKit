// This file is shared between BridgeTool and BridgeJSLink

// MARK: - Types

enum BridgeType: Codable, Equatable {
    case int, float, double, string, bool, jsObject(String?), swiftHeapObject(String), void
}

enum WasmCoreType: String, Codable {
    case i32, i64, f32, f64, pointer
}

struct Parameter: Codable {
    let label: String?
    let name: String
    let type: BridgeType
}

// MARK: - Exported Skeleton

struct ExportedFunction: Codable {
    var name: String
    var abiName: String
    var parameters: [Parameter]
    var returnType: BridgeType
}

struct ExportedClass: Codable {
    var name: String
    var constructor: ExportedConstructor?
    var methods: [ExportedFunction]
}

struct ExportedConstructor: Codable {
    var abiName: String
    var parameters: [Parameter]
}

struct ExportedSkeleton: Codable {
    let functions: [ExportedFunction]
    let classes: [ExportedClass]
}

// MARK: - Imported Skeleton

struct ImportedFunctionSkeleton: Codable {
    let name: String
    let parameters: [Parameter]
    let returnType: BridgeType
    let documentation: String?

    func abiName(context: ImportedTypeSkeleton?) -> String {
        return context.map { "bjs_\($0.name)_\(name)" } ?? "bjs_\(name)"
    }
}

struct ImportedConstructorSkeleton: Codable {
    let parameters: [Parameter]

    func abiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_init"
    }
}

struct ImportedPropertySkeleton: Codable {
    let name: String
    let isReadonly: Bool
    let type: BridgeType
    let documentation: String?

    func getterAbiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_\(name)_get"
    }

    func setterAbiName(context: ImportedTypeSkeleton) -> String {
        return "bjs_\(context.name)_\(name)_set"
    }
}

struct ImportedTypeSkeleton: Codable {
    let name: String
    let constructor: ImportedConstructorSkeleton?
    let methods: [ImportedFunctionSkeleton]
    let properties: [ImportedPropertySkeleton]
    let documentation: String?
}

struct ImportedFileSkeleton: Codable {
    let functions: [ImportedFunctionSkeleton]
    let types: [ImportedTypeSkeleton]
}

struct ImportedModuleSkeleton: Codable {
    let moduleName: String
    let children: [ImportedFileSkeleton]
}
