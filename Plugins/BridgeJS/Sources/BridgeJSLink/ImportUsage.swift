/// The imports of the linked `.wasm` module, which decide what JS glue gets emitted.
final class ImportUsage {
    /// The import names keyed by import module name, or `nil` to treat every import as used.
    private var imports: [String: Set<String>]?

    func configure(imports: [String: Set<String>]?) {
        self.imports = imports
    }

    func isUsed(module: String, name: String) -> Bool {
        guard let imports else { return true }
        return imports[module]?.contains(name) ?? false
    }
}
