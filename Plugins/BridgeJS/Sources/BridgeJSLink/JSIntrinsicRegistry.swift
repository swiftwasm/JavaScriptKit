#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// The state shared by the code generation of one link: the declaration graph and lookup tables.
final class JSIntrinsicRegistry {
    let graph = JSDeclGraph()
    var classPaths: [String: [String]] = [:]
    var renamedEnumNames: [String: (value: String, type: String)] = [:]

    var typeOwnerModules: [String: String] = [:]

    /// The imports of the linked `.wasm` module keyed by import module name, or `nil` to treat every
    /// import as used.
    var usedImports: [String: Set<String>]?

    /// Whether the linked module imports `name` from `module`, which makes its glue a root.
    func isUsedImport(module: String, name: String) -> Bool {
        guard let usedImports else { return true }
        return usedImports[module]?.contains(name) ?? false
    }

    /// Defines the intrinsic `name` in the intrinsics slot unless it is defined, and references it.
    func register(name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        try graph.defineOnce(.intrinsic(name)) { decl in
            try decl.part(.intrinsics, build)
        }
    }

    /// Defines the named codec `name` unless it is defined, and references it.
    func registerNamedCodec(name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        try graph.defineOnce(.codec(name)) { decl in
            try decl.part(.namedCodecs, build)
        }
    }

    func reset() {
        graph.reset()
        classPaths.removeAll()
        renamedEnumNames.removeAll()
        typeOwnerModules.removeAll()
        usedImports = nil
    }

    /// Returns the spelling of `symbol` and records the reference.
    func ref(_ symbol: JSSymbol) -> String {
        graph.ref(symbol)
    }
}
