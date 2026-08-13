#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Registry for JS helper intrinsics used during code generation.
final class JSIntrinsicRegistry {
    private var entries: [String: [String]] = [:]
    var classNamespaces: [String: [String]] = [:]

    var typeOwnerModules: [String: String] = [:]

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
