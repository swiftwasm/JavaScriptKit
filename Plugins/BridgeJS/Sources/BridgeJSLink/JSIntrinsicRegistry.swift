#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Registry for JS helper intrinsics used during code generation.
final class JSIntrinsicRegistry {
    private var entries: [String: [String]] = [:]
    var classNamespaces: [String: [String]] = [:]

    /// Maps a type name as carried by `BridgeType` (struct ABI name, class name,
    /// enum name, ...) to the module that declares it, so generated identifiers
    /// derived from type names can be module-qualified.
    ///
    /// The whole link output shares one JS scope, so two modules declaring a
    /// same-named `@JS` type would otherwise mint the same identifier.
    var typeOwnerModules: [String: String] = [:]

    /// Module-scope `{ lower, lift }` codec helpers, one per type shape, in
    /// dependency order: a composed codec is appended after the codecs it is
    /// built from, so the emitted `const`s can be evaluated top to bottom.
    private var codecNameOrder: [String] = []
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

    /// Registers a named codec helper once per name.
    ///
    /// `build` may itself register the codecs this one is composed from; those
    /// are appended first, which is what keeps the emitted declarations in a
    /// valid evaluation order.
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
        classNamespaces.removeAll()
        typeOwnerModules.removeAll()
        codecNameOrder.removeAll()
        codecBodies.removeAll()
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
