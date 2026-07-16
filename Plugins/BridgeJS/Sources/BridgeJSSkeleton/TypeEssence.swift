// The structural essence of a bridged type.
//
// `BridgeType` has ~20 cases, and historically each surface facet (Swift spelling, TypeScript
// spelling, mangled name) was its own ~20-arm `switch`, scattered across the tools. Adding a
// type meant editing every one of them.
//
// This file replaces that with the shape the enum was really hiding: every `BridgeType` reduces
// to one of a handful of *structural classes*, and each facet is *derived* from that essence by
// one general rule rather than re-spelled per case.
//
//   - **scalar** - a leaf that is fully described by three names (Swift, TS, mangled). Adding a
//     scalar is one essence entry; the derivations read those names and need no new arm.
//   - **nominal** - a named user type with a *kind*. The kind alone determines the mangling
//     suffix (V/O/P/C), the Swift spelling (`name`, or `Any<name>` for a protocol), and the TS
//     spelling (`name`, `<name>Tag`, or a typed-array name). Adding a nominal instance is pure
//     data; adding a nominal *kind* is one arm in each per-kind rule, all in this file.
//   - **combinators** (optional/array/dictionary/closure) - built from other types; every facet
//     folds over the children.
//
// `alias` is deliberately kept out of `nominal`: it is a transparent `@JS(as:)` newtype - a
// named view of another type, carrying no ABI of its own - not a value nominal in its own
// right. (Namespace enums, which are not values at all, are rejected at the parser and are not
// a `BridgeType` case: you can never have a value of one.)
//
// So the general rules switch on a handful of structural classes, not 20 type cases, and
// `essence(of:)` is the single place that maps a `BridgeType` to its essence.

// MARK: - Essence model

public enum TypeEssence {
    // -- value types: things that actually cross the boundary with an ABI --
    case scalar(ScalarEssence)
    case nominal(NominalEssence)
    case optional(BridgeType, JSOptionalKind)
    case array(BridgeType)
    case dictionary(BridgeType)
    case closure(ClosureSignature, useJSTypedClosure: Bool)
    case void

    // -- not a value --

    /// A transparent newtype: `@JS(as: T) struct Name`. It is a value, but a *view* of another
    /// value type - its own Swift name, but its underlying type's wire representation. Kept
    /// separate from `nominal` because it carries no ABI of its own; everything folds to
    /// `underlying`.
    case alias(name: String, underlying: BridgeType)
}

/// A leaf type described entirely by its spellings. There is nothing to derive - these are the
/// irreducible facts, so a scalar is a row of data.
public struct ScalarEssence: Equatable, Sendable {
    public let swiftName: String
    public let tsName: String
    public let mangle: String

    public init(swift: String, ts: String, mangle: String) {
        self.swiftName = swift
        self.tsName = ts
        self.mangle = mangle
    }
}

/// A named user type. Its `kind` is the minimal property from which the surface facets derive.
public struct NominalEssence: Equatable, Sendable {
    /// The effective Swift name used for mangling and (mostly) the Swift spelling. For an
    /// unnamed `JSObject` this is `"JSObject"`.
    public let name: String
    public let kind: NominalKind

    public init(name: String, kind: NominalKind) {
        self.name = name
        self.kind = kind
    }
}

public enum NominalKind: Equatable, Sendable {
    case structType
    case caseEnum
    case rawValueEnum(SwiftEnumRawType)
    case associatedValueEnum
    case protocolType
    case heapObject
    /// Carries the *original* (possibly nil) name, because the TS spelling of a `JSObject`
    /// depends on it (typed-array lookup, or `any` when unnamed) independently of the effective
    /// mangling name.
    case jsObject(originalName: String?)

    /// The Swift ABI nominal mangling suffix. This is the one fact that distinguishes the kinds
    /// for mangling; everything else about the mangled name is `<len><name><suffix>`.
    public var mangleSuffix: String {
        switch self {
        case .structType: return "V"
        case .caseEnum, .rawValueEnum, .associatedValueEnum: return "O"
        case .protocolType: return "P"
        case .heapObject, .jsObject: return "C"
        }
    }
}

// MARK: - The one dispatch: BridgeType -> essence

