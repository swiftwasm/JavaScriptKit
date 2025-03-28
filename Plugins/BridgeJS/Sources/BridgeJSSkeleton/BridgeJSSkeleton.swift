enum BridgeType: Codable, Equatable {
    case int, float, double, string, bool, jsObject, swiftHeapObject(String), void
}

enum WasmCoreType: String, Codable {
    case i32, i64, f32, f64, pointer
}

struct Parameter: Codable {
    let label: String?
    let name: String
    let type: BridgeType
}

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

struct ImportedFunction: Codable {
    let name: String
    let parameters: [Parameter]
    let returnType: BridgeType
}

struct ImportedSkeleton: Codable {
    let functions: [ImportedFunction]
}
