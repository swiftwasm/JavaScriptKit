#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Registry for JS helper intrinsics used during code generation.
final class JSIntrinsicRegistry {
    private var entries: [String: [String]] = [:]
    var classPaths: [String: [String]] = [:]
    var renamedEnumNames: [String: (value: String, type: String)] = [:]

    var typeOwnerModules: [String: String] = [:]

    /// The imports of the linked `.wasm` module keyed by import module name, which decide what JS glue
    /// gets emitted, or `nil` to treat every import as used.
    var usedImports: [String: Set<String>]?

    private var codecNameOrder: [String] = []

    /// The `bjs` imports that the generated JS references itself, in the order of their first reference,
    /// which must be defined even when the linked module doesn't import them.
    private(set) var referencedBJSImports: [String] = []
    private var referencedBJSImportSet: Set<String> = []
    private var codecBodies: [String: [String]] = [:]

    var isEmpty: Bool {
        entries.isEmpty
    }

    func register(name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        guard entries[name] == nil else { return }
        let printer = CodeFragmentPrinter()
        try build(printer)
        entries[name] = printer.lines
    }

    func registerNamedCodec(name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        guard codecBodies[name] == nil else { return }
        let printer = CodeFragmentPrinter()
        try build(printer)
        guard codecBodies[name] == nil else { return }
        codecBodies[name] = printer.lines
        codecNameOrder.append(name)
    }

    var hasNamedCodecs: Bool {
        !codecNameOrder.isEmpty
    }

    func emitNamedCodecLines() -> [String] {
        codecNameOrder.flatMap { codecBodies[$0] ?? [] }
    }

    func reset() {
        entries.removeAll()
        classPaths.removeAll()
        renamedEnumNames.removeAll()
        typeOwnerModules.removeAll()
        usedImports = nil
        codecNameOrder.removeAll()
        codecBodies.removeAll()
        referencedBJSImports.removeAll()
        referencedBJSImportSet.removeAll()
    }

    func isUsed(module: String, name: String) -> Bool {
        guard let usedImports else { return true }
        return usedImports[module]?.contains(name) ?? false
    }

    func isReferencedBJSImport(_ name: String) -> Bool {
        referencedBJSImportSet.contains(name)
    }

    /// Returns the JS expression for the `bjs` import `name`, recording the reference.
    func referenceBJSImport(_ name: String) -> String {
        if referencedBJSImportSet.insert(name).inserted {
            referencedBJSImports.append(name)
        }
        return "bjs[\"\(name)\"]"
    }

    func emitLines() -> [String] {
        var emitted: [String] = []
        for key in entries.keys.sorted() {
            if let lines = entries[key] {
                emitted.append(contentsOf: lines)
                emitted.append("")
            }
        }
        if emitted.last == "" {
            emitted.removeLast()
        }
        return emitted
    }
}