extension BridgeType {
    /// Maps a `BridgeType` to its structural essence. This is the *only* place that enumerates
    /// every `BridgeType` case; the facet rules below switch on the ~8 essence classes instead.
    public var essence: TypeEssence {
        switch self {
        case .bool:
            return .scalar(ScalarEssence(swift: "Bool", ts: "boolean", mangle: "Sb"))
        case .integer(let t):
            return .scalar(ScalarEssence(swift: t.swiftTypeName, ts: t.tsTypeName, mangle: t.mangleTypeName))
        case .float:
            return .scalar(ScalarEssence(swift: "Float", ts: "number", mangle: "Sf"))
        case .double:
            return .scalar(ScalarEssence(swift: "Double", ts: "number", mangle: "Sd"))
        case .string:
            return .scalar(ScalarEssence(swift: "String", ts: "string", mangle: "SS"))
        case .jsValue:
            return .scalar(ScalarEssence(swift: "JSValue", ts: "any", mangle: "7JSValueV"))
        case .void:
            return .void
        case .unsafePointer(let ptr):
            return .scalar(ScalarEssence(swift: ptr.swiftName, ts: "number", mangle: ptr.mangle))
        case .swiftStruct(let name):
            return .nominal(NominalEssence(name: name, kind: .structType))
        case .caseEnum(let name):
            return .nominal(NominalEssence(name: name, kind: .caseEnum))
        case .rawValueEnum(let name, let raw):
            return .nominal(NominalEssence(name: name, kind: .rawValueEnum(raw)))
        case .associatedValueEnum(let name):
            return .nominal(NominalEssence(name: name, kind: .associatedValueEnum))
        case .swiftProtocol(let name):
            return .nominal(NominalEssence(name: name, kind: .protocolType))
        case .swiftHeapObject(let name):
            return .nominal(NominalEssence(name: name, kind: .heapObject))
        case .jsObject(let name):
            return .nominal(NominalEssence(name: name ?? "JSObject", kind: .jsObject(originalName: name)))
        case .nullable(let wrapped, let kind):
            return .optional(wrapped, kind)
        case .array(let element):
            return .array(element)
        case .dictionary(let value):
            return .dictionary(value)
        case .closure(let signature, let useJSTypedClosure):
            return .closure(signature, useJSTypedClosure: useJSTypedClosure)
        case .alias(let name, let underlying):
            return .alias(name: name, underlying: underlying)
        }
    }
}

// MARK: - Derived facet: mangled name

extension BridgeType {
    /// The mangled name, derived from the essence.
    public var mangleTypeName: String {
        switch essence {
        case .scalar(let s):
            return s.mangle
        case .void:
            return "y"
        case .nominal(let n):
            return "\(n.name.count)\(n.name)\(n.kind.mangleSuffix)"
        case .optional(let wrapped, let kind):
            return "\(kind == .null ? "Sq" : "Su")\(wrapped.mangleTypeName)"
        case .array(let element):
            return "Sa\(element.mangleTypeName)"
        case .dictionary(let value):
            return "SD\(value.mangleTypeName)"
        case .alias(let name, _):
            return "Al\(name.count)\(name)"
        case .closure(let signature, let useJSTypedClosure):
            let params =
                signature.parameters.isEmpty
                ? "y" : signature.parameters.map { $0.mangleTypeName }.joined()
            let effects = (signature.isAsync ? "Ya" : "") + (signature.isThrows ? "K" : "")
            return "K\(effects)\(params)_\(signature.returnType.mangleTypeName)\(useJSTypedClosure ? "J" : "")"
        }
    }
}

// MARK: - Derived facet: Swift type spelling

