#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// The statements of `addImports` that define the functions of the `bjs` import module.
///
/// Each import is rendered on demand, only when the linked module imports it or other rendered
/// glue references it (see ``JSIntrinsicRegistry/referenceBJSImport(_:)``), so that the helpers
/// its rendering registers are also left out when it isn't needed.
struct BJSImportDefinitions: ~Copyable {
    private enum Entry {
        case statement(String)
        case bjsImport(name: String, renderValue: (CodeFragmentPrinter) throws -> Void)
    }

    private var entries: [Entry] = []

    /// Adds a statement that is always emitted.
    mutating func write(_ statement: String) {
        entries.append(.statement(statement))
    }

    /// Adds the import `bjs[name]`, whose value `renderValue` prints when it is needed.
    mutating func define(_ name: String, renderValue: @escaping (CodeFragmentPrinter) throws -> Void) {
        entries.append(.bjsImport(name: name, renderValue: renderValue))
    }

    /// Renders the statements and the definitions of the needed imports in the order they were added,
    /// except that definitions only referenced by glue rendered after them come last.
    consuming func render(importUsage: ImportUsage, registry: JSIntrinsicRegistry) throws -> [String] {
        var lines: [String] = []
        func emit(_ name: String, _ renderValue: (CodeFragmentPrinter) throws -> Void) throws {
            let printer = CodeFragmentPrinter()
            try renderValue(printer)
            var value = printer.lines
            value[0] = "bjs[\"\(name)\"] = \(value[0])"
            lines += value
        }
        // The definitions left out so far, which glue rendered later may still reference; a later
        // definition of a name overrides an earlier one
        var skipped: [String: (CodeFragmentPrinter) throws -> Void] = [:]
        for entry in entries {
            switch entry {
            case .statement(let statement):
                lines.append(statement)
            case .bjsImport(let name, let renderValue):
                guard importUsage.isUsed(module: "bjs", name: name) || registry.isReferencedBJSImport(name)
                else {
                    skipped[name] = renderValue
                    continue
                }
                skipped[name] = nil
                try emit(name, renderValue)
            }
        }
        // Glue can reference imports defined before it: the closure imports reference the
        // `swift_js_return_optional_*` ones. Defining those after the closures would avoid this loop, but
        // would reorder the unfiltered output. Rendering a definition here can reference further imports,
        // which are appended to the references this loop walks.
        var next = 0
        while next < registry.referencedBJSImports.count {
            let name = registry.referencedBJSImports[next]
            next += 1
            if let renderValue = skipped.removeValue(forKey: name) {
                try emit(name, renderValue)
            }
        }
        return lines
    }
}
