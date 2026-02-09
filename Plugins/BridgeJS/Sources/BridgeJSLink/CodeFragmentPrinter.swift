/// Registry for JS helper intrinsics used during code generation.
final class JSIntrinsicRegistry {
    private var entries: [String: [String]] = [:]

    var isEmpty: Bool {
        entries.isEmpty
    }

    func register(name: String, build: (CodeFragmentPrinter) throws -> Void) rethrows {
        guard entries[name] == nil else { return }
        let printer = CodeFragmentPrinter()
        try build(printer)
        entries[name] = printer.lines
    }

    func reset() {
        entries.removeAll()
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

/// A printer for code fragments.
final class CodeFragmentPrinter {
    private(set) var lines: [String] = []
    private var indentLevel: Int = 0

    init(header: String = "") {
        self.lines.append(contentsOf: header.split(separator: "\n").map { String($0) })
    }

    func nextLine() {
        lines.append("")
    }

    func write<S: StringProtocol>(_ line: S) {
        if line.isEmpty {
            // Empty lines should not have trailing spaces
            lines.append("")
            return
        }
        lines.append(String(repeating: " ", count: indentLevel * 4) + String(line))
    }

    func write(lines: [String]) {
        for line in lines {
            write(line)
        }
    }

    func write(contentsOf printer: CodeFragmentPrinter) {
        self.write(lines: printer.lines)
    }

    func indent() {
        indentLevel += 1
    }

    func unindent() {
        indentLevel -= 1
    }

    func indent(_ body: () throws -> Void) rethrows {
        indentLevel += 1
        try body()
        indentLevel -= 1
    }
}