extension BridgeType {
    /// The Swift source spelling, derived from the essence.
    public var swiftType: String {
        switch essence {
        case .scalar(let s):
            return s.swiftName
        case .void:
            return "Void"
        case .nominal(let n):
            switch n.kind {
            case .protocolType: return "Any\(n.name)"
            default: return n.name
            }
        case .optional(let wrapped, let kind):
            return kind == .null
                ? "Optional<\(wrapped.swiftType)>" : "JSUndefinedOr<\(wrapped.swiftType)>"
        case .array(let element):
            return "[\(element.swiftType)]"
        case .dictionary(let value):
            return "[String: \(value.swiftType)]"
        case .alias(let name, _):
            return name
        case .closure(let signature, let useJSTypedClosure):
            let paramTypes = signature.parameters.map { $0.swiftType }.joined(separator: ", ")
            let effects = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
            let closureType = "(\(paramTypes))\(effects) -> \(signature.returnType.swiftType)"
            return useJSTypedClosure ? "JSTypedClosure<\(closureType)>" : closureType
        }
    }
}

// MARK: - Derived facet: TypeScript type spelling

/// Maps a `JSTypedArray` Swift typealias name to its JavaScript TypedArray constructor name.
private let jsTypedArrayTSNames: [String: String] = [
    "JSInt8Array": "Int8Array",
    "JSUint8Array": "Uint8Array",
    "JSInt16Array": "Int16Array",
    "JSUint16Array": "Uint16Array",
    "JSInt32Array": "Int32Array",
    "JSUint32Array": "Uint32Array",
    "JSFloat32Array": "Float32Array",
    "JSFloat64Array": "Float64Array",
]

extension BridgeType {
    /// The TypeScript source spelling, derived from the essence.
    public var tsType: String {
        switch essence {
        case .scalar(let s):
            return s.tsName
        case .void:
            return "void"
        case .nominal(let n):
            switch n.kind {
            case .caseEnum, .rawValueEnum, .associatedValueEnum:
                return "\(n.name)Tag"
            case .jsObject(let originalName):
                if let originalName, let tsName = jsTypedArrayTSNames[originalName] {
                    return tsName
                }
                return originalName ?? "any"
            case .structType, .protocolType, .heapObject:
                return n.name
            }
        case .optional(let wrapped, let kind):
            return "\(wrapped.tsType) | \(kind.absenceLiteral)"
        case .array(let element):
            let inner = element.tsType
            if inner.contains("|") || inner.contains("=>") {
                return "(\(inner))[]"
            }
            return "\(inner)[]"
        case .dictionary(let value):
            return "Record<string, \(value.tsType)>"
        case .alias(_, let underlying):
            return underlying.tsType
        case .closure(let signature, _):
            let paramTypes = signature.parameters.enumerated().map { index, param in
                "arg\(index): \(param.tsType)"
            }.joined(separator: ", ")
            let returnTS =
                signature.isAsync ? "Promise<\(signature.returnType.tsType)>" : signature.returnType.tsType
            return "(\(paramTypes)) => \(returnTS)"
        }
    }
}

// MARK: - Sub-type spellings the essence needs

extension UnsafePointerType {
    /// The Swift source spelling of this pointer type.
    public var swiftName: String {
        switch kind {
        case .unsafePointer: return "UnsafePointer<\(pointee ?? "Never")>"
        case .unsafeMutablePointer: return "UnsafeMutablePointer<\(pointee ?? "Never")>"
        case .unsafeRawPointer: return "UnsafeRawPointer"
        case .unsafeMutableRawPointer: return "UnsafeMutableRawPointer"
        case .opaquePointer: return "OpaquePointer"
        }
    }

    /// The mangled name of this pointer type.
    public var mangle: String {
        let kindCode: String
        switch kind {
        case .unsafePointer: kindCode = "Sup"
        case .unsafeMutablePointer: kindCode = "Sump"
        case .unsafeRawPointer: kindCode = "Surp"
        case .unsafeMutableRawPointer: kindCode = "Sumrp"
        case .opaquePointer: kindCode = "Sop"
        }
        if let pointee, !pointee.isEmpty {
            let sanitized = pointee.filter { $0.isNumber || $0.isLetter }
            return "\(kindCode)\(sanitized.count)\(sanitized)"
        }
        return kindCode
    }
}

extension WasmCoreType {
    /// The Swift source spelling of this Wasm core type (used when emitting thunk signatures).
    public var swiftType: String {
        switch self {
        case .i32: return "Int32"
        case .i64: return "Int64"
        case .f32: return "Float32"
        case .f64: return "Float64"
        case .pointer: return "UnsafeMutableRawPointer"
        }
    }
}
